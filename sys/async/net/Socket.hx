package sys.async.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import sys.net.Dns.DnsHints;
import sys.net.Dns.DnsLookupFunction;
import sys.net.Net.IPFamily;
import sys.net.Net.NetFamily;
import sys.net.Net.SocketAddress;

typedef SocketOptions = {
    ?file:sys.io.File, // fd in Node
    ?allowHalfOpen:Bool,
    ?readable:Bool,
    ?writable:Bool
  };

typedef SocketConnectOptions = {
    ?port:Int,
    ?host:String,
    ?localAddress:String,
    ?localPort:Int,
    ?family:IPFamily,
    ?hints:DnsHints,
    ?lookup:DnsLookupFunction,
    ?path:String
  };

typedef SocketCreationOptions = sys.async.net.Socket.SocketOptions & sys.async.net.Socket.SocketConnectOptions;

extern class Socket extends haxe.io.Duplex {
  // node compatibility
  //final closeSignal:Signal<NoData>;
  final connectSignal:Signal<NoData>;
  //final dataSignal:Signal<Bytes>;
  //final drainSignal:Signal<NoData>;
  //final endSignal:Signal<NoData>;
  //final errorSignal:Signal<Error>;
  //final finishSignal:Signal<NoData>;
  final lookupSignal:Signal<{?err:Error, address:String, ?family:String, host:String}>;
  //final pauseSignal:Signal<NoData>;
  //final pipeSignal:Signal<IReadable>;
  //final readableSignal:Signal<NoData>;
  final readySignal:Signal<NoData>;
  //final resumeSignal:Signal<NoData>;
  final timeoutSignal:Signal<NoData>;
  //final unpipeSignal:Signal<IReadable>;
  
  var bufferSize:Int;
  var bytesRead:Int;
  var bytesWritten:Int;
  var connecting:Bool;
  var destroyed:Bool;
  var hadError:Bool;
  var localAddress:String;
  var localPort:Int;
  var pending:Bool;
  var remoteAddress:String;
  var remoteFamily:NetFamily;
  var remotePort:Int;
  
  function new(?options:SocketOptions);
  function address():SocketAddress;
  function connect(?options:SocketConnectOptions, ?connectListener:Listener<NoData>):Void;
  function connectTCP(port:Int, ?options:{?host:String, ?localAddress:String, ?localPort:Int, ?family:IPFamily, ?hints:DnsHints, ?lookup:DnsLookupFunction}, ?connectListener:Listener<NoData>):Void;
  function connectIPC(path:String, ?connectListener:Listener<NoData>):Void;
  // function destroy from Duplex
  // function end from Duplex
  // function pause from Duplex
  function ref():Void;
  // function resume from Duplex
  function setKeepAlive(?enable:Bool, ?initialDelay:Float):Void;
  function setNoDelay(?noDelay:Bool):Void;
  function setTimeout(timeout:Float, ?listener:Listener<NoData>):Void;
  function unref():Void;
  // function write from Duplex
}
