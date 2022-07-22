// Sami-ul
// Main file for news by country web app

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/JSONDeserialization/summary.dart';
import 'package:url_launcher/url_launcher.dart';
import 'JSONDeserialization/news.dart';
import 'Pages/search.dart';
import 'package:http/http.dart' as http;

List<News> newsData = [];
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'News',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(
          title: "News",
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget futureBuildResults(
    BuildContext context, AsyncSnapshot<List<News>> snapshot) {
  if (snapshot.hasData) {
    if (snapshot.data!.isNotEmpty) {
      return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return ListTile(
                contentPadding: const EdgeInsets.all(25),
                leading: const Icon(Icons.newspaper),
                title: Text(
                    "${snapshot.data![index].date} | ${snapshot.data![index].title}"),
                subtitle: Text("${snapshot.data![index].summary?.summary}"),
                onTap: () {
                  _launchURL(snapshot.data![index].link);
                });
          });
    } else {
      return const CupertinoAlertDialog(
        content: Text("No news found for this country"),
      );
    }
  } else if (snapshot.hasError) {
    return Text(snapshot.error.toString());
  } else {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

Future<List<News>> getNews(String country, int len) async {
  String url;
  if (country.isEmpty) {
    // For default loading on main page
    url = "http://localhost:3535/news?len=$len&time=3d&searchTerm=politics";
  } else {
    // for loading with a country specified
    url = "http://localhost:3535/news?len=$len&searchTerm=$country&time=3d";
  }
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var newsList = (json.decode(response.body) as List)
        .map((e) => News.fromJson(e))
        .toList(); // deserialize
    for (int i = 0; i < newsList.length; i++) {
      newsList[i].addSummary(await _getSummary(
          newsList[i].link)); // add a summary to each news object
    }
    return newsList;
  } else {
    throw Exception("Failed to load");
  }
}

Future<Summary> _getSummary(String link) async {
  var url =
      "http://localhost:3535/summary?link=$link"; // get request to python backend which generates summary
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return (Summary.fromJson(json.decode(response.body)));
  } else {
    throw Exception("Failed to load");
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          builder: futureBuildResults,
          future: getNews("", 20),
        ),
        appBar: AppBar(
          title: Text("News by Country"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search for Country',
              onPressed: () {
                showSearch(
                    context: context,
                    delegate:
                        Search()); // open search function and display search with countries as options
              },
            ),
          ],
        ));
  }
}
