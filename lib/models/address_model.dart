class AddressModel {
  String? city;
  String? street;
  int? buildingNumber;
  String? zipcode;

  AddressModel({this.buildingNumber, this.city, this.street, this.zipcode});

  AddressModel.fromMap(Map<String, dynamic> json) {
    buildingNumber = json['number'];
    city = json['city'];
    street = json['street'];
    zipcode = json['zipcode'];
  }
}
