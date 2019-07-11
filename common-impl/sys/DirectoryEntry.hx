package sys;

import haxe.io.FilePath;

interface DirectoryEntry {
	final name:FilePath;
	function isBlockDevice():Bool;
	function isCharacterDevice():Bool;
	function isDirectory():Bool;
	function isFIFO():Bool;
	function isFile():Bool;
	function isSocket():Bool;
	function isSymbolicLink():Bool;
}