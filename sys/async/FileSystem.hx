package sys.async;

import haxe.Error;
import haxe.io.Bytes;
import sys.*;

extern class FileSystem {
  // sys.FileSystem-like functions
  static function access(path:String, ?mode:FileAccessMode = FileAccessMode.Ok, callback:(?error:Error)->Void):Void;
  static function chmod(path:String, mode:FileMode, ?followSymLinks:Bool = true, callback:(?error:Error)->Void):Void;
  static function chown(path:String, uid:Int, gid:Int, ?followSymLinks:Bool = true, callback:(?error:Error)->Void):Void;
  static function copyFile(src:String, dest:String, ?flags:FileCopyFlags, callback:(?error:Error)->Void):Void;
  //static function exists(path:String):Promise<Bool>; // deprecated in node.js
  static function link(existingPath:String, newPath:String, callback:(?error:Error)->Void):Void;
  static function mkdir(path:String, ?recursive:Bool, ?mode:FileMode, callback:(?error:Error)->Void):Void;
  static function mkdtemp(prefix:String, callback:(?error:Error, ?path:String)->Void):Void;
  static function readdir(path:String, callback:(?error:Error, ?files:Array<String>)->Void):Void;
  static function readdirTypes(path:String, callback:(?error:Error, ?files:Array<DirectoryEntry>)->Void):Void;
  static function readlink(path:String, callback:(?error:Error, ?link:String)->Void):Void;
  static function realpath(path:String, callback:(?error:Error, ?path:String)->Void):Void;
  static function rename(oldPath:String, newPath:String, callback:(?error:Error)->Void):Void;
  static function rmdir(path:String, callback:(?error:Error)->Void):Void;
  static function stat(path:String, ?followSymLinks:Bool = true, callback:(?error:Error, ?stats:FileStat)->Void):Void;
  static function symlink(target:String, path:String, ?type:String, callback:(?error:Error)->Void):Void;
  static function truncate(path:String, len:Int, callback:(?error:Error)->Void):Void;
  static function unlink(path:String, callback:(?error:Error)->Void):Void;
  static function utimes(path:String, atime:Date, mtime:Date, callback:(?error:Error)->Void):Void;
  
  // sys.io.File-like functions
  static function appendFile(path:String, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:(?error:Error)->Void):Void;
  static function open(path:String, ?flags:FileOpenFlags, ?mode:FileMode, ?binary:Bool = true, callback:(?error:Error, ?file:sys.io.File)->Void):Void;
  static function readFile(path:String, ?flags:FileOpenFlags, callback:(?error:Error, ?bytes:Bytes)->Void):Void;
  static function writeFile(path:String, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:(?error:Error)->Void):Void;
}
