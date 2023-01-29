class RatingModel {
  num? rate;
  int? count;

  RatingModel.fromMap(Map<String, dynamic> json) {
    rate = json['rate'];
    count = json['count'];
  }
}
