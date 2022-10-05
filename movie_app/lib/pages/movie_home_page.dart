import 'package:flutter/material.dart';
import 'package:movie_app/pages/movie_details_page.dart';
import 'package:movie_app/provider/movie_provider.dart';
import 'package:movie_app/utils/text_styles.dart';
import 'package:provider/provider.dart';

class MovieHomePage extends StatefulWidget {
  static const String routeName = '/';
  const MovieHomePage({Key? key}) : super(key: key);
  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {
  late MovieProvider provider;
  bool isFirst = true;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isFirst) {
      provider = Provider.of<MovieProvider>(context);
      provider.getMovieData();
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff010101),
        appBar: AppBar(
            backgroundColor: Color(0xff010101),
            elevation: 0,
            centerTitle: true,
            title: Image.asset(
              'images/netflix.png',
              height: 80,
            )),
        body: Column(
          children: [provider.hasDataLoaded ? myWidget() : Text('Not found')],
        ));
  }

  Widget myWidget() {
    return Expanded(
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text(
                            'Popular on Netflix',
                            style: txtDateHeader18,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: provider.movieModel!.data!.movies!
                                  .getRange(0, 5)
                                  .map((movie) => InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              MovieDetailsPage.routeName,
                                              arguments: movie);
                                        },
                                        child: Card(
                                          child: Image.network(
                                            '${movie.mediumCoverImage}',
                                            height: 180,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ))
                                  .toList()),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text(
                            'Trending Now',
                            style: txtDateHeader18,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: provider.movieModel!.data!.movies!
                                  .getRange(5, 10)
                                  .map((movie) => InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              MovieDetailsPage.routeName,
                                              arguments: movie);
                                        },
                                        child: Card(
                                          child: Image.network(
                                            '${movie.mediumCoverImage}',
                                            height: 180,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ))
                                  .toList()),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text(
                            'Watch It Again',
                            style: txtDateHeader18,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: provider.movieModel!.data!.movies!
                                  .getRange(10, 15)
                                  .map((movie) => InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              MovieDetailsPage.routeName,
                                              arguments: movie);
                                        },
                                        child: Card(
                                          child: Image.network(
                                            '${movie.mediumCoverImage}',
                                            height: 180,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ))
                                  .toList()),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text(
                            'Exciting Movies',
                            style: txtDateHeader18,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: provider.movieModel!.data!.movies!
                                  .getRange(15, 20)
                                  .map((movie) => InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              MovieDetailsPage.routeName,
                                              arguments: movie);
                                        },
                                        child: Card(
                                          child: Image.network(
                                            '${movie.mediumCoverImage}',
                                            height: 180,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ))
                                  .toList()),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
