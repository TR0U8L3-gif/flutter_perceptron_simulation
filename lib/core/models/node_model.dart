
class Node {
  String name;
  double value;
  Node({required this.name, required this.value});
}

class Input extends Node{
  Input({required super.name, required super.value});
}

class Output extends Node{
  Output({required super.name, required super.value});
}