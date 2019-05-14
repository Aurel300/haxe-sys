package haxe.io;

typedef PathObject = {
    ?dir:String,
    ?root:String,
    ?base:String,
    ?name:String,
    ?ext:String
  };

extern class Path {
  // node compatibility (path module)
  static final delimiter:String;
  static final sep:String;
  static final posix:PathPosix;
  static final win32:PathWin32;
  
  static function basename(path:String, ?ext:String):String;
  static function dirname(path:String):String;
  static function extname(path:String):String;
  static function format(pathObject:PathObject):String;
  static function isAbsolute(path:String):Bool;
  static function join(?paths:Array<String>):String;
  static function normalize(path:String):String;
  static function parse(path:String):PathObject;
  static function relative(from:String, to:String):String;
  static function resolve(?paths:Array<String>):String;
  static function toNamespacedPath(path:String):String;
  
  // Haxe haxe.io.Path compatibility
  static function addTrailingSlash(path:String):String;
  static inline function directory(path:String):String return dirname(path);
  static inline function extension(path:String):String return extname(path);
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
  
  function basename(path:String, ?ext:String):String;
  function dirname(path:String):String;
  function extname(path:String):String;
  function format(pathObject:PathObject):String;
  function isAbsolute(path:String):Bool;
  function join(paths:Array<String>):String;
  function normalize(path:String):String;
  function parse(path:String):PathObject;
  function relative(from:String, to:String):String;
  function resolve(paths:Array<String>):String;
  function toNamespacedPath(path:String):String;
}

extern class PathWin32 {
  final delimiter:String;
  final sep:String;
  
  function basename(path:String, ?ext:String):String;
  function dirname(path:String):String;
  function extname(path:String):String;
  function format(pathObject:PathObject):String;
  function isAbsolute(path:String):Bool;
  function join(paths:Array<String>):String;
  function normalize(path:String):String;
  function parse(path:String):PathObject;
  function relative(from:String, to:String):String;
  function resolve(paths:Array<String>):String;
  function toNamespacedPath(path:String):String;
}
