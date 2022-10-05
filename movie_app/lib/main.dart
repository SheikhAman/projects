import 'package:flutter/material.dart';
import 'package:movie_app/pages/movie_details_page.dart';
import 'package:movie_app/pages/movie_home_page.dart';
import 'package:provider/provider.dart';
import 'provider/movie_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MovieProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: MovieHomePage.routeName,
      routes: {
        MovieHomePage.routeName: (context) => MovieHomePage(),
        MovieDetailsPage.routeName: (context) => MovieDetailsPage(),
      },
    );
  }
}
