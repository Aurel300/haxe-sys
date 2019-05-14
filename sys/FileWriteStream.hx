package sys;

import haxe.NoData;
import haxe.async.Event;

extern class FileWriteStream extends haxe.io.Writable {
  final eventOpen:Event<sys.io.File>;
  final eventReady:Event<NoData>;
  
  var bytesWritten:Int;
  var path:String;
  var pending:Bool;
}
