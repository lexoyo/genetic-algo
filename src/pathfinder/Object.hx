package pathfinder;

import pathfinder.Game;

class Object {
  public static inline var WALL_TYPE = .1;
  public static inline var PLAYER_TYPE = .2;
  public static inline var DOOR_TYPE = .3;
  public var x : Int;
  public var y : Int;
  public var width : Int;
  public var height : Int;
  public var action : Action;
  public var type: Float;
  public var score: Int = 0;
  public function new ( x : Int, y : Int, width : Int, height : Int, type: Float) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
  public function collide( other : Object ) {
    if( type == PLAYER_TYPE) {
      if ( other.type == DOOR_TYPE ) score += 100;
      if ( other.type == WALL_TYPE ) score -= 1;
    }
  }
}
