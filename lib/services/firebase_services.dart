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
    final userCredential =
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
    print("-----> Sign-in successful - $userCredential.");
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "invalid-custom-token":
        print("-----> The supplied token is not a Firebase custom auth token.");
        break;
      case "custom-token-mismatch":
        print("-----> The supplied token is for a different Firebase project.");
        break;
      default:
        print("-----> Unkown error.");
    }
  }
}
