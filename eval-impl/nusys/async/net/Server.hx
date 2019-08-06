package nusys.async.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import sys.net.Address;
import nusys.net.Dns;
import sys.Net.SocketAddress;

typedef ServerOptions = {
	?allowHalfOpen:Bool,
	?pauseOnConnect:Bool
};

typedef ServerListenTcpOptions = {
	?port:Int,
	?host:String,
	?address:Address,
	?backlog:Int,
	?exclusive:Bool,
	?ipv6only:Bool
};

class Server {
	var native:eval.uv.Socket;

	public final closeSignal:Signal<NoData> = new ArraySignal<NoData>();
	public final connectionSignal:Signal<Socket> = new ArraySignal<Socket>();
	public final errorSignal:Signal<Error> = new ArraySignal<Error>();
	public final listeningSignal:Signal<NoData> = new ArraySignal<NoData>();

	var listenDefer:nusys.Timer;
	public var listening(default, null):Bool;
	public var maxConnections:Int;

	public function new(?options:ServerOptions) {
		native = new eval.uv.Socket();
	}

	// function address():SocketAddress;
	public function close(?callback:Callback<NoData>):Void {
		native.close(Callback.nonNull(callback));
	}
	// function getConnections(callback:Callback<Int>):Void;
	// function listenSocket(socket:Socket, ?backlog:Int, ?listener:Listener<NoData>):Void;
	// function listenServer(server:Server, ?backlog:Int, ?listener:Listener<NoData>):Void;
	// function listenFile(file:sys.io.File, ?backlog:Int, ?listener:Listener<NoData>):Void;
	// function listenIPC(path:String, ?backlog:Int, ?options:{?exclusive:Bool, ?readableAll:Bool, ?writableAll:Bool}, ?listener:Listener<NoData>):Void;
	public function listenTcp(options:ServerListenTcpOptions, ?listener:Listener<Socket>):Void {
		if (listening || listenDefer != null)
			throw "already listening";
		if (listener != null)
			connectionSignal.on(listener);

		if (options.host != null && options.address != null)
			throw "cannot specify both host and address";

		// take a copy since we reuse the object asynchronously
		var options = {
			port: options.port,
			host: options.host,
			address: options.address,
			backlog: options.backlog,
			exclusive: options.exclusive,
			ipv6only: options.ipv6only
		};

		function listen(address:Address):Void {
			listenDefer = null;
			listening = true;
			if (options.ipv6only == null)
				options.ipv6only = false;
			try {
				native.bindTcp(address, options.port == null ? 0 : options.port, options.ipv6only);
				native.listen(options.backlog == null ? 511 : options.backlog, (err) -> {
					if (err != null)
						return errorSignal.emit(err);
					try {
						var client = @:privateAccess new Socket(native.accept());
						@:privateAccess client.connected = true;
						client.serverSpawn = true;
						connectionSignal.emit(client);
					} catch (e:haxe.Error) {
						errorSignal.emit(e);
					}
				});
			} catch (e:haxe.Error) {
				errorSignal.emit(e);
			}
		}

		if (options.address != null) {
			listenDefer = Defer.nextTick(() -> listen(options.address));
			return;
		}
		if (options.host == null)
			options.host = "";
		Dns.lookup(options.host, null, (err, entries) -> {
			if (err != null)
				return errorSignal.emit(err);
			if (entries.length == 0)
				throw "!";
			listen(entries[0]);
		});
	}

	// function ref():Void;
	// function unref():Void;
}