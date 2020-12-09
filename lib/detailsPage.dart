//import 'dart:html';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailsPage extends StatefulWidget {
  String movie;

  DetailsPage({this.movie});
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool loading;

  String movie;

  void initState() {
    setState(() {
      loading = true;
    });

    getPredictionsMovie(widget.movie);
  }

  var predictionsData;

  getPredictionsMovie(movie) async {
    var request = {
      "movie": movie,
    };
    String url = "http://10.0.2.2:12345/content_recommendation";
    var data = await http.post(url,
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: jsonEncode(request));

    var decodedData = jsonDecode(data.body)["predictionmovies"];

    setState(() {
      predictionsData = decodedData;
      loading = false;
    });

    // print(predictionsData.length);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Container(
            child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 12.0,
                ),
                Container(
                  child: Text(
                    "Flutter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    child: Text(
                      " Movies",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 38.0,
            ),
            Container(
              color: Colors.redAccent.withOpacity(0.7),
              height: 250.0,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                widget.movie,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
            SizedBox(
              height: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 212.0),
              child: Container(
                child: Text(
                  "You may also like : ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: loading == true
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 6.0,
                          backgroundColor: Colors.redAccent.withOpacity(0.7),
                        ),
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height - 480.0,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: predictionsData.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DetailsPage(
                                        movie: predictionsData[index],
                                      );
                                    }));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 55.0,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Center(
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0),
                                            child: Icon(
                                              Icons.movie_outlined,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Container(
                                              //color: Colors.white,
                                              width: 320.0,
                                              child: Text(
                                                predictionsData[index],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                )
                              ],
                            );
                          }),
                    ),
            ),
          ],
        )),
      ),
    );
  }
}
