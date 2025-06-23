void main() {
  List<String> fruits = ['apple', 'banana', 'grape', 'orange', 'kiwi'];

  List<String> aFruits = fruits.where((fruit) => fruit.startsWith('e')).toList();
  

  print(aFruits);
}