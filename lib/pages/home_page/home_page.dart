import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/api_key.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/movie_firebase_model.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:themoviedb/pages/personal_collection_page/personal_collection_page.dart';
import 'package:themoviedb/pages/search_page/search_movie_page.dart';
import 'package:themoviedb/pages/widgets.dart';
import 'package:themoviedb/providers/collection_provider.dart';
import 'package:themoviedb/providers/movie_provider.dart';
import 'package:themoviedb/providers/top_button_provider.dart';
import 'package:themoviedb/services/firebase_services.dart';
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
    super.initState();
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
    authFirebase(dbEmail, dbPass);
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
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: StreamBuilder<List<MovieCollection>>(
        stream: readMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Provider.of<MyCollectionProvider>(context).movieCollection =
                snapshot.requireData;
          }
          return FutureBuilder(
            future: moviesProvider.getPopularMovies(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
              if (snapshot.hasData) {
                final movies = snapshot.data;
                return Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.topCenter,
                  children: [
                    BackgroundImage(
                        backgroundPageController: backgroundPageController,
                        pageValue: pageValue,
                        movies: movies!),
                    const BackgroundColor(),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 0),
                          height: 45.h,
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.video_collection_rounded,
                                    color: Colors.white,
                                    size: 35.h,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child:
                                                  const MyPersonalCollection(),
                                            ))
                                        .then((_) =>
                                            animationController.forward());
                                  }),
                              SizedBox(width: 10.h),
                              IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 35.h,
                                  ),
                                  onPressed: () {
                                    moviesProvider.clearSearchList();
                                    Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.fade,
                                              child: const SearchMoviePage(),
                                            ))
                                        .then((_) =>
                                            animationController.forward());
                                  }),
                              const Spacer(),
                              Container(
                                  decoration: BoxDecoration(
                                      border: language == 'es-ES'
                                          ? Border.all(
                                              color: Colors.white, width: 2.sp)
                                          : Border.all(
                                              color: Colors.transparent,
                                              width: 2.sp),
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                      onPressed: () {
                                        Provider.of<MoviesProvider>(context,
                                                listen: false)
                                            .language = 'es-ES';
                                        refreshCards(number, moviesProvider);
                                        animateToStart();
                                      },
                                      icon: Image.asset(
                                          'lib/assets/images/esp.png'))),
                              SizedBox(width: 8.w),
                              Container(
                                  decoration: BoxDecoration(
                                      border: language != 'es-ES'
                                          ? Border.all(
                                              color: Colors.white, width: 2.sp)
                                          : Border.all(
                                              color: Colors.transparent,
                                              width: 2.sp),
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                      onPressed: () {
                                        Provider.of<MoviesProvider>(context,
                                                listen: false)
                                            .language = 'en-EN';
                                        refreshCards(number, moviesProvider);
                                      },
                                      icon: Image.asset(
                                          'lib/assets/images/uk.png'))),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 0.sp),
                          height: 35.sp,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: Provider.of<MoviesProvider>(context)
                                  .btnNamesText
                                  .length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 20.w),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        side: number == i
                                            ? BorderSide(
                                            width: 2.sp,
                                            color: Colors.white)
                                            : BorderSide(
                                            width: 2.sp,
                                            color: Colors.white),
                                        shadowColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0.sp),
                                        ),
                                        backgroundColor: number == i
                                            ? Colors.white
                                            : Colors.transparent,
                                        padding: EdgeInsets.symmetric(horizontal: 30.sp)),
                                    child: Text(
                                      Provider.of<MoviesProvider>(context, listen: false).btnNamesText[i],
                                      style: TextStyle(
                                          color: number == i ? Colors.black : Colors.white,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      Provider.of<MoviesProvider>(context, listen: false).popularPage = 1;
                                      Provider.of<TopButtonModel>(context, listen: false).number = i;
                                      refreshCards(i, moviesProvider);
                                      animateToStart();
                                    },
                                  )
                                  ,
                                );
                              }),
                        ),
                        SizedBox(height: 70.h),
                        Expanded(
                          child: MovieListCards(
                              pageController: pageController,
                              movies: movies,
                              pageValue: pageValue),
                        )
                      ],
                    ),
                  ],
                );
              } else {
                return const CustomGIF();
              }
            },
          );
        },
      ),
    );
  }

  void animateToStart() {
    setState(() {
      pageController.animateToPage(0,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    });
  }

  void refreshCards(int number, MoviesProvider moviesProvider) {
    String type = '';
    if (number == 0) {
      type = 'movie';
      moviesProvider.clearListMovies();
      moviesProvider.getPopularMovies();
    } else {
      type = 'tv';
      moviesProvider.getTvShowPopular();
    }
    Provider.of<TopButtonModel>(context, listen: false).type = type;
    Provider.of<MoviesProvider>(context, listen: false).type = type;
  }
}
