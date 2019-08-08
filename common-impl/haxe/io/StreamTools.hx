package haxe.io;

extern class StreamTools {
	static function pipeline(input:IReadable, ?intermediate:Array<IDuplex>, output:IWritable):Void;
}
