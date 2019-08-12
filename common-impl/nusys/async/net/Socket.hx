package nusys.async.net;

import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import nusys.net.*;
import nusys.async.net.SocketOptions.SocketConnectTcpOptions;
import nusys.async.net.SocketOptions.SocketConnectIpcOptions;
import sys.net.*;

extern class Socket extends Duplex {
	static function create(?options:SocketOptions):Socket;

	// dataSignal (in Duplex)
	// drainSignal (in Duplex)
	// errorSignal (in Duplex)

	// closeSignal
	final connectSignal:Signal<NoData>;
	// endSignal
	final lookupSignal:Signal<Address>;
	final timeoutSignal:Signal<NoData>;
	var localAddress(get, never):Null<SocketAddress>;
	var remoteAddress(get, never):Null<SocketAddress>;

	function connectTcp(options:SocketConnectTcpOptions, ?cb:Callback<NoData>):Void;

	function destroy(?cb:Callback<NoData>):Void;

	function setKeepAlive(?enable:Bool = false, ?initialDelay:Int = 0):Void;

	function setNoDelay(?noDelay:Bool = true):Void;

	function setTimeout(timeout:Int, ?listener:Listener<NoData>):Void;

	// function connectIPC(path:String, ?connectListener:Listener<NoData>):Void;
	// function destroy from Duplex
	// function end from Duplex
	// function pause from Duplex
	// function ref():Void;
	// function resume from Duplex
	// function unref():Void;
	// function write from Duplex
}
