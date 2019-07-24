package test;

import haxe.io.Bytes;

using StringTools;

class TestFileSystem extends Test {
	function setup():Void {
		TestBase.uvSetup();
	}

	function teardown():Void {
		TestBase.uvTeardown();
	}

	/**
		Tests `FileSystem.access`, `perm` from `FileSystem.stat`, and
		`FileSystem.chmod`.
	**/
	function testAccess():Void {
		// create a file
		sys.io.File.saveContent("resources-rw/access.txt", "");

		nusys.FileSystem.chmod("resources-rw/access.txt", None);
		eq(nusys.FileSystem.stat("resources-rw/access.txt").permissions, None);
		noExc(() -> nusys.FileSystem.access("resources-rw/access.txt"));
		exc(() -> nusys.FileSystem.access("resources-rw/access.txt", Read));

		nusys.FileSystem.chmod("resources-rw/access.txt", "r-------x");
		eq(nusys.FileSystem.stat("resources-rw/access.txt").permissions, "r-------x");
		noExc(() -> nusys.FileSystem.access("resources-rw/access.txt", Read));
		exc(() -> nusys.FileSystem.access("resources-rw/access.txt", Write));
		exc(() -> nusys.FileSystem.access("resources-rw/access.txt", Execute));

		// cleanup
		sys.FileSystem.deleteFile("resources-rw/access.txt");
	}

	function testExists():Void {
		t(nusys.FileSystem.exists("resources-ro/hello.txt"));
		t(nusys.FileSystem.exists("resources-ro/binary.bin"));
		f(nusys.FileSystem.exists("resources-ro/non-existent-file"));
	}

	function testMkdir():Void {
		// initially these directories don't exist
		f(sys.FileSystem.exists("resources-rw/mkdir"));
		f(sys.FileSystem.exists("resources-rw/mkdir/nested/dir"));

		// without `recursive`, this should not succeed
		exc(() -> nusys.FileSystem.mkdir("resources-rw/mkdir/nested/dir"));

		// create a single directory
		nusys.FileSystem.mkdir("resources-rw/mkdir");

		// create a directory recursively
		nusys.FileSystem.mkdir("resources-rw/mkdir/nested/dir", true);

		t(sys.FileSystem.exists("resources-rw/mkdir"));
		t(sys.FileSystem.exists("resources-rw/mkdir/nested/dir"));
		f(sys.FileSystem.exists("resources-rw/mkdir/dir"));

		// raise if target already exists if not `recursive`
		exc(() -> nusys.FileSystem.mkdir("resources-rw/mkdir/nested/dir"));

		// cleanup
		sys.FileSystem.deleteDirectory("resources-rw/mkdir/nested/dir");
		sys.FileSystem.deleteDirectory("resources-rw/mkdir/nested");
		sys.FileSystem.deleteDirectory("resources-rw/mkdir");
	}

	function testMkdtemp():Void {
		// empty `resources-rw` to begin with
		aeq(sys.FileSystem.readDirectory("resources-rw"), []);

		// create some temporary directories
		var dirs = [ for (i in 0...3) nusys.FileSystem.mkdtemp("resources-rw/helloXXXXXX") ];

		for (f in sys.FileSystem.readDirectory("resources-rw")) {
			t(f.startsWith("hello"));
			t(sys.FileSystem.isDirectory('resources-rw/$f'));
			sys.FileSystem.deleteDirectory('resources-rw/$f');
		}

		// cleanup
		for (f in sys.FileSystem.readDirectory("resources-rw")) {
			sys.FileSystem.deleteDirectory('resources-rw/$f');
		}
	}

