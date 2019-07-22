package test;

import haxe.io.Bytes;
import utest.Assert;

class TestFile extends Test {
	function setup() {
		TestBase.uvSetup();
	}

	function teardown() {
		TestBase.uvTeardown();
	}

	/**
		Tests read/write functions utilising haxe.io.Bytes buffers.
	**/
	function testBuffers():Void {
		var file = nusys.FileSystem.open("resources-ro/hello.txt");
		var buffer = Bytes.alloc(5);

		// FIXME: `read` can probably return a smaller number
		eq(file.read(buffer, 0, 5, 0).bytesRead, 5);
		eq(buffer.compare(Bytes.ofString("hello")), 0);

		eq(file.read(buffer, 0, 5, 6).bytesRead, 5);
		eq(buffer.compare(Bytes.ofString("world")), 0);

		Assert.raises(() -> file.read(buffer, 0, 6, 0));
		Assert.raises(() -> file.read(buffer, -1, 5, 0));
		Assert.raises(() -> file.read(buffer, 0, 0, 0));
		Assert.raises(() -> file.read(buffer, 0, 0, -1));

		buffer = Bytes.alloc(15);
		eq(file.read(buffer, 0, 5, 0).bytesRead, 5);
		eq(file.read(buffer, 5, 5, 0).bytesRead, 5);
		eq(file.read(buffer, 10, 5, 0).bytesRead, 5);
		eq(buffer.compare(Bytes.ofString("hellohellohello")), 0);
	}
}
