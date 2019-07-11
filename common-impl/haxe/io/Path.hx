package haxe.io;

typedef PathObject = {
    ?dir:FilePath,
    ?root:FilePath,
    ?base:FilePath,
    ?name:FilePath,
    ?ext:FilePath
  };

extern class Path {
  // node compatibility (path module)
  static final delimiter:String;
  static final sep:String;
  static final posix:PathPosix;
  static final win32:PathWin32;
  
  static function basename(path:FilePath, ?ext:FilePath):FilePath;
  static function dirname(path:FilePath):FilePath;
  static function extname(path:FilePath):FilePath;
  static function format(pathObject:PathObject):FilePath;
  static function isAbsolute(path:FilePath):Bool;
  static function join(?paths:Array<FilePath>):FilePath;
  static function normalize(path:FilePath):FilePath;
  static function parse(path:FilePath):PathObject;
  static function relative(from:FilePath, to:FilePath):FilePath;
  static function resolve(?paths:Array<FilePath>):FilePath;
  static function toNamespacedPath(path:FilePath):FilePath;
  
  // Haxe haxe.io.Path compatibility
  static function addTrailingSlash(path:String):String;
  static inline function directory(path:String):FilePath return dirname(path);
  static inline function extension(path:String):FilePath return extname(path);
  // static function isAbsolute(path:String):Bool; // same interface
  // static function join(paths:Array<String>):String; // same interface
  // static function normalize(path:String):String; // same interface
  static function removeTrailingSlashes(path:String):String;
  static function withExtension(path:String, ?ext:String):String;
  static function withoutDirectory(path:String):String;
  static function withoutExtension(path:String):String;
  
  var backslash:Bool;
  var dir:Null<String>;
  var ext:Null<String>;
  var file:String;
  
  function new(path:String);
  function toString():String;
}

extern class PathPosix {
  final delimiter:String;
  final sep:String;
  
  function basename(path:FilePath, ?ext:FilePath):FilePath;
  function dirname(path:FilePath):FilePath;
  function extname(path:FilePath):FilePath;
  function format(pathObject:PathObject):FilePath;
  function isAbsolute(path:FilePath):Bool;
  function join(paths:Array<FilePath>):FilePath;
  function normalize(path:FilePath):FilePath;
  function parse(path:FilePath):PathObject;
  function relative(from:FilePath, to:FilePath):FilePath;
  function resolve(paths:Array<FilePath>):FilePath;
  function toNamespacedPath(path:FilePath):FilePath;
}

extern class PathWin32 {
  final delimiter:String;
  final sep:String;
  
  function basename(path:FilePath, ?ext:FilePath):FilePath;
  function dirname(path:FilePath):FilePath;
  function extname(path:FilePath):FilePath;
  function format(pathObject:PathObject):FilePath;
  function isAbsolute(path:FilePath):Bool;
  function join(paths:Array<FilePath>):FilePath;
  function normalize(path:FilePath):FilePath;
  function parse(path:FilePath):PathObject;
  function relative(from:FilePath, to:FilePath):FilePath;
  function resolve(paths:Array<FilePath>):FilePath;
  function toNamespacedPath(path:FilePath):FilePath;
}
