package sys;

import haxe.NoData;
import haxe.async.*;
import sys.net.Address;
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

/**
	Network utilities.
**/
class Net {
	/**
		Constructs a socket with the given `options`. If `options.connect` is
		given, an appropriate `connect` method is called on the socket. If `cb` is
		given, it is passed to the `connect` method, so it will be called once the
		socket successfully connects or an error occurs during connecting.

		The `options` object is given both to the `Socket` constructor and to the
		`connect` method.
	**/
	public static function createConnection(options:SocketCreationOptions, ?cb:Callback<NoData>):Socket {
		var socket = Socket.create(options);
		if (options.connect != null)
			switch (options.connect) {
				case Tcp(options):
					socket.connectTcp(options, cb);
				case Ipc(options):
					// socket.connectIpc(options, cb);
			}
		return socket;
	}

	/**
		Constructs a server with the given `options`. If `options.listen` is
		given, an appropriate `listen` method is called on the server. If `cb` is
		given, it is passed to the `listen` method, so it will be called for each
		client that connects to the server.

		The `options` object is given both to the `Server` constructor and to the
		`listen` method.
	**/
	public static function createServer(?options:ServerCreationOptions, ?listener:Listener<Socket>):Server {
		var server = new Server(options);
		if (options.listen != null)
			switch (options.listen) {
				case Tcp(options):
					server.listenTcp(options, listener);
			}
		return server;
	}
}

enum IPFamily {
	IPv4;
	IPv6;
}
