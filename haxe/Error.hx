package haxe;

import haxe.PosInfos;

class Error {
  public final message:String;
  public final posInfos:PosInfos;
  public final type:ErrorType;
  
  public function new(message:String, type:ErrorType, ?posInfos:PosInfos) {
    this.message = message;
    this.type = type;
    this.posInfos = posInfos;
  }
  
  public function toString():String {
    return '$message at $posInfos';
  }
}
