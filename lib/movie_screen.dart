import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/tennis_screen.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final List<Movie> movieList = [];

  @override
  void initState() {
    super.initState();
    //_getMovieList();
  }

  void _getMovieList() {
    _firebaseFirestore.collection("movies").get().then((value) {
      movieList.clear();
      for (QueryDocumentSnapshot doc in value.docs) {
        movieList.add(
          Movie.fromJson(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ),
        );
      }
      log("movieList: ${movieList[0].name}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie App"),
      ),
      body: StreamBuilder(
          stream: _firebaseFirestore.collection("movies").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            movieList.clear();
            for (QueryDocumentSnapshot doc in (snapshot.data?.docs ?? [])) {
              movieList.add(
                  Movie.fromJson(doc.id, doc.data() as Map<String, dynamic>));
            }
            for (Movie movie in movieList) {
              log('List: ${movie.name}');
            }

            return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(movieList[index].name),
                  subtitle: Text(movieList[index].language),
                  leading: Text(movieList[index].rating),
                  trailing: Text(movieList[index].year),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: movieList.length,
            );
          }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            onPressed: () {
              Map<String, dynamic> newMovie = {
                "name": "Shathi",
                "language": "English, Hindi, Bangla",
                "year": "2008",
                "rating": "3.5"
              };

              _firebaseFirestore
                  .collection("movies")
                  .doc("movie-1")
                  .set(newMovie);
            },
            child: const Text("Add"),
          ),
          const SizedBox(height: 24),
          FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            onPressed: () {
              Map<String, dynamic> newMovie = {
                "name": "Shathi Updated",
                "language": "English, Hindi, Bangla",
                "year": "2008",
                "rating": "3.5"
              };
              _firebaseFirestore
                  .collection("movies")
                  .doc("movie-1")
                  .update(newMovie);
            },
            child: const Text("Update"),
          ),
          const SizedBox(height: 24),
          FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            onPressed: () {
              _firebaseFirestore.collection("movies").doc("movie-1").delete();
            },
            child: const Text("Delete"),
          ),
          const SizedBox(height: 24),
          FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              // Tennis Score
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TennisScreen(),
                ),
              );
            },
            child: const Text("Tennis"),
          ),
        ],
      ),
    );
  }
}

class Movie {
  final String id, name, language, year, rating;

  Movie({
    required this.id,
    required this.name,
    required this.language,
    required this.year,
    required this.rating,
  });

  factory Movie.fromJson(String id, Map<String, dynamic> json) {
    return Movie(
        id: id,
        name: json['name'],
        language: json['language'],
        year: json['year'],
        rating: json['rating'] ?? '0.0');
  }
}
