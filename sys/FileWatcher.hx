package sys;

import haxe.Error;
import haxe.NoData;
import haxe.async.Signal;

extern class FileWatcher {
  final changeSignal:Signal<FileWatcherEvent>;
  final closeSignal:Signal<NoData>;
  final errorSignal:Signal<Error>;
  
  function close():Void;
}
