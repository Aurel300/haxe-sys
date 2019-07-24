package sys.async;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import haxe.io.FilePath;
import sys.*;

extern class FileSystem {
  // sys.FileSystem-like functions
  static function access(path:FilePath, ?mode:FileAccessMode = FileAccessMode.Ok, callback:Callback<NoData>):Void;
  static function chmod(path:FilePath, mode:FilePermissions, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void;
  static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void;
  static function copyFile(src:FilePath, dest:FilePath, ?flags:FileCopyFlags, callback:Callback<NoData>):Void;
  static function exists(path:FilePath, callback:Callback<Bool>):Void;
  static function link(existingPath:FilePath, newPath:FilePath, callback:Callback<NoData>):Void;
  static function mkdir(path:FilePath, ?recursive:Bool, ?mode:FilePermissions, callback:Callback<NoData>):Void;
  static function mkdtemp(prefix:FilePath, callback:Callback<FilePath>):Void;
  static function readdir(path:FilePath, callback:Callback<Array<FilePath>>):Void;
  static function readdirTypes(path:FilePath, callback:Callback<Array<DirectoryEntry>>):Void;
  static function readlink(path:FilePath, callback:Callback<FilePath>):Void;
  static function realpath(path:FilePath, callback:Callback<FilePath>):Void;
  static function rename(oldPath:FilePath, newPath:FilePath, callback:Callback<NoData>):Void;
  static function rmdir(path:FilePath, callback:Callback<NoData>):Void;
  static function stat(path:FilePath, ?followSymLinks:Bool = true, callback:Callback<FileStat>):Void;
  static function symlink(target:FilePath, path:FilePath, ?type:String, callback:Callback<NoData>):Void;
  static function truncate(path:FilePath, len:Int, callback:Callback<NoData>):Void;
  static function unlink(path:FilePath, callback:Callback<NoData>):Void;
  static function utimes(path:FilePath, atime:Date, mtime:Date, callback:Callback<NoData>):Void;
  
  // sys.io.File-like functions
  static function appendFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FilePermissions, callback:Callback<NoData>):Void;
  static function open(path:FilePath, ?flags:FileOpenFlags, ?mode:FilePermissions, ?binary:Bool = true, callback:Callback<sys.io.File>):Void;
  static function readFile(path:FilePath, ?flags:FileOpenFlags, callback:Callback<Bytes>):Void;
  static function writeFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FilePermissions, callback:Callback<NoData>):Void;
}
