package sys;

extern class FileStat {
  // sys.FileStat compatibility
  var atime:Date;
  var ctime:Date;
  var dev:Int; //???
  var gid:Int;
  var ino:Int;
  var mode:Int;
  var mtime:Date;
  var nlink:Int;
  var rdev:Int;
  var size:Int;
  var uid:Int;
  
  // node compatibility
  var blksize:Int;
  var blocks:Int;
  var atimeMs:Float;
  var ctimeMs:Float;
  var mtimeMs:Float;
  var birthtime:Date;
  var birthtimeMs:Float;
  
  function isBlockDevice():Bool;
  function isCharacterDevice():Bool;
  function isDirectory():Bool;
  function isFIFO():Bool;
  function isFile():Bool;
  function isSocket():Bool;
  function isSymbolicLink():Bool;
}
