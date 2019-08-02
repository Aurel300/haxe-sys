package impl;

import haxe.io.*;
import haxe.io.Readable.ReadResult;

/*
class ByteConsumer extends Writable {
	public function new() {
		super();
	}

	var asyncing = false;

	override function internalWrite():Void {
		function async():Void {
			if (buffer.length == 0) {
				asyncing = false;
				return;
			}
			trace("got", pop());
			haxe.Timer.delay(async, 200);
		}
		if (!asyncing) {
			haxe.Timer.delay(async, 200);
			asyncing = true;
		}
	}
}
*/
class SlowSource extends Readable {
	final data:Array<Bytes>;

	public function new(data:Array<Bytes>) {
		super();
		this.data = data.copy();
	}

	override function internalRead(remaining):ReadResult {
		if (data.length > 0) {
			var nextChunk = data.shift();
			var nextEof = data.length == 0;
			haxe.Timer.delay(() -> asyncRead([nextChunk], nextEof), 10);	
		}
		return None;
	}
}
