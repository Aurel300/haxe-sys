package nusys.async.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import haxe.io.Readable.ReadResult;
// import sys.net.Dns.DnsHints;
// import sys.net.Dns.DnsLookupFunction;
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

	final native:eval.uv.Socket;
	var readStarted = false;

	function new(native) {
		super();
		this.native = native;
	}

	override function internalRead(remaining):ReadResult {
		if (readStarted)
			return None;
		readStarted = true;

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
		native.connectTCP(options.port, cb);
	}

	public function destroy(?cb:Callback<NoData>):Void {
		native.stopRead();
		native.close(Callback.nonNull(cb));
	}

	// function connectIPC(path:String, ?connectListener:Listener<NoData>):Void;
	// function destroy from Duplex
	// function end from Duplex
	// function pause from Duplex
	// function ref():Void;
	// function resume from Duplex
	// function setKeepAlive(?enable:Bool, ?initialDelay:Float):Void;
	// function setNoDelay(?noDelay:Bool):Void;
	// function setTimeout(timeout:Float, ?listener:Listener<NoData>):Void;
	// function unref():Void;
	// function write from Duplex
}
