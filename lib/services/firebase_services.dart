import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:themoviedb/models/movie_firebase_model.dart';

Stream<List<MovieCollection>> readMovies() {
  Stream<List<MovieCollection>> firebaseMyFavoriteMovies;
  firebaseMyFavoriteMovies = FirebaseFirestore.instance
      .collection('myPersonalMovieCollection')
      .orderBy("date", descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => MovieCollection.fromJson(doc.data()))
      .toList());
  return firebaseMyFavoriteMovies;
}

void deleteMovie(String id) => FirebaseFirestore.instance
    .collection('myPersonalMovieCollection')
    .doc(id)
    .delete();

Future<void> authFirebase(String email, String pass) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );
    print("Successfully signed in!");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided.');
    } else {
      print('Error: ${e.message}');
    }
  }
}
