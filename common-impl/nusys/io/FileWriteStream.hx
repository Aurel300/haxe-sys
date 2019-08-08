package nusys.io;

import haxe.NoData;
import haxe.async.Signal;

extern class FileWriteStream extends haxe.io.Writable {
  final openSignal:Signal<sys.io.File>;
  final readySignal:Signal<NoData>;
  
  var bytesWritten:Int;
  var path:String;
  var pending:Bool;
}
