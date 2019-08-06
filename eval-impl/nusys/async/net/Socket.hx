package nusys.async.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import haxe.io.Readable.ReadResult;
// import sys.net.Dns.DnsHints;
// import sys.net.Dns.DnsLookupFunction;
import sys.net.Address;
import nusys.net.Dns;
import sys.Net.IPFamily;
import sys.Net.NetFamily;
import sys.Net.SocketAddress;

typedef SocketOptions = {
	// ?file:sys.io.File, // fd in Node
	?allowHalfOpen:Bool,
	?readable:Bool,
	?writable:Bool
};

typedef SocketConnectTcpOptions = {
	port:Int,
	?host:String,
	?address:Address,
	?localAddress:String,
	?localPort:Int,
	?family:IPFamily
};

typedef SocketConnectIpcOptions = {
	path:String
};

class Socket extends Duplex {
	public static function create(?options:SocketOptions):Socket {
		var native = new eval.uv.Socket();
		// TODO: use options
		return new Socket(native);
	}

	public final connectSignal:Signal<NoData> = new ArraySignal<NoData>();
	var connectDefer:nusys.Timer;
	final native:eval.uv.Socket;
	var readStarted = false;
	var connectStarted = false;
	var connected = false;

	function new(native) {
		super();
		this.native = native;
	}

	override function internalRead(remaining):ReadResult {
		if (readStarted)
			return None;
		readStarted = true;

		function start():Void {
			native.startRead((err, chunk) -> {
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
				if (err != null)
					errorSignal.emit(err);
				// TODO: destroy stream and socket
			});
		}
	}

	// function address():SocketAddress;

	public function connectTcp(options:SocketConnectTcpOptions, ?cb:Callback<NoData>):Void {
		if (connectStarted)
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
					cb(err, nd);
					if (err != null)
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
			if (err != null)
				return errorSignal.emit(err);
			if (entries.length == 0)
				throw "!";
			connect(entries[0]);
		});
	}

	public function destroy(?cb:Callback<NoData>):Void {
		native.stopRead();
		native.close(Callback.nonNull(cb));
	}

	public function setKeepAlive(?enable:Bool = false, ?initialDelay:Int = 0):Void {
		native.setKeepAlive(enable, initialDelay);
	}

	public function setNoDelay(?noDelay:Bool = true):Void {
		native.setNoDelay(noDelay);
	}

	// TODO: implement via Timer
	// public function setTimeout(timeout:Float, ?listener:Listener<NoData>):Void;

	// function connectIPC(path:String, ?connectListener:Listener<NoData>):Void;
	// function destroy from Duplex
	// function end from Duplex
	// function pause from Duplex
	// function ref():Void;
	// function resume from Duplex
	// function unref():Void;
	// function write from Duplex
}
