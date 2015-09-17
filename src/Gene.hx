import haxe.EnumTools;

enum GeneType {
  LEFT;
  RIGHT;
  TOP;
  BOTTOM;
  GOTO(value:Int);
}

class Gene {
  public static inline var NUM_GENE_TYPES:Int = 5;
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
    }
    return gene;
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
    }
    return gotoIdx;
  }
  public function toString(): String {
    return Std.string(type);
  }
}

