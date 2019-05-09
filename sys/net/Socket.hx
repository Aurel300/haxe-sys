package sys.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.async.Event;
import sys.net.Net.IPFamily;
import sys.net.Net.NetFamily;
import sys.net.Net.SocketAddress;

extern class Socket extends haxe.io.Duplex {
  //final eventClose:Event<NoData>;
  final eventConnect:Event<NoData>;
  //final eventData:Event<Bytes>;
  //final eventDrain:Event<NoData>;
  //final eventEnd:Event<NoData>;
  //final eventError:Event<Error>;
  //final eventFinish:Event<NoData>;
  final eventLookup:Event<{err:Error, address:String, ?family:String, host:String}>;
  //final eventPause:Event<NoData>;
  //final eventPipe:Event<IReadable>;
  //final eventReadable:Event<NoData>;
  final eventReady:Event<NoData>;
  //final eventResume:Event<NoData>;
  final eventTimeout:Event<NoData>;
  //final eventUnpipe:Event<IReadable>;
  
  var bufferSize:Int;
  var bytesRead:Int;
  var bytesWritten:Int;
  var connecting:Bool;
  var destroyed:Bool;
  var localAddress:String;
  var localPort:Int;
  var pending:Bool;
  var remoteAddress:String;
  var remoteFamily:NetFamily;
  var remotePort:Int;
  
  // function new(fd, ?readable:Bool, ?writable:Bool); ?
  function new(?allowHalfOpen:Bool);
  
  function address():SocketAddress;
  function connectTCP(port:Int, ?host:String, ?localAddress:String, ?localPort:Int, ?family:IPFamily, ?hints:Int, ?lookup:String->String, ?connectListener:Callback<NoData>):Void;
  function connectIPC(path:String, ?connectListener:Callback<NoData>):Void;
  //function destroy(?error:Error); // Duplex
  //function end(...); // Duplex
  //function pause():Void; // Duplex
  function ref():Void;
  //function resume():Void; // Duplex
  function setKeepAlive(?enable:Bool, ?initialDelay:Float):Void;
  function setNoDelay(?noDelay:Bool):Void;
  function setTimeout(timeout:Float, ?callback:Callback<NoData>):Void;
  function unref():Void;
  //function write(...); // Duplex
}
