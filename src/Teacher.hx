typedef CreatureData = {
  score: Int,
  route: List<Coord<Int>>
}
typedef Coord<T> = { var x:T; var y:T; }
class Teacher {
  public static inline var MAX_TURNS:Int = 2000;
  private var turns:Int = 0;
  private var creaturesData:Array<CreatureData> = null;

  public function new(creatures: Array<Creature>) {
    creaturesData = new Array();
    for(creature in creatures) {
      creaturesData[creature.id] = {
        score: 0,
        route: new List<Coord<Int>>()
      }
    }
  }
  public function start() {
    turns = 0;
  }
  public function stop() {}
  public function turn() {
    turns ++;
  }
  public function loop(creature:Creature) {
    if(creature.x <= 0 && creature.y < (Map.HEIGHT/2)+10 && creature.y > (Map.HEIGHT/2)-10) {
      creaturesData[creature.id].score++;
    }
    if(turns == 0) {
      creaturesData[creature.id].route.clear();
      creature.reset();
    }
    creaturesData[creature.id].route.add({
      x: Math.round(creature.x),
      y: Math.round(creature.y)
    });
  }
  public function getScore(creature:Creature):Int {
    return creaturesData[creature.id].score;
  }
  public function getRoute(creature:Creature): String {
    var map = new Array();
    for(x in 0...Map.WIDTH) {
      map[x] = new Array();
      for(y in 0...Map.HEIGHT) {
        var obs  = Map.getObstruction(x, y);
        if(obs == 0) map[x][y] = "_";
        else map[x][y] = "X";
        if(x == 0 && y < (Map.HEIGHT/2)+10 && y > (Map.HEIGHT/2)-10) {
          map[x][y] = "!";
        }
        if(Math.round(creature.initialX) == x && Math.round(creature.initialY) == y) {
          map[x][y] = "I";
        }
      }
    }
    for(step in creaturesData[creature.id].route) {
      var x = step.x;
      var y = step.y;
      if(Math.round(creature.initialX) == x && Math.round(creature.initialY) == y) {
        map[x][y] = "I";
      }
      else {
        map[x][y] = "O";
      }
    }
    var str = "";
    for(x in 0...Map.WIDTH) {
      str += map[x].join("") + "\n";
    }
    return str;
  }
  public function isOver():Bool {
    return turns >= MAX_TURNS;
  }
}

