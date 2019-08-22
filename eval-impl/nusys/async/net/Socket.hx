package nusys.async.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import haxe.io.Readable.ReadResult;
// import sys.net.Dns.DnsHints;
// import sys.net.Dns.DnsLookupFunction;
import nusys.io.*;
import nusys.net.*;
import nusys.async.net.SocketOptions.SocketConnectTcpOptions;
import nusys.async.net.SocketOptions.SocketConnectIpcOptions;

class Socket extends Duplex {
	public static function create(?options:SocketOptions):Socket {
		// TODO: use options
		return new Socket();
	}

	public final closeSignal:Signal<NoData> = new ArraySignal();
	public final connectSignal:Signal<NoData> = new ArraySignal();
	// endSignal
	public final lookupSignal:Signal<Address> = new ArraySignal();
	public final timeoutSignal:Signal<NoData> = new ArraySignal();

	var connectDefer:nusys.Timer;
	var native:eval.uv.Stream;
	var nativeSocket:eval.uv.Socket;
	var nativePipe:eval.uv.Pipe;
	var internalReadCalled = false;
	var readStarted = false;
	var connectStarted = false;
	public var connected(default, null):Bool = false;
	var serverSpawn:Bool = false;
	var timeoutTime:Int = 0;
	var timeoutTimer:nusys.Timer;
	public var localAddress(get, never):Null<SocketAddress>;
	public var remoteAddress(get, never):Null<SocketAddress>;

	function new() {
		super();
	}

	function initPipe(ipc:Bool):Void {
		nativePipe = new eval.uv.Pipe(ipc);
		native = nativePipe.asStream();
		connected = true;
	}

	override function internalRead(remaining):ReadResult {
		if (internalReadCalled)
			return None;
		internalReadCalled = true;

		function start():Void {
			readStarted = true;
			native.startRead((err, chunk) -> {
				timeoutReset();
				if (err != null) {
					switch (err.type) {
						case UVError(EOF):
							asyncRead([], true);
						case _:
							errorSignal.emit(err);
					}
				} else {
					asyncRead([chunk], false);
				}
			});
		}

		if (connected)
			start();
		else
			connectSignal.once(start);

		return None;
	}

	// TODO: keep track of pending writes for finish event emission
	// in `internalWrite` and `writeHandle`
	function writeDone(err:Error, nd:NoData):Void {
		timeoutReset();
		if (err != null)
			errorSignal.emit(err);
		// TODO: destroy stream and socket
	}

	override function internalWrite():Void {
		while (inputBuffer.length > 0) {
			native.write(pop(), writeDone);
		}
	}

	function get_localAddress():Null<SocketAddress> {
		if (nativeSocket != null)
			return nativeSocket.getSockName();
		if (nativePipe != null)
			return nativePipe.getSockName();
		return null;
	}

	function get_remoteAddress():Null<SocketAddress> {
		if (nativeSocket != null)
			return nativeSocket.getPeerName();
		if (nativePipe != null)
			return nativePipe.getPeerName();
		return null;
	}

	public function connectTcp(options:SocketConnectTcpOptions, ?cb:Callback<NoData>):Void {
		if (connectStarted || connected)
			throw "already connected";

		if (options.host != null && options.address != null)
			throw "cannot specify both host and address";

		connectStarted = true;
		nativeSocket = new eval.uv.Socket();
		native = nativeSocket.asStream();

		// take a copy since we reuse the object asynchronously
		var options = {
			port: options.port,
			host: options.host,
			address: options.address,
			localAddress: options.localAddress,
			localPort: options.localPort,
			family: options.family
		};

		function connect(address:Address):Void {
			connectDefer = null;
			// TODO: bindTcp for localAddress and localPort, if specified
			try {
				nativeSocket.connectTcp(address, options.port, (err, nd) -> {
					timeoutReset();
					if (err == null)
						connected = true;
					if (cb != null)
						cb(err, nd);
					if (err == null)
						connectSignal.emit(new NoData());
				});
			} catch (err:haxe.Error) {
				if (cb != null)
					cb(err, new NoData());
			}
		}

		if (options.address != null) {
			connectDefer = Defer.nextTick(() -> connect(options.address));
			return;
		}
		if (options.host == null)
			options.host = "localhost";
		Dns.lookup(options.host, {family: options.family}, (err, entries) -> {
			timeoutReset();
			if (err != null)
				return errorSignal.emit(err);
			if (entries.length == 0)
				throw "!";
			lookupSignal.emit(entries[0]);
			connect(entries[0]);
		});
	}

