class NameModel {
  String? firstName;
  String? lastName;

  NameModel({this.lastName, this.firstName});

  NameModel.fromMap(Map<String, dynamic> json) {
    firstName = json['firstname'];
    lastName = json['lastname'];
  }
}
