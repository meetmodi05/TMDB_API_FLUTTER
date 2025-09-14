import 'dart:convert';

import 'package:http/http.dart' as http;

class TMDBService {
  final String APIKEY = "1d4f1ebc80737f7c5cb49efca64e6e3d";
  final String BAE_URL = "https://api.themoviedb.org/3";
  final String bearerToken =
      "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZDRmMWViYzgwNzM3ZjdjNWNiNDllZmNhNjRlNmUzZCIsIm5iZiI6MTY4MjQ5OTkyNC40NTksInN1YiI6IjY0NDhlOTU0MmZkZWM2MDRlNGEwZWRmYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.KqEGOy_jB17wjpUk-Fb8-O0GXjcjG9KQw5dwoisxNdc";

  Future<List<dynamic>> getTopRatedMovies() async {
    final url = Uri.parse("$BAE_URL/movie/top_rated?api_key=$APIKEY&language=en-US&page=1");
    final response = await http.get(url, headers: {"Authorization": "Bearer $bearerToken", "accept": "application/json"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception("Failed to load movies ${response.statusCode}");
    }
  }
}

class TMDBServices {
  // 🔑 Replace with your actual Bearer token from TMDB API
  final String bearerToken = "YOUR_BEARER_TOKEN_HERE";

  final String baseUrl = "https://api.themoviedb.org/3";

  // Fetch Top Rated Movies (using Bearer Authorization)
  Future<List<dynamic>> getTopRatedMovies() async {
    final url = Uri.parse(
      "$baseUrl/discover/movie"
      "?include_adult=false"
      "&include_video=false"
      "&language=en-US"
      "&page=1"
      "&sort_by=vote_average.desc"
      "&without_genres=99,10755"
      "&vote_count.gte=200",
    );

    final response = await http.get(url, headers: {"Authorization": "Bearer $bearerToken", "accept": "application/json"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception("Failed to load movies: ${response.statusCode}");
    }
  }
}
