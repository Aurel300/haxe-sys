package haxe.io;

class StreamTools {
	public static function pipeline(input:IReadable, ?intermediate:Array<IDuplex>, output:IWritable):Void {
		if (intermediate == null || intermediate.length == 0)
			return input.pipe(output);

		input.pipe(intermediate[0]);
		for (i in 0...intermediate.length - 1) {
			intermediate[i].pipe(intermediate[i + 1]);
		}
		intermediate[intermediate.length - 1].pipe(output);
	}
}
