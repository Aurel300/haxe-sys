package sys.net;

import haxe.io.Bytes;

class AddressTools {
	static final v4re = {
		final v4seg = "(?:[0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])";
		final v4str = '${v4seg}\\.${v4seg}\\.${v4seg}\\.${v4seg}';
		new EReg('^${v4str}$$', "");
	};

	static final v6re = {
		final v4seg = "(?:[0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])";
		final v4str = '${v4seg}\\.${v4seg}\\.${v4seg}\\.${v4seg}';
		final v6seg = "(?:[0-9a-fA-F]{1,4})";
		new EReg("^("
			+ '(?:${v6seg}:){7}(?:${v6seg}|:)|'
			+ '(?:${v6seg}:){6}(?:${v4str}|:${v6seg}|:)|'
			+ '(?:${v6seg}:){5}(?::${v4str}|(:${v6seg}){1,2}|:)|'
			+ '(?:${v6seg}:){4}(?:(:${v6seg}){0,1}:${v4str}|(:${v6seg}){1,3}|:)|'
			+ '(?:${v6seg}:){3}(?:(:${v6seg}){0,2}:${v4str}|(:${v6seg}){1,4}|:)|'
			+ '(?:${v6seg}:){2}(?:(:${v6seg}){0,3}:${v4str}|(:${v6seg}){1,5}|:)|'
			+ '(?:${v6seg}:){1}(?:(:${v6seg}){0,4}:${v4str}|(:${v6seg}){1,6}|:)|'
			+ '(?::((?::${v6seg}){0,5}:${v4str}|(?::${v6seg}){1,7}|:))'
			+ ")$", // "(%[0-9a-zA-Z]{1,})?$", // TODO: interface not supported
			"");
	};

	public static function format(address:Address):String {
		return (switch (address) {
			case IPv4(ip):
				'${ip >>> 24}.${(ip >> 16) & 0xFF}.${(ip >> 8) & 0xFF}.${ip & 0xFF}';
			case IPv6(ip):
				var groups = [for (i in 0...8) (ip.get(i * 2) << 8) | ip.get(i * 2 + 1)];
				var longestRun = -1;
				var longestPos = -1;
				for (i in 0...8) {
					if (groups[i] != 0)
						continue;
					var run = 1;
					// TODO: skip if the longest run cannot be beaten
					for (j in i + 1...8) {
						if (groups[j] != 0)
							break;
						run++;
					}
					if (run > longestRun) {
						longestRun = run;
						longestPos = i;
					}
				}
				inline function hex(groups:Array<Int>):String {
					return groups.map(value -> StringTools.hex(value, 1).toLowerCase()).join(":");
				}
				if (longestRun > 1) {
					hex(groups.slice(0, longestPos)) + "::" + hex(groups.slice(longestPos + longestRun));
				} else {
					hex(groups);
				}
		});
	}

	public static function isIP(address:String):Bool {
		return isIPv4(address) || isIPv6(address);
	}

	public static function isIPv4(address:String):Bool {
		return v4re.match(address);
	}

	public static function isIPv6(address:String):Bool {
		return v6re.match(address);
	}

	public static function toIP(address:String):Null<Address> {
		var ipv4 = toIPv4(address);
		return ipv4 != null ? ipv4 : toIPv6(address);
	}

	public static function toIPv4(address:String):Null<Address> {
		if (!isIPv4(address))
			return null;
		var components = address.split(".").map(Std.parseInt);
		return IPv4((components[0] << 24) | (components[1] << 16) | (components[2] << 8) | components[3]);
	}

	public static function toIPv6(address:String):Null<Address> {
		if (!isIPv6(address))
			return null;
		var buffer = Bytes.alloc(16);
		buffer.fill(0, 16, 0);
		function parse(component:String, res:Int):Void {
			var value = Std.parseInt('0x0$component');
			buffer.set(res, value >> 8);
			buffer.set(res + 1, value & 0xFF);
		}
		var stretch = address.split("::");
		var components = stretch[0].split(":");
		for (i in 0...components.length)
			parse(components[i], i * 2);
		if (stretch.length > 1) {
			var end = 16;
			components = stretch[1].split(":");
			if (isIPv4(components[components.length - 1])) {
				end -= 4;
				var ip = components.pop().split(".").map(Std.parseInt);
				for (i in 0...4)
					buffer.set(end + i, ip[i]);
			}
			end -= components.length * 2;
			for (i in 0...components.length)
				parse(components[i], end + i);
		}
		return IPv6(buffer);
	}

	public static function mapToIPv6(address:Address):Address {
		return (switch (address) {
			case IPv4(ip):
				var buffer = Bytes.alloc(16);
				buffer.set(10, 0xFF);
				buffer.set(11, 0xFF);
				buffer.set(12, ip >>> 24);
				buffer.set(13, (ip >> 16) & 0xFF);
				buffer.set(14, (ip >> 8) & 0xFF);
				buffer.set(15, ip & 0xFF);
				IPv6(buffer);
			case _:
				address;
		});
	}

	public static function equals(a:Address, b:Address, ?ipv6mapped:Bool = false):Bool {
		if (ipv6mapped) {
			return (switch [mapToIPv6(a), mapToIPv6(b)] {
				case [IPv6(a), IPv6(b)]: a.compare(b) == 0;
				case _: false; // cannot happen?
			});
		}
		return (switch [a, b] {
			case [IPv4(a), IPv4(b)]: a == b;
			case [IPv6(a), IPv6(b)]: a.compare(b) == 0;
			case _: false;
		});
	}
}
