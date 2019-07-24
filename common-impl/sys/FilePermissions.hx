package sys;

enum abstract FilePermissions(Int) from Int {
	@:from public static function fromString(s:String):FilePermissions {
		inline function bit(cc:Int, expect:Int):Int {
			return (if (cc == expect)
				1;
			else if (cc == "-".code)
				0;
			else
				throw "invalid file permissions string");
		}
		switch (s.length) {
			case 9: // rwxrwxrwx
				return bit(s.charCodeAt(0), "r".code) << 8
					| bit(s.charCodeAt(1), "w".code) << 7
					| bit(s.charCodeAt(2), "x".code) << 6
					| bit(s.charCodeAt(3), "r".code) << 5
					| bit(s.charCodeAt(4), "w".code) << 4
					| bit(s.charCodeAt(5), "x".code) << 3
					| bit(s.charCodeAt(6), "r".code) << 2
					| bit(s.charCodeAt(7), "w".code) << 1
					| bit(s.charCodeAt(8), "x".code);
			case _:
				throw "invalid file permissions string";
		}
	}

	public static function fromOctal(s:String):FilePermissions {
		inline function digit(n:Int):Int {
			if (n >= "0".code && n <= "7".code) return n - "0".code;
			throw "invalid octal file permissions";
		}
		switch (s.length) {
			case 3: // 777
				return digit(s.charCodeAt(0)) << 6
					| digit(s.charCodeAt(1)) << 3
					| digit(s.charCodeAt(2));
			case _:
				throw "invalid octal file permissions";
		}
	}

	var None = 0;
	var ExecuteOthers = 1 << 0;
	var WriteOthers = 1 << 1;
	var ReadOthers = 1 << 2;
	var ExecuteGroup = 1 << 3;
	var WriteGroup = 1 << 4;
	var ReadGroup = 1 << 5;
	var ExecuteOwner = 1 << 6;
	var WriteOwner = 1 << 7;
	var ReadOwner = 1 << 8;

	inline function get_raw():Int return this;

	@:op(A | B)
	inline function join(other:FilePermissions):FilePermissions return this | other.get_raw();
}
