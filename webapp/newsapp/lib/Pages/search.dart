import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/JSONDeserialization/summary.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../JSONDeserialization/news.dart';

class Search extends SearchDelegate<String> {
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
    "Brunei Darussalam",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Cabo Verde",
    "The Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "The Comoros",
    "Congo",
    "Democratic Republic of Congo",
    "Costa Rica",
    "Cote d'Ivoire",
    "Croatia",
    "Cuba",
    "Cyprus",
    "Czechia",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Timor-Leste",
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
    "Gambia",
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
    "North Korea",
    "South Korea",
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
    "The Marshall Islands",
    "Mauritania",
    "Mauritius",
    "Mexico",
    "The Federated States of Micronesia",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Morocco",
    "Mozambique",
    "Myanmar",
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
    "Eswatini",
    "Sweden",
    "Switzerland",
    "Syrian Arab Republic",
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
          icon: const Icon(Icons.clear),
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
        .where((p) => p.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            query = suggestionList[index].toString();
            showResults(context); // Creates search with the name of the country
            res = suggestionList[index].toString();
          },
          minVerticalPadding: 25,
          leading: Container(child: _getFlag(suggestionList[index]), width: 75),
          title: Text(suggestionList[index])),
      itemCount: suggestionList.length,
    );
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

  int length = 10;
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      builder: futureBuildResults,
      future: getNews(res, length),
    );
  }

  Widget _getFlag(String name) {
    String orig = name;
    switch (name.toLowerCase()) {
      case "cote d'ivoire":
        name = "ci";
        break;
      case "south korea":
        name = "kr";
        break;
      case "macedonia":
        name = "mk";
        break;
      case "russia":
        name = "ru";
        break;
      case "vatican city":
        name = "va";
        break;
    }
    try {
      return Image.asset("Images/$orig.png");
    } catch (e) {
      throw Exception("Failed to load");
    }
  }

  Widget futureBuildResults(
      BuildContext context, AsyncSnapshot<List<News>> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data!.isNotEmpty) {
        return Row(children: [
          Expanded(
              child: Row(
            children: [
              const Spacer(flex: 2),
              const Spacer(flex: 2),
              Text(res, style: const TextStyle(fontSize: 40)),
              const Spacer(flex: 1),
              Container(
                child: _getFlag(res),
                height: 70,
              ),
              const Spacer(flex: 2),
              const Spacer(flex: 2)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  margin: EdgeInsets.all(8),
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            contentPadding: const EdgeInsets.all(25),
                            leading: const Icon(Icons.newspaper),
                            title: Text(
                                "${snapshot.data![index].date} | ${snapshot.data![index].title}"),
                            subtitle: Text(
                                "${snapshot.data![index].summary?.summary}"),
                            onTap: () {
                              _launchURL(snapshot.data![index].link);
                            });
                      })))
        ]);
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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
