import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:themoviedb/pages/details_page/details_page.dart';
import 'package:themoviedb/pages/widgets.dart';
import 'package:themoviedb/providers/movie_provider.dart';
import 'package:themoviedb/responsive.dart';

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
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: kSearchDuration),
    )
      ..addListener(() {
        setState(() {});
      })
      ..forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
      //extendBody: true,
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: (1 - animationController.value) * -150,
              child: CustomSearch(
                onTapSearch: () {
                  Provider.of<MoviesProvider>(context, listen: false).query =
                      textController.text;
                  moviesProvider.searchMovie();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                onTapBack: () {
                  moviesProvider.query = "";
                  FocusScope.of(context).requestFocus(FocusNode());
                  animationController.reverse();
                  Navigator.pop(context);
                },
                enabled: true,
                focusNode: focusNode,
                textController: textController,
              )),
          Positioned(
            top: 150,
            bottom: 0,
            left: 0,
            right: 0,
            child: _FavoriteMoviesSearched(moviesProvider: moviesProvider),
          )
        ],
      ),
    );
  }
}

class _FavoriteMoviesSearched extends StatelessWidget {
  const _FavoriteMoviesSearched({
    required this.moviesProvider,
  });

  final MoviesProvider moviesProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        physics: const BouncingScrollPhysics(),
        itemCount: moviesProvider.searchMoviesList.length,
        itemBuilder: (_, i) {
          var movie = moviesProvider.searchMoviesList[i];
          return SearchCard(movie: movie, type: 'movie');
        });
  }
}

class SearchCard extends StatelessWidget {
  const SearchCard(
      {Key? key, required this.movie, this.myRating = -1, required this.type})
      : super(key: key);
  final Movie movie;
  final double myRating;
  final String type;

  @override
  Widget build(BuildContext context) {
    bool isTablet = SizeScreen.isTablet(context);
    double scale =
        isTablet ? kSizePosterCoefficientTablet : kSizePosterCoefficientPhone;
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
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                height: 150,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: PosterImage(
                    image: movie.getPosterImg(),
                    scale: scale,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      movie.title,
                      minFontSize: 16,
                      stepGranularity: 4,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    AutoSizeText(
                      minFontSize: 8,
                      stepGranularity: 4,
                      movie.originalTitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellowAccent),
                        const SizedBox(width: 5),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.releaseDate,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (myRating > 1)
                    Text(emojis[myRating.toInt() - 1],
                        style: const TextStyle(fontSize: 35)),
                  const SizedBox(height: 10),
                  if (type != '')
                    Text(type.toUpperCase(),
                        style:
                            TextStyle(color: kTextDetailsColor, fontSize: 15)),
                ],
              ),
              const SizedBox(width: 20)
            ],
          ),
        ));
  }
}
