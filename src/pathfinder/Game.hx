package pathfinder;

enum Action {
  NONE;
  UP;
  DOWN;
  LEFT;
  RIGHT;
}

class Game {
  public var isOver = false;
  private var objects : Array<Object>;
  public var map : Map;
  private var numIdleTurns : Int = 0;
  private static inline var NUM_IDLE_TO_END : Int = 3;
  public function new ( objects : Array<Object> ) {
    this.objects = objects;
    map = new Map();
    for ( object in objects ) {
      addToMap(map, object);
    }
  }
  public function addToMap(map:Map, object:Object) {
    for(i in 0...object.width)
      for(j in 0...object.height)
        map.set( object.x + i, object.y + j, object );
  }
  public function removeFromMap(map:Map, object:Object) {
    for(i in 0...object.width)
      for(j in 0...object.height)
        map.set( object.x + i, object.y + j, null );
  }
  /**
   * move objects, handle collisions, display the map
   */
  public function nextTurn () {
    var atLeastOneMove = false;
    for ( object in objects ) {
      // compute object movement
      var offset = switch ( object.action ) {
        case UP:
          {x: 0, y: 1};
        case DOWN:
          {x: 0, y: -1};
        case LEFT:
          {x: -1, y: 0};
        case RIGHT:
          {x: 1, y: 0};
        case NONE:
          {x: 0, y: 0};
      }
      // handle collision
      var destCell = null;
      var outOfMap = false;
      try {
        destCell = map.get( object.x + offset.x, object.y + offset.y);
      }
      catch ( e : Dynamic ) {
        outOfMap = true;
      }
      if ( destCell != null && destCell != object ) {
        collide( object, destCell );
      }
      // move object if there is no collision
      else if ( !outOfMap && object.action != NONE ) {
        atLeastOneMove = true;
        removeFromMap(map, object);
        object.x += offset.x;
        object.y += offset.y;
        addToMap(map, object);
      }
    }
    if (atLeastOneMove) {
      numIdleTurns = 0;
    }
    else {
      numIdleTurns++;
      if (numIdleTurns >= NUM_IDLE_TO_END) {
        isOver = true;
      }
    }
  }


  /**
   * called upon collision
   */
  public function collide ( object1 : Object, object2 : Object ) {
    object1.collide( object2 );
    object2.collide( object1 );
    if ( object1.type == Object.DOOR_TYPE || object2.type == Object.DOOR_TYPE )
      isOver = true;
  }
}
