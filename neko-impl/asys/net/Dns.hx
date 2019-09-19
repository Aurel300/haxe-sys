package asys.net;

import haxe.async.*;
import asys.net.DnsLookupOptions.DnsHints;

@:access(String)
class Dns {
	static var w_dns_getaddrinfo:(neko.NativeArray<Dynamic>)->Void = neko.Lib.load("uv", "w_dns_getaddrinfo_dyn", 1);

	public static function lookup(hostname:String, ?lookupOptions:DnsLookupOptions, cb:Callback<Array<Address>>):Void {
		if (lookupOptions == null)
			lookupOptions = {};
		var flagAddrConfig = lookupOptions.hints != null && @:privateAccess lookupOptions.hints.get_raw() & @:privateAccess DnsHints.AddrConfig.get_raw() != 0;
		var flagV4Mapped = lookupOptions.hints != null && @:privateAccess lookupOptions.hints.get_raw() & @:privateAccess DnsHints.V4Mapped.get_raw() != 0;
		w_dns_getaddrinfo(neko.NativeArray.ofArrayRef(([neko.Uv.loop, neko.NativeString.ofString(hostname), flagAddrConfig, flagV4Mapped, switch (lookupOptions.family) {
			case null: 0;
			case Ipv4: 4;
			case Ipv6: 6;
		}, (error, entries) -> {
			if (error != null)
				cb(error, null);
			else
				cb(null, neko.NativeArray.toArray(entries));
		}]:Array<Dynamic>)));
	}

	public static function reverse(ip:Address, callback:Callback<Array<String>>):Void {
		throw "!"; // TODO
	}
}
