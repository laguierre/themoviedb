import 'dart:core';
import 'package:flutter/material.dart';
import 'package:themoviedb/models/cast_model.dart';
import 'package:themoviedb/models/details_movie_model.dart';
import 'package:themoviedb/models/tvshow_model.dart';
import 'package:themoviedb/services/themovieapi_services.dart';
import '../models/movie_model.dart';

class MoviesProvider extends ChangeNotifier {
  List<TvShow> _tvShow = [];
  List<Actor> _performers = [];
  int _popularPage = 1;
  int _popularTvShowPage = 1;
  String _duration = 'N/A';

  List<String> _btnNamesText = ['En cine', 'Tv Show'];

  List<String> get btnNamesText => _btnNamesText;

  set btnNamesText(List<String> btnNamesText) {
    _btnNamesText = btnNamesText;
  }

  String _language = 'es-ES';

  String get language => _language;

  set language(String language) {
    _language = language;
    if (_language == 'es-ES') {
      _btnNamesText = ['En cine', 'Tv Show'];
    } else {
      _btnNamesText = ['Cinema', 'Tv Show'];
      ;
    }
    notifyListeners();
  }

  List<Movie> _searchMoviesList = [];

  List<Movie> get searchMoviesList => _searchMoviesList;

  set searchMovies(List<Movie> movies) {
    _searchMoviesList = movies;
    notifyListeners();
  }

  late MovieDetails _movieDetails;

  MovieDetails get movieDetails => _movieDetails;

  set movieDetails(MovieDetails movieDetails) {
    _movieDetails = movieDetails;
    notifyListeners();
  }

  String _releaseDate = 'N/A';

  String get releaseDate => _releaseDate;

  set releaseDate(String releaseDate) {
    _releaseDate = releaseDate;
    notifyListeners();
  }

  String get duration => _duration;

  set duration(String releaseDate) {
    _duration = releaseDate;
    notifyListeners();
  }

  String _query = "";

  String get query => _query;

  set query(String query) {
    _query = query;
    notifyListeners();
  }

  List<Movie> _movies = [];

  List<Movie> get movies => _movies;

  set movies(List<Movie> movies) {
    _movies = movies;
    notifyListeners();
  }

  List<TvShow> get tvShow => _tvShow;

  set tvShow(List<TvShow> tvShow) {
    _tvShow = tvShow;
    notifyListeners();
  }

  set performers(List<Actor> performers) {
    _performers = performers;
    notifyListeners();
  }

  List<Actor> get performers => _performers;

  int get popularPage => _popularPage;

  set popularPage(int popularPage) {
    _popularPage = popularPage;
    notifyListeners();
  }

  int get popularTvShowPage => _popularTvShowPage;

  set popularTvShowPage(int popularTvShowPage) {
    _popularTvShowPage = popularTvShowPage;
    notifyListeners();
  }

  Future<List<Movie>> getNowPlaying() async {
    if (movies.isNotEmpty) {
      return movies;
    }
    var service = TheMovieApiService();
    movies = await service.getNowPlaying(_language);
    //notifyListeners();
    return movies;
  }

  Future<List<Movie>> getPopularMovies() async {
    if (movies.isNotEmpty) {
      return movies;
    }
    var service = TheMovieApiService();
    movies = await service.getPopularMoviesService(_popularPage, _language);
    //notifyListeners();
    return movies;
  }

  Future<List<Movie>> getTvShowPopular() async {

    var service = TheMovieApiService();
    _tvShow = await service.getTvShow(_popularTvShowPage, _language);
    if (_tvShow.isNotEmpty) {
      movies = [];
      for (int i = 0; i < _tvShow.length; i++) {
        Movie buffer = Movie(
            voteCount: 0,
            id: 0,
            video: false,
            voteAverage: 0.0,
            title: "",
            popularity: 0.0,
            posterPath: "",
            originalLanguage: "",
            originalTitle: "",
            genreIds: [],
            backdropPath: "",
            adult: false,
            overview: "",
            releaseDate: "");

        buffer.backdropPath = _tvShow[i].backdropPath!;
        buffer.id = _tvShow[i].id!;
        buffer.title = _tvShow[i].originalName!;
        buffer.originalTitle = _tvShow[i].originalName!;
        buffer.originalLanguage = _tvShow[i].originalLanguage!;
        buffer.overview = _tvShow[i].overview!;
        buffer.voteAverage = _tvShow[i].voteAverage!;
        buffer.posterPath = _tvShow[i].posterPath!;
        buffer.voteCount = _tvShow[i].voteCount!;
        buffer.popularity = _tvShow[i].popularity!;
        buffer.genreIds = _tvShow[i].genreIds!;
        movies.add(buffer);
      }
    }
    notifyListeners();
    return movies;
  }

