package neuralnet;

class Layer {
  public var neurons : Array<Neuron>;
  public function new ( weights : Array<Array<Float>>, biases : Array<Float> ) {
    if( weights.length != biases.length ) throw "Weigths and biases arrays are expected to have the same length";
    neurons = [ for ( i in 0...weights.length ) new Neuron ( weights[i], biases[i] )];
  }
  private static function getRandomWeights( numInputs : Int ) : Array<Float> {
    return [ for (i in 0...numInputs) Std.random( 1 )  ];
  }


  /**
   * compute the output values for the given input values
   */
  public function compute ( input : Array<Float> ) : Array<Float> {
    return [ for ( neuron in neurons) neuron.compute ( input ) ];
  }
}

