import 'dart:convert';
import 'dart:io';
import 'package:Maintenance/SparePartInList.dart';
import 'package:Maintenance/Welcomepage.dart';
import 'package:Maintenance/components/app_button_widget.dart';
import 'package:Maintenance/components/appbar.dart';
import 'package:Maintenance/constant/app_assets.dart';
import 'package:Maintenance/constant/app_color.dart';
import 'package:Maintenance/constant/app_fonts.dart';
import 'package:Maintenance/constant/app_helper.dart';
import 'package:Maintenance/constant/app_styles.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:Maintenance/constant/app_color.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:dio/src/response.dart' as Response;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SparePartIn extends StatefulWidget {
  final String? id;
  SparePartIn({this.id});
  @override
  _SparePartInState createState() => _SparePartInState();
}

class _SparePartInState extends State<SparePartIn> {
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController specificationController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController quantityReceiveController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController totalCostController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController sparePartBrandController = TextEditingController();
  TextEditingController sparePartNameController = TextEditingController();
  TextEditingController invoicePdfController = TextEditingController();

  List sparePartsNameList = [];
  List POList = [];
  List sparePartModelNoList = [];
  List allList = [];
  List partyList = [];
  List currencyList = [];
  List<String> selectedMachineItems = [];
  List<dynamic> Mach = [];
  List<int>? invoicePdfFileBytes;

  bool menu = false, user = false, face = false, home = false;

  bool _isLoading = false;
  String setPage = '', pic = '', site = '', personid = '';

  List<int>? referencePdfFileBytes;
  String selectedmachine = "";
  String selectedmachinemodel = "";
  String selectedspare = "";
  String selectedsparemodel = "",
      sendSelectedsparemodel = "",
      selectedPartyName = "",
      sendSelectedParty = "";
  String selectedCurrency = "";
  String selectedPO = "";

  String status = '',
      sparePartId = '',
      designation = '',
      token = '',
      department = '';
  final _dio = Dio();
  List data = [];

  Response.Response? _response;

  @override
  void initState() {
    super.initState();
    store();
    quantityReceiveController.addListener(updateTotalCost);
    priceController.addListener(updateTotalCost);
  }

  @override
  void dispose() {
    quantityReceiveController.removeListener(updateTotalCost);
    priceController.removeListener(updateTotalCost);

    quantityReceiveController.dispose();
    priceController.dispose();

    totalCostController.dispose();

    super.dispose();
  }

  void updateTotalCost() {
    double priceAmount = 0.0;
    double receiveQuantity = 0.0;

    // Check if the text fields are not empty before parsing
    if (priceController.text.isNotEmpty) {
      priceAmount = double.parse(priceController.text);
    }

    if (quantityReceiveController.text.isNotEmpty) {
      receiveQuantity = double.parse(quantityReceiveController.text);
    }

    double totalCost = priceAmount * receiveQuantity;

    setState(() {
      totalCostController.text =
          totalCost.toStringAsFixed(2) + " " + selectedCurrency;
    });
  }

  // *******  Send the Data where will be Used to Backend *******

