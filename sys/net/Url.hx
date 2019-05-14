package sys.net;

extern class Url { // once implemented might be abstract over String
  static function domainToASCII(domain:String):String;
  static function domainToUnicode(domain:String):String;
  static function fileURLToPath(url:String):String;
  static function format(url:Url, ?opt:UrlFormatOptions):String;
  static function pathToFileURL(path:String):Url;
  
  var hash:String;
  var host:String; // = hostname + port
  var hostname:String;
  var href:String;
  var origin:String;
  var password:String;
  var pathname:String;
  var port:Null<Int>;
  var protocol:String;
  var search:String;
  var searchParams:UrlSearchParams;
  var username:String;
  
  function new(input:String, ?base:String);
  function toString():String;
}

typedef UrlFormatOptions = {
    ?auth:Bool,
    ?fragment:Bool,
    ?search:Bool,
    ?unicode:Bool
  };

extern class UrlSearchParams {
  static function fromString(string:String):UrlSearchParams;
  static function fromMap(map:Map<String, Array<String>>):UrlSearchParams;
  static function fromIterable(iterable:KeyValueIterable<String, String>):UrlSearchParams;
  
  function new();
  function append(name:String, value:String):Void;
  function delete(name:String):Void;
  // function entries();
  // function forEach();
  function get(name:String):Null<String>;
  function getAll(name:String):Array<String>;
  function has(name:String):Bool;
  // function keys();
  function set(name:String, value:String):Void;
  function sort():Void;
  function toString():String;
  // function values();
  
  function iterator():Iterator<String>;
  function keyValueIterator():KeyValueIterator<String, String>;
}
