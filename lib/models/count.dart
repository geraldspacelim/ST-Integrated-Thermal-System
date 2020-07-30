import 'package:flutter/material.dart';

class Count extends ChangeNotifier{

  int _count = 0; 
  int get count => _count;
  
  void updateCount(int updatedCount) {
    _count = updatedCount; 
    notifyListeners(); 
  }
} 
