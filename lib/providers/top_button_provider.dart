import 'package:flutter/material.dart';

class TopButtonModel extends ChangeNotifier{
  int _number = 0;
  String type = 'movie';
  int get number => _number;
  set number(int number){
    _number = number;
    if(_number == 0){
      type = 'movie';
    }
    else{
      type = 'tv';
    }
    notifyListeners();
  }
}