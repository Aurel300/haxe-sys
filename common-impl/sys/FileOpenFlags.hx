package sys;

enum abstract FileOpenFlags(Int) {
	@:from public static function fromString(flags:String):FileOpenFlags {
		return (switch (flags) {
			case "r": ReadOnly;
			case "r+": ReadWrite;
			case "rs+": ReadWrite | Sync;
			case "sr+": ReadWrite | Sync;
			case "w": Truncate | Create | WriteOnly;
			case "w+": Truncate | Create | ReadWrite;
			case "a": Append | Create | WriteOnly;
			case "a+": Append | Create | ReadWrite;
			case "wx": Truncate | Create | WriteOnly | Excl;
			case "xw": Truncate | Create | WriteOnly | Excl;
			case "wx+": Truncate | Create | ReadWrite | Excl;
			case "xw+": Truncate | Create | ReadWrite | Excl;
			case "ax": Append | Create | WriteOnly | Excl;
			case "xa": Append | Create | WriteOnly | Excl;
			case "as": Append | Create | WriteOnly | Sync;
			case "sa": Append | Create | WriteOnly | Sync;
			case "ax+": Append | Create | ReadWrite | Excl;
			case "xa+": Append | Create | ReadWrite | Excl;
			case "as+": Append | Create | ReadWrite | Sync;
			case "sa+": Append | Create | ReadWrite | Sync;
			case _: throw "invalid file open flags";
		});
	}

	function new(value:Int)
		this = value;

	inline function get_raw():Int return this;

	@:op(A | B)
	inline function join(other:FileOpenFlags) return new FileOpenFlags(this | other.get_raw());

	// TODO: some of these don't make sense in Haxe-wrapped libuv
	var Append = 0x400;
	var Create = 0x40;
	var Direct = 0x4000;
	var Directory = 0x10000;
	var Dsync = 0x1000;
	var Excl = 0x80;
	var NoAtime = 0x40000;
	var NoCtty = 0x100;
	var NoFollow = 0x20000;
	var NonBlock = 0x800;
	var ReadOnly = 0x0;
	var ReadWrite = 0x2;
	var Sync = 0x101000;
	var Truncate = 0x200;
	var WriteOnly = 0x1;
}
