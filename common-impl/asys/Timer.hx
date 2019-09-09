package asys;

extern class Timer {
	static function delay(f:() -> Void, timeMs:Int):Timer;

	static function measure<T>(f:()->T, ?pos:haxe.PosInfos):T;

	static function stamp():Float;

	function new(timeMs:Int);

	dynamic function run():Void;

	function stop():Void;

	function ref():Void;

	function unref():Void;
}
