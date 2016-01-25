package pathfinder;

import pathfinder.Game;

class Object {
  public var x : Int;
  public var y : Int;
  public var width : Int;
  public var height : Int;
  public var action : Action;
  public function new ( x : Int, y : Int, width : Int, height : Int) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
  public function collide( other : Object ) {}
}
