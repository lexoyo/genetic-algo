import haxe.EnumTools;

enum GeneType {
  LEFT;
  RIGHT;
  TOP;
  BOTTOM;
  GOTO(value:Int);
  GT(property:WorldProperty, value:Int);
  LT(property:WorldProperty, value:Int);
}

enum WorldProperty {
  ME(property:CreatureProperties);
  MAP(x:Int, y:Int);
}

enum CreatureProperties {
  X;
  Y;
}

class Gene {
  public static inline var NUM_GENE_TYPES:Int = 7;
  public var type: GeneType;
  public function new() {}
  public static function randomize(): Gene {
    var gene = new Gene();
    var randIdx = Math.floor(Math.random() * NUM_GENE_TYPES);
    switch(randIdx) {
      case 0:
        gene.type = LEFT;
      case 1:
        gene.type = RIGHT;
      case 2:
        gene.type = TOP;
      case 3:
        gene.type = BOTTOM;
      case 4:
        gene.type = GOTO(Math.floor(Math.random() * Creature.NUM_GENES));
      case 5:
        gene.type = GT(gene.getRandomProp(), Math.round(Math.random() * 100000));
      case 6:
        gene.type = GT(gene.getRandomProp(), Math.round(Math.random() * 100000));
    }
    return gene;
  }
  public function getRandomProp() {
    var randPercent = Math.round(Math.random() * 100);
    if (randPercent < 25) return ME(X);
    if (randPercent < 50) return ME(Y);
    return MAP(
      Math.floor(Math.random() * Map.WIDTH),
      Math.floor(Math.random() * Map.HEIGHT)
    );
  }
  public function getValueOf(creature:Creature, property:WorldProperty):Int {
    switch(property) {
      case ME(myProp):
        switch(myProp) {
          case X: return Math.round(creature.x);
          case Y: return Math.round(creature.y);
        }
      case MAP(x, y): return Map.getObstruction(x, y);
    }
  }
  public static function evolve(gene1: Gene, gene2: Gene): Gene {
    var randPercent = Math.round(Math.random() * 100);
    if (randPercent < 45) return gene2;
    if (randPercent < 90) return gene1;
    return randomize();
  }
  public static function exec(creature: Creature, gene: Gene): Int {
    var gotoIdx = creature.currentGeneIdx + 1;
    switch(gene.type) {
      case LEFT: creature.x--;
      case RIGHT: creature.x++;
      case TOP: creature.y++;
      case BOTTOM: creature.y--;
      case GOTO(value): gotoIdx = value;
      case GT(property, value): if(gene.getValueOf(creature, property) <= value) gotoIdx++;
      case LT(property, value): if(gene.getValueOf(property) >= value) gotoIdx++;
    }
    return gotoIdx;
  }
  public function toString(): String {
    return Std.string(type);
  }
}

