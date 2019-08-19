package nusys.io;

import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import haxe.io.Readable.ReadResult;

class Pipe extends Duplex {
	public static function create():Pipe {
		return new Pipe(new eval.uv.Pipe());
	}

	var native:eval.uv.Pipe;
	var readStarted = false;

	function new(native:eval.uv.Pipe) {
		super();
		this.native = native;
	}

	override function internalRead(remaining):ReadResult {
		if (readStarted)
			return None;

		readStarted = true;
		native.startRead((err, chunk) -> {
			if (err != null) {
				switch (err.type) {
					case UVError(EOF):
						asyncRead([], true);
					case _:
						errorSignal.emit(err);
				}
			} else {
				asyncRead([chunk], false);
			}
		});

		return None;
	}

	override function internalWrite():Void {
		while (inputBuffer.length > 0) {
			// TODO: keep track of pending writes for finish event emission
			native.write(pop(), (err) -> {
				if (err != null)
					errorSignal.emit(err);
				// TODO: destroy stream and socket
			});
		}
	}

	public function close(?cb:Callback<NoData>):Void {
		if (readStarted)
			native.stopRead();
		native.close(Callback.nonNull(cb));
	}
}
