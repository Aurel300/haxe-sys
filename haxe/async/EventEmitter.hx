package haxe.async;

class EventEmitter {
  final events:Array<Event<Dynamic>> = [];
  
  public function new() {}
  
  public function registerEvent(event:Event<Dynamic>):Void {
    events.push(event);
  }
  
  public function off():Void {
    for (event in events) {
      event.off();
    }
  }
}
