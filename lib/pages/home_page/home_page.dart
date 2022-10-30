import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:themoviedb/pages/search_page/search_movie_page.dart';
import 'package:themoviedb/pages/widgets.dart';
import 'package:themoviedb/providers/movie_provider.dart';
import 'package:themoviedb/providers/top_button_provider.dart';
import 'home_page_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late PageController pageController, backgroundPageController;
  late AnimationController animationController;
  late Animation animation;

  int currentPage = 0, backgroundPage = 0;
  double pageValue = 0;
  late bool trigger;

  @override
  void initState() {
    pageController = PageController(
        initialPage: currentPage, viewportFraction: kViewportFraction)
      ..addListener(pageAddListener);
    backgroundPageController = PageController(initialPage: 0)
      ..addListener(() {
        setState(() {});
      });
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: kSearchDuration),
    )
      ..addListener(animationAddListener)
      ..forward();
    super.initState();
  }

  void animationAddListener() {
    setState(() {});
  }

  void pageAddListener() {
    setState(() {
      pageValue = pageController.page!;
      Provider.of<PageViewProvider>(context, listen: false).pageValue =
          pageValue;
      if (pageController.position.pixels >=
          pageController.position.maxScrollExtent) {
        if (Provider.of<TopButtonModel>(context, listen: false).number == 0) {
          Provider.of<MoviesProvider>(context, listen: false)
              .refreshPopularMovies();
        } else {
          Provider.of<MoviesProvider>(context, listen: false)
              .refreshPopularTvShow();
        }
      }
      backgroundPageController.jumpTo(pageController.offset / 0.8);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    pageController.dispose();
    backgroundPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    int number = Provider.of<TopButtonModel>(context).number;
    String language = Provider.of<MoviesProvider>(context).language;
    String languageSearch = language == 'es-ES' ? "En cine" : "Now Playing";
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: moviesProvider.getPopularMovies(),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data;
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                BackgroundImage(
                    backgroundPageController: backgroundPageController,
                    pageValue: pageValue,
                    movies: movies!),
                const BackgroundColor(),
                MovieListCards(
                    pageController: pageController,
                    movies: movies,
                    pageValue: pageValue),
                Positioned(
                    right: 20,
                    left: 20,
                    top: 40,
                    child: Row(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ).copyWith(
                                elevation:
                                    MaterialStateProperty.all<double>(0)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: const SearchMoviePage(),
                                  )).then((_) => animationController.forward());
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search,
                                  size: 34,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  languageSearch,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ],
                            )),
                        const Spacer(),
                        Container(
                            decoration: BoxDecoration(
                                border: language == 'es-ES'
                                    ? Border.all(color: Colors.white, width: 2)
                                    : Border.all(
                                        color: Colors.transparent, width: 2),
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  Provider.of<MoviesProvider>(context,
                                          listen: false)
                                      .language = 'es-ES';
                                  refreshCards(number, moviesProvider);

                                  /*pageController.animateToPage(0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.linear);*/
                                },
                                icon:
                                    Image.asset('lib/assets/images/esp.png'))),
                        Container(
                            decoration: BoxDecoration(
                                border: language != 'es-ES'
                                    ? Border.all(color: Colors.white, width: 2)
                                    : Border.all(
                                        color: Colors.transparent, width: 2),
                                shape: BoxShape.circle),
                            child: IconButton(
                                onPressed: () {
                                  Provider.of<MoviesProvider>(context,
                                          listen: false)
                                      .language = 'en-EN';
                                  refreshCards(number, moviesProvider);
                                },
                                icon: Image.asset('lib/assets/images/uk.png'))),
                      ],
                    )),
                Positioned(
                    right: 20,
                    left: 20,
                    top: 120,
                    height: 40,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: Provider.of<MoviesProvider>(context)
                            .btnNamesText
                            .length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    side: number == i
                                        ? const BorderSide(
                                            width: 2, color: Colors.white)
                                        : const BorderSide(
                                            width: 2, color: Colors.white),
                                    shadowColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    backgroundColor: number == i
                                        ? Colors.white
                                        : Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25)),
                                child: Text(
                                  Provider.of<MoviesProvider>(context,
                                          listen: false)
                                      .btnNamesText[i],
                                  style: TextStyle(
                                      color: number == i
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Provider.of<TopButtonModel>(context,
                                          listen: false)
                                      .number = i;
                                  refreshCards(i, moviesProvider);
                                  animateToStart();
                                }),
                          );
                        }))
              ],
            );
          } else {
            return const CustomGIF();
          }
        },
      ),
    );
  }

  void animateToStart() {
    setState(() {
      pageController.animateToPage(0,
          duration:
              const Duration(milliseconds: 500),
          curve: Curves.linear);
    });
  }

  void refreshCards(int number, MoviesProvider moviesProvider) {
    if (number == 0) {
      Provider.of<TopButtonModel>(context, listen: false).type = 'movie';
      moviesProvider.clearListMovies();
      moviesProvider.getPopularMovies();
    } else {
      Provider.of<TopButtonModel>(context, listen: false).type = 'tv';
      moviesProvider.getTvShowPopular();
    }
  }
}
