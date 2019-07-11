package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;

interface IWritable extends IStream {
  // final closeSignal:Signal<NoData>;
  final drainSignal:Signal<NoData>;
  // final errorSignal:Signal<haxe.Error>;
  final finishSignal:Signal<NoData>;
  final pipeSignal:Signal<IReadable>;
  final unpipeSignal:Signal<IReadable>;
  
  var writable(default, null):Bool;
  var writableHighWaterMark(default, null):Int;
  var writableLength(default, null):Int;
  
  function cork():Void;
  function end(?chunk:Bytes, ?listener:Listener<NoData>):Void;
  function uncork():Void;
  function write(chunk:Bytes, ?callback:Callback<NoData>):Bool;
}
