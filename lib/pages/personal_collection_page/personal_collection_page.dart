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
  List<MovieCollection> filteredCollection = [];
  String selectedYear = 'Todas';
  bool isLoading = true;
  bool showMovies = false;
  bool showSeries = false;
  int qtyMovie = 0;
  int qtySeries = 0;
  int filteredQtyMovie = 0;
  int filteredQtySeries = 0;
  Map<String, List<MovieCollection>> groupedMovies = {};
  List<String> availableYears = [];
  Map<String, dynamic> moviesMap = {};
  Map<String, dynamic> seriesMap = {};

  @override
  void initState() {
    super.initState();
    try {
      final collectionProvider =
          Provider.of<MyCollectionProvider>(context, listen: false);
      final collection = collectionProvider.movieCollection;
      setState(() {
        filteredCollection = moviesCollection = collection;
        availableYears = getAvailableYears(collection);
        qtyMovie = collection.where((movie) => movie.type == 'movie').length;
        qtySeries = collection.where((movie) => movie.type == 'tv').length;
        isLoading = false;
      });
      updateCountsAndGroups();
      moviesMap = generateMoviesMap(filteredCollection);
      seriesMap = generateSeriesMap(filteredCollection);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> generateMoviesMap(List<MovieCollection> collection) {
    Map<String, dynamic> moviesMap = {'total': 0};

    collection.where((movie) => movie.type == 'movie').forEach((movie) {
      String year = movie.date.substring(0, 4);
      if (!moviesMap.containsKey(year)) {
        moviesMap[year] = 0;
      }
      moviesMap['total']++;
      moviesMap[year]++;
    });

    return moviesMap;
  }

  Map<String, dynamic> generateSeriesMap(List<MovieCollection> collection) {
    Map<String, dynamic> seriesMap = {'total': 0};

    collection.where((series) => series.type == 'tv').forEach((series) {
      String year = series.date.substring(0, 4);
      if (!seriesMap.containsKey(year)) {
        seriesMap[year] = 0;
      }
      seriesMap['total']++;
      seriesMap[year]++;
    });

    return seriesMap;
  }

  void filterMoviesByYear(String year) {
    setState(() {
      selectedYear = year;
      filterMoviesByType();
    });
  }

  void updateCountsAndGroups() {
    if (showMovies) {
      filteredQtyMovie =
          filteredCollection.where((movie) => movie.type == 'movie').length;
      filteredQtySeries =
          filteredCollection.where((movie) => movie.type == 'tv').length;
    } else if (showSeries) {
      filteredQtySeries =
          filteredCollection.where((movie) => movie.type == 'tv').length;
      filteredQtyMovie =
          filteredCollection.where((movie) => movie.type == 'movie').length;
    }
    groupedMovies = groupMoviesByYear(filteredCollection);
  }

  List<String> getAvailableYears(List<MovieCollection> collection) {
    return collection
        .map((movie) => movie.date.substring(0, 4))
        .toSet()
        .toList();
  }

  void filterMoviesByType() {
    setState(() {
      filteredCollection = moviesCollection.where((movie) {
        bool matchType = (showMovies && movie.type == 'movie') ||
            (showSeries && movie.type == 'tv');
        bool matchYear =
            selectedYear == 'Todas' || movie.date.startsWith(selectedYear);
        return matchType && matchYear;
      }).toList();

      updateCountsAndGroups();
    });
  }

  Map<String, List<MovieCollection>> groupMoviesByYear(
      List<MovieCollection> moviesCollection) {
    Map<String, List<MovieCollection>> moviesByYear = {};

    for (var movie in moviesCollection) {
      if (movie.date.length >= 4) {
        String year = movie.date.substring(0, 4);
        if (!moviesByYear.containsKey(year)) {
          moviesByYear[year] = [];
        }
        moviesByYear[year]!.add(movie);
      }
    }
    return moviesByYear;
  }

  void filterMoviesBySearch(String query) {
    setState(() {
      filteredCollection = moviesCollection
          .where((movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      updateCountsAndGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    String language = Provider.of<MoviesProvider>(context).language;
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      extendBody: true,
      body: isLoading
          ? const CustomGIF()
          : Column(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(10.sp, 30.sp, 10.sp, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 35.h,
                          child: Row(

                            children: [
                              const CustomBackButton(),
                              SizedBox(width: 15.sp),
                              Text(
                                language == 'es-ES'
                                    ? 'Mis películas'
                                    : 'My Personal Collection',
                                style: TextStyle(
                                    color: kTextDetailsColor, fontSize: 24.sp),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20.sp),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: FilterButton(
                                isMovie: true,
                                label: language == 'es-ES'
                                    ? 'Películas'
                                    : 'Movies',
                                count: qtyMovie,
                                isSelected: showMovies,
                                onTap: () {
                                  setState(() {
                                    showMovies = true;
                                    showSeries = !showMovies;
                                    filterMoviesByType();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 10.sp),
                            Flexible(
                                child: FilterButton(
                                  isMovie: false,
                              label: 'Series',
                              count: qtySeries,
                              isSelected: showSeries,
                              onTap: () {
                                setState(() {
                                  showMovies = false;
                                  showSeries = !showMovies;
                                  filterMoviesByType();
                                });
                              },
                            )),
                          ],
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
                              itemCount: availableYears.length + 1,
                              itemBuilder: (context, index) {
                                String year;
                                bool isSelected;
                                int count;

                                if (index == 0) {
                                  year = 'Todas';
                                  isSelected = selectedYear == 'Todas';
                                  count = moviesCollection.length;
                                } else {
                                  year = availableYears[index - 1];
                                  isSelected = selectedYear == year;
                                  if (showMovies) {
                                    count = moviesMap[year] ?? 0;
                                  } else {
                                    count = seriesMap[year] ?? 0;
                                  }
                                }

                                return Padding(
                                  padding: EdgeInsets.only(right: 10.sp),
                                  child: Material(
                                    elevation: 5.0,
                                    borderRadius:
                                        BorderRadius.circular(18.0.sp),
                                    shadowColor: Colors.black.withOpacity(0.2),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: isSelected
                                            ? kSearchColorButton
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0.sp),
                                        ),
                                        backgroundColor: isSelected
                                            ? Colors.white
                                            : kSearchColorButton,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.sp),
                                        side: BorderSide.none,
                                      ),
                                      child: Text(
                                        year == 'Todas'
                                            ? 'Todas'
                                            : '$year ($count)',
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      onPressed: () {
                                        filterMoviesByYear(year);
                                      },
                                    )
                                  )
                                );
                              },
                            )),
                        Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            height: 38.sp,
                            margin: EdgeInsets.fromLTRB(0, 0.sp, 0, 5.sp),
                            padding: EdgeInsets.symmetric(horizontal: 5.sp),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.sp),
                                color: Colors.white.withOpacity(0.8)),
                            child: Row(
                              children: [
                                SizedBox(width: 10.sp),
                                Icon(Icons.search,
                                    color: kSearchColorTextField, size: 18.sp),
                                Expanded(
                                    child: TextField(
                                        onChanged: (text) {
                                          filterMoviesBySearch(text);
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
                                          fontSize: 16.0.sp,
                                          decoration: TextDecoration.none,
                                          color: kSearchColorTextField,
                                        ))),
                                IconButton(
                                  color: kSearchColorTextField,
                                  padding: const EdgeInsets.all(0),
                                  icon: Icon(Icons.close, size: 20.sp),
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    textEditingController.text = "";
                                    filterMoviesBySearch("");
                                  },
                                )
                              ],
                            ))
                      ],
                    )),
                SizedBox(height: 10.sp),
                Expanded(
                    child: ListView.builder(
                  padding: EdgeInsets.only(right: 0.sp, left: 15.sp, top: 0.sp),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredCollection.length,
                  itemBuilder: (BuildContext context, int index) {
                    double myRating = filteredCollection[index].rating;
                    moviesProvider
                        .searchMovieById(filteredCollection[index].id);
                    String type = filteredCollection[index].type;

                    return FutureBuilder(
                      future: type == 'movie'
                          ? moviesProvider
                              .searchMovieById(filteredCollection[index].id)
                          : moviesProvider
                              .searchTvShowById(filteredCollection[index].id),
                      builder: (BuildContext context,
                          AsyncSnapshot<MovieDetails> snapshot) {
                        var movie = snapshot.data;
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CustomGIF();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Text('No data available');
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
                            releaseDate: movie.releaseDate ?? '',
                        mediaType: type);

                        return Slidable(
                            endActionPane: ActionPane(
                              extentRatio: 0.30,
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                    backgroundColor: const Color(0xFF0D0D0D),
                                    foregroundColor: Colors.red,
                                    icon: Icons.delete_forever,
                                    label: language == 'es-ES'
                                        ? 'Borrar'
                                        : 'Delete',
                                    onPressed: (context) {
                                      deleteMovie(movie.id.toString());
                                      Provider.of<MyCollectionProvider>(context,
                                              listen: false)
                                          .movieCollection
                                          .removeAt(index);
                                      moviesCollection =
                                          Provider.of<MyCollectionProvider>(
                                                  context,
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
                            ));
                      },
                    );
                  },
                ))
              ],
            ),
    );
  }
}
