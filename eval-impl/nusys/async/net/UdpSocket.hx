package nusys.async.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.Bytes;
// import sys.net.DnsLookupFunction;
import sys.net.*;
import nusys.net.*;

class UdpSocket {
	public static function create(type:IpFamily, ?options:{
		?reuseAddr:Bool,
		?ipv6Only:Bool,
		?recvBufferSize:Int,
		?sendBufferSize:Int,
		// ?lookup:DnsLookupFunction
	}, ?listener:Listener<UdpMessage>):UdpSocket {
		var native = new eval.uv.UdpSocket();
		var res = new UdpSocket(native, type);
		// TODO: use other options, register listener
		if (options == null)
			options = {};
		if (options.recvBufferSize != null)
			res.recvBufferSize = options.recvBufferSize;
		if (options.sendBufferSize != null)
			res.sendBufferSize = options.sendBufferSize;
		return res;
	}

	//final closeSignal:Signal<NoData>;
	//final connectSignal:Signal<NoData>;
	public final errorSignal:Signal<Error> = new ArraySignal();
	//final listeningSignal:Signal<NoData>;
	public final messageSignal:Signal<UdpMessage> = new ArraySignal();

	public final type:IpFamily;
	public var remoteAddress(default, null):Null<SocketAddress>;
	public var localAddress(get, never):Null<SocketAddress>;
	public var recvBufferSize(get, set):Int;
	public var sendBufferSize(get, set):Int;
	var native:eval.uv.UdpSocket;

	function new(native, type) {
		this.native = native;
		this.type = type;
	}

	function get_localAddress():Null<SocketAddress> {
		return try native.getSockName() catch (e:Dynamic) null;
	}

	function get_recvBufferSize():Int {
		return native.getRecvBufferSize();
	}

	function get_sendBufferSize():Int {
		return native.getSendBufferSize();
	}

	function set_recvBufferSize(size:Int):Int {
		return native.setRecvBufferSize(size);
	}

	function set_sendBufferSize(size:Int):Int {
		return native.setSendBufferSize(size);
	}

	public function bind(?address:Address, ?port:Int):Void {
		if (address == null)
			address = AddressTools.all(type);
		if (port == null)
			port = 0;
		native.bindTcp(address, port, false);
		native.startRead((err, msg) -> {
			if (err != null)
				return errorSignal.emit(err);
			messageSignal.emit(msg);
		});
	}

	public function close(?cb:Callback<NoData>):Void {
		native.stopRead();
		native.close(Callback.nonNull(cb));
	}

	public function connect(?address:Address, port:Int):Void {
		if (remoteAddress != null)
			throw "already connected";
		if (address == null)
			address = AddressTools.localhost(type);
		remoteAddress = Network(address, port);
	}

	public function disconnect():Void {
		if (remoteAddress == null)
			throw "not connected";
		remoteAddress = null;
	}

	public function send(msg:Bytes, offset:Int, length:Int, ?address:Address, ?port:Int, ?callback:Callback<NoData>):Void {
		if (address == null && port == null) {
			if (remoteAddress == null)
				throw "not connected";
		} else if (address != null && port != null) {
			if (remoteAddress != null)
				throw "already connected";
		} else
			throw "invalid arguments";
		if (address == null) {
			switch (remoteAddress) {
				case Network(a, p):
					address = a;
					port = p;
				case _:
					throw "!";
			}
		}
		native.send(msg, offset, length, address, port, callback);
	}

	public function addMembership(multicastAddress:String, ?multicastInterface:String):Void {
		if (multicastInterface == null)
			multicastInterface = "";
		native.addMembership(multicastAddress, multicastInterface);
	}

	public function dropMembership(multicastAddress:String, ?multicastInterface:String):Void {
		if (multicastInterface == null)
			multicastInterface = "";
		native.dropMembership(multicastAddress, multicastInterface);
	}

	public function setBroadcast(flag:Bool):Void {
		native.setBroadcast(flag);
	}

	public function setMulticastInterface(multicastInterface:String):Void {
		native.setMulticastInterface(multicastInterface);
	}

	public function setMulticastLoopback(flag:Bool):Void {
		native.setMulticastLoopback(flag);
	}

	public function setMulticastTTL(ttl:Int):Void {
		native.setMulticastTTL(ttl);
	}

	public function setTTL(ttl:Int):Void {
		native.setTTL(ttl);
	}

	//function ref():Void;
	//function unref():Void;
}

typedef UdpMessage = {
	data:Bytes,
	remoteAddress:Address,
	remotePort:Int
};
