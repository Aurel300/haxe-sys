package haxe.async;

class Defer {
	public static function nextTick(f:() -> Void):nusys.Timer {
		return nusys.Timer.delay(f, 0);
	}
}
