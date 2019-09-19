package neko.uv;

import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import asys.net.*;

@:access(haxe.async.Callback)
abstract Handle(Dynamic) {
	static var w_close:(Dynamic, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_close", 2);
	static var w_ref:(Dynamic)->Void = neko.Lib.load("uv", "w_ref", 1);
	static var w_unref:(Dynamic)->Void = neko.Lib.load("uv", "w_unref", 1);

	public function close(cb:Callback<NoData>):Void {
		w_close(this, cb.toUVNoData());
	}

	public function ref():Void {
		w_ref(this);
	}

	public function unref():Void {
		w_unref(this);
	}
}
