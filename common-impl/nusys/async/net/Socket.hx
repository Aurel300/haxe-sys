package nusys.async.net;

import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import nusys.net.*;
import nusys.async.net.SocketOptions.SocketConnectTcpOptions;
import nusys.async.net.SocketOptions.SocketConnectIpcOptions;
import sys.net.*;

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

	/**
		Connect this socket via TCP to the given remote.
	**/
	function connectTcp(options:SocketConnectTcpOptions, ?cb:Callback<NoData>):Void;

	/**
		Connect this socket to an IPC pipe.
	**/
	function connectIpc(options:SocketConnectIpcOptions, ?cb:Callback<NoData>):Void;

	function destroy(?cb:Callback<NoData>):Void;

	function setKeepAlive(?enable:Bool = false, ?initialDelay:Int = 0):Void;

	function setNoDelay(?noDelay:Bool = true):Void;

	function setTimeout(timeout:Int, ?listener:Listener<NoData>):Void;

	function ref():Void;
	function unref():Void;
}
