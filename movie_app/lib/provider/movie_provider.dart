import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:http/http.dart';

class MovieProvider extends ChangeNotifier {
  MovieModel? movieModel;

  bool get hasDataLoaded => movieModel != null;

  getMovieData() async {
    // String url link ta ke Uri te convert korlam
    print("link ta ke Uri te convert korlam");
    final uri = Uri.parse("https://yts.mx/api/v2/list_movies.json");
    try {
      // json data get korlam uri theke
      final response = await get(uri);
      // json data decode kore map pelam
      final map = jsonDecode(response.body);
      if (response.statusCode == 200) {
        movieModel = MovieModel.fromJson(map);
        // temp er data console asle bujbo data aseche
        print(movieModel!.data!.movies!.length);
        // weather jehetu change hoi tai notifyListener kore dilam
        notifyListeners();
      } else {
        print(map["message"]);
      }
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }
}
