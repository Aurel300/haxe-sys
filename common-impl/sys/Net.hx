package sys;

import haxe.NoData;
import haxe.async.*;
import nusys.async.net.Socket;
import nusys.async.net.Socket.SocketOptions;
import nusys.async.net.Socket.SocketConnectTcpOptions;
import nusys.async.net.Socket.SocketConnectIpcOptions;
import nusys.async.net.Server;
import nusys.async.net.Server.ServerOptions;
import nusys.async.net.Server.ServerListenTcpOptions;

enum SocketConnect {
	Tcp(options:SocketConnectTcpOptions);
	Ipc(options:SocketConnectIpcOptions);
}

enum ServerListen {
	Tcp(options:ServerListenTcpOptions);
}

typedef SocketCreationOptions = SocketOptions & {?connect:SocketConnect};

typedef ServerCreationOptions = ServerOptions & {?listen:ServerListen};

class Net {
	public static function createConnection(options:SocketCreationOptions, ?cb:Callback<NoData>):Socket {
		var socket = Socket.create(options);
		if (options != null && options.connect != null)
			switch (options.connect) {
				case Tcp(options):
					socket.connectTcp(options, cb);
				case Ipc(options):
					// socket.connectIpc(options, cb);
			}
		return socket;
	}

	public static function createServer(?options:ServerCreationOptions, ?listener:Listener<Socket>):Server {
		var server = new Server(options);
		if (options != null && options.listen != null)
			switch (options.listen) {
				case Tcp(options):
					server.listenTcp(options, listener);
			}
		return server;
	}

	/*static function isIP(input:String):Null<IPFamily>;
		static function isIPv4(input:String):Bool;
		static function isIPv6(input:String):Bool; */
}

enum NetFamily {
	IP(sub:IPFamily);
	UDP;
	Unix;
}

enum IPFamily {
	IPv4;
	IPv6;
}

enum SocketAddress {
	Network(port:Int, family:String, address:String);
	Unix(name:String);
}
