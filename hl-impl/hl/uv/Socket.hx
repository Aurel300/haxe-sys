package hl.uv;

import haxe.NoData;
import haxe.async.*;
import asys.net.*;

private typedef Native = hl.Abstract<"uv_tcp_t">;

@:access(haxe.async.Callback)
abstract Socket(Native) from Native {
	@:hlNative("uv", "w_tcp_init") static function w_tcp_init(_:Loop):Native return null;
	@:hlNative("uv", "w_tcp_nodelay") static function w_tcp_nodelay(_:Native, _:Bool):Void {};
	@:hlNative("uv", "w_tcp_keepalive") static function w_tcp_keepalive(_:Native, _:Bool, _:Int):Void {};
	@:hlNative("uv", "w_tcp_accept") static function w_tcp_accept(_:Loop, _:Native):Native return null;
	@:hlNative("uv", "w_tcp_bind_ipv4") static function w_tcp_bind_ipv4(_:Native, _:Int, _:Int):Void {};
	@:hlNative("uv", "w_tcp_bind_ipv6") static function w_tcp_bind_ipv6(_:Native, _:hl.Bytes, _:Int, _:Bool):Void {};
	@:hlNative("uv", "w_tcp_connect_ipv4") static function w_tcp_connect_ipv4(_:Native, _:Int, _:Int, _:Dynamic->Void):Void {};
	@:hlNative("uv", "w_tcp_connect_ipv6") static function w_tcp_connect_ipv6(_:Native, _:hl.Bytes, _:Int, _:Dynamic->Void):Void {};
	@:hlNative("uv", "w_tcp_getsockname") static function w_tcp_getsockname(_:Native):Dynamic return null;
	@:hlNative("uv", "w_tcp_getpeername") static function w_tcp_getpeername(_:Native):Dynamic return null;
	@:hlNative("uv", "w_tcp_stream") static function w_tcp_stream(_:Native):Stream return null;

	public inline function new() {
		this = w_tcp_init(Uv.loop);
	}

	public inline function connectTcp(address:Address, port:Int, cb:Callback<NoData>):Void {
		switch (address) {
			case Ipv4(ip):
				w_tcp_connect_ipv4(this, ip, port, cb.toUVNoData());
			case Ipv6(ip):
				w_tcp_connect_ipv6(this, hl.Bytes.fromBytes(ip), port, cb.toUVNoData());
		}
	}

	public inline function bindTcp(address:Address, port:Int, ipv6only:Bool):Void {
		switch (address) {
			case Ipv4(ip):
				w_tcp_bind_ipv4(this, ip, port);
			case Ipv6(ip):
				w_tcp_bind_ipv6(this, hl.Bytes.fromBytes(ip), port, ipv6only);
		}
	}

	public inline function accept():Socket {
		return w_tcp_accept(Uv.loop, this);
	}

	public inline function setKeepAlive(enable:Bool, initialDelay:Int):Void {
		w_tcp_keepalive(this, enable, initialDelay);
	}

	public inline function setNoDelay(noDelay:Bool):Void {
		w_tcp_nodelay(this, noDelay);
	}

	public inline function getSockName():SocketAddress {
		return w_tcp_getsockname(this);
	}

	public inline function getPeerName():SocketAddress {
		return w_tcp_getpeername(this);
	}

	public inline function asStream():Stream {
		return w_tcp_stream(this);
	}
}
