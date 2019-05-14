package sys;

extern class DirectoryEntry {
  final name:String;
  
  function isBlockDevice():Bool;
  function isCharacterDevice():Bool;
  function isDirectory():Bool;
  function isFIFO():Bool;
  function isFile():Bool;
  function isSocket():Bool;
  function isSymbolicLink():Bool;
}