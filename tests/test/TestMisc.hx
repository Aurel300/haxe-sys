package test;

import sys.FilePermissions;

class TestMisc extends Test {
	/**
		Tests `sys.FilePermissions`. No actual system calls are tested here; see
		e.g. `TestFileSystem.testAccess`.
	**/
	function testFilePermissions():Void {
		eq(("---------" : FilePermissions), None);
		eq(("r--------" : FilePermissions), ReadOwner);
		eq(("-w-------" : FilePermissions), WriteOwner);
		eq(("--x------" : FilePermissions), ExecuteOwner);
		eq(("---r-----" : FilePermissions), ReadGroup);
		eq(("----w----" : FilePermissions), WriteGroup);
		eq(("-----x---" : FilePermissions), ExecuteGroup);
		eq(("------r--" : FilePermissions), ReadOthers);
		eq(("-------w-" : FilePermissions), WriteOthers);
		eq(("--------x" : FilePermissions), ExecuteOthers);
		eq(("rwx------" : FilePermissions), ReadOwner | WriteOwner | ExecuteOwner);
		eq(("---rwx---" : FilePermissions), ReadGroup | WriteGroup | ExecuteGroup);
		eq(("------rwx" : FilePermissions), ReadOthers | WriteOthers | ExecuteOthers);
		eq(("rw-rw-rw-" : FilePermissions), ReadOwner | WriteOwner | ReadGroup | WriteGroup | ReadOthers | WriteOthers);

		eq(ReadOwner, FilePermissions.fromOctal("400"));
		eq(ReadOwner | WriteOwner | ExecuteOwner, FilePermissions.fromOctal("700"));
		eq(ReadOwner | WriteOwner | ReadGroup | WriteGroup | ReadOthers | WriteOthers, FilePermissions.fromOctal("666"));
	}
}
