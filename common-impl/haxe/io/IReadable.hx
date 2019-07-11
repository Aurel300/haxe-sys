package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Signal;

interface IReadable extends IStream {
  // final closeSignal:Signal<NoData>;
  final dataSignal:Signal<Bytes>;
  final endSignal:Signal<NoData>;
  // final errorSignal:Signal<Error>;
  final pauseSignal:Signal<NoData>;
  final readableSignal:Signal<NoData>;
  final resumeSignal:Signal<NoData>;
  
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
