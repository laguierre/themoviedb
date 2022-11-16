import 'package:flutter/material.dart';
import 'package:themoviedb/models/movie_firebase_model.dart';

class MyCollectionProvider extends ChangeNotifier {
  double _rating = 0.0;

  double get rating => _rating;

  set rating(double rating) {
    _rating = rating;
    notifyListeners();
  }

  List<MovieCollection> movieCollection = [];
}
