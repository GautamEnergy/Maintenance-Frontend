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
  String? qualityId;
  String? shift;
  String? shiftInChargeName;
  String? shiftInChargePreLime;
  String? shiftInChargePostLim;
  String? productBarCode;
  String? createdOn;
  String? createdBy;
  String? wattage;
  String? stage;
  String? resposiblePerson;
  String? reasonOfIssue;
  String? issueComeFrom;
  String? actionTaken;
  String? modulePicture;
  String? issue;
  String? modelName;

  UserData(
      {this.qualityId,
      this.shift,
      this.shiftInChargeName,
      this.shiftInChargePreLime,
      this.shiftInChargePostLim,
      this.productBarCode,
      this.createdOn,
      this.createdBy,
      this.wattage,
      this.stage,
      this.resposiblePerson,
      this.reasonOfIssue,
      this.issueComeFrom,
      this.actionTaken,
      this.modulePicture,
      this.issue,
      this.modelName});

  UserData.fromJson(Map<String, dynamic> json) {
    qualityId = json['QualityId'];
    shift = json['Shift'];
    shiftInChargeName = json['ShiftInChargeName'];
    shiftInChargePreLime = json['ShiftInChargePreLime'];
    shiftInChargePostLim = json['ShiftInChargePostLim'];
    productBarCode = json['ProductBarCode'];
    createdOn = json['CreatedOn'];
    createdBy = json['CreatedBy'];
    wattage = json['Wattage'];
    stage = json['Stage'];
    resposiblePerson = json['ResposiblePerson'];
    reasonOfIssue = json['ReasonOfIssue'];
    issueComeFrom = json['IssueComeFrom'];
    actionTaken = json['ActionTaken'];
    modulePicture = json['ModulePicture'];
    issue = json['Issue'];
    modelName = json['ModelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QualityId'] = this.qualityId;
    data['Shift'] = this.shift;
    data['ShiftInChargeName'] = this.shiftInChargeName;
    data['ShiftInChargePreLime'] = this.shiftInChargePreLime;
    data['ShiftInChargePostLim'] = this.shiftInChargePostLim;
    data['ProductBarCode'] = this.productBarCode;
    data['CreatedOn'] = this.createdOn;
    data['CreatedBy'] = this.createdBy;
    data['Wattage'] = this.wattage;
    data['Stage'] = this.stage;
    data['ResposiblePerson'] = this.resposiblePerson;
    data['ReasonOfIssue'] = this.reasonOfIssue;
    data['IssueComeFrom'] = this.issueComeFrom;
    data['ActionTaken'] = this.actionTaken;
    data['ModulePicture'] = this.modulePicture;
    data['Issue'] = this.issue;
    data['ModelName'] = this.modelName;
    return data;
  }
}
