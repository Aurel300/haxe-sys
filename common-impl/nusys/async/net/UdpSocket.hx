package nusys.async.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.Bytes;
// import sys.net.DnsLookupFunction;
import sys.net.*;
import nusys.net.*;

extern class UdpSocket {
	static function createSocket(type:IpFamily, options:{
		?reuseAddr:Bool,
		?ipv6Only:Bool,
		?recvBufferSize:Int,
		?sendBufferSize:Int,
		// ?lookup:DnsLookupFunction
	}, ?listener:Listener<UdpMessage>):UdpSocket;

	final closeSignal:Signal<NoData>;
	final connectSignal:Signal<NoData>;
	final errorSignal:Signal<Error>;
	final listeningSignal:Signal<NoData>;
	final messageSignal:Signal<UdpMessage>;

	function new();
	function addMembership(multicastAddress:Address, ?multicastInterface:String):Void;
	function address():SocketAddress;
	function bind(?port:Int, ?address:Address, ?listener:Listener<NoData>):Void;
	// bind over fd?
	function close(?listener:Listener<NoData>):Void;
	function connect(port:Int, ?address:Address, ?callback:Callback<NoData>):Void;
	function disconnect():Void;
	function dropMembership(multicastAddress:Address, ?multicastInterface:String):Void;
	function getRecvBufferSize():Int;
	function getSendBufferSize():Int;
	function ref():Void;
	function remoteAddress():SocketAddress;
	function send(msg:Bytes, offset:Int, length:Int, ?address:Address, ?port:Int, ?callback:Callback<NoData>):Void;
	function setBroadcast(flag:Bool):Void;
	function setMulticastInterface(multicastInterface:String):Void;
	function setMulticastLoopback(flag:Bool):Void;
	function setMulticastTTL(ttl:Int):Void;
	function setRecvBufferSize(size:Int):Void;
	function setSendBufferSize(size:Int):Void;
	function setTTL(ttl:Int):Void;
	function unref():Void;
}

typedef UdpMessage = {
	msg:Bytes,
	remoteAddress:Address,
	remotePort:Int
};
