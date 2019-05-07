package haxe;

import haxe.PosInfos;

class Error {
  public final message:String;
  public final posInfos:PosInfos;
  
  public function new(message:String, ?posInfos:PosInfos) {
    this.message = message;
    this.posInfos = posInfos;
  }
  
  public function toString():String {
    return '$message at $posInfos';
  }
}
