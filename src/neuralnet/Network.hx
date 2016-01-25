package neuralnet;

/**
 * Create the layers of the neural network, compute the output for a given input.
 */
class Network {
  private var layers : Array<Layer>;
  /**
   * the number of layers is the length of weights
   * the number of inputs is the length of weights[0]
   * the number of outputs is the length of weights[weights.length - 1]
   * @constructor
   * @param weights the weight of each input of each neuron of each layer
   * @param biases the bias of each neuron of each layer
   */
  public function new ( weights : Array<Array<Array<Float>>>, biases : Array<Array<Float>> ) {
    layers = [ for ( i in 0...weights.length ) new Layer( weights[i], biases[i] )];
  }
  public function compute ( input : Array<Float> ) : Array<Float> {
    // compute each layer's output and returns the last one
    var lastOutput = input;
    for ( layer in layers) {
      lastOutput = layer.compute ( lastOutput );
    }
    return lastOutput;
  }
}

