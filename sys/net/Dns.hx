package sys.net;

import haxe.async.Callback;
import sys.net.Net.IPFamily;

extern class Dns {
  static function getServers():Array<String>;
  static function lookup(hostname:String, ?family:IPFamily, ?hints:DnsHints, ?all:Bool, ?verbatim:Bool, callback:Callback<{address:String, family:IPFamily}>):Void;
  static function lookupService(address:String, port:Int, callback:Callback<{hostname:String, service:String}>):Void;
  static function resolve(hostname:String, ?rrtype:String, callback:Callback<Array<DnsRecord>>):Void;
  static function resolve4(hostname:String, ?ttl:Bool, callback:Callback<Array<DnsRecord>>):Void;
  static function resolve6(hostname:String, ?ttl:Bool, callback:Callback<Array<DnsRecord>>):Void;
  static function resolveAny(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  static function resolveCname(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  static function resolveMx(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  static function resolveNaptr(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  static function resolveNs(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  static function resolvePtr(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  static function resolveSoa(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  static function resolveSrv(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  static function resolveTxt(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  static function reverse(ip:String, callback:Callback<Array<String>>):Void;
  static function setServers(servers:Array<String>):Void;
}

enum abstract DnsHints(Int) {
  var AddrConfig = 1 << 0;
  var V4Mapped = 1 << 1;
  
  inline function get_raw():Int return this;
  
  @:op(A | B)
  inline function join(other:DnsHints) return this | other.get_raw();
}

extern class DnsResolver {
  function new();
  function cancel():Void;
  function getServers():Array<String>;
  function resolve(hostname:String, ?rrtype:String, callback:Callback<Array<DnsRecord>>):Void;
  function resolve4(hostname:String, ?ttl:Bool, callback:Callback<Array<DnsRecord>>):Void;
  function resolve6(hostname:String, ?ttl:Bool, callback:Callback<Array<DnsRecord>>):Void;
  function resolveAny(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  function resolveCname(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  function resolveMx(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  function resolveNaptr(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  function resolveNs(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  function resolvePtr(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  function resolveSoa(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  function resolveSrv(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  function resolveTxt(hostname:String, callback:Callback<Array<DnsRecord>>):Void;
  function reverse(ip:String, callback:Callback<Array<String>>):Void;
  function setServers(servers:Array<String>):Void;
}

enum DnsRecord {
  Address(address:String);
  AddressTtl(address:String, ttl:Int);
  Value(v:String);
  
  Mx(priority:Int, exchange:String);
  Naptr(flags:String, service:String, regexp:String, replacement:String, order:Int, preference:Int);
  Soa(nsname:String, hostmaster:String, serial:Int, refresh:Int, retry:Int, expire:Int, minttl:Int);
  Srv(priority:Int, weight:Int, port:Int, name:String);
  Txt(entry:String);
}
