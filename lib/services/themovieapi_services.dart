import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:themoviedb/constants.dart';
import 'package:themoviedb/models/cast_model.dart';
import 'package:themoviedb/models/details_movie_model.dart';
import 'package:themoviedb/models/details_tvshow_model.dart';
import 'package:themoviedb/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'package:themoviedb/models/tvshow_model.dart';

class TheMovieApiService {
  Future<List<Movie>> getPopularMoviesService(
      int popularPage, String language) async {
    final url = Uri.http(urlTheMovieDB, '3/movie/popular', {
      'api_key': apiKey,
      'language': language,
      'page': popularPage.toString(),
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = await json.decode(response.body);
      List<Movie> movieList = [];
      for (var movie in decoded['results']) {
        movieList.add(Movie.fromJsonMap(movie));
      }
      return movieList;
    }
    return [];
  }

  Future<List<Movie>> getNowPlaying(String language) async {
    final url = Uri.http(urlTheMovieDB, '3/movie/now_playing', {
      'api_key': apiKey,
      'language': language,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = await json.decode(response.body);
      List<Movie> movieList = [];
      for (var movie in decoded['results']) {
        movieList.add(Movie.fromJsonMap(movie));
      }
      return movieList;
    }
    return [];
  }

  Future<List<TvShow>> getTvShow(int popularTvShowPage, String language) async {
    final url = Uri.http(urlTheMovieDB, '3/tv/popular', {
      'api_key': apiKey,
      'language': language,
      'page': popularTvShowPage.toString()
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = await json.decode(response.body);
      List<TvShow> movieList = [];
      for (var movie in decoded['results']) {
        movieList.add(TvShow.fromJsonMap(movie));
      }
      return movieList;
    }
    return [];
  }

  ///3/movie/$movieId/credits
  Future<List<Actor>> getCast(
      String movieId, String language, String type) async {
    final url = Uri.https(urlTheMovieDB, '3/$type/$movieId/credits', {
      'api_key': apiKey,
      'language': language,
    });
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    return Cast.fromJsonList(decodedData['cast']).performer;
  }

  Future<List<Actor>> getCastTvShow(String movieId, String language) async {
    final url = Uri.https(urlTheMovieDB, '3/tv/$movieId/credits', {
      'api_key': apiKey,
      'language': language,
    });
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    return Cast.fromJsonList(decodedData['cast']).performer;
  }

  Future<MovieDetails> getDetails(
      String movieId, String language, String type) async {
    final url = Uri.https(urlTheMovieDB, '3/$type/$movieId', {
      'api_key': apiKey,
      'language': language,
      'page': '1',
    });
    final response = await http.get(url);
    //print(url);
    final decodedData = json.decode(response.body);
    if (type == 'movie') {
      return MovieDetails.fromJson(decodedData);
    } else {

      var tvShow = TvShowDetails.fromJson(decodedData);
      var movieDetails = MovieDetails();

      movieDetails.adult = tvShow.adult;
      movieDetails.backdropPath = tvShow.backdropPath;
      movieDetails.budget = 0;
      movieDetails.homepage = tvShow.homepage;
      movieDetails.id = tvShow.id;
      movieDetails.imdbId = '0';
      movieDetails.originalLanguage = tvShow.originalLanguage;
      movieDetails.originalTitle = tvShow.originalName;
      movieDetails.overview = tvShow.overview;
      movieDetails.popularity = tvShow.popularity;
      movieDetails.posterPath = tvShow.posterPath;
      movieDetails.productionCountries = tvShow.productionCountries;
      movieDetails.productionCompanies = tvShow.productionCompanies;
       movieDetails.genres = tvShow.genres;
      movieDetails.spokenLanguages = tvShow.spokenLanguages;
      movieDetails.releaseDate = tvShow.firstAirDate;
      movieDetails.revenue = 0;
      movieDetails.runtime = tvShow.episodeRunTime!.isNotEmpty? tvShow.episodeRunTime![0] : 0;
      movieDetails.status = tvShow.status;
      movieDetails.tagline = tvShow.tagline;
      movieDetails.title = tvShow.name;
      movieDetails.video = false;
      movieDetails.voteAverage = tvShow.voteAverage;
      movieDetails.voteCount = tvShow.voteCount;

      //print(decodedData);
      return movieDetails; //movieDetails;
    }

    //print(decodedData);
    /*if(type == 'tv'){
      final url = Uri.https(urlTheMovieDB, '3/tv/$movieId',
          {'api_key': apiKey, 'language': language, 'page': '1'});
      final resp = await http.get(url);
      final decodedData = json.decode(resp.body);
      var tvShowDetails = TvShowDetails.fromJson(decodedData);
      movieDetails.releaseDate = tvShowDetails.firstAirDate;
      //movieDetails.runtime = tvShowDetails.episodeRunTime![0];
    }*/
  }

  Future<MovieDetails> getDetailsTvShow(String movieId, String language) async {
    final url = Uri.https(urlTheMovieDB, '3/tv/$movieId',
        {'api_key': apiKey, 'language': language, 'page': '1'});
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    return MovieDetails.fromJson(decodedData);
  }

  Future<List<Movie>> getSearchMovies(String query, String language) async {
    List<Movie> movieList = [];
    final url = Uri.https(urlTheMovieDB, '3/search/movie', {
      'api_key': apiKey,
      'language': language,
      'query': query,
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = await json.decode(response.body);
      for (var movie in decoded['results']) {
        movieList.add(Movie.fromJsonMap(movie));
      }
    }
    return movieList;
  }
}
