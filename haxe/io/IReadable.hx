package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Event;

interface IReadable extends IStream {
  // final eventClose:Event<NoData>;
  final eventData:Event<Bytes>;
  final eventEnd:Event<NoData>;
  // final eventError:Event<Error>;
  final eventPause:Event<NoData>;
  final eventReadable:Event<NoData>;
  final eventResume:Event<NoData>;
  
  var readable(default, null):Bool;
  var readableFlowing(default, null):ReadableState;
  var readableHighWaterMark(default, null):Int;
  var readableLength(default, null):Int;
  
  function isPaused():Bool;
  function pause():Void;
  function pipe(destination:IWritable, ?end:Bool = true):Void;
  function read(?size:Int):Bytes;
  function resume():Void;
  function unpipe(?destination:IWritable):Void;
  function unshift(chunk:Bytes):Void;
}