	function testReaddir():Void {
		aeq(nusys.FileSystem.readdir("resources-rw"), []);
		aeq(nusys.FileSystem.readdirTypes("resources-rw"), []);
		aeq(nusys.FileSystem.readdir("resources-ro"), ["hello.txt", "binary.bin"]);
		var res = nusys.FileSystem.readdirTypes("resources-ro");
		eq(res.length, 2);
		eq(res[0].name, "hello.txt");
		eq(res[0].isBlockDevice(), false);
		eq(res[0].isCharacterDevice(), false);
		eq(res[0].isDirectory(), false);
		eq(res[0].isFIFO(), false);
		eq(res[0].isFile(), true);
		eq(res[0].isSocket(), false);
		eq(res[0].isSymbolicLink(), false);

		// raises if target is not a directory or does not exist
		exc(() -> nusys.FileSystem.readdir("resources-ro/hello.txt"));
		exc(() -> nusys.FileSystem.readdir("resources-ro/non-existent-directory"));
	}

	function testRename():Void {
		// setup
		sys.io.File.saveContent("resources-rw/hello.txt", TestBase.helloString);
		sys.io.File.saveContent("resources-rw/other.txt", "");
		sys.FileSystem.createDirectory("resources-rw/sub");
		sys.io.File.saveContent("resources-rw/sub/foo.txt", "");

		t(sys.FileSystem.exists("resources-rw/hello.txt"));
		f(sys.FileSystem.exists("resources-rw/world.txt"));

		// rename a file
		nusys.FileSystem.rename("resources-rw/hello.txt", "resources-rw/world.txt");

		f(sys.FileSystem.exists("resources-rw/hello.txt"));
		t(sys.FileSystem.exists("resources-rw/world.txt"));
		eq(sys.io.File.getContent("resources-rw/world.txt"), TestBase.helloString);

		// raises if the old path is non-existent
		exc(() -> nusys.FileSystem.rename("resources-rw/non-existent", "resources-rw/foobar"));

		// raises if renaming file to directory
		exc(() -> nusys.FileSystem.rename("resources-rw/world.txt", "resources-rw/sub"));

		// raises if renaming directory to file
		exc(() -> nusys.FileSystem.rename("resources-rw/sub", "resources-rw/world.txt"));

		// rename a directory
		nusys.FileSystem.rename("resources-rw/sub", "resources-rw/resub");

		f(sys.FileSystem.exists("resources-rw/sub"));
		t(sys.FileSystem.exists("resources-rw/resub"));
		aeq(sys.FileSystem.readDirectory("resources-rw/resub"), ["foo.txt"]);

		// renaming to existing file overrides it
		nusys.FileSystem.rename("resources-rw/world.txt", "resources-rw/other.txt");

		f(sys.FileSystem.exists("resources-rw/world.txt"));
		t(sys.FileSystem.exists("resources-rw/other.txt"));
		eq(sys.io.File.getContent("resources-rw/other.txt"), TestBase.helloString);

		// cleanup
		sys.FileSystem.deleteFile("resources-rw/other.txt");
		sys.FileSystem.deleteFile("resources-rw/resub/foo.txt");
		sys.FileSystem.deleteDirectory("resources-rw/resub");
	}

	function testStat():Void {
		var stat = nusys.FileSystem.stat("resources-ro");
		t(stat.isDirectory());

		var stat = nusys.FileSystem.stat("resources-ro/hello.txt");
		eq(stat.size, TestBase.helloBytes.length);
		t(stat.isFile());

		var stat = nusys.FileSystem.stat("resources-ro/binary.bin");
		eq(stat.size, TestBase.binaryBytes.length);
		t(stat.isFile());

		exc(() -> nusys.FileSystem.stat("resources-ro/non-existent-file"));
	}

	/**
		Tests old filesystem APIs.
		`exists` is tested in `testExists`.
	**/
	function testCompat():Void {
		eq(nusys.FileSystem.readFile("resources-ro/hello.txt").toString(), TestBase.helloString);
		beq(nusys.FileSystem.readFile("resources-ro/hello.txt"), TestBase.helloBytes);
		beq(nusys.FileSystem.readFile("resources-ro/binary.bin"), TestBase.binaryBytes);
		t(nusys.FileSystem.isDirectory("resources-ro"));
		f(nusys.FileSystem.isDirectory("resources-ro/hello.txt"));
		aeq(nusys.FileSystem.readDirectory("resources-ro"), ["hello.txt", "binary.bin"]);
	}
}
