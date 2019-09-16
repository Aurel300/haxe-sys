package hl.uv;

import haxe.NoData;
import haxe.async.*;
import haxe.io.Bytes;
import asys.net.*;

private typedef Native = hl.Abstract<"uv_udp_t">;

@:access(String)
@:access(haxe.async.Callback)
abstract UdpSocket(Native) from Native {
	@:hlNative("uv", "w_udp_init") static function w_udp_init(_:Loop):Native return null;
	@:hlNative("uv", "w_udp_bind_ipv4") static function w_udp_bind_ipv4(_:Native, _:Int, _:Int):Void {}
	@:hlNative("uv", "w_udp_bind_ipv6") static function w_udp_bind_ipv6(_:Native, _:hl.Bytes, _:Int, _:Bool):Void {}
	@:hlNative("uv", "w_udp_send_ipv4") static function w_udp_send_ipv4(_:Native, _:hl.Bytes, _:Int, _:Int, _:Int, _:Dynamic->Void):Void {}
	@:hlNative("uv", "w_udp_send_ipv6") static function w_udp_send_ipv6(_:Native, _:hl.Bytes, _:Int, _:hl.Bytes, _:Int, _:Dynamic->Void):Void {}
	@:hlNative("uv", "w_udp_recv_start") static function w_udp_recv_start(_:Native, _:(Dynamic, hl.Bytes, Int, Dynamic, Int)->Void):Void {}
	@:hlNative("uv", "w_udp_recv_stop") static function w_udp_recv_stop(_:Native):Void {}
	@:hlNative("uv", "w_udp_set_membership") static function w_udp_set_membership(_:Native, _:hl.Bytes, _:hl.Bytes, _:Bool):Void {}
	@:hlNative("uv", "w_udp_close") static function w_udp_close(_:Native, _:Dynamic->Void):Void {}
	@:hlNative("uv", "w_udp_getsockname") static function w_udp_getsockname(_:Native):Dynamic return null;
	@:hlNative("uv", "w_udp_set_broadcast") static function w_udp_set_broadcast(_:Native, _:Bool):Void {}
	@:hlNative("uv", "w_udp_set_multicast_interface") static function w_udp_set_multicast_interface(_:Native, _:hl.Bytes):Void {}
	@:hlNative("uv", "w_udp_set_multicast_loopback") static function w_udp_set_multicast_loopback(_:Native, _:Bool):Void {}
	@:hlNative("uv", "w_udp_set_multicast_ttl") static function w_udp_set_multicast_ttl(_:Native, _:Int):Void {}
	@:hlNative("uv", "w_udp_set_ttl") static function w_udp_set_ttl(_:Native, _:Int):Void {}
	@:hlNative("uv", "w_udp_get_recv_buffer_size") static function w_udp_get_recv_buffer_size(_:Native):Int return 0;
	@:hlNative("uv", "w_udp_get_send_buffer_size") static function w_udp_get_send_buffer_size(_:Native):Int return 0;
	@:hlNative("uv", "w_udp_set_recv_buffer_size") static function w_udp_set_recv_buffer_size(_:Native, _:Int):Int return 0;
	@:hlNative("uv", "w_udp_set_send_buffer_size") static function w_udp_set_send_buffer_size(_:Native, _:Int):Int return 0;
	@:hlNative("uv", "w_udp_stream") static function w_udp_stream(_:Native):Stream return null;

	public inline function new() {
		this = w_udp_init(Uv.loop);
	}

	public inline function addMembership(multicastAddress:String, multicastInterface:String):Void {
		w_udp_set_membership(this, multicastAddress.toUtf8(), multicastInterface.toUtf8(), true);
	}

	public inline function dropMembership(multicastAddress:String, multicastInterface:String):Void {
		w_udp_set_membership(this, multicastAddress.toUtf8(), multicastInterface.toUtf8(), false);
	}

	public inline function send(msg:Bytes, offset:Int, length:Int, address:Address, port:Int, cb:Callback<NoData>):Void {
		switch (address) {
			case Ipv4(ip):
				w_udp_send_ipv4(this, hl.Bytes.fromBytes(msg).offset(offset), length, ip, port, cb.toUVNoData());
			case Ipv6(ip):
				w_udp_send_ipv6(this, hl.Bytes.fromBytes(msg).offset(offset), length, ip, port, cb.toUVNoData());
		}
	}

	public inline function close(cb:Callback<NoData>):Void {
		w_udp_close(this, cb.toUVNoData());
	}

	public inline function bindTcp(address:Address, port:Int, ipv6only:Bool):Void {
		switch (address) {
			case Ipv4(ip):
				w_udp_bind_ipv4(this, ip, port);
			case Ipv6(ip):
				w_udp_bind_ipv6(this, ip, port, ipv6only);
		}
	}

	public inline function startRead(cb:Callback<{data:Bytes, remoteAddress:Address, remotePort:Int}>):Void {
		w_udp_recv_start(this, (error, data, length, addr, port) -> {
			if (error != null)
				cb(error, null);
			else
				cb(null, {data: data.toBytes(length), remoteAddress: addr, remotePort: port});
		});
	}

	public inline function stopRead():Void {
		w_udp_recv_stop(this);
	}

	public inline function getSockName():SocketAddress {
		return w_udp_getsockname(this);
	}

	public inline function setBroadcast(flag:Bool):Void {
		w_udp_set_broadcast(this, flag);
	}

	public inline function setMulticastInterface(intfc:String):Void {
		w_udp_set_multicast_interface(this, intfc.toUtf8());
	}

	public inline function setMulticastLoopback(flag:Bool):Void {
		w_udp_set_multicast_loopback(this, flag);
	}

	public inline function setMulticastTTL(ttl:Int):Void {
		w_udp_set_multicast_ttl(this, ttl);
	}

	public inline function setTTL(ttl:Int):Void {
		w_udp_set_ttl(this, ttl);
	}

	public inline function getRecvBufferSize():Int {
		return w_udp_get_recv_buffer_size(this);
	}

	public inline function getSendBufferSize():Int {
		return w_udp_get_send_buffer_size(this);
	}

	public inline function setRecvBufferSize(size:Int):Int {
		return w_udp_set_recv_buffer_size(this, size);
	}

	public inline function setSendBufferSize(size:Int):Int {
		return w_udp_set_send_buffer_size(this, size);
	}

	public inline function asStream():Stream {
		return w_udp_stream(this);
	}
}
