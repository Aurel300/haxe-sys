package haxe.async;

class Defer {
	public static function nextTick(f:() -> Void):haxe.Timer {
		return haxe.Timer.delay(f, 0);
	}
}
