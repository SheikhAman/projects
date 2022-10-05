import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/utils/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../provider/movie_provider.dart';
import 'package:intl/intl.dart';
import '../utils/helper_function.dart';

class MovieDetailsPage extends StatefulWidget {
  static const String routeName = '/details';
  MovieDetailsPage({Key? key}) : super(key: key);

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  Movies? movie;
  @override
  void didChangeDependencies() {
    movie = ModalRoute.of(context)!.settings.arguments as Movies;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(size.width);
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: size.height / 1.5,
                    width: size.width,
                    child: Image.network('${movie!.mediumCoverImage}',
                        fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 15,
                    left: 8,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 10,
                    child: Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    width: size.width,
                    child: ListTile(
                      tileColor: Colors.black45,
                      subtitle: Column(
                        children: [
                          Text(
                            '${movie!.year} • ${movie!.genres}',
                            style: txtTempBig16White54withBg,
                          ),
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: (movie!.rating!.toDouble() / 2),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            maxRating: 5,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            unratedColor: Colors.grey,
                            ignoreGestures: true,
                            onRatingUpdate: (rating) {},
                          )
                        ],
                      ),
                      title: Text(' ${movie!.titleLong}',
                          textAlign: TextAlign.center,
                          style: txtTempBig25WithBg),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 12.0, left: 12),
                child: Container(
                  height: 0.8,
                  color: Colors.grey,
                  width: size.width,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Card(
                          child: Image.network(
                            '${movie!.backgroundImageOriginal}',
                            height: 180,
                            width: 120,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Title:',
                                    style: txtNormal16White54,
                                  ),
                                  Expanded(
                                    child: FittedBox(
                                      child: Text(
                                        ' ${movie!.titleEnglish}',
                                        style: txtNormal16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Running Time: ',
                                    style: txtNormal16White54,
                                  ),
                                  Text(
                                    getFormattedDateTime(movie!.runtime!, 'ms'),
                                    style: txtNormal16,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Release Date: ',
                                    style: txtNormal16White54,
                                  ),
                                  Text(
                                    getFormattedDateTime(
                                        movie!.dateUploadedUnix!, 'yMd'),
                                    style: txtNormal16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, right: 12.0, left: 12),
                      child: Container(
                        height: 0.8,
                        color: Colors.grey,
                        width: size.width,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "StoryLine",
                      style: txtAddress24,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${movie!.descriptionFull}',
                      style: txtNormal16White54,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const myhour = 'h';
