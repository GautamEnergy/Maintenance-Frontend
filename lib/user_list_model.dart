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

    data = json['data'] == null
        ? []
        : List<UserData>.from(json['data'].map((x) => UserData.fromJson(x)));
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
  String? personID;
  String? loginID;
  String? employeeID;
  String? name;
  String? profileImg;
  String? location;
  String? designation;
  String? department;
  String? status;

  UserData(
      {this.personID,
      this.loginID,
      this.employeeID,
      this.name,
      this.profileImg,
      this.location,
      this.designation,
      this.department,
      this.status});

  UserData.fromJson(Map<String, dynamic> json) {
    personID = json['PersonID'];
    loginID = json['LoginID'];
    employeeID = json['EmployeeID'];
    name = json['Name'];
    profileImg = json['ProfileImg'];
    location = json['Location'];
    designation = json['Designation'];
    department = json['Department'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PersonID'] = this.personID;
    data['LoginID'] = this.loginID;
    data['EmployeeID'] = this.employeeID;
    data['Name'] = this.name;
    data['ProfileImg'] = this.profileImg;
    data['Location'] = this.location;
    data['Designation'] = this.designation;
    data['Department'] = this.department;
    data['Status'] = this.status;
    return data;
  }
}
