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
  String? partyName;
  String? sparePartName;
  String? sparePartModelNumber;
  String? voucherNumber;
  List<String>? machineNames;
  String? sparePartBrandName;
  String? sparePartSpecification;
  String? quantityPurchaseOrder;
  String? quantityRecieved;
  String? unit;
  String? currency;
  String? price;
  String? totalCost;
  String? invoiceNumber;
  String? invoicePdfURL;
  String? availableStock;
  String? name;
  String? createdOn;
  String? date;
  String? time;

  UserData(
      {this.partyName,
      this.sparePartName,
      this.sparePartModelNumber,
      this.voucherNumber,
      this.machineNames,
      this.sparePartBrandName,
      this.sparePartSpecification,
      this.quantityPurchaseOrder,
      this.quantityRecieved,
      this.unit,
      this.currency,
      this.price,
      this.totalCost,
      this.invoiceNumber,
      this.invoicePdfURL,
      this.availableStock,
      this.name,
      this.createdOn,
      this.date,
      this.time});

  UserData.fromJson(Map<String, dynamic> json) {
    partyName = json['PartyName'];
    sparePartName = json['SparePartName'];
    sparePartModelNumber = json['SparePartModelNumber'];
    voucherNumber = json['Voucher_Number'];
    machineNames = json['Machine_Names'].cast<String>();
    sparePartBrandName = json['Spare_Part_Brand_Name'];
    sparePartSpecification = json['Spare_Part_Specification'];
    quantityPurchaseOrder = json['Quantity_Purchase_Order'];
    quantityRecieved = json['Quantity_Recieved'];
    unit = json['Unit'];
    currency = json['Currency'];
    price = json['Price'];
    totalCost = json['Total_Cost'];
    invoiceNumber = json['Invoice_Number'];
    invoicePdfURL = json['Invoice_Pdf_URL'];
    availableStock = json['Available_Stock'];
    name = json['Name'];
    createdOn = json['Created_On'];
    date = json['Date'];
    time = json['Time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PartyName'] = this.partyName;
    data['SparePartName'] = this.sparePartName;
    data['SparePartModelNumber'] = this.sparePartModelNumber;
    data['Voucher_Number'] = this.voucherNumber;
    data['Machine_Names'] = this.machineNames;
    data['Spare_Part_Brand_Name'] = this.sparePartBrandName;
    data['Spare_Part_Specification'] = this.sparePartSpecification;
    data['Quantity_Purchase_Order'] = this.quantityPurchaseOrder;
    data['Quantity_Recieved'] = this.quantityRecieved;
    data['Unit'] = this.unit;
    data['Currency'] = this.currency;
    data['Price'] = this.price;
    data['Total_Cost'] = this.totalCost;
    data['Invoice_Number'] = this.invoiceNumber;
    data['Invoice_Pdf_URL'] = this.invoicePdfURL;
    data['Available_Stock'] = this.availableStock;
    data['Name'] = this.name;
    data['Created_On'] = this.createdOn;
    data['Date'] = this.date;
    data['Time'] = this.time;
    return data;
  }
}
