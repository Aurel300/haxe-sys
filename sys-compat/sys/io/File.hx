package sys.io;

import asys.FileSystem;
import asys.io.*;

// TODO: asys.io.File{In,Out}put have the same interface as sys.io.~, but for
// type compatibility the functions below should return the sys.io.~ variants.
@:access(asys.io.FileInput)
@:access(asys.io.FileOutput)
class File {
	static inline function append(path:String, ?binary:Bool = true):FileOutput
		return new FileOutput(asys.FileSystem.open(path, "a", binary));

	static inline function copy(srcPath:String, dstPath:String):Void
		FileSystem.copyFile(srcPath, dstPath);

	static inline function getBytes(path:String):Bytes
		return FileSystem.readFile(path);

	static inline function getContent(path:String):String
		return FileSystem.readFile(path).toString();

	static inline function read(path:String, ?binary:Bool = true):FileInput
		return new FileInput(FileSystem.open(path, "r", binary));

	static inline function saveBytes(path:String, bytes:Bytes):Void
		return FileSystem.writeFile(path, bytes);

	static inline function saveContent(path:String, content:String):Void
		return FileSystem.writeFile(path, Bytes.ofString(content));

	static inline function update(path:String, ?binary:Bool = true):FileOutput
		return new FileOutput(FileSystem.open(path, ReadWrite, binary));

	static inline function write(path:String, ?binary:Bool = true):FileOutput
		return new FileOutput(FileSystem.open(path, "w", binary));
}
