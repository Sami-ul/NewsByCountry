// Sami-ul
// Summary json deserialization

class Summary {
  String? summary;

  Summary({this.summary});

  Summary.fromJson(Map<String, dynamic> json) {
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['summary'] = summary;
    return data;
  }
}
