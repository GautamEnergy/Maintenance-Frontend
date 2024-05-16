import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool? status;
  String? message;
  List<UserData>? data;

  UserModel({this.status, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    data = json["data"] == null
        ? []
        : List<UserData>.from(json["data"].map((x) => UserData.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData {
  String? employeeID;
  String? name;
  String? profileImg;
  String? location;
  String? fQCDetailId;
  String? product;
  String? productBatchNo;
  String? partyName;
  DateTime? dateOfQualityCheck;
  String? pdf;

  UserData(
      {this.employeeID,
      this.name,
      this.profileImg,
      this.location,
      this.fQCDetailId,
      this.product,
      this.productBatchNo,
      this.partyName,
      this.dateOfQualityCheck,
      this.pdf});

  UserData.fromJson(Map<String, dynamic> json) {
    employeeID = json['EmployeeID'];
    name = json['Name'];
    profileImg = json['ProfileImg'];
    location = json['Location'];
    fQCDetailId = json['FQCDetailId'];
    product = json['Product'];
    productBatchNo = json['ProductBatchNo'];
    partyName = json['PartyName'];
    dateOfQualityCheck = DateTime.parse(json['DateOfQualityCheck']);
    pdf = json['Pdf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeID'] = this.employeeID;
    data['Name'] = this.name;
    data['ProfileImg'] = this.profileImg;
    data['Location'] = this.location;
    data['FQCDetailId'] = this.fQCDetailId;
    data['Product'] = this.product;
    data['ProductBatchNo'] = this.productBatchNo;
    data['PartyName'] = this.partyName;
    data['DateOfQualityCheck'] = this.dateOfQualityCheck;
    data['Pdf'] = this.pdf;
    return data;
  }
}
