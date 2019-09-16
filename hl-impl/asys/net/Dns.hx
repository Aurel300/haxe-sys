package asys.net;

import haxe.async.*;
import asys.net.DnsLookupOptions.DnsHints;

@:access(String)
class Dns {
	@:hlNative("uv", "w_dns_getaddrinfo") public static function w_dns_getaddrinfo(_:hl.uv.Loop, _:hl.Bytes, flag_addrconfig:Bool, flag_v4mapped:Bool, hint_family:Int, cb:(Dynamic, hl.NativeArray<Address>)->Void):Void {}
	// @:hlNative("uv", "w_getnameinfo_ipv4") public static function getnameinfo_ipv4(loop:UVLoop, ip:Int, flags:Int, cb:(Dynamic, hl.Bytes, hl.Bytes)->Void):Void {}
	// @:hlNative("uv", "w_getnameinfo_ipv6") public static function getnameinfo_ipv6(loop:UVLoop, ip:hl.Bytes, flags:Int, cb:(Dynamic, hl.Bytes, hl.Bytes)->Void):Void {}

	public static function lookup(hostname:String, ?lookupOptions:DnsLookupOptions, cb:Callback<Array<Address>>):Void {
		if (lookupOptions == null)
			lookupOptions = {};
		var flagAddrConfig = lookupOptions.hints != null && @:privateAccess lookupOptions.hints.get_raw() & @:privateAccess DnsHints.AddrConfig.get_raw() != 0;
		var flagV4Mapped = lookupOptions.hints != null && @:privateAccess lookupOptions.hints.get_raw() & @:privateAccess DnsHints.V4Mapped.get_raw() != 0;
		w_dns_getaddrinfo(hl.Uv.loop, hostname.toUtf8(), flagAddrConfig, flagV4Mapped, switch (lookupOptions.family) {
			case null: 0;
			case Ipv4: 4;
			case Ipv6: 6;
		}, (error, entries) -> {
			if (error != null)
				cb(error, null);
			else
				cb(null, cast hl.types.ArrayObj.alloc(entries));
		});
	}

	public static function reverse(ip:Address, callback:Callback<Array<String>>):Void {
		throw "!"; // TODO
	}
}
