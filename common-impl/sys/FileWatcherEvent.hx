package sys;

import haxe.io.FilePath;

enum FileWatcherEvent {
  Rename(newPath:FilePath);
  Change(path:FilePath);
}
