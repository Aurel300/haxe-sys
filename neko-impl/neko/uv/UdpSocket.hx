package neko.uv;

import haxe.NoData;
import haxe.async.*;
import haxe.io.Bytes;
import asys.net.*;

@:access(String)
@:access(haxe.async.Callback)
abstract UdpSocket(Dynamic) from Dynamic {
	static var w_udp_init:(Loop)->Dynamic = neko.Lib.load("uv", "w_udp_init", 1);
	static var w_udp_bind_ipv4:(Dynamic, Int, Int)->Void = neko.Lib.load("uv", "w_udp_bind_ipv4", 3);
	static var w_udp_bind_ipv6:(Dynamic, neko.NativeString, Int, Bool)->Void = neko.Lib.load("uv", "w_udp_bind_ipv6", 4);
	static var w_udp_send_ipv4:(neko.NativeArray<Dynamic>)->Void = neko.Lib.load("uv", "w_udp_send_ipv4_dyn", 1);
	static var w_udp_send_ipv6:(neko.NativeArray<Dynamic>)->Void = neko.Lib.load("uv", "w_udp_send_ipv6_dyn", 1);
	static var w_udp_recv_start:(Dynamic, (Dynamic, neko.NativeString, Int, Dynamic, Int)->Void)->Void = neko.Lib.load("uv", "w_udp_recv_start", 2);
	static var w_udp_recv_stop:(Dynamic)->Void = neko.Lib.load("uv", "w_udp_recv_stop", 1);
	static var w_udp_set_membership:(Dynamic, neko.NativeString, neko.NativeString, Bool)->Void = neko.Lib.load("uv", "w_udp_set_membership", 4);
	static var w_udp_close:(Dynamic, Dynamic->Void)->Void = neko.Lib.load("uv", "w_udp_close", 2);
	static var w_udp_getsockname:(Dynamic)->Dynamic = neko.Lib.load("uv", "w_udp_getsockname", 1);
	static var w_udp_set_broadcast:(Dynamic, Bool)->Void = neko.Lib.load("uv", "w_udp_set_broadcast", 2);
	static var w_udp_set_multicast_interface:(Dynamic, neko.NativeString)->Void = neko.Lib.load("uv", "w_udp_set_multicast_interface", 2);
	static var w_udp_set_multicast_loopback:(Dynamic, Bool)->Void = neko.Lib.load("uv", "w_udp_set_multicast_loopback", 2);
	static var w_udp_set_multicast_ttl:(Dynamic, Int)->Void = neko.Lib.load("uv", "w_udp_set_multicast_ttl", 2);
	static var w_udp_set_ttl:(Dynamic, Int)->Void = neko.Lib.load("uv", "w_udp_set_ttl", 2);
	static var w_udp_get_recv_buffer_size:(Dynamic)->Int = neko.Lib.load("uv", "w_udp_get_recv_buffer_size", 1);
	static var w_udp_get_send_buffer_size:(Dynamic)->Int = neko.Lib.load("uv", "w_udp_get_send_buffer_size", 1);
	static var w_udp_set_recv_buffer_size:(Dynamic, Int)->Int = neko.Lib.load("uv", "w_udp_set_recv_buffer_size", 2);
	static var w_udp_set_send_buffer_size:(Dynamic, Int)->Int = neko.Lib.load("uv", "w_udp_set_send_buffer_size", 2);
	static var w_udp_stream:(Dynamic)->Stream = neko.Lib.load("uv", "w_udp_stream", 1);

	public inline function new() {
		this = w_udp_init(Uv.loop);
	}

	public inline function addMembership(multicastAddress:String, multicastInterface:String):Void {
		w_udp_set_membership(this, neko.NativeString.ofString(multicastAddress), neko.NativeString.ofString(multicastInterface), true);
	}

	public inline function dropMembership(multicastAddress:String, multicastInterface:String):Void {
		w_udp_set_membership(this, neko.NativeString.ofString(multicastAddress), neko.NativeString.ofString(multicastInterface), false);
	}

	public inline function send(msg:Bytes, offset:Int, length:Int, address:Address, port:Int, cb:Callback<NoData>):Void {
		switch (address) {
			case Ipv4(ip):
				w_udp_send_ipv4(neko.NativeArray.ofArrayRef(([
					this, msg.getData(), offset, length, ip, port, cb.toUVNoData()
				]:Array<Dynamic>)));
			case Ipv6(ip):
				w_udp_send_ipv6(neko.NativeArray.ofArrayRef(([
					this, msg.getData(), offset, length, ip.getData(), port, cb.toUVNoData()
				]:Array<Dynamic>)));
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
				w_udp_bind_ipv6(this, ip.getData(), port, ipv6only);
		}
	}

	public inline function startRead(cb:Callback<{data:Bytes, remoteAddress:Address, remotePort:Int}>):Void {
		w_udp_recv_start(this, (error, data, length, addr, port) -> {
			if (error != null)
				cb(error, null);
			else
				cb(null, {data: Bytes.ofData(data), remoteAddress: addr, remotePort: port});
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
		w_udp_set_multicast_interface(this, neko.NativeString.ofString(intfc));
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
