package sys.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.Event;
import haxe.io.Bytes;
import sys.net.Net.IPFamily;

extern class UdpSocket {
  // Haxe compatibility
  // function new(); // matching interface
  function readFrom(buf:Bytes, pos:Int, len:Int, addr:Address):Int;
  function sendTo(buf:Bytes, pos:Int, len:Int, addr:Address):Int;
  // function setBroadcast(b:Bool):Void; // matching interface
  
  // node compatibility (dgram.Socket)
  final eventClose:Event<NoData>;
  final eventConnect:Event<NoData>;
  final eventError:Event<Error>;
  final eventListening:Event<NoData>;
  final eventMessage:Event<UdpMessage>;
  
  function new();
  function addMembership(multicastAddress:String, ?multicastInterface:String):Void;
  function address():SocketAddress;
  function bind(?port:Int, ?address:String, ?callback:Callback<NoData>):Void;
  // bind over fd?
  function close(?callback:Callback<NoData>):Void;
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
}

typedef UdpMessage = {
     msg:Bytes
    ,rinfo:{
         address:String
        ,family:IPFamily
        ,port:Int
        ,size:Int
      }
  };
