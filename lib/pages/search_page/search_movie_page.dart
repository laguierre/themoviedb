import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/movie_firebase_model.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:themoviedb/pages/details_page/details_page.dart';
import 'package:themoviedb/pages/widgets.dart';
import 'package:themoviedb/providers/collection_provider.dart';
import 'package:themoviedb/providers/movie_provider.dart';

class SearchMoviePage extends StatefulWidget {
  const SearchMoviePage({Key? key}) : super(key: key);

  @override
  State<SearchMoviePage> createState() => _SearchMoviePageState();
}

class _SearchMoviePageState extends State<SearchMoviePage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: kSearchDuration),
    )
      ..addListener(() {
        setState(() {});
      })
      ..forward();
    focusNode.requestFocus(FocusNode());

  }

  @override
  void dispose() {
    animationController.dispose();
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: (1 - animationController.value) * -150,
            child: CustomSearch(
              onTapSearch: () {
                searchMovies(context, textController.text, moviesProvider);
              },
              onTapBack: () {
                moviesProvider.query = "";
                FocusScope.of(context).unfocus();
                animationController.reverse();
                Navigator.pop(context);
              },
              enabled: true,
              focusNode: focusNode,
              textController: textController,
              onFieldSubmitted: (String value) {
                searchMovies(context, value, moviesProvider);
              },
            ),
          ),
          Positioned(
            top: 100.sp,
            bottom: 0,
            left: 0,
            right: 0,
            child: _FavoriteMoviesSearched(moviesProvider: moviesProvider),
          )
        ],
      ),
    );
  }

  void searchMovies(BuildContext context, String value, MoviesProvider moviesProvider) {
    Provider.of<MoviesProvider>(context, listen: false).query =
        value;
    moviesProvider.searchMovie();
  }
}


class _FavoriteMoviesSearched extends StatelessWidget {
  const _FavoriteMoviesSearched({
    required this.moviesProvider,
  });

  final MoviesProvider moviesProvider;

  @override
  Widget build(BuildContext context) {
    List<MovieCollection> moviesCollection =
        Provider.of<MyCollectionProvider>(context, listen: false)
            .movieCollection;

    return ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 0),
        physics: const BouncingScrollPhysics(),
        itemCount: moviesProvider.searchMoviesList.length,
        itemBuilder: (_, i) {
          double myRating = -1;
          var movie = moviesProvider.searchMoviesList[i];
          bool wasSeen = moviesCollection.any((movieCollection) {
            return movieCollection.id == movie.id;
          });

          wasSeen ? myRating = 10 : myRating = -1;
          return SearchCard(movie: movie, type: 'movie', myRating: myRating);
        });
  }
}

class SearchCard extends StatelessWidget {
  const SearchCard({
    Key? key,
    required this.movie,
    this.myRating = -1,
    required this.type,
  }) : super(key: key);
  final Movie movie;
  final double myRating;
  final String type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: DetailsPage(movie: movie, type: type),
                  childCurrent: this));
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.sp),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.sp),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                        const Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(3.sp),
                  height: 120.sp,
                  width: 80.sp,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PosterImage(
                      image: movie.getPosterImg(),
                    ),
                  ),
                ),
                SizedBox(width: 15.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.sp),
                      Text(
                        movie.originalTitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.sp),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellowAccent,
                            size: 16.sp,
                          ),
                          SizedBox(width: 5.sp),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            overflow: TextOverflow.ellipsis,
                            style:
                            TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                          SizedBox(width: 15.sp),
                        ],
                      ),
                      SizedBox(height: 8.sp),
                      Text(
                        movie.releaseDate,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (myRating > 1 && myRating != 10)
                      Text(emojis[myRating.toInt() - 1],
                          style: TextStyle(fontSize: 20.sp)),
                    if (myRating == 10)
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.yellow,
                        size: 28.sp,
                      ),
                    SizedBox(height: 5.sp),
                    if (type != '')
                      Text(type.toUpperCase(),
                          style: TextStyle(
                              color: kTextDetailsColor, fontSize: 11.sp)),
                  ],
                ),
                SizedBox(width: 15.sp)
              ],
            )));
  }
}

class CustomSearch extends StatelessWidget {
  const CustomSearch({
    Key? key,
    required this.enabled,
    required this.onTapBack,
    required this.focusNode,
    required this.textController,
    required this.onTapSearch,
    required this.onFieldSubmitted,
  }) : super(key: key);

  final bool enabled;
  final VoidCallback onTapBack;
  final VoidCallback onTapSearch;
  final FocusNode focusNode;
  final TextEditingController textController;
  final ValueChanged<String> onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 38.sp,
      margin: EdgeInsets.fromLTRB(20.sp, 40.sp, 20.sp, 0),
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.sp),
        color: Colors.white.withOpacity(0.8),
      ),
      child: Row(
        children: [
          if (enabled)
            IconButton(
              color: Colors.black,
              padding: const EdgeInsets.all(0),
              onPressed: onTapBack,
              icon: Icon(Icons.arrow_back_ios, size: 16.sp),
            ),
          Expanded(
            child: TextFormField(
              //focusNode: focusNode,
              controller: textController,
              enabled: enabled,
              keyboardType: TextInputType.text,
              //onFieldSubmitted: onFieldSubmitted,
              decoration:  InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 6.sp),
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 16.0.sp,
                decoration: TextDecoration.none,
                color: Colors.black,
              ),
              // onTap: () {
              //   // Solicitar el foco cuando se toque el campo de texto
              //   focusNode.requestFocus();
              // },
            ),
          ),
          IconButton(
            color: Colors.black,
            padding: const EdgeInsets.all(0),
            onPressed: onTapSearch,
            icon: Icon(Icons.search, size: 24.sp),
          ),
        ],
      ),
    );
  }
}
