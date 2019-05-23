package sys.net;

import haxe.async.Callback;
import sys.net.Net.IPFamily;

typedef DnsLookupOptions = {
    ?family:IPFamily,
    ?hints:DnsHints,
    ?all:Bool,
    ?verbatim:Bool
  };

typedef DnsLookupFunction = (hostname:String, ?lookupOptions:DnsLookupOptions, callback:Callback<Array<{address:String, family:IPFamily}>>)->Void;

extern class Dns {
  static function lookup(hostname:String, ?lookupOptions:DnsLookupOptions, callback:Callback<Array<{address:String, family:IPFamily}>>):Void;
  static function reverse(ip:String, callback:Callback<Array<String>>):Void;
}

enum abstract DnsHints(Int) {
  var AddrConfig = 1 << 0;
  var V4Mapped = 1 << 1;
  
  inline function get_raw():Int return this;
  
  @:op(A | B)
  inline function join(other:DnsHints) return this | other.get_raw();
}