	public function connectIpc(options:SocketConnectIpcOptions, ?cb:Callback<NoData>):Void {
		if (connectStarted || connected)
			throw "already connected";

		connectStarted = true;
		nativePipe = new eval.uv.Pipe(false);
		native = nativePipe.asStream();

		try {
			nativePipe.connectIpc(options.path, (err, nd) -> {
				timeoutReset();
				if (err == null)
					connected = true;
				if (cb != null)
					cb(err, nd);
				if (err == null)
					connectSignal.emit(new NoData());
			});
		} catch (err:haxe.Error) {
			if (cb != null)
				cb(err, new NoData());
		}
	}

	public function connectFd(ipc:Bool, fd:Int):Void {
		if (connectStarted || connected)
			throw "already connected";

		connectStarted = true;
		nativePipe = new eval.uv.Pipe(ipc);
		nativePipe.open(fd);
		connected = true;
		native = nativePipe.asStream();

		// TODO: signal consistency with other connect methods
	}

	public function destroy(?cb:Callback<NoData>):Void {
		if (readStarted)
			native.stopRead();
		native.close((err, nd) -> {
			if (err != null)
				errorSignal.emit(err);
			if (cb != null)
				cb(err, nd);
			closeSignal.emit(new NoData());
		});
	}

	public function setKeepAlive(?enable:Bool = false, ?initialDelay:Int = 0):Void {
		if (nativeSocket == null)
			throw "not connected via TCP";
		nativeSocket.setKeepAlive(enable, initialDelay);
	}

	public function setNoDelay(?noDelay:Bool = true):Void {
		if (nativeSocket == null)
			throw "not connected via TCP";
		nativeSocket.setNoDelay(noDelay);
	}

	function timeoutTrigger():Void {
		timeoutTimer = null;
		timeoutSignal.emit(new NoData());
	}

	function timeoutReset():Void {
		if (timeoutTimer != null)
			timeoutTimer.stop();
		timeoutTimer = null;
		if (timeoutTime != 0) {
			timeoutTimer = nusys.Timer.delay(timeoutTrigger, timeoutTime);
			timeoutTimer.unref();
		}
	}

	public function setTimeout(timeout:Int, ?listener:Listener<NoData>):Void {
		timeoutTime = timeout;
		timeoutReset();
		if (listener != null)
			timeoutSignal.once(listener);
	}

	public function writeHandle(data:Bytes, handle:Socket):Void {
		if (nativePipe == null)
			throw "not connected via IPC";
		nativePipe.writeHandle(data, handle.native, writeDone);
	}

	private function get_handlesPending():Int {
		if (nativePipe == null)
			throw "not connected via IPC";
		return nativePipe.pendingCount();
	}

	public var handlesPending(get, never):Int;

	public function readHandle():Socket {
		if (nativePipe == null)
			throw "not connected via IPC";
		var ret = new Socket();
		switch (nativePipe.acceptPending()) {
			case Socket(nativeSocket):
				ret.nativeSocket = nativeSocket;
				ret.native = nativeSocket.asStream();
			case Pipe(nativePipe):
				ret.nativePipe = nativePipe;
				ret.native = nativePipe.asStream();
		}
		ret.connected = true;
		return ret;
	}

	/*
	// TODO: #8263 (static hxUnserialize)
	// Automatic un/serialisation will not work here since hxUnserialize needs to
	// call supper, otherwise the socket is unusable; for now sockets are
	// delivered separately in IPC.

	@:access(nusys.io.IpcSerializer)
	private function hxSerialize(_):Void {
		if (IpcSerializer.activeSerializer == null)
			throw "cannot serialize socket";
		IpcSerializer.activeSerializer.chunkSockets.push(this);
	}

	@:access(nusys.io.IpcUnserializer)
	private function hxUnserialize(_):Void {
		if (IpcUnserializer.activeUnserializer == null)
			throw "cannot unserialize socket";
		trace(dataSignal, input);
		var source:Socket = IpcUnserializer.activeUnserializer.chunkSockets.shift();
		this.native = source.native;
		this.nativePipe = source.nativePipe;
		this.nativeSocket = source.nativeSocket;
		this.connected = true;
		trace("successfully unserialized", this.nativeSocket);
	}
	*/

	public function ref():Void {
		if (native == null)
			throw "not connected";
		native.ref();
	}

	public function unref():Void {
		if (native == null)
			throw "not connected";
		native.unref();
	}
}
