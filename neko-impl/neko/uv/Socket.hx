package neko.uv;

import haxe.NoData;
import haxe.async.*;
import asys.net.*;

@:access(haxe.async.Callback)
abstract Socket(Dynamic) from Dynamic {
	static var w_tcp_init:(Loop)->Dynamic = neko.Lib.load("uv", "w_tcp_init", 1);
	static var w_tcp_nodelay:(Dynamic, Bool)->Void = neko.Lib.load("uv", "w_tcp_nodelay", 2);
	static var w_tcp_keepalive:(Dynamic, Bool, Int)->Void = neko.Lib.load("uv", "w_tcp_keepalive", 3);
	static var w_tcp_accept:(Loop, Dynamic)->Dynamic = neko.Lib.load("uv", "w_tcp_accept", 2);
	static var w_tcp_bind_ipv4:(Dynamic, Int, Int)->Void = neko.Lib.load("uv", "w_tcp_bind_ipv4", 3);
	static var w_tcp_bind_ipv6:(Dynamic, neko.NativeString, Int, Bool)->Void = neko.Lib.load("uv", "w_tcp_bind_ipv6", 4);
	static var w_tcp_connect_ipv4:(Dynamic, Int, Int, Dynamic->Void)->Void = neko.Lib.load("uv", "w_tcp_connect_ipv4", 4);
	static var w_tcp_connect_ipv6:(Dynamic, neko.NativeString, Int, Dynamic->Void)->Void = neko.Lib.load("uv", "w_tcp_connect_ipv6", 4);
	static var w_tcp_getsockname:(Dynamic)->Dynamic = neko.Lib.load("uv", "w_tcp_getsockname", 1);
	static var w_tcp_getpeername:(Dynamic)->Dynamic = neko.Lib.load("uv", "w_tcp_getpeername", 1);
	static var w_tcp_stream:(Dynamic)->Stream = neko.Lib.load("uv", "w_tcp_stream", 1);

	public inline function new() {
		this = w_tcp_init(Uv.loop);
	}

	public inline function connectTcp(address:Address, port:Int, cb:Callback<NoData>):Void {
		switch (address) {
			case Ipv4(ip):
				w_tcp_connect_ipv4(this, ip, port, cb.toUVNoData());
			case Ipv6(ip):
				w_tcp_connect_ipv6(this, ip.getData(), port, cb.toUVNoData());
		}
	}

	public inline function bindTcp(address:Address, port:Int, ipv6only:Bool):Void {
		switch (address) {
			case Ipv4(ip):
				w_tcp_bind_ipv4(this, ip, port);
			case Ipv6(ip):
				w_tcp_bind_ipv6(this, ip.getData(), port, ipv6only);
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
