# Perceptron Simulation
Visualization of the learning algorithm for a single perceptron type neuron.

## Project description
The assumption of the project was to build an application that works on all operating systems. I created a mobile application using the Flutter framework and the Dart language.

The application simulates a perceptron, which is one of the basic models in the field of machine learning. The aim of the project is to create a tool that accepts data from a file and trains the perceptron to identify the correct answers based on the provided training data.

## Theoretical basis
A perceptron is a simple mathematical model that mimics the action of a single neuron in the brain. It is the basic element of artificial neural networks.

The perceptron consists of inputs and outputs, weights, an activation function, a learning rate, and a threshold. The inputs represent the signals we feed into the perceptron. We assign a weight to each input, which determines how important the signal is to the perceptron. The activation function decides whether the perceptron should forward the signal further in the network or not. The learning rate determines how far the perceptron takes towards optimizing the weights. Bias is the value that is added to the sum of the weighted input signals in the perceptron before passing them to the activation function. Bias allows you to shift the activation threshold, thereby controlling the perceptron's sensitivity to input.

During learning, the perceptron "learns" to adjust the weights of its inputs to respond correctly to the inputs. This process is called supervised learning. During training, we present input examples to the perceptron along with the desired outputs. Based on these results, the perceptron adjusts its weights to better represent the desired behavior.

Learning the perceptron involves iteratively presenting training examples, modifying the weights, and continuously checking how well the perceptron does at predicting outcomes based on new data. This process is repeated many times until the perceptron reaches a satisfactory accuracy in prediction.

## Main features of the application:
### Loading data: 
The application allows the user to load training data from a file. The data can be in text or CSV format, depending on the user's preferences.

### Data processing: 
After loading the data, the application processes them in order to prepare them for the learning process. This includes splitting the training and test sets, and converting them to the appropriate format for the perceptron.

### Perceptron learning: 
The app performs perceptron learning based on the provided training data. The learning algorithm adjusts the perceptron weights to minimize prediction error and correctly classify the data.

### Testing and evaluation:
After the training process is completed, the application allows testing on test data and evaluating the effectiveness of the perceptron. This may include the calculation of metrics such as accuracy, precision, and recall to assess classification quality.

### Visualization of the results: 
The application can also provide visualizations of the perceptron training results, such as graphs showing the change in the perceptron weights during training, or graphs presenting the perceptron's effectiveness on test data.

## Source code
Models (perceptron, activation function, inputs and outputs): [link](https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/tree/main/lib/core/models)

Views (start screen, data loading screen, etc): [link](https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/tree/main/lib/core/views)

Controllers (route management, simulation management): [link](https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/tree/main/lib/core/controllers)

Sample perceptron learning data file: [link](https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/tree/main/assets/data)

## App appearance:
### Main screen:
<img src="https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/assets/71569327/469ad138-bc56-46d2-90a3-b109c1314548" width="256">

### File example screen: 
<img src="https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/assets/71569327/3d2c0ea9-e802-49dc-8ef5-65519fbf8f9a" width="256">

### Loading data: 
<img src="https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/assets/71569327/4f8a32e9-280e-4818-a072-b2ad8b2eb0b2" width="256">
<img src="https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/assets/71569327/39422041-014f-45ee-8ceb-f05f2e4bcb7f" width="256">

### Separating data: 
<img src="https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/assets/71569327/2e69e261-ef9f-47bb-8f35-d43060c5219e" width="256">

### Selecting activation function: 
<img src="https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/assets/71569327/29ca4215-5d3c-427a-9b71-347e52c74021" width="256">

### Selecting learning rate:
<img src="https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/assets/71569327/354c6f65-a704-4627-bcaa-6326b4d2363d" width="256">

### Visualization of the results: 
<img src="https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/assets/71569327/1f8fbc3c-5bc6-45c3-8a43-a7b7f826fde0" width="256">
<img src="https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/assets/71569327/ce5c8046-3e8c-49ea-adaa-ab8a78c894fb" heihht="32">
<img src="https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/assets/71569327/e13c5ded-0450-4ddc-bddc-d58cf216da66" width="256">
<img src="https://github.com/TR0U8L3-gif/flutter_perceptron_simulation/assets/71569327/1bf58a50-57a2-4f05-aa6b-22ec23d94a49" width="256">

