// Sami-ul
// News json deserialization

import 'package:newsapp/JSONDeserialization/summary.dart';

class News {
  late String date;
  late String link;
  late String title;
  Summary? summary;

  News(this.date, this.link, this.title);

  News.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    link = json['link'];
    title = json['title'];
  }
  void addSummary(Summary s) {
    summary = s;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['link'] = this.link;
    data['title'] = this.title;
    return data;
  }
}
