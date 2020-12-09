import 'dart:convert';
import 'package:custom_ml_model/detailsPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading;
  var movieData;
  var finalData;

  void initState() {
    setState(() {
      loading = true;
    });

    getTotalMoviesData();
  }

  getTotalMoviesData() async {
    String url = "http://10.0.2.2:12345/getmovies";

    var data = await http.get(url, headers: {
      "content-type": "application/json",
      "accept": "application/json",
    });

    var decodedData = json.decode(data.body)["movies"];
    //print(decodedData.length);
    setState(() {
      finalData = decodedData;
      loading = false;
    });
    //print(finalData[0]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text("Flutter",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              GestureDetector(
                onTap: () {
                  getTotalMoviesData();
                },
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
            height: 30.0,
          ),
          loading == true
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.redAccent,
                      strokeWidth: 6.0,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 90,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: finalData.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return DetailsPage(
                                      movie: finalData[index],
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
                                          padding:
                                              const EdgeInsets.only(left: 25.0),
                                          child: Icon(
                                            Icons.movie_outlined,
                                            color: Colors.white,
                                            size: 24.0,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Container(
                                            //color: Colors.white,
                                            width: 320.0,
                                            child: Text(
                                              finalData[index],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 27.0,
                                                //fontWeight: FontWeight.bold,
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
    ));
  }
}
