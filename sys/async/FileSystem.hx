package sys.async;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import sys.*;

extern class FileSystem {
  // sys.FileSystem-like functions
  static function access(path:String, ?mode:FileAccessMode = FileAccessMode.Ok, callback:Callback<NoData>):Void;
  static function chmod(path:String, mode:FileMode, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void;
  static function chown(path:String, uid:Int, gid:Int, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void;
  static function copyFile(src:String, dest:String, ?flags:FileCopyFlags, callback:Callback<NoData>):Void;
  static function exists(path:String, callback:Callback<Bool>):Void; // deprecated in node.js due to a different interface, ok here
  static function link(existingPath:String, newPath:String, callback:Callback<NoData>):Void;
  static function mkdir(path:String, ?recursive:Bool, ?mode:FileMode, callback:Callback<NoData>):Void;
  static function mkdtemp(prefix:String, callback:Callback<String>):Void;
  static function readdir(path:String, callback:Callback<Array<String>>):Void;
  static function readdirTypes(path:String, callback:Callback<Array<DirectoryEntry>>):Void;
  static function readlink(path:String, callback:Callback<String>):Void;
  static function realpath(path:String, callback:Callback<String>):Void;
  static function rename(oldPath:String, newPath:String, callback:Callback<NoData>):Void;
  static function rmdir(path:String, callback:Callback<NoData>):Void;
  static function stat(path:String, ?followSymLinks:Bool = true, callback:Callback<FileStat>):Void;
  static function symlink(target:String, path:String, ?type:String, callback:Callback<NoData>):Void;
  static function truncate(path:String, len:Int, callback:Callback<NoData>):Void;
  static function unlink(path:String, callback:Callback<NoData>):Void;
  static function utimes(path:String, atime:Date, mtime:Date, callback:Callback<NoData>):Void;
  
  // sys.io.File-like functions
  static function appendFile(path:String, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:Callback<NoData>):Void;
  static function open(path:String, ?flags:FileOpenFlags, ?mode:FileMode, ?binary:Bool = true, callback:Callback<sys.io.File>):Void;
  static function readFile(path:String, ?flags:FileOpenFlags, callback:Callback<Bytes>):Void;
  static function writeFile(path:String, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:Callback<NoData>):Void;
}
