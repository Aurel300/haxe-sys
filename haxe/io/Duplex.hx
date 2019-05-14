package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;

extern class Duplex implements IReadable implements IWritable {
  final eventClose:Event<NoData>;
  final eventData:Event<Bytes>;
  final eventDrain:Event<NoData>;
  final eventEnd:Event<NoData>;
  final eventError:Event<Error>;
  final eventFinish:Event<NoData>;
  final eventPause:Event<NoData>;
  final eventPipe:Event<IReadable>;
  final eventReadable:Event<NoData>;
  final eventResume:Event<NoData>;
  final eventUnpipe:Event<IReadable>;
  
  var readable(default, null):Bool;
  var readableFlowing(default, null):ReadableState;
  var readableHighWaterMark(default, null):Int;
  var readableLength(default, null):Int;
  var writable(default, null):Bool;
  var writableHighWaterMark(default, null):Int;
  var writableLength(default, null):Int;

  function new();
  function cork():Void;
  function destroy(?error:Error):Void;
  function end(?chunk:Bytes, ?listener:Listener<NoData>):Void;
  function isPaused():Bool;
  function pause():Void;
  function pipe(destination:IWritable, ?end:Bool = true):Void;
  function read(?size:Int):Bytes;
  function resume():Void;
  function uncork():Void;
  function unpipe(?destination:IWritable):Void;
  function unshift(chunk:Bytes):Void;
  function write(chunk:Bytes, ?callback:Callback<NoData>):Bool;
}
