package sys.net;

import haxe.io.Bytes;

enum Address {
	IPv4(raw:Int);
	IPv6(raw:Bytes);
}
