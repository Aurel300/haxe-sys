package nusys.async.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.Bytes;
// import sys.net.DnsLookupFunction;
import sys.net.*;
import nusys.net.*;
import nusys.async.net.SocketOptions.UdpSocketOptions;

extern class UdpSocket {
	static function create(type:IpFamily, ?options:UdpSocketOptions, ?listener:Listener<UdpMessage>):UdpSocket;

	final type:IpFamily;

	/**
		Remote address and port that `this` socket is connected to. See `connect`.
	**/
	var remoteAddress(default, null):Null<SocketAddress>;

	private function get_localAddress():Null<SocketAddress>;

	var localAddress(get, never):Null<SocketAddress>;

	private function get_recvBufferSize():Int;
	private function set_recvBufferSize(size:Int):Int;

	var recvBufferSize(get, set):Int;

	private function get_sendBufferSize():Int;
	private function set_sendBufferSize(size:Int):Int;

	var sendBufferSize(get, set):Int;

	// final closeSignal:Signal<NoData>;
	// final connectSignal:Signal<NoData>;
	final errorSignal:Signal<Error>;
	// final listeningSignal:Signal<NoData>;

	/**
		Emitted when a message is received by `this` socket. See `UdpMessage`.
	**/
	final messageSignal:Signal<UdpMessage>;

	/**
		Joins the given multicast group.
	**/
	function addMembership(multicastAddress:String, ?multicastInterface:String):Void;

	/**
		Binds `this` socket to a local address and port. Packets sent to the bound
		address will arrive via `messageSignal`. Outgoing packets will be sent from
		the given address and port. If any packet is sent without calling `bind`
		first, an address and port is chosen automatically by the system - it can
		be obtained with `localAddress`.
	**/
	function bind(?address:Address, ?port:Int):Void;

	/**
		Closes `this` socket and all underlying resources.
	**/
	function close(?cb:Callback<NoData>):Void;

	/**
		Connects `this` socket to a remote address and port. Any `send` calls after
		`connect` is called must not specify `address` nor `port`, they will
		automatically use the ones specified in the `connect` call.
	**/
	function connect(?address:Address, port:Int):Void;

	/**
		Clears any remote address and port previously set with `connect`.
	**/
	function disconnect():Void;

	/**
		Leaves the given multicast group.
	**/
	function dropMembership(multicastAddress:String, ?multicastInterface:String):Void;

	/**
		Sends a message.

		@param msg Buffer from which to read the message data.
		@param offset Position in `msg` at which to start reading.
		@param length Length of message in bytes.
		@param address Address to send the message to. Must be `null` if `this`
			socket is connected.
		@param port Port to send the message to. Must be `null` if `this` socket is
			connected.
	**/
	function send(msg:Bytes, offset:Int, length:Int, ?address:Address, ?port:Int, ?callback:Callback<NoData>):Void;

	/**
		Sets broadcast on or off.
	**/
	function setBroadcast(flag:Bool):Void;

	/**
		Sets the multicast interface on which to send and receive data.
	**/
	function setMulticastInterface(multicastInterface:String):Void;

	/**
		Set IP multicast loopback on or off. Makes multicast packets loop back to
		local sockets.
	**/
	function setMulticastLoopback(flag:Bool):Void;

	/**
		Sets the multicast TTL (time-to-live).
	**/
	function setMulticastTTL(ttl:Int):Void;

	/**
		Sets the TTL (time-to-live) for outgoing packets.

		@param ttl Number of hops.
	**/
	function setTTL(ttl:Int):Void;

	function ref():Void;
	function unref():Void;
}

/**
	A packet received emitted by `messageSignal` of a `UdpSocket`.
**/
typedef UdpMessage = {
	/**
		Message data.
	**/
	var msg:Bytes;
	/**
		Remote IPv4 or IPv6 address from which the message originates.
	**/
	var remoteAddress:Address;
	/**
		Remote port from which the message originates.
	**/
	var remotePort:Int;
};