  Future<List<Movie>> searchMovie() async {
    /*if (movies.isNotEmpty) {
      return _searchMovies;
    }*/
    var service = TheMovieApiService();
    _query = query;
    _searchMoviesList = await service.getSearchMovies(_query, _language);
    return _searchMoviesList;
  }

  void refreshPopularMovies() async {
    var service = TheMovieApiService();
    ++_popularPage;
    movies
        .addAll(await service.getPopularMoviesService(_popularPage, _language));
    notifyListeners();
  }

  void refreshPopularTvShow() async {
    var service = TheMovieApiService();
    ++_popularTvShowPage;

    _tvShow = await service.getTvShow(_popularTvShowPage, _language);

    if (_tvShow.isNotEmpty) {
      for (int i = 0; i < _tvShow.length; i++) {
        Movie buffer = Movie(
            voteCount: 0,
            id: 0,
            video: false,
            voteAverage: 0.0,
            title: "",
            popularity: 0.0,
            posterPath: "",
            originalLanguage: "",
            originalTitle: "",
            genreIds: [],
            backdropPath: "",
            adult: false,
            overview: "",
            releaseDate: "");

        buffer.backdropPath = _tvShow[i].backdropPath!;
        buffer.id = _tvShow[i].id!;
        buffer.title = _tvShow[i].originalName!;
        buffer.originalTitle = _tvShow[i].originalName!;
        buffer.originalLanguage = _tvShow[i].originalLanguage!;
        buffer.overview = _tvShow[i].overview!;
        buffer.voteAverage = _tvShow[i].voteAverage!;
        buffer.posterPath = _tvShow[i].posterPath!;
        buffer.voteCount = _tvShow[i].voteCount!;
        buffer.popularity = _tvShow[i].popularity!;
        buffer.genreIds = _tvShow[i].genreIds!;
        _movies.add(buffer);
      }
    }
    notifyListeners();
  }

  Future<List<Actor>> getCast(String movieId, String type) async {
    var service = TheMovieApiService();
    performers = await service.getCast(movieId, _language, type);
    notifyListeners();
    return performers;
  }

  Future<List<Actor>> getCastTvShow(String movieId, String type) async {
    var service = TheMovieApiService();
    performers = await service.getCast(movieId, _language, type);
    notifyListeners();
    return performers;
  }

  Future<MovieDetails> getDetails(String movieId, String type) async {
    var service = TheMovieApiService();
    _movieDetails = await service.getDetails(movieId, _language, type);
    _releaseDate = _movieDetails.releaseDate!;
    _duration = _movieDetails.getMovieDuration(_movieDetails.runtime!);

    return _movieDetails;
  }

  Future<MovieDetails> getDetailsTvShow(String movieId) async {
    var service = TheMovieApiService();
    _movieDetails = await service.getDetailsTvShow(movieId, _language);
    _releaseDate = _movieDetails.releaseDate!;
    _duration = _movieDetails.getMovieDuration(_movieDetails.runtime!);

    return _movieDetails;
  }

  void clearSearchList() {
    _searchMoviesList = [];
  }

  void clearListMovies() {
    _movies = [];
  }

  void clearPopularPage() {
    _popularPage = 0;
  }

  void tvShow2MovieList() {
    if (_tvShow.isNotEmpty) {
      _movies = [];
      for (int i = 0; i < _tvShow.length; i++) {
        Movie buffer = Movie(
            voteCount: 0,
            id: 0,
            video: false,
            voteAverage: 0.0,
            title: "",
            popularity: 0.0,
            posterPath: "",
            originalLanguage: "",
            originalTitle: "",
            genreIds: [],
            backdropPath: "",
            adult: false,
            overview: "",
            releaseDate: "");

        buffer.backdropPath = _tvShow[i].backdropPath!;
        buffer.id = _tvShow[i].id!;
        buffer.title = _tvShow[i].originalName!;
        buffer.originalTitle = _tvShow[i].originalName!;
        buffer.originalLanguage = _tvShow[i].originalLanguage!;
        buffer.overview = _tvShow[i].overview!;
        buffer.voteAverage = _tvShow[i].voteAverage!;
        buffer.posterPath = _tvShow[i].posterPath!;
        buffer.voteCount = _tvShow[i].voteCount!;
        buffer.popularity = _tvShow[i].popularity!;
        buffer.genreIds = _tvShow[i].genreIds!;
        _movies.add(buffer);
      }
    }
  }
}

class PageViewProvider extends ChangeNotifier {
  int _pageIndex = 0;
  double _pageValue = 0.0;

  int get pageIndex => _pageIndex;

  set pageIndex(int pageIndex) {
    _pageIndex = pageIndex;
    notifyListeners();
  }

  double get pageValue => _pageValue;

  set pageValue(double pageValue) {
    _pageValue = pageValue;
    notifyListeners();
  }
}
