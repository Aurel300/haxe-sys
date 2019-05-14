package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;

interface IWritable extends IStream {
  // final eventClose:Event<NoData>;
  final eventDrain:Event<NoData>;
  // final eventError:Event<haxe.Error>;
  final eventFinish:Event<NoData>;
  final eventPipe:Event<IReadable>;
  final eventUnpipe:Event<IReadable>;
  
  var writable(default, null):Bool;
  var writableHighWaterMark(default, null):Int;
  var writableLength(default, null):Int;
  
  function cork():Void;
  function end(?chunk:Bytes, ?listener:Listener<NoData>):Void;
  function uncork():Void;
  function write(chunk:Bytes, ?callback:Callback<NoData>):Bool;
}
