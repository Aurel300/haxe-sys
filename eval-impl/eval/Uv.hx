package eval;

extern class Uv {
	static function init():Void;
	static function run(mode:sys.uv.UVRunMode):Bool;
	static function stop():Void;
	static function close():Void;
}
