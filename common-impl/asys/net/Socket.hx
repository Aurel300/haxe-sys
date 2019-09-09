package asys.net;

import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import asys.net.SocketOptions.SocketConnectTcpOptions;
import asys.net.SocketOptions.SocketConnectIpcOptions;

/**
	Socket object, used for clients and servers for TCP communications and IPC
	(inter-process communications) over Windows named pipes and Unix local domain
	sockets.

	An IPC pipe is a communication channel between two processes. It may be
	uni-directional or bi-directional, depending on how it is created. Pipes can
	be automatically created for spawned subprocesses with `Process.spawn`.
**/
extern class Socket extends Duplex {
	/**
		Creates an unconnected socket or pipe instance.

		@param options.allowHalfOpen
		@param options.readable Whether the socket should be readable to the
			current process.
		@param options.writable Whether the socket should be writable to the
			current process.
	**/
	static function create(?options:SocketOptions):Socket;

	// closeSignal

	/**
		Emitted when the socket connects to a remote endpoint.
	**/
	final connectSignal:Signal<NoData>;

	// endSignal

	/**
		(TCP only.) Emitted after the IP address of the hostname given in
		`connectTcp` is resolved, but before the socket connects.
	**/
	final lookupSignal:Signal<Address>;

	/**
		Emitted when a timeout occurs. See `setTimeout`.
	**/
	final timeoutSignal:Signal<NoData>;

	private function get_localAddress():Null<SocketAddress>;

	/**
		The address of the local side of the socket connection, or `null` if not
		connected.
	**/
	var localAddress(get, never):Null<SocketAddress>;

	private function get_remoteAddress():Null<SocketAddress>;

	/**
		The address of the remote side of the socket connection, or `null` if not
		connected.
	**/
	var remoteAddress(get, never):Null<SocketAddress>;

	private function get_handlesPending():Int;

	/**
		(IPC only.) Number of pending sockets or pipes. Accessible using
		`readHandle`.
	**/
	var handlesPending(get, never):Int;

	/**
		`true` when `this` socket is connected to a remote host or an IPC pipe.
	**/
	var connected(default, null):Bool;

	/**
		Connect `this` socket via TCP to the given remote.

		If neither `options.host` nor `options.address` is specified, the host
		`localhost` is resolved via DNS and used as the address. At least one of
		`options.host` or `options.address` must be `null`.

		`options.localAddress` and `options.localPort` can be used to specify what
		address and port to use on the local machine for the outgoing connection.
		If `null` or not specified, an address and/or a port will be chosen
		automatically by the system when connecting. The local address and port can
		be obtained using the `localAddress`.

		@param options.port Remote port to connect to.
		@param options.host Hostname to connect to, will be resolved using
			`Dns.resolve` to an address. `lookupSignal` will be emitted with the
			resolved address before the connection is attempted.
		@param options.address IPv4 or IPv6 address to connect to.
		@param options.localAddress Local IPv4 or IPv6 address to connect from.
		@param options.localPort Local port to connect from.
		@param options.family Limit DNS lookup to the given family.
	**/
	function connectTcp(options:SocketConnectTcpOptions, ?cb:Callback<NoData>):Void;

	/**
		Connect `this` socket to an IPC pipe.

		@param options.path Pipe path.
	**/
	function connectIpc(options:SocketConnectIpcOptions, ?cb:Callback<NoData>):Void;

	/**
		Connect `this` socket to a file descriptor. Used internally to establish
		IPC channels between Haxe processes.

		@param ipc Whether IPC features (sending sockets) should be enabled.
	**/
	function connectFd(ipc:Bool, fd:Int):Void;

	/**
		Closes `this` socket and all underlying resources.
	**/
	function destroy(?cb:Callback<NoData>):Void;

	/**
		(TCP only.) Enable or disable TCP keep-alive.

		@param initialDelay Initial delay in seconds. Ignored if `enable` is
			`false`.
	**/
	function setKeepAlive(?enable:Bool = false, ?initialDelay:Int = 0):Void;

	/**
		(TCP only.) Enable or disable TCP no-delay. Enabling no-delay disables
		Nagle's algorithm.
	**/
	function setNoDelay(?noDelay:Bool = true):Void;

	/**
		Set a timeout for socket oprations. Any time activity is detected on the
		socket (see below), the timer is reset to `timeout`. When the timer runs
		out, `timeoutSignal` is emitted. Note that a timeout will not automatically
		do anything to the socket - it is up to the `timeoutSignal` handler to
		perform an action, e.g. ping the remote host or close the socket.

		Socket activity which resets the timer:

		- A chunk of data is received.
		- An error occurs during reading.
		- A chunk of data is written to the socket.
		- Connection is established.
		- (TCP only.) DNS lookup is finished (successfully or not).

		@param timeout Timeout in seconds, or `0` to disable.
	**/
	function setTimeout(timeout:Int, ?listener:Listener<NoData>):Void;

	/**
		(IPC only.) Send a socket or pipe in along with the given `data`. The
		socket must be connected.
	**/
	function writeHandle(data:Bytes, handle:Socket):Void;

	/**
		(IPC only.) Receive a socket or pipe. Should only be called when
		`handlesPending` is greater than zero.
	**/
	function readHandle():Socket;

	function ref():Void;
	function unref():Void;
}
