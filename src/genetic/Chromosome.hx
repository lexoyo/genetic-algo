package genetic;

// a gene is a float number in [0, 1[
typedef Gene = Float;

class Chromosome {
  public var genes : Array<Gene>;
  public function new( genes : Array<Gene> ) {
    this.genes = genes;
  }
  public function toString(): String {
    return "[Chromosome:: ${genes.length}]";
  }
  public static function createRandom( numGenes:Int ) : Chromosome {
    return new Chromosome ([ for (i in 0...numGenes) Math.random() ]);
  }
}

