package nusys.io;

import haxe.NoData;
import haxe.async.Signal;

extern class FileReadStream extends haxe.io.Readable {
  final openSignal:Signal<sys.io.File>;
  final readySignal:Signal<NoData>;
  
  var bytesRead:Int;
  var path:String;
  var pending:Bool;
}
