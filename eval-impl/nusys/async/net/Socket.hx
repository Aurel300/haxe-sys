package nusys.async.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import haxe.io.Readable.ReadResult;
// import sys.net.Dns.DnsHints;
// import sys.net.Dns.DnsLookupFunction;
import nusys.net.*;
import nusys.async.net.SocketOptions.SocketConnectTcpOptions;
import nusys.async.net.SocketOptions.SocketConnectIpcOptions;

class Socket extends Duplex {
	public static function create(?options:SocketOptions):Socket {
		var native = new eval.uv.Socket();
		// TODO: use options
		return new Socket(native);
	}

	// dataSignal (in Duplex)
	// drainSignal (in Duplex)
	// errorSignal (in Duplex)

	// closeSignal
	public final connectSignal:Signal<NoData> = new ArraySignal<NoData>();
	// endSignal
	public final lookupSignal:Signal<Address> = new ArraySignal<Address>();
	public final timeoutSignal:Signal<NoData> = new ArraySignal<NoData>();

	var connectDefer:nusys.Timer;
	final native:eval.uv.Socket;
	var internalReadCalled = false;
	var readStarted = false;
	var connectStarted = false;
	var connected = false;
	var serverSpawn:Bool = false;
	public var localAddress(get, never):Null<SocketAddress>;
	public var remoteAddress(get, never):Null<SocketAddress>;

	function new(native) {
		super();
		this.native = native;
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

	override function internalWrite():Void {
		while (inputBuffer.length > 0) {
			// TODO: keep track of pending writes for finish event emission
			native.write(pop(), (err) -> {
				timeoutReset();
				if (err != null)
					errorSignal.emit(err);
				// TODO: destroy stream and socket
			});
		}
	}

	function get_localAddress():Null<SocketAddress> {
		if (!connected)
			return null;
		return native.getSockName();
	}

	function get_remoteAddress():Null<SocketAddress> {
		if (!connected)
			return null;
		return native.getPeerName();
	}

	public function connectTcp(options:SocketConnectTcpOptions, ?cb:Callback<NoData>):Void {
		if (connectStarted || connected)
			throw "already connected";

		if (options.host != null && options.address != null)
			throw "cannot specify both host and address";

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
				native.connectTcp(address, options.port, (err, nd) -> {
					timeoutReset();
					if (err == null)
						connected = true;
					cb(err, nd);
					if (err == null)
						connectSignal.emit(new NoData());
				});
			} catch (err:haxe.Error) {
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

	public function destroy(?cb:Callback<NoData>):Void {
		if (readStarted)
			native.stopRead();
		native.close(Callback.nonNull(cb));
	}

	public function setKeepAlive(?enable:Bool = false, ?initialDelay:Int = 0):Void {
		native.setKeepAlive(enable, initialDelay);
	}

	public function setNoDelay(?noDelay:Bool = true):Void {
		native.setNoDelay(noDelay);
	}

	var timeoutTime:Int = 0;
	var timeoutTimer:nusys.Timer;

	function timeoutTrigger():Void {
		timeoutTimer = null;
		timeoutSignal.emit(new NoData());
	}

	function timeoutReset():Void {
		if (timeoutTimer != null)
			timeoutTimer.stop();
		timeoutTimer = null;
		if (timeoutTime != 0)
			timeoutTimer = nusys.Timer.delay(timeoutTrigger, timeoutTime, false);
	}

	public function setTimeout(timeout:Int, ?listener:Listener<NoData>):Void {
		timeoutTime = timeout;
		timeoutReset();
		if (listener != null)
			timeoutSignal.once(listener);
	}

	// function connectIPC(path:String, ?connectListener:Listener<NoData>):Void;
	// function destroy from Duplex
	// function end from Duplex
	// function pause from Duplex
	// function ref():Void;
	// function resume from Duplex
	// function unref():Void;
	// function write from Duplex
}
