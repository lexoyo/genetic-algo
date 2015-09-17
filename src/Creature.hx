class Creature {
  public static inline var NUM_GENES: Int = 100;
  private static var nextId = 0;
  private var genome: Array<Gene>;
  public var x: Float;
  public var y: Float;
  public var initialX: Float;
  public var initialY: Float;
  public var id: Int;
  public var currentGeneIdx: Int = 0;

  public static function randomize(): Creature {
    var creature = new Creature();
    for(idx in 0...NUM_GENES) {
      creature.genome[idx] = Gene.randomize();
    }
    return creature;
  }
  public static function evolve(creature1: Creature, creature2: Creature): Creature {
    var creature = new Creature();
    for(idx in 0...NUM_GENES) {
      creature.genome[idx] = Gene.evolve(creature1.genome[idx], creature2.genome[idx]);
    }
    return creature;
  }
  public function new() {
    id = nextId++;
    genome = new Array();
    reset();
  }
  public function reset() {
    x = 10 + Math.random() * (Map.WIDTH - 20);
    y = 10 + Math.random() * (Map.HEIGHT - 20);
//x = 25; y = 25;
    initialX = x;
    initialY = y;
  }
  public function loop() {
    if(currentGeneIdx < NUM_GENES) {
      currentGeneIdx = Gene.exec(this, genome[currentGeneIdx]);
/*
      var gene = Gene.randomize();
      gene.type = BOTTOM;
      currentGeneIdx = Gene.exec(this, gene);
*/
    }
  }
  public function toString() {
    var idx = 0;
    var genes: Array<String> = genome.map(function (gene) {
      if(currentGeneIdx == idx++) return "*" + gene.toString() + "*";
      return gene.toString();
    });
    return "Creature:: " + id + " (" + Math.round(x) + ", " + Math.round(y) + ", " + Math.round(initialX) + ", " + Math.round(initialY) + ") [" + genes.join(", ") + "]";
  }
}

