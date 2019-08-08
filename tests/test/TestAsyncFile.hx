package test;

import utest.Async;
import haxe.io.Bytes;
import nusys.FileSystem as NewFS;
import nusys.io.File as NewFile;
import sys.FileSystem as OldFS;
import sys.io.File as OldFile;

class TestAsyncFile extends Test {
	/**
		Tests read functions.
	**/
	function testRead(async:Async):Void {
		// ASCII
		sub(async, done -> {
			var file = NewFS.open("resources-ro/hello.txt");
			var buffer = Bytes.alloc(5);
			file.async.read(buffer, 0, 5, 0, (err, res) -> {
				eq(err, null);
				eq(res.buffer, buffer);
				eq(res.bytesRead, 5);
				beq(res.buffer, Bytes.ofString("hello"));
				file.close();
				done();
			});
		});

		sub(async, done -> {
			var file = NewFS.open("resources-ro/hello.txt");
			var buffer = Bytes.alloc(5);
			file.async.read(buffer, 0, 5, 6, (err, res) -> {
				eq(err, null);
				eq(res.buffer, buffer);
				eq(res.bytesRead, 5);
				beq(res.buffer, Bytes.ofString("world"));
				file.close();
				done();
			});
		});

		// invalid arguments throw synchronous errors
		var file = NewFS.open("resources-ro/hello.txt");
		var buffer = Bytes.alloc(5);
		exc(() -> file.async.read(buffer, 0, 6, 0, (_, _) -> assert()));
		exc(() -> file.async.read(buffer, -1, 5, 0, (_, _) -> assert()));
		exc(() -> file.async.read(buffer, 0, 0, 0, (_, _) -> assert()));
		exc(() -> file.async.read(buffer, 0, 0, -1, (_, _) -> assert()));
		file.close();

		sub(async, done -> {
			var file = NewFS.open("resources-ro/hello.txt");
			var buffer = Bytes.alloc(15);
			file.async.read(buffer, 0, 5, 0, (err, res) -> {
				eq(err, null);
				eq(res.bytesRead, 5);
				file.async.read(buffer, 5, 5, 0, (err, res) -> {
					eq(err, null);
					eq(res.bytesRead, 5);
					file.async.read(buffer, 10, 5, 0, (err, res) -> {
						eq(err, null);
						beq(buffer, Bytes.ofString("hellohellohello"));
						file.close();
						done();
					});
				});
			});
		});

		// binary (+ invalid UTF-8)
		sub(async, done -> {
			var file = NewFS.open("resources-ro/binary.bin");
			var buffer = Bytes.alloc(TestBase.binaryBytes.length);
			file.async.read(buffer, 0, buffer.length, 0, (err, res) -> {
				eq(err, null);
				eq(res.bytesRead, buffer.length);
				beq(buffer, TestBase.binaryBytes);
				file.close();
				done();
			});
		});

		eq(asyncDone, 0);
		TestBase.uvRun();
	}

	/**
		Tests write functions.
	**/
	function testWrite(async:Async) {
		sub(async, done -> {
			var file = NewFS.open("resources-rw/hello.txt", "w");
			var buffer = Bytes.ofString("hello");
			file.async.write(buffer, 0, 5, 0, (err, res) -> {
				eq(err, null);
				eq(res.bytesWritten, 5);
				file.close();
				beq(OldFile.getBytes("resources-rw/hello.txt"), buffer);
				OldFS.deleteFile("resources-rw/hello.txt");
				done();
			});
		});

		sub(async, done -> {
			var file = NewFS.open("resources-rw/unicode.txt", "w");
			var buffer = TestBase.helloBytes;
			file.async.write(buffer, 0, buffer.length, 0, (err, res) -> {
				eq(err, null);
				eq(res.bytesWritten, buffer.length);
				file.close();
				beq(OldFile.getBytes("resources-rw/unicode.txt"), buffer);
				OldFS.deleteFile("resources-rw/unicode.txt");
				done();
			});
		});

		sub(async, done -> {
			var file = NewFS.open("resources-rw/unicode2.txt", "w");
			var buffer = TestBase.helloBytes;
			file.async.writeString(TestBase.helloString, 0, (err, res) -> {
				eq(err, null);
				eq(res.bytesWritten, TestBase.helloBytes.length);
				file.close();
				beq(OldFile.getBytes("resources-rw/unicode2.txt"), TestBase.helloBytes);
				OldFS.deleteFile("resources-rw/unicode2.txt");
				done();
			});
		});

		eq(asyncDone, 0);
		TestBase.uvRun();
	}
}
