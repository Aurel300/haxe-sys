package sys;

import haxe.Error;
import haxe.NoData;
import haxe.async.Event;

enum FileWatcherEvent {
  Rename(newPath:String);
  Change(path:String);
}

extern class FileWatcher {
  final eventChange:Event<FileWatcherEvent>;
  final eventClose:Event<NoData>;
  final eventError:Event<Error>;
  
  function close():Void;
}
