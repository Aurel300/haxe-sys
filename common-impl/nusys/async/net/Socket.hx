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

	var serverSpawn:Bool;

	function address():Null<SocketAddress>;

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
