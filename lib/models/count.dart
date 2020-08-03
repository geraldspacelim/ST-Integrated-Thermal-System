import 'dart:async';

class Count{
  StreamController<int> countController = StreamController();
  int count = 5; 

   Stream<int> intStream() {
    return countController.stream;
  }

  updateCount(int updatedCount) {
    countController.add(count = updatedCount); 
  }
}