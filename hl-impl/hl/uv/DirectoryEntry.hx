package hl.uv;

import haxe.io.FilePath;

class DirectoryEntry implements asys.DirectoryEntry {
	var name_:FilePath;

	function get_name():FilePath return name_;

	public var name(get, never):FilePath;
	public final type:asys.uv.UVDirentType;

	public function new(name:hl.Bytes, type:asys.uv.UVDirentType) {
		this.name_ = @:privateAccess String.fromUTF8(name);
		this.type = type;
	}

	public function isBlockDevice():Bool return type == DirentBlock;

	public function isCharacterDevice():Bool return type == DirentChar;

	public function isDirectory():Bool return type == DirentDir;

	public function isFIFO():Bool return type == DirentFifo;

	public function isFile():Bool return type == DirentFile;

	public function isSocket():Bool return type == DirentSocket;

	public function isSymbolicLink():Bool return type == DirentLink;
}
