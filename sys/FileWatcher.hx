package sys;

import haxe.Error;
import haxe.NoData;
import haxe.async.Event;
import haxe.io.FilePath;

enum FileWatcherEvent {
  Rename(newPath:FilePath);
  Change(path:FilePath);
}

extern class FileWatcher {
  final eventChange:Event<FileWatcherEvent>;
  final eventClose:Event<NoData>;
  final eventError:Event<Error>;
  
  function close():Void;
}
