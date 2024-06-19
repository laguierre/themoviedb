import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    //TODO acomodar por acá
    Map<String, List<MovieCollection>> groupedMovies = groupMoviesByYear(moviesCollection);

    print(groupedMovies.length);
// Imprimir las películas agrupadas por año
    groupedMovies.forEach((year, movies) {
      print('Year: $year');
      for (var movie in movies) {
        print('  - ${movie.title}');
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBody: true,
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 50.sp, 10.sp, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CustomBackButton(),
                      SizedBox(width: 15.sp),
                      Text(
                        language == 'es-ES'
                            ? 'Mis películas'
                            : 'My Personal Collection',
                        style:
                            TextStyle(color: kTextDetailsColor, fontSize: 24),
                      )
                    ],
                  ),
                  SizedBox(height: 20.sp),
                  if (language == 'es-ES')
                    QtyMovies(
                      qtyMovie: qtyMovie,
                      qtySeries: qtySeries,
                      movieLanguage:
                          language == 'es-ES' ? 'Películas' : 'Movies',
                    ),



                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(0.sp, 20.sp, 0, 25.sp),
                    height: 30.sp,
                    width: double.infinity,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: groupedMovies.keys.length,
                      itemBuilder: (context, index) {
                        String year = groupedMovies.keys.elementAt(index);
                        return Padding(
                          padding: EdgeInsets.only(right: 10.sp),
                          child: Material(
                            elevation: 5.0,  // Elevación para sombra
                            borderRadius: BorderRadius.circular(18.0.sp),
                            shadowColor: Colors.black.withOpacity(0.2), // Color de la sombra
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF2D2C2C),
                                side: BorderSide(
                                  width: 2.sp,
                                  color: const Color(0xFF2D2C2C),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0.sp),
                                ),
                                backgroundColor: const Color(0xFF2D2C2C),
                                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                              ),
                              child: Text(
                                '$year (${groupedMovies[year]!.length})',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                // Acción a realizar cuando se presiona el botón
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),






                  ///Search
                  Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 48.sp,
                      margin: EdgeInsets.fromLTRB(0, 0.sp, 0, 5.sp),
                      padding: EdgeInsets.symmetric(horizontal: 5.sp),
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
                          border: Border.all(
                              color: kSearchColorTextField, width: 2),
                          borderRadius: BorderRadius.circular(18.sp),
                          color: Colors.white.withOpacity(0.8)),
                      child: Row(
                        children: [
                          SizedBox(width: 10.sp),
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
                              decoration: InputDecoration(
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintText: "Search",
                                hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.none),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.sp, horizontal: 8.sp),
                                isDense: true,
                              ),
                              style: TextStyle(
                                fontSize: 18.0.sp,
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
                          )
                        ],
                      ))
                ],
              )),
          SizedBox(height: 10.sp),
          Expanded(
            child: ListView.builder(
              padding:  EdgeInsets.only(right: 0.sp, left: 15.sp, top: 0.sp),
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

Map<String, List<MovieCollection>> groupMoviesByYear(List<MovieCollection> moviesCollection) {
  Map<String, List<MovieCollection>> moviesByYear = {};

  for (var movie in moviesCollection) {
    // Extrae el año de la fecha
    String year = movie.date.substring(0, 4);

    // Si el año no está en el mapa, inicializa una nueva lista para ese año
    if (!moviesByYear.containsKey(year)) {
      moviesByYear[year] = [];
    }

    // Añade la película a la lista del año correspondiente
    moviesByYear[year]!.add(movie);
  }
  return moviesByYear;
}