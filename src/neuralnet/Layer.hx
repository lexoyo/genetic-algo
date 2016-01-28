package neuralnet;

/**
 * Handle the creation of layers of neurons, with random weights and biases. Also computes an output for a given input.
 */
class Layer {
  public var neurons : Array<Neuron>;
  public function new ( weights : Array<Array<Float>>, biases : Array<Float> ) {
    neurons = [ for ( i in 0...biases.length ) new Neuron ( weights[i], biases[i] )];
  }


  /**
   * compute the output values for the given input values
   */
  public function compute ( input : Array<Float> ) : Array<Float> {
    return [ for ( neuron in neurons) neuron.compute ( input ) ];
  }
}