  void store() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pic = prefs.getString('pic')!;
      personid = prefs.getString('personid')!;
      site = prefs.getString('site')!;
      designation = prefs.getString('designation')!;
      department = prefs.getString('department')!;
      token = prefs.getString('token')!;
    });
    getPartyListData();
    getSparePartModelNoListData();
  }

  Future<void> _pickcocPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File pdffile = File(result.files.single.path!);
      setState(() {
        invoicePdfFileBytes = pdffile.readAsBytesSync();
        invoicePdfController.text = result.files.single.name;
      });
    } else {
      // User canceled the file picker
    }
  }

  getPartyListData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Maintenance/GetParty');

    http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var partyBody = jsonDecode(response.body);
        setState(() {
          partyList = partyBody;
        });
      }
    });
  }

  getSparePartModelNoListData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Maintenance/GetAutoData');

    http.post(
      Uri.parse(url),
      body: json.encode({"required": "Spare Part Model No"}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var machineBody = jsonDecode(response.body);

        setState(() {
          sparePartModelNoList = machineBody['data'];
        });
      }
    });
  }

  getPONumberListData(PartyId, SparepartModelId) async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Maintenance/GetVoucherList');

    http.post(
      Uri.parse(url),
      body: json.encode({"SparePartId": SparepartModelId, "PartyId": PartyId}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var poBody = jsonDecode(response.body);
        print("poBody........QQQQQ");
        print(poBody);
        setState(() {
          POList = poBody;
        });
      }
    });
  }

  getAllDataFromPONumber(SparePartId, PurchaseOrderId) async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Maintenance/GetPO&SparePartDetail');

    http.post(
      Uri.parse(url),
      body: json.encode(
          {"SparePartId": SparePartId, "PurchaseOrderId": PurchaseOrderId}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var allBody = jsonDecode(response.body);
        print("Raajjj.....?");
        print(allBody);

        setState(() {
          // allList = allBody;
          sparePartBrandController.text = allBody['BrandName'];

          priceController.text = allBody['Price'];
          specificationController.text = allBody['Specification'];
          quantityController.text = allBody['Quantity'];
          currencyController.text = allBody['Currency'];
          unitController.text = allBody['Unit'];
          Mach = allBody['Machine'];
          selectedMachineItems = Mach.where((element) => element is String)
              .cast<String>()
              .toList();
        });
      }
    });
  }

  Future createData() async {
    var data = {
      "CreatedBy": personid,
      "PartyId": sendSelectedParty,
      "SparePartId": sendSelectedsparemodel,
      "SparePartName": sparePartNameController.text,
      "PurchaseOrderId": selectedPO,
      "MachineNames": selectedMachineItems,
      "SparePartBrandName": sparePartBrandController.text,
      "Price": priceController.text,
      "SparePartSpecification": specificationController.text,
      "QuantityPurchaseOrder": quantityController.text,
      "Currency": currencyController.text,
      "Unit": unitController.text,
      "QuantityRecieved": quantityReceiveController.text,
      "TotalCost": totalCostController.text,
      "InvoiceNumber": invoiceNumberController.text,
      "Status": "Active"
    };

    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    final url = (site! + "Maintenance/SparePartIn");

    final prefs = await SharedPreferences.getInstance();

    var response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var objData = json.decode(response.body);

      setState(() {
        sparePartId = objData[0]['SparePartInId'];
      });

      if (invoicePdfFileBytes != '' && invoicePdfFileBytes != null) {
        uploadPDF((invoicePdfFileBytes ?? []));
      } else {
        setState(() {
          _isLoading = false;
        });
        Toast.show("Spare Part In Successfully.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => SparePartInList()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      Toast.show("Error In Server",
          duration: Toast.lengthLong, gravity: Toast.center);
    }
  }

  uploadPDF(List<int> referenceBytes) async {
    print("PDF......");
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    var formData = FormData.fromMap({
      "SparePartId": sparePartId,
      "InvoicePdf": MultipartFile.fromBytes(
        referenceBytes,
        filename:
            (invoicePdfController.text + (currentdate.toString()) + '.pdf'),
        contentType: MediaType("application", 'pdf'),
      ),
    });

    _response = await _dio.post((site! + 'Maintenance/SparePartsImage'),
        options: Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
          validateStatus: (status) => true,
        ),
        data: formData);

    try {
      if (_response?.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        Toast.show("Spare Part In Successfully.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => SparePartInList()),
            (Route<dynamic> route) => false);
      } else {
        Toast.show("Spare Part In Successfully Added But Error in Invoice Pdf",
            duration: Toast.lengthLong, gravity: Toast.center);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => SparePartInList()),
            (Route<dynamic> route) => false);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.white,
          appBar: GautamAppBar(
            organization: "organizationtype",
            isBackRequired: true,
            memberId: personid,
            imgPath: "ImagePath",
            memberPic: pic,
            logo: "logo",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return WelcomePage();
              }));
            },
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: setPage == ''
                ? Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 195, 230, 155)
                                  .withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _registerFormKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppAssets.imgLogo,
                                              height: 100,
                                              width: 230,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Spare Parts In",
                                      style: TextStyle(
                                        fontSize: 27,
                                        color: Color.fromARGB(255, 56, 57, 56),
                                        fontFamily: appFontFamily,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                Text(
                                  "Party Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                DropdownSearch<String>(
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: AppStyles
                                        .textFieldInputDecoration
                                        .copyWith(
                                      hintText: "Please Select Party Name",
                                      counterText: '',
                                      contentPadding: const EdgeInsets.all(10),
                                      fillColor: const Color.fromARGB(
                                              255, 196, 214, 176)
                                          .withOpacity(
                                              0.5), // Your desired color
                                      filled: true,
                                    ),
                                  ),
                                  items: partyList
                                      .map((label) =>
                                          label['PartyName'].toString())
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedPartyName = val!;

                                      selectedsparemodel = "";
                                      // Empty at onChange:
                                      selectedPO = "";
                                      selectedMachineItems = [];
                                      sparePartBrandController.text = "";
                                      priceController.text = "";
                                      specificationController.text = "";
                                      quantityController.text = "";
                                      currencyController.text = "";
                                      unitController.text = "";
                                      quantityReceiveController.text = "";
                                    });

                                    final selectedParty = partyList.firstWhere(
                                        (element) =>
                                            element['PartyName'] == val);
                                    // getSparePartSpecificationData(
                                    //     selectedModel['SparePartId']
                                    //         .toString());
                                    getPONumberListData(
                                        selectedParty['PartyNameId'].toString(),
                                        sendSelectedsparemodel);
                                    setState(() {
                                      sendSelectedParty =
                                          selectedParty['PartyNameId']
                                              .toString();
                                    });
                                  },
                                  selectedItem: selectedPartyName != ''
                                      ? selectedPartyName
                                      : null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select Party Name';
                                    }
                                    return null;
                                  },
                                  popupProps: const PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Search Party Name...',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Spare Part Model No",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                DropdownSearch<String>(
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: AppStyles
                                        .textFieldInputDecoration
                                        .copyWith(
                                      hintText:
                                          "Please Select Spare Part Model No",
                                      counterText: '',
                                      contentPadding: const EdgeInsets.all(10),
                                      fillColor: const Color.fromARGB(
                                              255, 196, 214, 176)
                                          .withOpacity(
                                              0.5), // Your desired color
                                      filled: true,
                                    ),
                                  ),
                                  items: sparePartModelNoList
                                      .map((label) =>
                                          label['SparePartModelNumber']
                                              .toString())
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedsparemodel = val!;
                                      // Empty at onChange:
                                      selectedPO = "";
                                      selectedMachineItems = [];
                                      sparePartBrandController.text = "";
                                      priceController.text = "";
                                      specificationController.text = "";
                                      quantityController.text = "";
                                      currencyController.text = "";
                                      unitController.text = "";
                                      quantityReceiveController.text = "";
                                    });
                                    final selectedModel = sparePartModelNoList
                                        .firstWhere((element) =>
                                            element['SparePartModelNumber'] ==
                                            val);

                                    getPONumberListData(
                                        sendSelectedParty,
                                        selectedModel['SparePartId']
                                            .toString());

                                    getAllDataFromPONumber(
                                        selectedModel['SparePartId'].toString(),
                                        selectedPO);

                                    setState(() {
                                      sendSelectedsparemodel =
                                          selectedModel['SparePartId']
                                              .toString();
                                      sparePartNameController.text =
                                          selectedModel['SparePartName']
                                              .toString();
                                      selectedPO = "";
                                      selectedMachineItems = [];
                                      sparePartBrandController.text = "";
                                      priceController.text = "";
                                      specificationController.text = "";
                                      quantityController.text = "";
                                      currencyController.text = "";
                                      unitController.text = "";
                                      quantityReceiveController.text = "";
                                    });
                                  },
                                  selectedItem: selectedsparemodel != ''
                                      ? selectedsparemodel
                                      : null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select Spare Part Model No';
                                    }
                                    return null;
                                  },
                                  popupProps: const PopupProps.menu(
                                    showSearchBox: true,
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Search Spare Part Model No',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Spare Part Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                TextFormField(
                                  controller: sparePartNameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Spare Part Name",
                                    fillColor: const Color.fromARGB(
                                            255, 196, 214, 176)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly: true,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText:
                                            "Please Enter Spare Part Name",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "PO Number",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                DropdownButtonFormField<String>(
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Select PO Number",
                                    counterText: '',
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: const Color.fromARGB(
                                            255, 196, 214, 176)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  items: POList.map((label) => DropdownMenuItem(
                                        child: Text(
                                          label['Voucher_Number'],
                                          style: AppStyles.textInputTextStyle,
                                        ),
                                        value: label['Purchase_Order_Id']
                                            .toString(),
                                      )).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedPO = val!;
                                      selectedMachineItems = [];
                                      sparePartBrandController.text = "";
                                      priceController.text = "";
                                      specificationController.text = "";
                                      quantityController.text = "";
                                      currencyController.text = "";
                                      unitController.text = "";
                                      quantityReceiveController.text = "";
                                    });
                                    getAllDataFromPONumber(
                                        sendSelectedsparemodel, val);
                                  },
                                  value: selectedPO != '' ? selectedPO : null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a po number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Machine Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                DropdownSearch<String>.multiSelection(
                                  items: const [], // Add your items here
                                  selectedItems: selectedMachineItems,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      hintText: "Please Select Machine Name",
                                      counterText: '',
                                      contentPadding: EdgeInsets.all(10),
                                      fillColor: const Color.fromARGB(
                                              255, 196, 214, 176)
                                          .withOpacity(0.5),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      errorText: selectedMachineItems.isEmpty
                                          ? 'Please select at least one machine'
                                          : null,
                                    ),
                                  ),
                                  onChanged: (List<String> value) {
                                    setState(() {
                                      selectedMachineItems = value;
                                    });
                                  },
                                  enabled:
                                      false, // Set to true to allow selection
                                  clearButtonProps: const ClearButtonProps(
                                    isVisible: true,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Spare Part Brand Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                TextFormField(
                                  controller: sparePartBrandController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText:
                                        "Please Enter Spare Part Brand Name",
                                    fillColor: const Color.fromARGB(
                                            255, 196, 214, 176)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly: true,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText:
                                            "Please Enter Spare Part Brand Name",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Specification",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: specificationController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Specification",
                                    fillColor: const Color.fromARGB(
                                            255, 196, 214, 176)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  readOnly: true,
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Specification",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Quantity In PCS(In PO)",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Quantity",
                                    fillColor: const Color.fromARGB(
                                            255, 196, 214, 176)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly: true,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Quantity",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Quantity In PCS(Receive)",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: quantityReceiveController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Quantity",
                                    fillColor: const Color.fromARGB(
                                            255, 196, 214, 176)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly: quantityController.text != ""
                                      ? false
                                      : true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Quantity';
                                    } else if (int.parse(value) >
                                            int.parse(
                                                quantityController.text) ||
                                        int.parse(value) < 1) {
                                      return 'Please Enter Valid Quantity';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Units",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: unitController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Units",
                                    fillColor: const Color.fromARGB(
                                            255, 196, 214, 176)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly: true,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Units",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Currency",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                TextFormField(
                                  controller: currencyController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Currency",
                                    fillColor: const Color.fromARGB(
                                            255, 196, 214, 176)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly: true,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Currency",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Price",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Price",
                                    fillColor: const Color.fromARGB(
                                            255, 196, 214, 176)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly: true,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Price",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Total Cost",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: totalCostController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Total Cost",
                                    fillColor: const Color.fromARGB(
                                            255, 196, 214, 176)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly: true,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Total Cost",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Invoice Number",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: invoiceNumberController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Invoice Number",
                                    fillColor: const Color.fromARGB(
                                            255, 196, 214, 176)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText:
                                            "Please Enter Invoice Number",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Upload Invoice Pdf",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: invoicePdfController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                          hintText: "Please Select Invoice Pdf",
                                          fillColor: Color.fromARGB(
                                                  255, 196, 214, 176)
                                              .withOpacity(
                                                  0.5), // Your desired color
                                          filled: true,
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              _pickcocPDF();
                                            },
                                            icon: const Icon(
                                                Icons.open_in_browser),
                                          ),
                                          counterText: ''),
                                  style: AppStyles.textInputTextStyle,
                                  maxLines: 1,
                                  readOnly: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Select Invoice Pdf";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                _isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : AppButton(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.white,
                                          fontSize: 16,
                                        ),
                                        onTap: () {
                                          AppHelper.hideKeyboard(context);
                                          if (_registerFormKey.currentState!
                                              .validate()) {
                                            _registerFormKey.currentState!
                                                .save();
                                            print("bhanuuuuuu");
                                            createData();
                                          }
                                        },
                                        label: "Save",
                                        organization: '',
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder:
                                                        (BuildContext
                                                                context) =>
                                                            WelcomePage()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      },
                                      child: const Text(
                                        'BACK',
                                        style: TextStyle(
                                            fontFamily: appFontFamily,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.redColor),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Powered By Gautam Solar Pvt. Ltd.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: appFontFamily,
                                          color: AppColors.greyColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
          ),
          // floatingActionButton: (status == "Pending") ? null : _getFAB(),
          // bottomNavigationBar: Container(
          //   height: 60,
          //   decoration: const BoxDecoration(
          //     color: Color.fromARGB(255, 245, 203, 19),
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(20),
          //       topRight: Radius.circular(20),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       InkWell(
          //           onTap: () {
          //             Navigator.of(context).pushReplacement(MaterialPageRoute(
          //                 builder: (BuildContext context) =>
          //                     department == 'IPQC' &&
          //                             designation != 'Super Admin'
          //                         ? IpqcPage()
          //                         : WelcomePage()));
          //           },
          //           child: Image.asset(
          //               home
          //                   ? AppAssets.icHomeSelected
          //                   : AppAssets.icHomeUnSelected,
          //               height: 25)),
          //       const SizedBox(
          //         width: 8,
          //       ),
          //       InkWell(
          //           onTap: () {
          //             // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //             //     builder: (BuildContext context) => AddEditProfile()));
          //           },
          //           child: Image.asset(
          //               user
          //                   ? AppAssets.imgSelectedPerson
          //                   : AppAssets.imgPerson,
          //               height: 25)),
          //       const SizedBox(
          //         width: 8,
          //       ),
          //       InkWell(
          //           child: Image.asset(
          //               face
          //                   ? AppAssets.icSearchSelected
          //                   : AppAssets.icSearchUnSelected,
          //               height: 25)),
          //       const SizedBox(
          //         width: 8,
          //       ),
          //       InkWell(
          //           onTap: () {
          //             Navigator.of(context).pushReplacement(MaterialPageRoute(
          //                 builder: (BuildContext context) => PublicDrawer()));
          //           },
          //           child: Image.asset(
          //               menu ? AppAssets.imgSelectedMenu : AppAssets.imgMenu,
          //               height: 25)),
          //     ],
          //   ),
          // ),
        );
      }),
    );
  }
}
