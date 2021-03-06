package haxe.io;

/**
	Represents a relative or absolute file path.
**/
abstract FilePath(String) from String {
	@:from public static function encode(bytes:Bytes):FilePath {
		// TODO: standard UTF-8 decoding, except any invalid bytes is replaced
		// with (for example) U+FFFD, followed by the byte itself as a codepoint
		return null;
	}

	public function decode():Bytes {
		return null;
	}

	/**
		The components of `this` path.
	**/
	public var components(get, never):Array<FilePath>;

	private function get_components():Array<FilePath> {
		return this.split("/");
	}

	@:op(A / B)
	public function addComponent(other:FilePath):FilePath {
		return this + "/" + other.get_raw();
	}

	private function get_raw():String
		return this;

	#if hl
	private function decodeNative():hl.Bytes {
		return @:privateAccess this.toUtf8();
	}

	private static function encodeNative(data:hl.Bytes):FilePath {
		return ((@:privateAccess String.fromUCS2(data)) : FilePath);
	}
	#elseif neko
	private function decodeNative():neko.NativeString {
		return neko.NativeString.ofString(this);
	}

	private static function encodeNative(data:neko.NativeString):FilePath {
		return (neko.NativeString.toString(data) : FilePath);
	}
	#end
}
