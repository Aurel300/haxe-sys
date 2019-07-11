package test;

class TestFileSystem extends Test {
	function setup():Void {
		UV.init();
	}

	function teardown():Void {}

	/**
		Tests old filesystem APIs.
	**/
	function testCompat():Void {
		t(nusys.FileSystem.exists("resources-ro/hello.txt"));
		f(nusys.FileSystem.exists("resources-ro/non-existent-file"));
	}
}
