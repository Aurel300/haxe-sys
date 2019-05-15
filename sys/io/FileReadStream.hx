package sys.io;

import haxe.NoData;
import haxe.async.Event;

extern class FileReadStream extends haxe.io.Readable {
  final eventOpen:Event<sys.io.File>;
  final eventReady:Event<NoData>;
  
  var bytesRead:Int;
  var path:String;
  var pending:Bool;
}
