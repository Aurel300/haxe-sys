package hl.uv;

import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import asys.net.*;

private typedef Native = hl.Abstract<"uv_handle_t">;

@:access(haxe.async.Callback)
abstract Handle(Native) {
	@:hlNative("uv", "w_close") static function w_close(_:Native, _:Dynamic->Void):Void {}
	@:hlNative("uv", "w_ref") static function w_ref(_:Native):Void {}
	@:hlNative("uv", "w_unref") static function w_unref(_:Native):Void {}

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
