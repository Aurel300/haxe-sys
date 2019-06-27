package sys;

import haxe.Error;
import haxe.NoData;
import haxe.async.Signal;
import haxe.io.FilePath;

enum FileWatcherEvent {
  Rename(newPath:FilePath);
  Change(path:FilePath);
}

extern class FileWatcher {
  final changeSignal:Signal<FileWatcherEvent>;
  final closeSignal:Signal<NoData>;
  final errorSignal:Signal<Error>;
  
  function close():Void;
}
