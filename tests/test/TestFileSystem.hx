package test;

import haxe.io.Bytes;
import utest.Assert;

class TestFileSystem extends Test {
	public static var helloString = "hello world
symbols ◊†¶•¬
non-BMP 🐄";
	public static var helloBytes = Bytes.ofString(helloString);

	function setup():Void {
		UV.init();
	}

	function teardown():Void {
		UV.loop_close(UV.loop);
	}

	function testReaddir():Void {
		aeq(nusys.FileSystem.readdir("resources-ro"), ["hello.txt"]);
		Assert.raises(() -> nusys.FileSystem.readdir("resources-ro/hello.txt"));
		Assert.raises(() -> nusys.FileSystem.readdir("resources-ro/non-existent-directory"));
	}

	/**
		Tests old filesystem APIs.
	**/
	function testCompat():Void {
		t(nusys.FileSystem.exists("resources-ro/hello.txt"));
		f(nusys.FileSystem.exists("resources-ro/non-existent-file"));
		eq(nusys.FileSystem.readFile("resources-ro/hello.txt").toString(), helloString);
		eq(nusys.FileSystem.readFile("resources-ro/hello.txt").compare(helloBytes), 0);
	}
}
