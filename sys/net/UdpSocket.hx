package sys.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.async.Event;
import haxe.async.Listener;
import haxe.io.Bytes;
import sys.net.Dns.DnsLookupFunction;
import sys.net.Net.IPFamily;

extern class UdpSocket {
  // Haxe compatibility
  // function new(); // matching interface
  function readFrom(buf:Bytes, pos:Int, len:Int, addr:Address):Int;
  function sendTo(buf:Bytes, pos:Int, len:Int, addr:Address):Int;
  // function setBroadcast(b:Bool):Void; // matching interface
  
  // node compatibility (dgram.Socket)
  static function createSocket(type:IPFamily, options:{?reuseAddr:Bool, ?ipv6Only:Bool, ?recvBufferSize:Int, ?sendBufferSize:Int, ?lookup:DnsLookupFunction}, ?listener:Listener<UdpMessage>):UdpSocket;
  
  final eventClose:Event<NoData>;
  final eventConnect:Event<NoData>;
  final eventError:Event<Error>;
  final eventListening:Event<NoData>;
  final eventMessage:Event<UdpMessage>;
  
  function new();
  function addMembership(multicastAddress:String, ?multicastInterface:String):Void;
  function address():SocketAddress;
  function bind(?port:Int, ?address:String, ?listener:Listener<NoData>):Void;
  // bind over fd?
  function close(?listener:Listener<NoData>):Void;
  function connect(port:Int, ?address:String, ?callback:Callback<NoData>):Void;
  function disconnect():Void;
  function dropMembership(multicastAddress:String, ?multicastInterface:String):Void;
  function getRecvBufferSize():Int;
  function getSendBufferSize():Int;
  function ref():Void;
  function remoteAddress():SocketAddress;
  function send(msg:Bytes, ?offset:Int, ?length:Int, ?port:Int, ?address:String, ?callback:Callback<NoData>):Void;
  function setBroadcast(flag:Bool):Void;
  function setMulticastInterface(multicastInterface:String):Void;
  function setMulticastLoopback(flag:Bool):Void;
  function setMulticastTTL(ttl:Int):Void;
  function setRecvBufferSize(size:Int):Void;
  function setSendBufferSize(size:Int):Void;
  function setTTL(ttl:Int):Void;
  function unref():Void;
}

typedef UdpMessage = {
    msg:Bytes,
    rinfo:{
        address:String,
        family:IPFamily,
        port:Int,
        size:Int
      }
  };
