import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:themoviedb/pages/details_page/details_page.dart';
import 'package:themoviedb/pages/widgets.dart';
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
      extendBody: true,
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
                  moviesProvider.searchMovies = [];
                  moviesProvider.searchMovie();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                onTapBack: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await animationController.reverse();
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
              child: FutureBuilder(
                  future: moviesProvider.searchMovie(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Movie>> snapshot) {
                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        physics: const BouncingScrollPhysics(),
                        itemCount: moviesProvider.searchMoviesList.length,
                        itemBuilder: (context, index) {
                          var movie = moviesProvider.searchMoviesList[index];
                          return SearchCard(movie: movie);
                        });
                  }))
        ],
      ),
    );
  }
}

class SearchCard extends StatelessWidget {
  const SearchCard({Key? key, required this.movie}) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.bottomToTop,
              child: DetailsPage(movie: movie),
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
                Text(
                  movie.originalTitle,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellowAccent),
                    const SizedBox(width: 5),
                    Text(
                      movie.voteAverage.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Release date: ${movie.releaseDate.substring(0,7)}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
