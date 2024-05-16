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
  String? supplierName;
  DateTime? qualityCheckDate;
  String? cOCPdf;
  String? invoicePdf;
  String? excelURL;
  String? solarDetailID;
  String? invoiceNo;
  String? materialName;

  UserData(
      {this.employeeID,
      this.name,
      this.profileImg,
      this.location,
      this.supplierName,
      this.qualityCheckDate,
      this.cOCPdf,
      this.invoicePdf,
      this.excelURL,
      this.solarDetailID,
      this.invoiceNo,
      this.materialName});

  UserData.fromJson(Map<String, dynamic> json) {
    employeeID = json['EmployeeID'];
    name = json['Name'];
    profileImg = json['ProfileImg'];
    location = json['Location'];
    supplierName = json['SupplierName'];
    qualityCheckDate = DateTime.parse(json['QualityCheckDate']);
    cOCPdf = json['COCPdf'];
    invoicePdf = json['InvoicePdf'];
    excelURL = json['ExcelURL'];
    solarDetailID = json['SolarDetailID'];
    invoiceNo = json['InvoiceNo'];
    materialName = json['MaterialName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeID'] = this.employeeID;
    data['Name'] = this.name;
    data['ProfileImg'] = this.profileImg;
    data['Location'] = this.location;
    data['SupplierName'] = this.supplierName;
    data['QualityCheckDate'] = this.qualityCheckDate;
    data['COCPdf'] = this.cOCPdf;
    data['InvoicePdf'] = this.invoicePdf;
    data['ExcelURL'] = this.excelURL;
    data['SolarDetailID'] = this.solarDetailID;
    data['InvoiceNo'] = this.invoiceNo;
    data['MaterialName'] = this.materialName;
    return data;
  }
}


















// import 'dart:convert';

// UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

// String userModelToJson(UserModel data) => json.encode(data.toJson());

// class UserModel {
//   bool? status;
//   String? message;
//   List<UserData>? data;

//   UserModel({this.status, this.message, this.data});

//   UserModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json["data"] == null
//         ? []
//         : List<UserData>.from(json["data"][0].map((x) => UserData.fromJson(x)));
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class UserData {
//   String? personid;
//   String? employeeid;
//   String? employeementtype;
//   String? fullname;
//   String? profilepic;
//   String? officialcontactno;
//   String? officialemail;
//   String? personalcontactno;
//   String? personalemail;
//   String? department;

//   UserData(
//       {this.personid,
//       this.employeeid,
//       this.employeementtype,
//       this.fullname,
//       this.profilepic,
//       this.officialcontactno,
//       this.officialemail,
//       this.personalcontactno,
//       this.personalemail,
//       this.department});

//   UserData.fromJson(Map<String, dynamic> json) {
//     personid = json['personid'];
//     employeeid = json['employeeid'];
//     employeementtype = json['employeementtype'];
//     fullname = json['fullname'];
//     profilepic = json['profilepic'];
//     officialcontactno = json['officialcontactno'];
//     officialemail = json['officialemail'];
//     personalcontactno = json['personalcontactno'];
//     personalemail = json['personalemail'];
//     department = json['department'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['personid'] = this.personid;
//     data['employeeid'] = this.employeeid;
//     data['employeementtype'] = this.employeementtype;
//     data['fullname'] = this.fullname;
//     data['profilepic'] = this.profilepic;
//     data['officialcontactno'] = this.officialcontactno;
//     data['officialemail'] = this.officialemail;
//     data['personalcontactno'] = this.personalcontactno;
//     data['personalemail'] = this.personalemail;
//     data['department'] = this.department;
//     return data;
//   }
// }


