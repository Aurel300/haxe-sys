package nusys.net;

import haxe.io.Bytes;

/**
	Represents a resolved IP address. The methods from `nusys.net.AddressTools`
	are always available on `Address` instances.
**/
@:using(nusys.net.AddressTools)
enum Address {
	/**
		32-bit IPv4 address. As an example, the IP address `127.0.0.1` is
		represented as `Ipv4(0x7F000001)`.
	**/
	Ipv4(raw:Int);

	/**
		128-bit IPv6 address.
	**/
	Ipv6(raw:Bytes);
}
