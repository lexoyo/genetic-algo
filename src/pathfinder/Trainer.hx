package pathfinder;

import pathfinder.Game;

class Trainer {
  // constants for learning algorithm
  private static inline var NUM_GENERATIONS = 100;
  private static inline var NUM_MATCH = 2;
  private static inline var NUM_CREATURE = 1000;
  private static inline var NUM_TURNS = 50;
  // constants for genetic algorithm
  private static inline var NUM_WINNERS = 40;
  private static inline var NUM_RANDOM_WINNERS = 10;
  private static inline var MUTATION_PERCENT = .1; // the less the score the heigher the mutation rate, see Generation::evolve
  // and for neural network
  private static inline var NUM_INPUTS = (Map.SIZE_X * Map.SIZE_Y) + 4 + 4;
  private static inline var NUM_OUTPUTS = 5;
  private static inline var NUM_LAYERS = 2;
  private static inline var NUM_NEURONS = 10;
  public static function main() {
    new Trainer();
  }
  public function new() {
    var numChromosomes = NUM_LAYERS;
    var genotypeStructure = getGenotypeStructure();
    // create a 1st random generation with these genes
    var generation = genetic.Generation.createRandom( NUM_CREATURE, genotypeStructure );
    // now start the learning process
    for(generationIdx in 0...NUM_GENERATIONS) {
      trace('Start tournament with $generation');
      var generationBestScore = 0;
      var numWinners = 0;
      for(matchIdx in 0...NUM_MATCH) {
        var door = new Object( Math.floor(Math.random() * 10), 0, 8, 1, Object.DOOR_TYPE );
        var walls = [ new Object( 2, 3, Math.floor(Math.random() * 10), 1, Object.WALL_TYPE ) ];
        var game:Game = null;
        for(creature in generation.creatures) {
          var chromosomesArray : Array<Array<Float>> = [ for (chromosome in creature.chromosomes) [ for (gene in chromosome.genes) gene ]];
          var network = createNetwork ( chromosomesArray, genotypeStructure );
          var player = new Object( 10, 10, 1, 1, Object.PLAYER_TYPE );
          game = new Game(walls.concat([door, player]));
          var turn = 0;
          while(!game.isOver && turn++ < NUM_TURNS) {
            var input = getNetworkInput( player, door, game.map.objects, Map.SIZE_X, Map.SIZE_Y );
            var output = network.compute( input );
            player.action = getActionFromOutput( output );
            //if(player.action != NONE) trace("------", output, player.action);
            game.nextTurn();
          }
          creature.score += player.score;
          if ( creature.score > 0 ) numWinners++;
          if( generationBestScore < creature.score ) generationBestScore = creature.score;
          // if(creature.score > 0)
          // displayMap(game.map.objects);
          // trace('$creature');
        }
        displayMap(game.map.objects);
      }
      trace('End of tournament with best score $generationBestScore and $numWinners winners.');
      generation = generation.evolve(NUM_WINNERS, NUM_RANDOM_WINNERS, MUTATION_PERCENT);
    }
  }

  function displayMap(map : Array<Array<Null<Object>>>) {
    Sys.print('\033[2J');
    trace("------");
      for(line in map) {
        var arr = [];
        for (object in line)  {
          if(object == null) arr.push("0");
          else if (object.type == Object.WALL_TYPE) arr.push("|");
          else if (object.type == Object.PLAYER_TYPE) arr.push("M");
          else arr.push("X");
        }
        trace(arr);
      }
      trace("------");
  }

  /**
   * this methods fills an array to link the chromosomes and the neural network of a creature
   * each element of the array represents a chromosome
   * the value of the element is made of the number of inputs and number of neurons
   * the number of genes in the chromosome is also the weights + the biases
   * the number of weights = numInputs * numNeurons
   * the number of biases = numNeurons
   */
  private function getGenotypeStructure() : Array<{ numInputs:Int, numNeurons:Int, numGenes:Int }> {
    return [{
      // first chromosome has the genes for the input weights and the first layer's bias
      numInputs:  NUM_INPUTS,
      numNeurons:  NUM_NEURONS,
      numGenes: NUM_INPUTS * NUM_NEURONS + NUM_NEURONS,
    }].concat([
      // then each hidden...
      for( i in 1...NUM_LAYERS ) {
        // ... has the inputs from preceding layer x number of layers + bias of each neuron
        {
          numInputs: NUM_NEURONS,
          numNeurons: NUM_NEURONS,
          numGenes: NUM_NEURONS * NUM_NEURONS + NUM_NEURONS,
        }
      }
    ])
    .concat([{
      // and finally the last chromosome number of genes is the input of the preceding layer x number of neurons in the output layer + the bias of each output neuron
      numInputs: NUM_NEURONS,
      numNeurons: NUM_OUTPUTS,
      numGenes: NUM_NEURONS * NUM_OUTPUTS + NUM_OUTPUTS,
    }]);
  }


  /**
   * create a network of NUM_LAYERS of NUM_NEURONS with NUM_INPUTS and NUM_OUTPUTS
   * the weights and biases of the layers are the chromosomes of the creature
   * so the creature has one chromosome per layer
   * and each chromosome has one gene per input weight per neuron, plus one per neuron (bias)
   */
  private function createNetwork( chromosomes : Array<Array<Float>>, genotypeStructure : Array<{ numInputs:Int, numNeurons:Int }> ) : neuralnet.Network {
    var biases = [];
    var weights = [];
    for (chromosomeIdx in 0...genotypeStructure.length) {
      var chromosomeStructure = genotypeStructure[ chromosomeIdx ];
      weights.push([
          for ( neuronIdx  in 0...chromosomeStructure.numNeurons ) {
            for ( inputIdx  in 0...chromosomeStructure.numInputs ) {
              chromosomes[ chromosomeIdx ].slice( inputIdx + neuronIdx * chromosomeStructure.numInputs,  inputIdx + neuronIdx * chromosomeStructure.numInputs + chromosomeStructure.numInputs);
            }
          }
      ]);
      biases.push( chromosomes[ chromosomeIdx ].slice( chromosomeStructure.numInputs * chromosomeStructure.numNeurons ));
    }
    var res = new neuralnet.Network( weights, biases );
    return res;
  }


  /**
   * build an array
   * serializes the map with other useful info for the neural network
   * all elements have a value between 0 and 1
   */
  private function getNetworkInput( player : Object, door : Object, map : Array<Array<Null<Object>>>, mapWidth : Int, mapHeight : Int ) : Array<Float> {
    return [
      player.x / mapWidth,
      player.y / mapHeight,
      player.width / mapWidth,
      player.height / mapHeight,
      door.x / mapWidth,
      door.y / mapHeight,
      door.width / mapWidth,
      door.height / mapHeight,
    ].concat( [ for(line in map) { for (object in line) if(object == null) Object.WALL_TYPE; else object.type; }] );
  }



  /**
   * interprete the network's output as a command for the game
   */
  private function getActionFromOutput( output : Array<Float> ) : Null<Action> {
    var max = Math.max( output[0], Math.max( output[1], Math.max( output[2], Math.max( output[3], output[4] ))));
    return
      if ( max == output[0]) NONE;
      else if ( max == output[1]) UP;
      else if ( max == output[2]) DOWN;
      else if ( max == output[3]) LEFT;
      else if ( max == output[4]) RIGHT;
      else throw "Error: unknown command found as output of the network";
  }
}

