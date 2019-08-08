package nusys.net;

import nusys.net.Address;
import sys.net.DnsLookupOptions;
import haxe.async.Callback;

using nusys.net.AddressTools;

extern class Dns {
	static function lookup(hostname:String, ?lookupOptions:DnsLookupOptions, callback:Callback<Array<Address>>):Void;
	static function reverse(ip:Address, callback:Callback<Array<String>>):Void;
}
