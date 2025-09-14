import 'package:flutter/material.dart';
import 'package:tmdb_api_demo/tmdb_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'TMDB Popular Movies', theme: ThemeData.dark(), home: const MovieListScreen());
  }
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final TMDBService _tmdbService = TMDBService();
  late Future<List<dynamic>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = _tmdbService.getTopRatedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Top Rated Movies")),
      body: FutureBuilder<List<dynamic>>(
        future: _movies,
        builder: (context, snapshot) {
          // 🔹 Show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 🔹 Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text("Failed to load movies.\n${snapshot.error}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _movies = _tmdbService.getTopRatedMovies();
                      });
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // 🔹 Handle empty data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No movies found.", style: TextStyle(fontSize: 18)));
          }

          // 🔹 Show movie list
          final movies = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _movies = _tmdbService.getTopRatedMovies();
              });
            },
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final posterUrl = "https://image.tmdb.org/t/p/w200${movie['poster_path']}";
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: movie['poster_path'] != null
                        ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(posterUrl, width: 50))
                        : const Icon(Icons.movie, size: 40),
                    title: Text(movie['title']),
                    subtitle: Text("⭐ ${movie['vote_average']}"),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
