package haxe.io;

abstract FilePath(String) from String {
  @:from public static function encode(bytes:Bytes):FilePath {
    // TODO: standard UTF-8 decoding, except any invalid bytes is replaced
    // with (for example) U+FFFD, followed by the byte itself as a codepoint
    return null;
  }
  
  public function decode():Bytes {
    return null;
  }
  
  private function decodeHl():hl.Bytes {
    return @:privateAccess this.toUtf8();
  }
  private static function encodeHl(data:hl.Bytes):FilePath {
    return ((@:privateAccess String.fromUCS2(data)):FilePath);
  }
}