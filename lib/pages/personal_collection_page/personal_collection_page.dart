import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/details_movie_model.dart';
import 'package:themoviedb/models/movie_firebase_model.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:themoviedb/pages/search_page/search_movie_page.dart';
import 'package:themoviedb/pages/widgets.dart';
import 'package:themoviedb/providers/collection_provider.dart';
import 'package:themoviedb/services/firebase_services.dart';
import '../../providers/movie_provider.dart';
import 'personal_collection_page_widget.dart';

class MyPersonalCollection extends StatefulWidget {
  const MyPersonalCollection({Key? key}) : super(key: key);

  @override
  State<MyPersonalCollection> createState() => _MyPersonalCollectionState();
}

class _MyPersonalCollectionState extends State<MyPersonalCollection> {
  TextEditingController textEditingController = TextEditingController();
  List<MovieCollection> moviesCollection = [];

  @override
  void initState() {
    moviesCollection = Provider.of<MyCollectionProvider>(context, listen: false)
        .movieCollection;
    textEditingController.text = "";
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String language = Provider.of<MoviesProvider>(context).language;
    int qtyMovie = 0, qtySeries = 0;
    final moviesProvider = Provider.of<MoviesProvider>(context);

    for (var element in moviesCollection) {
      if (element.type == 'movie') {
        qtyMovie++;
      } else if (element.type == 'tv') {
        qtySeries++;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBody: true,
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CustomBackButton(),
                      const SizedBox(width: 20),
                      Text(
                        language == 'es-ES'
                            ? 'Mis películas'
                            : 'My Personal Collection',
                        style:
                            TextStyle(color: kTextDetailsColor, fontSize: 24),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (language == 'es-ES')
                    QtyMovies(
                      qtyMovie: qtyMovie,
                      qtySeries: qtySeries,
                      movieLanguage:
                          language == 'es-ES' ? 'Películas' : 'Movies',
                    ),

                  ///Search
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 5),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        border:
                            Border.all(color: kSearchColorTextField, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.8)),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Icon(Icons.search, color: kSearchColorTextField),

                        Expanded(
                          child: TextField(
                            onChanged: (text) {
                              moviesCollection = [];
                              Provider.of<MyCollectionProvider>(context,
                                      listen: false)
                                  .movieCollection
                                  .forEach((element) {
                                if (element.title
                                    .toLowerCase()
                                    .contains(text.toLowerCase())) {
                                  moviesCollection.add(element);
                                }
                              });
                              setState(() {});
                            },
                            controller: textEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.none),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              isDense: true,
                            ),
                            style: TextStyle(
                              fontSize: 20.0,
                              decoration: TextDecoration.none,
                              color: kSearchColorTextField,
                            ),
                          ),
                        ),
                        IconButton(
                          color: kSearchColorTextField,
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            textEditingController.text = "";
                            moviesCollection =
                                Provider.of<MyCollectionProvider>(context,
                                        listen: false)
                                    .movieCollection;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  )
                ],
              )),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
              physics: const BouncingScrollPhysics(),
              itemCount: moviesCollection.length,
              itemBuilder: (BuildContext context, int index) {
                double myRating = moviesCollection[index].rating;
                moviesProvider.searchMovieById(moviesCollection[index].id);
                String type = moviesCollection[index].type;

                return FutureBuilder(
                  future: type == 'movie'
                      ? moviesProvider
                          .searchMovieById(moviesCollection[index].id)
                      : moviesProvider
                          .searchTvShowById(moviesCollection[index].id),
                  builder: (BuildContext context,
                      AsyncSnapshot<MovieDetails> snapshot) {
                    var movie = snapshot.data;
                    if (!snapshot.hasData) {
                      return const CustomGIF();
                    }
                    Movie movieCard = Movie(
                        voteCount: movie!.voteCount ?? 0,
                        id: movie.id ?? 0,
                        video: movie.video ?? false,
                        voteAverage: movie.voteAverage ?? 0,
                        title: movie.title ?? '',
                        popularity: movie.popularity ?? 0,
                        posterPath: movie.posterPath ?? '',
                        originalLanguage: movie.originalLanguage ?? '',
                        originalTitle: snapshot.data!.originalTitle ?? '',
                        genreIds: [],
                        backdropPath: movie.backdropPath ?? '',
                        adult: movie.adult ?? false,
                        overview: movie.overview ?? '',
                        releaseDate: movie.releaseDate ?? '');
                    return Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.30,
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                              backgroundColor: const Color(0xFF0D0D0D),
                              foregroundColor: Colors.red,
                              icon: Icons.delete_forever,
                              label: language == 'es-ES' ? 'Borrar' : 'Delete',
                              onPressed: (context) {
                                deleteMovie(movie.id.toString());
                                Provider.of<MyCollectionProvider>(context,
                                        listen: false)
                                    .movieCollection
                                    .removeAt(index);
                                moviesCollection =
                                    Provider.of<MyCollectionProvider>(context,
                                            listen: false)
                                        .movieCollection;
                                setState(() {});
                              }),
                        ],
                      ),
                      child: SearchCard(
                        movie: movieCard,
                        myRating: myRating,
                        type: type,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
