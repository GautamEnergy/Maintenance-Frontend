import 'dart:convert';
import 'dart:io';
import 'package:Maintenance/CommonDrawer.dart';
import 'package:Maintenance/Welcomepage.dart';
import 'package:Maintenance/components/app_button_widget.dart';
import 'package:Maintenance/components/app_loader.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:dio/src/response.dart' as Response;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class addParty extends StatefulWidget {
  final String? id;
  addParty({this.id});
  @override
  _addPartyState createState() => _addPartyState();
}

class _addPartyState extends State<addParty> {
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController partyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController gstNumberController = TextEditingController();

  List<TextEditingController> sampleAControllers = [];
  List<TextEditingController> sampleBControllers = [];

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
  String selectedbrand = "";

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
    isCycleTimeTrue = true; // Set initial value
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
  }

  String extractPanFromGst(String gstNumber) {
    if (gstNumber.length != 15) {
      setState(() {
        panNumberController.text = "";
      });
      throw FormatException("Invalid GST number length");
    }

    // Extracting the PAN number part (3rd to 12th character)
    String panNumber = gstNumber.substring(2, 12);

    // Optional: Validate the PAN number format
    RegExp panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(panNumber)) {
      setState(() {
        panNumberController.text = "";
      });
      throw FormatException("Invalid PAN number format");
    }
    print("PAN:");
    print(panNumber);
    setState(() {
      panNumberController.text = panNumber;
    });
    return panNumber;
  }

  // Future _get() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     if (widget.id != '' && widget.id != null) {
  //       _isLoading = true;
  //     }
  //     site = prefs.getString('site')!;
  //   });
  //   final AllSolarData = ((site!) + 'IPQC/GetSpecificSolderingPeelTest');
  //   final allSolarData = await http.post(
  //     Uri.parse(AllSolarData),
  //     body: jsonEncode(<String, String>{
  //       "JobCardDetailId": widget.id ?? '',
  //       "token": token!
  //     }),
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );

  //   setState(() {
  //     _isLoading = false;
  //   });

  //   var resBody = json.decode(allSolarData.body);

  //   if (mounted) {
  //     setState(() {
  //       if (resBody != '') {
  //         status = resBody['response']['Status'] ?? '';
  //         dateOfQualityCheck = resBody['response']['Date'] ?? '';
  //         dateController.text = resBody['response']['Date'] != ''
  //             ? DateFormat("EEE MMM dd, yyyy").format(
  //                 DateTime.parse(resBody['response']['Date'].toString()))
  //             : '';
  //         selectedShift = resBody['response']['Shift'] ?? "";
  //         LineController.text = resBody['response']['Line'] ?? "";
  //         operatornameController.text =
  //             resBody['response']['OperatorName'] ?? '';
  //         selectedtype = resBody['response']['BussingStage'] ?? "";
  //         ribbonWidthController.text = resBody['response']['RibbonSize'] ?? '';
  //         busbarWidthController.text = resBody['response']['BusBarWidth'] ?? '';
  //         ribbonController.text =
  //             resBody['response']['Sample1Length'].toString() ?? '';

  //         sampleAInputtext = resBody['response']['Sample1'] ?? [];
  //         numberOfStringers = resBody['response']['Sample1Length'] ?? 0;

  //         sampleBInputText = resBody['response']['Sample2'] ?? [];
  //         addControllers(numberOfStringers);

  //         for (int i = 0; i < numberOfStringers; i++) {
  //           sampleAControllers.add(TextEditingController());
  //           sampleBControllers.add(TextEditingController());
  //           if (widget.id != "" &&
  //               widget.id != null &&
  //               sampleAInputtext.length > 0 &&
  //               sampleBInputText.length > 0) {
  //             sampleAControllers[i].text =
  //                 sampleAInputtext[i]["sampleAControllers${i + 1}"];
  //             sampleBControllers[i].text =
  //                 sampleBInputText[i]["sampleBControllers${i + 1}"];
  //           }
  //         }

  //         remarkController.text = resBody['response']['Remarks'] ?? '';
  //         referencePdfController.text = resBody['response']['Pdf'] ?? '';
  //       }
  //     });
  //   }
  // }

  // Future setApprovalStatus() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   FocusScope.of(context).unfocus();
  //   final url = (site! + "IPQC/UpdateSolderingPeelTestStatus");

  //   var params = {
  //     "token": token,
  //     "CurrentUser": personid,
  //     "ApprovalStatus": approvalStatus,
  //     "JobCardDetailId": widget.id ?? ""
  //   };

  //   var response = await http.post(
  //     Uri.parse(url),
  //     body: json.encode(params),
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     var objData = json.decode(response.body);
  //     if (objData['success'] == false) {
  //       Toast.show("Please Try Again.",
  //           duration: Toast.lengthLong,
  //           gravity: Toast.center,
  //           backgroundColor: AppColors.redColor);
  //     } else {
  //       Toast.show("Busbar Test $approvalStatus .",
  //           duration: Toast.lengthLong,
  //           gravity: Toast.center,
  //           backgroundColor: AppColors.blueColor);
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (BuildContext context) => IpqcTestList()));
  //     }
  //   } else {
  //     Toast.show("Error In Server",
  //         duration: Toast.lengthLong, gravity: Toast.center);
  //   }
  // }

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

  Future createData() async {
    var data = {
      "PartyName": partyNameController.text,
      "GSTNumber": gstNumberController.text,
      "PANNumber": panNumberController.text,
      "Address": addressController.text,
      "Country": countryController.text,
      "State": stateController.text,
      "Email": emailController.text,
      "MobileNumber": mobileNumberController.text,
      "Status": "Active",
      "CurrentUser": personid
    };

    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    final url = (site! + "Maintenance/AddParty");

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
        _isLoading = false;
      });

      if (objData['success'] == false) {
        Toast.show(objData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.redColor);
      } else {
        Toast.show("Party Added Successfully.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
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

// ***************** Done Send the Data *******************************

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
                return PublicDrawer();
              }));
            },
          ),
          body: _isLoading
              ? AppLoader()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 245, 190, 8)
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
                                      "Add New Party",
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
                                  "Party Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: partyNameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Party Name",
                                    fillColor: Color.fromARGB(
                                            255, 243, 220, 142)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Party Name",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Address",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: addressController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Address",
                                    fillColor: Color.fromARGB(
                                            255, 243, 220, 142)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Address",
                                      ),
                                    ],
                                  ),
                                ),

                                //***************   Details   ********************
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Country",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: countryController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Country",
                                    fillColor: Color.fromARGB(
                                            255, 243, 220, 142)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Country",
                                      ),
                                    ],
                                  ),
                                ),

                                //***************   Details   ********************
                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "State",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: stateController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter State",
                                    fillColor: Color.fromARGB(
                                            255, 243, 220, 142)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter State",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Email",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Email",
                                    fillColor: Color.fromARGB(
                                            255, 243, 220, 142)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Email",
                                      ),
                                      EmailValidator(
                                          errorText:
                                              "Please Enter a valid Email"),
                                    ],
                                  ),
                                ),

                                //***************   Details   ********************
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Mobile Number",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: mobileNumberController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Mobile Number",
                                    fillColor: Color.fromARGB(
                                            255, 243, 220, 142)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        10), // Limits the input to 10 characters
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Allows only digits
                                  ],
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Mobile Number",
                                      ),
                                      MinLengthValidator(
                                        10,
                                        errorText:
                                            "Please Enter Valid Mobile Number",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  "GST Number",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: gstNumberController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter GST Number",
                                    fillColor: Color.fromARGB(
                                            255, 243, 220, 142)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter GST Number",
                                      ),
                                      PatternValidator(
                                        r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
                                        errorText:
                                            "Please Enter a Valid GST Number",
                                      ),
                                    ],
                                  ),
                                  onChanged: (value) {
                                    // Call your function here
                                    extractPanFromGst(value);
                                  },
                                ),

                                //***************   Details   ********************
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "PAN Number",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: panNumberController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter PAN Number",
                                    fillColor: Color.fromARGB(
                                            255, 243, 220, 142)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter PAN Number",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),

                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                AppButton(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                    fontSize: 16,
                                  ),
                                  onTap: () {
                                    AppHelper.hideKeyboard(context);
                                    if (_registerFormKey.currentState!
                                        .validate()) {
                                      _registerFormKey.currentState!.save();
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
                                                            PublicDrawer()),
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
                  )),
        );
      }),
    );
  }
}
