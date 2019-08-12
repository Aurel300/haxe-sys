# Breaking changes

 - **`sys.FileStat`**
   - changed to abstract, underlying type has additional fields (`blksize`, `blocks`, `atimeMs`, `ctimeMs`, `mtimeMs`, `birthtime`, `birthtimeMs`)
 - **`sys.FilePath`**
   - some functions in sys which used to take a path as a String now take FilePath, which has `from String`, but it may cause some issues nonetheless
