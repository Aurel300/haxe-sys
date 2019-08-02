package nusys.async.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.Bytes;
// import sys.net.Dns.DnsHints;
// import sys.net.Dns.DnsLookupFunction;
import sys.net.Net.IPFamily;
import sys.net.Net.NetFamily;
import sys.net.Net.SocketAddress;

typedef SocketOptions = {
	// ?file:sys.io.File, // fd in Node
	?allowHalfOpen:Bool,
	?readable:Bool,
	?writable:Bool
};

typedef SocketConnectOptions = {
	?port:Int,
	?host:String,
	?localAddress:String,
	?localPort:Int,
	?family:IPFamily,
	// ?hints:DnsHints,
	// ?lookup:DnsLookupFunction,
	?path:String
};

typedef SocketCreationOptions = SocketOptions & SocketConnectOptions;

extern class Socket {
	function new(); // ?options:SocketOptions);
	// function address():SocketAddress;
	// function connect(?options:SocketConnectOptions, ?connectListener:Listener<NoData>):Void;
	function connectTCP(port:Int,
		cb:Callback<NoData>):Void; // , ?options:{?host:String, ?localAddress:String, ?localPort:Int, ?family:IPFamily, ?hints:DnsHints, ?lookup:DnsLookupFunction}, ?connectListener:Listener<NoData>):Void;
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
	function write(data:Bytes, cb:Callback<NoData>):Void;
	function end(cb:Callback<NoData>):Void;

	// streams:
	function startRead(cb:Callback<Bytes>):Void;
	function stopRead():Void;

	// server:
	function bindTCP(port:Int):Void;
	function listen(backlog:Int, cb:Callback<NoData>):Void;
	function accept():Socket;
	function close(cb:Callback<NoData>):Void;
}
