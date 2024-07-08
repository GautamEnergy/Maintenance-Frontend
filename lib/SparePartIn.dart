import 'dart:convert';
import 'dart:io';
import 'package:Maintenance/Welcomepage.dart';
import 'package:Maintenance/components/app_button_widget.dart';
import 'package:Maintenance/components/appbar.dart';
import 'package:Maintenance/constant/app_assets.dart';
import 'package:Maintenance/constant/app_color.dart';
import 'package:Maintenance/constant/app_fonts.dart';
import 'package:Maintenance/constant/app_helper.dart';
import 'package:Maintenance/constant/app_styles.dart';

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
  TextEditingController dateController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  TextEditingController LineController = TextEditingController();
  TextEditingController operatornameController = TextEditingController();
  TextEditingController bussingStageController = TextEditingController();
  TextEditingController ribbonWidthController = TextEditingController();
  TextEditingController busbarWidthController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController specificationController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController transportationPriceController = TextEditingController();
  TextEditingController dutyAmountController = TextEditingController();
  TextEditingController totalCostController = TextEditingController();
  TextEditingController machineModelNumberController = TextEditingController();

  TextEditingController ribbonController = TextEditingController();
  TextEditingController referencePdfController = new TextEditingController();

  List<TextEditingController> sampleAControllers = [];
  List<TextEditingController> sampleBControllers = [];
  List MachineList = [];
  List machineModelList = [
    {"key": 'A234', "value": 'A234'},
    {"key": 'B235', "value": 'B235'},
  ];
  List sparePartsList = [
    {"key": 'Screw', "value": 'Screw'},
    {"key": 'Buffing', "value": 'Buffing'},
  ];
  List sparePartModelList = [
    {"key": 'G102', "value": 'G102'},
    {"key": 'G10', "value": 'G103'},
  ];
  List brandList = [
    {"key": 'BMW', "value": 'BMW'},
    {"key": 'Bugati', "value": 'Bugati'},
  ];

  List currencyList = [
    {"key": 'INR', "value": 'INR'},
    {"key": 'CNY', "value": 'CNY'},
  ];

  bool menu = false, user = false, face = false, home = false;
  int numberOfStringers = 0;
  bool _isLoading = false;
  String setPage = '', pic = '', site = '', personid = '';
  String invoiceDate = '';
  String date = '';
  String dateOfQualityCheck = '';
  bool? isCycleTimeTrue;
  bool? isBacksheetCuttingTrue;
  List<int>? referencePdfFileBytes;
  String selectedmachine = "";
  String selectedmachinemodel = "";
  String selectedspare = "";
  String selectedsparemodel = "";
  String selectedCurrency = "";
  String selectedbrand = "";
  List Sample1Controllers = [];
  List Sample2Controllers = [];
  List sampleAInputtext = [];
  List sampleBInputText = [];
  late String sendStatus;
  String status = '',
      jobCarId = '',
      approvalStatus = "Approved",
      designation = '',
      token = '',
      department = '';
  final _dio = Dio();
  List data = [];

  Response.Response? _response;

  void addControllers(int count) {
    for (int i = 0; i < count; i++) {
      sampleAControllers.add(TextEditingController());
      sampleBControllers.add(TextEditingController());
    }
  }

  @override
  void initState() {
    super.initState();
    store();

    dutyAmountController.addListener(updateTotalCost);
    priceController.addListener(updateTotalCost);
    transportationPriceController.addListener(updateTotalCost);
  }

  @override
  void dispose() {
    dutyAmountController.removeListener(updateTotalCost);
    priceController.removeListener(updateTotalCost);
    transportationPriceController.removeListener(updateTotalCost);

    dutyAmountController.dispose();
    priceController.dispose();
    transportationPriceController.dispose();
    totalCostController.dispose();

    super.dispose();
  }

  void updateTotalCost() {
    double priceAmount = 0.0;
    double dutyAmount = 0.0;
    double transportationPrice = 0.0;

    // Check if the text fields are not empty before parsing
    if (priceController.text.isNotEmpty) {
      priceAmount = double.parse(priceController.text);
    }

    if (dutyAmountController.text.isNotEmpty) {
      dutyAmount = double.parse(dutyAmountController.text);
    }

    if (transportationPriceController.text.isNotEmpty) {
      transportationPrice = double.parse(transportationPriceController.text);
    }

    double totalCost = priceAmount + dutyAmount + transportationPrice;

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
    getMachineListData();
  }

  getMachineListData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Maintenance/MachineDetailById');

    http.get(
      Uri.parse(url),
      // body: json.encode({"MachineId": ""}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var machineBody = jsonDecode(response.body);
        setState(() {
          MachineList = machineBody;
          // options = machineList
          //     .map((item) => ValueItem(
          //         label: item['MachineName']!, value: item['MachineId']!))
          //     .toList();
        });
      }
    });
  }

  getMachineModelNumber(machineId) async {
    print("machineBody.Idddddddd.");
    print(machineId);
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Maintenance/GetMachineModelNumber');

    http.post(
      Uri.parse(url),
      body: json.encode({"MachineId": machineId}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var machineBody = jsonDecode(response.body);
        print("machineBody..");
        print(machineBody);
        setState(() {
          machineModelNumberController.text =
              machineBody[0]['MachineModelNumber'];
        });
      }
    });
  }

  // Future<void> _pickReferencePDF() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );

  //   if (result != null) {
  //     File pdffile = File(result.files.single.path!);
  //     setState(() {
  //       referencePdfFileBytes = pdffile.readAsBytesSync();
  //       referencePdfController.text = result.files.single.name;
  //     });
  //   } else {
  //     // User canceled the file picker
  //   }
  // }

  // Future createData() async {
  //   var data = {
  //     "Type": "Busbar",
  //     "JobCardDetailId": jobCarId != '' && jobCarId != null
  //         ? jobCarId
  //         : widget.id != '' && widget.id != null
  //             ? widget.id
  //             : '',
  //     "DocNo": "GSPL/IPQC/GP/005",
  //     "RevNo": "1.0 & 12.08.2023",
  //     "RibbonMake": "",
  //     "CellSize": "",
  //     "RibbonSize": ribbonWidthController.text,
  //     "Date": dateOfQualityCheck,
  //     "Line": LineController.text,
  //     "Shift": selectedShift,
  //     "MachineNo": "",
  //     "OperatorName": operatornameController.text,
  //     "CellMake": "",
  //     "Status": sendStatus,
  //     "BussingStage": selectedtype,
  //     "BusBarWidth": busbarWidthController.text,
  //     "CreatedBy": personid,
  //     "Remarks": remarkController.text,
  //     "Sample1Length": ribbonController.text,
  //     "Samples": {"Sample1": Sample1Controllers, "Sample2": Sample2Controllers}
  //   };

  //   setState(() {
  //     _isLoading = true;
  //   });
  //   FocusScope.of(context).unfocus();

  //   final url = (site! + "IPQC/AddSolderingPeelTest");

  //   final prefs = await SharedPreferences.getInstance();

  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: json.encode(data),
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     var objData = json.decode(response.body);
  //     setState(() {
  //       jobCarId = objData['UUID'];

  //       _isLoading = false;
  //     });

  //     print(objData['UUID']);
  //     if (objData['success'] == false) {
  //       Toast.show(objData['message'],
  //           duration: Toast.lengthLong,
  //           gravity: Toast.center,
  //           backgroundColor: AppColors.redColor);
  //     } else {
  //       if (sendStatus == 'Pending') {
  //         uploadPDF((referencePdfFileBytes ?? []));
  //       } else {
  //         Toast.show("Data has been saved.",
  //             duration: Toast.lengthLong,
  //             gravity: Toast.center,
  //             backgroundColor: AppColors.blueColor);
  //       }
  //     }
  //   } else {
  //     Toast.show("Error In Server",
  //         duration: Toast.lengthLong, gravity: Toast.center);
  //   }
  // }

  // uploadPDF(List<int> referenceBytes) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   final prefs = await SharedPreferences.getInstance();
  //   site = prefs.getString('site')!;

  //   var currentdate = DateTime.now().microsecondsSinceEpoch;
  //   var formData = FormData.fromMap({
  //     "JobCardDetailId": jobCarId,
  //     "SolderingPdf": MultipartFile.fromBytes(
  //       referenceBytes,
  //       filename:
  //           (referencePdfController.text + (currentdate.toString()) + '.pdf'),
  //       contentType: MediaType("application", 'pdf'),
  //     ),
  //   });

  //   _response =
  //       await _dio.post((site! + 'IPQC/UploadSolderingPeelTestPdf'), // Prod

  //           options: Options(
  //             contentType: 'multipart/form-data',
  //             followRedirects: false,
  //             validateStatus: (status) => true,
  //           ),
  //           data: formData);

  //   try {
  //     if (_response?.statusCode == 200) {
  //       setState(() {
  //         _isLoading = false;
  //       });

  //       Toast.show("Busbar Test Completed.",
  //           duration: Toast.lengthLong,
  //           gravity: Toast.center,
  //           backgroundColor: AppColors.blueColor);
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (BuildContext context) => IpqcTestList()));
  //     } else {
  //       Toast.show("Error In Server",
  //           duration: Toast.lengthLong, gravity: Toast.center);
  //     }
  //   } catch (err) {
  //     print("Error");
  //   }
  // }

  // Widget _getFAB() {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 70),
  //     child: FloatingActionButton(
  //       onPressed: () {
  //         Sample1Controllers = [];

  //         for (int i = 0; i < numberOfStringers; i++) {
  //           Sample1Controllers.add(
  //               {"sampleAControllers${i + 1}": sampleAControllers[i].text});
  //         }

  //         Sample2Controllers = [];

  //         for (int i = 0; i < numberOfStringers; i++) {
  //           Sample2Controllers.add(
  //               {"sampleBControllers${i + 1}": sampleBControllers[i].text});
  //         }
  //         if (status != 'Pending') {
  //           setState(() {
  //             sendStatus = 'Inprogress';
  //           });
  //           createData();
  //         }
  //       },
  //       child: ClipOval(
  //         child: Image.asset(
  //           AppAssets.save,
  //           height: 70,
  //           width: 60,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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

                                // **************** Document Number *******************
                                const SizedBox(
                                  height: 35,
                                ),

                                Text(
                                  "Machine Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),

                                DropdownButtonFormField<String>(
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Select Machine Name",
                                    counterText: '',
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  items: MachineList.map((label) =>
                                      DropdownMenuItem(
                                        child: Text(
                                          label['MachineName'],
                                          style: AppStyles.textInputTextStyle,
                                        ),
                                        value: label['MachineId'].toString(),
                                      )).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedmachine = val!;
                                    });
                                    getMachineModelNumber(val!);
                                  },
                                  value: selectedmachine != ''
                                      ? selectedmachine
                                      : null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a Machine Name';
                                    }
                                    return null; // Return null if the validation is successful
                                  },
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Machine Model Number",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),

                                TextFormField(
                                  controller: machineModelNumberController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText:
                                        "Please Enter Machine Model Number",
                                    fillColor: Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly: true,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText:
                                            "Please Enter Machine Model Number",
                                      ),
                                    ],
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

                                DropdownButtonFormField<String>(
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Select Spare Part Name",
                                    counterText: '',
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  items: sparePartsList
                                      .map((label) => DropdownMenuItem(
                                            child: Text(
                                              label['key'],
                                              style:
                                                  AppStyles.textInputTextStyle,
                                            ),
                                            value: label['value'].toString(),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedspare = val!;
                                    });
                                  },
                                  value: selectedspare != ''
                                      ? selectedspare
                                      : null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select Spare Part Name';
                                    }
                                    return null; // Return null if the validation is successful
                                  },
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

                                DropdownButtonFormField<String>(
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Select Brand Name",
                                    counterText: '',
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  items: brandList
                                      .map((label) => DropdownMenuItem(
                                            child: Text(
                                              label['key'],
                                              style:
                                                  AppStyles.textInputTextStyle,
                                            ),
                                            value: label['value'].toString(),
                                          ))
                                      .toList(),
                                  onChanged:
                                      designation != "QC" && status == "Pending"
                                          ? null
                                          : (val) {
                                              setState(() {
                                                selectedbrand = val!;
                                              });
                                            },
                                  value: selectedbrand != ''
                                      ? selectedbrand
                                      : null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a Brand Name';
                                    }
                                    return null; // Return null if the validation is successful
                                  },
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

                                DropdownButtonFormField<String>(
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText:
                                        "Please Select Spare Part Model No",
                                    counterText: '',
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  items: sparePartModelList
                                      .map((label) => DropdownMenuItem(
                                            child: Text(
                                              label['key'],
                                              style:
                                                  AppStyles.textInputTextStyle,
                                            ),
                                            value: label['value'].toString(),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedsparemodel = val!;
                                    });
                                  },
                                  value: selectedsparemodel != ''
                                      ? selectedsparemodel
                                      : null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select Spare Part Model No';
                                    }
                                    return null; // Return null if the validation is successful
                                  },
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "Specification",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: specificationController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Specification",
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
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
                                  "Quantity In PCS",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Quantity",
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
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
                                  "Units",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: unitController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Units",
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly:
                                      status == 'Pending' && designation != "QC"
                                          ? true
                                          : false,
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

                                DropdownButtonFormField<String>(
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Select Currency",
                                    counterText: '',
                                    contentPadding: EdgeInsets.all(10),
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  items: currencyList
                                      .map((label) => DropdownMenuItem(
                                            child: Text(
                                              label['key'],
                                              style:
                                                  AppStyles.textInputTextStyle,
                                            ),
                                            value: label['value'].toString(),
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedCurrency = val!;
                                    });
                                  },
                                  value: selectedCurrency != ''
                                      ? selectedCurrency
                                      : null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select Currency';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Price",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Price",
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
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
                                  "Transportation Price",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: transportationPriceController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText:
                                        "Please Enter Transportation Price",
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText:
                                            "Please Enter Transportation Price",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Duty Amount",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: dutyAmountController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Duty Amount",
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Duty Amount",
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
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: totalCostController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Total Cost",
                                    fillColor: Color.fromARGB(
                                            255, 195, 230, 155)
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
                                          }
                                        },
                                        label: "Save",
                                        organization: '',
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
