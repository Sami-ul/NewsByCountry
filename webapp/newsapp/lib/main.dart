// Sami-ul
// Main file for news by country web app

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:newsapp/JSONDeserialization/summary.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

import 'JSONDeserialization/news.dart';

import 'package:http/http.dart' as http;

List<News> newsData = [];
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'News',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(
          title: "News",
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          builder: DataSearch()._futureBuildResults,
          future: DataSearch()._getNews("", 20),
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
                        DataSearch()); // open search function and display search with countries as options
              },
            ),
          ],
        ));
  }
}

class DataSearch extends SearchDelegate<String> {
  var list = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Australia",
    "Austria",
    "Azerbaijan",
    "The Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bhutan",
    "Bolivia",
    "Bosnia and Herzegovina",
    "Botswana",
    "Brazil",
    "Brunei",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Cape Verde",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "Comoros",
    "Republic of the Congo",
    "Democratic Republic of the Congo",
    "Costa Rica",
    "Cote d'Ivoire",
    "Croatia",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "East Timor (Timor-Leste)",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Ethiopia",
    "Fiji",
    "Finland",
    "France",
    "Gabon",
    "The Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Greece",
    "Grenada",
    "Guatemala",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Korea, North",
    "Korea, South",
    "Kosovo",
    "Kuwait",
    "Kyrgyzstan",
    "Laos",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macedonia",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Mauritania",
    "Mauritius",
    "Mexico",
    "Micronesia, Federated States of",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Morocco",
    "Mozambique",
    "Myanmar (Burma)",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Palestine",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Qatar",
    "Romania",
    "Russia",
    "Rwanda",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Vincent and the Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Sudan",
    "Spain",
    "Sri Lanka",
    "Sudan",
    "Suriname",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syria",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Togo",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States of America",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Vatican City",
    "Venezuela",
    "Vietnam",
    "Yemen",
    "Zambia",
    "Zimbabwe",
  ];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, "");
      },
    );
  }

  var res = "";
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = list
        .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            showResults(context); // Creates search with the name of the country
            res = suggestionList[index].toString();
          },
          leading: Icon(Icons.location_city),
          title: Text(suggestionList[index])),
      itemCount: suggestionList.length,
    );
  }

  Future<List<News>> _getNews(String country, int len) async {
    var url;
    if (country.length == 0) {
      // For default loading on main page
      url = "http://localhost:3535/news?len=$len&time=3d&searchTerm=politics";
    } else {
      // for loading with a country specified
      url = "http://localhost:3535/news?len=$len&searchTerm=$country&time=3d";
    }
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // maybe use setState here idek
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
        "http://localhost:3535/summary?link=${link}"; // get request to python backend which generates summary
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // maybe use setState here idek
      return (Summary.fromJson(json.decode(response.body)));
    } else {
      throw Exception("Failed to load");
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      builder: _futureBuildResults,
      future: _getNews(res, 10),
    );
  }

  Widget _futureBuildResults(
      BuildContext context, AsyncSnapshot<List<News>> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data!.length != 0) {
        return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                  contentPadding: EdgeInsets.all(25),
                  leading: Icon(Icons.newspaper),
                  title: Text(
                      "${snapshot.data![index].date} | ${snapshot.data![index].title}"),
                  subtitle: Text("${snapshot.data![index].summary?.summary}"),
                  onTap: () {
                    _launchURL(snapshot.data![index].link);
                  });
            });
      } else {
        return CupertinoAlertDialog(
          content: Text("No news found for this country"),
        );
      }
    } else if (snapshot.hasError) {
      return Text(snapshot.error.toString());
    } else {
      return Center(child: CircularProgressIndicator.adaptive());
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
