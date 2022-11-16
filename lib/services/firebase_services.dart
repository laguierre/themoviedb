import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:themoviedb/models/movie_firebase_model.dart';

Stream<List<MovieCollection>> readMovies() => FirebaseFirestore.instance
    .collection('myPersonalMovieCollection')
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => MovieCollection.fromJson(doc.data()))
        .toList());

void deleteMovie(String id) => FirebaseFirestore.instance
    .collection('myPersonalMovieCollection').doc(id).delete();