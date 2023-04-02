import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/cast_model.dart';
import 'package:themoviedb/models/details_movie_model.dart';
import 'package:themoviedb/models/movie_firebase_model.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:themoviedb/pages/widgets.dart';
import 'package:themoviedb/providers/collection_provider.dart';
import 'package:themoviedb/providers/movie_provider.dart';
import 'details_page_widgets.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.movie, required this.type})
      : super(key: key);

  final Movie movie;
  final String type;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);
    return Scaffold(
        body: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color(0xFF0D0D0D),
                  Color(0xFF1A1A1A),
                ])),

            ///Get Movie or Tv Show Details
            child: FutureBuilder(
                future: moviesProvider.getDetails(
                    widget.movie.id.toString(), widget.type),
                builder: (context, AsyncSnapshot<MovieDetails> snapshot) {
                  if (snapshot.hasData) {
                    ///Get Movie or Tv Show Cast
                    return FutureBuilder(
                        future: moviesProvider.getCast(
                            (widget.movie.id).toString(), widget.type),
                        builder:
                            (context, AsyncSnapshot<List<Actor>> snapshot) {
                          if ((snapshot.hasData)) {
                            final performers = snapshot.data;
                            return SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(children: [
                                  MovieDetailsInfo(
                                      size: size,
                                      moviesProvider: moviesProvider,
                                      movie: widget.movie),
                                  Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 30, 20, 20),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(widget.movie.title,
                                                style: kTextStyleDetails),
                                            const SizedBox(height: 15),
                                            OverviewText(widget: widget),
                                            const SizedBox(height: 20),
                                            GenresListCard(
                                                moviesProvider: moviesProvider),
                                            const SizedBox(height: 20),
                                            CastMovie(performers: performers!),
                                            const SizedBox(height: 10),
                                            PersonalRating(movie: widget.movie),
                                          ]))
                                ]));
                          } else {
                            return const CustomGIF();
                          }
                        });
                  } else {
                    return const CustomGIF();
                  }
                })));
  }
}

class PersonalRating extends StatefulWidget {
  const PersonalRating({
    Key? key,
    required this.movie,
  }) : super(key: key);
  final Movie movie;

  @override
  State<PersonalRating> createState() => _PersonalRatingState();
}

class _PersonalRatingState extends State<PersonalRating> {
  @override
  Widget build(BuildContext context) {
    String language = Provider.of<MoviesProvider>(context).language;
    List<MovieCollection> moviesCollection =
        Provider.of<MyCollectionProvider>(context).movieCollection;
    double myRating = 0;
    for (var element in moviesCollection) {
      if (element.id == widget.movie.id) {
        myRating = element.rating;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        language == 'es-ES'
            ? Text('Puntaje personal', style: kTextStyleDetails)
            : Text('Personal Rating', style: kTextStyleDetails),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          child: RatingBar.builder(
            unratedColor: kTextDetailsColor.withOpacity(0.3),
            glowColor: Colors.white,
            itemSize: 50,
            initialRating: myRating,
            minRating: 1,
            direction: Axis.horizontal,
            itemPadding: const EdgeInsets.symmetric(horizontal: 5),
            itemBuilder: (context, index) {
              return Text(emojis[index]);
            },
            onRatingUpdate: (index) {
              Provider.of<MyCollectionProvider>(context, listen: false).rating =
                  index;
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                    width: 2,
                    color: kTextDetailsColor,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  foregroundColor: kTextDetailsColor,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 15.0,
                ),
                onPressed: () {
                  double rating =
                      Provider.of<MyCollectionProvider>(context, listen: false)
                          .rating;
                  saveOnFireBase(widget.movie, rating,
                      Provider.of<MoviesProvider>(context, listen: false).type);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      content: Text(language == 'es-ES'
                          ? 'Pelicula guardada'
                          : 'Movie saved')));
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(Icons.save_alt),
                    const SizedBox(width: 10),
                    Text(
                      language == 'es-ES' ? 'Guardar' : 'Save',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )),
          ],
        )
      ],
    );
  }

  Future saveOnFireBase(Movie movie, double rating, String type) async {
    final docUser = FirebaseFirestore.instance
        .collection('myPersonalMovieCollection')
        .doc(movie.id.toString());

    final movie2Save = MovieCollection(
      id: movie.id,
      title: movie.title,
      rating: rating,
      type: type,
      date: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
          .replaceAll("00:00:00.000", ""),
    );
    final json = movie2Save.toJson();

    ///Create document and write data to Firebase
    await docUser.set(json);
  }
}
