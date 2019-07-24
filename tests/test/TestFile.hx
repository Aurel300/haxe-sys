package test;

import haxe.io.Bytes;

class TestFile extends Test {
	function setup():Void {
		TestBase.uvSetup();
	}

	function teardown():Void {
		TestBase.uvTeardown();
	}

	/**
		Tests read functions.
	**/
	function testRead():Void {
		// ASCII
		var file = nusys.FileSystem.open("resources-ro/hello.txt");
		var buffer = Bytes.alloc(5);

		// FIXME: `read` can probably return a smaller number
		eq(file.read(buffer, 0, 5, 0).bytesRead, 5);
		beq(buffer, Bytes.ofString("hello"));

		eq(file.read(buffer, 0, 5, 6).buffer, buffer);
		beq(buffer, Bytes.ofString("world"));

		exc(() -> file.read(buffer, 0, 6, 0));
		exc(() -> file.read(buffer, -1, 5, 0));
		exc(() -> file.read(buffer, 0, 0, 0));
		exc(() -> file.read(buffer, 0, 0, -1));

		buffer = Bytes.alloc(15);
		eq(file.read(buffer, 0, 5, 0).bytesRead, 5);
		eq(file.read(buffer, 5, 5, 0).bytesRead, 5);
		eq(file.read(buffer, 10, 5, 0).bytesRead, 5);
		beq(buffer, Bytes.ofString("hellohellohello"));

		file.close();

		// binary (+ invalid UTF-8)
		var file = nusys.FileSystem.open("resources-ro/binary.bin");
		var buffer = Bytes.alloc(TestBase.binaryBytes.length);
		eq(file.read(buffer, 0, buffer.length, 0).bytesRead, buffer.length);
		beq(buffer, TestBase.binaryBytes);
	}

	/**
		Tests write functions.
	**/
	function testWrite():Void {
		var file = nusys.FileSystem.open("resources-rw/hello.txt", "w");
		var buffer = Bytes.ofString("hello");
		eq(file.write(buffer, 0, 5, 0).bytesWritten, 5);
		file.close();

		beq(sys.io.File.getBytes("resources-rw/hello.txt"), buffer);

		file = nusys.FileSystem.open("resources-rw/unicode.txt", "w");
		var buffer = TestBase.helloBytes;
		eq(file.write(buffer, 0, buffer.length, 0).bytesWritten, buffer.length);
		file.close();

		beq(sys.io.File.getBytes("resources-rw/unicode.txt"), buffer);

		// cleanup
		sys.FileSystem.deleteFile("resources-rw/hello.txt");
		sys.FileSystem.deleteFile("resources-rw/unicode.txt");
	}
}
