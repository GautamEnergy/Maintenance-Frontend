import 'dart:convert';
import 'dart:io';
import 'package:QCM/Ipqc.dart';
import 'package:QCM/components/app_loader.dart';
import 'package:QCM/components/appbar.dart';
import 'package:QCM/ipqcTestList.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:QCM/components/app_button_widget.dart';
import 'package:http/http.dart' as http;
import 'package:dio/src/response.dart' as Response;
import 'package:QCM/constant/app_assets.dart';
import 'package:QCM/constant/app_color.dart';
import 'package:QCM/constant/app_fonts.dart';
import 'package:QCM/constant/app_helper.dart';
import 'package:QCM/constant/app_styles.dart';
import 'package:toast/toast.dart';

class ipqcSelant extends StatefulWidget {
  final String? id;
  ipqcSelant({this.id});
  @override
  _ipqcSelantState createState() => _ipqcSelantState();
}

class _ipqcSelantState extends State<ipqcSelant> {
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController shiftController = TextEditingController();

  TextEditingController LongAController = TextEditingController();
  TextEditingController LongBController = TextEditingController();
  TextEditingController LongDController = TextEditingController();

  TextEditingController ShortAController = TextEditingController();
  TextEditingController ShortBController = TextEditingController();
  TextEditingController ShortDController = TextEditingController();

  TextEditingController JunctionAController = TextEditingController();
  TextEditingController JunctionBController = TextEditingController();
  TextEditingController JunctionDController = TextEditingController();

  TextEditingController BaseAController = TextEditingController();
  TextEditingController CatalystBController = TextEditingController();
  TextEditingController RatioController = TextEditingController();

  TextEditingController referencePdfController = new TextEditingController();

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
  String selectedShift = "Day Shift";
  String sendStatus = "";
  String status = '',
      jobCarId = '',
      approvalStatus = "Approved",
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
    isCycleTimeTrue = true;

    LongAController.addListener(calculateDifference);
    LongBController.addListener(calculateDifference);

    ShortAController.addListener(calculateDifference);
    ShortBController.addListener(calculateDifference);

    JunctionAController.addListener(calculateDifference);
    JunctionBController.addListener(calculateDifference);
    // setState(() {

    // });
  }

  void calculateDifference() {
    // Get values from controllers
    double a = double.tryParse(LongAController.text) ?? 0;
    double b = double.tryParse(LongBController.text) ?? 0;

    double c = double.tryParse(ShortAController.text) ?? 0;
    double d = double.tryParse(ShortBController.text) ?? 0;

    double j = double.tryParse(JunctionAController.text) ?? 0;
    double k = double.tryParse(JunctionBController.text) ?? 0;

    // Calculate difference
    double difference = b - a;
    double Shortdifference = d - c;
    double Junctiondifference = k - j;

    // Update the Difference Weight field
    LongDController.text = difference.toString();
    ShortDController.text = Shortdifference.toString();
    JunctionDController.text = Junctiondifference.toString();
  }

  @override
  void dispose() {
    // Clean up listeners when the widget is disposed
    LongAController.removeListener(calculateDifference);
    LongBController.removeListener(calculateDifference);

    ShortAController.removeListener(calculateDifference);
    ShortBController.removeListener(calculateDifference);

    JunctionAController.removeListener(calculateDifference);
    JunctionBController.removeListener(calculateDifference);
    super.dispose();
  }

  // ************  Send the Data where will be Used to Backend *****************

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
    _get();
  }

  Future _get() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.id != '' && widget.id != null) {
        _isLoading = true;
      }
      site = prefs.getString('site')!;
    });
    final AllSolarData = ((site!) + 'IPQC/GetSpecificSealentWeight');
    final allSolarData = await http.post(
      Uri.parse(AllSolarData),
      body: jsonEncode(<String, String>{
        "JobCardDetailId": widget.id ?? '',
        "token": token!
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      _isLoading = false;
    });
    var resBody = json.decode(allSolarData.body);

    if (mounted) {
      setState(() {
        if (resBody != '') {
          status = resBody['response']['Status'] ?? '';
          dateOfQualityCheck = resBody['response']['Date'] ?? '';
          dateController.text = resBody['response']['Date'] != ''
              ? DateFormat("EEE MMM dd, yyyy").format(
                  DateTime.parse(resBody['response']['Date'].toString()))
              : '';
          selectedShift = resBody['response']['Shift'] ?? '';
          // Long Frame
          LongAController.text =
              resBody['response']['LongFrame_WithoutSealant'] ?? '';
          LongBController.text =
              resBody['response']['LongFrame_WithSealant'] ?? '';
          LongDController.text =
              resBody['response']['LongFrame_DiffWeight'] ?? '';
          // Short Frame
          ShortAController.text =
              resBody['response']['ShortFrame_WithoutSealant'] ?? '';
          ShortBController.text =
              resBody['response']['ShortFrame_WithSealant'] ?? '';
          ShortDController.text =
              resBody['response']['ShortFrame_DiffWeight'] ?? '';
          // Junction Frame
          JunctionAController.text =
              resBody['response']['JunctionBox_WithoutSealant'] ?? '';
          JunctionBController.text =
              resBody['response']['JunctionBox_WithSealant'] ?? '';
          JunctionDController.text =
              resBody['response']['JunctionBox_DiffWeight'] ?? '';
          // Potting
          BaseAController.text = resBody['response']['BaseWeight'] ?? '';
          CatalystBController.text =
              resBody['response']['CatalystWeight'] ?? '';
          RatioController.text = resBody['response']['Ratio'] ?? '';

          referencePdfController.text = resBody['response']['PreLamPdf'] ?? '';
        }
      });
    }
  }

  Future setApprovalStatus() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    final url = (site! + "IPQC/UpdateSealentStatus");

    var params = {
      "token": token,
      "CurrentUser": personid,
      "ApprovalStatus": approvalStatus,
      "JobCardDetailId": widget.id ?? ""
    };

    var response = await http.post(
      Uri.parse(url),
      body: json.encode(params),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      var objData = json.decode(response.body);
      if (objData['success'] == false) {
        Toast.show("Please Try Again.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.redColor);
      } else {
        Toast.show("Sealent Test $approvalStatus .",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => IpqcTestList()));
      }
    } else {
      Toast.show("Error In Server",
          duration: Toast.lengthLong, gravity: Toast.center);
    }
  }

  Future<void> _pickReferencePDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File pdffile = File(result.files.single.path!);
      setState(() {
        referencePdfFileBytes = pdffile.readAsBytesSync();
        referencePdfController.text = result.files.single.name;
      });
    } else {
      // User canceled the file picker
    }
  }

  Future createData() async {
    var data = {
      "Type": "Sealent",
      "JobCardDetailId": jobCarId != '' && jobCarId != null
          ? jobCarId
          : widget.id != '' && widget.id != null
              ? widget.id
              : '',
      "Status": sendStatus,
      "CreatedBy": personid,
      "DocNo": "GSPL/IPQC/SP/012",
      "RevNo": "1.0/12.08.2023",
      "Date": dateOfQualityCheck,
      "Shift": selectedShift,
      "Stages": [
        {
          "Stage": "Long Frame",
          "WithoutSealant": LongAController.text,
          "WithSealant": LongBController.text,
          "DifferenceWeight": LongDController.text,
          "BaseWeight": BaseAController.text,
          "CatalystWeight": CatalystBController.text,
          "Ratio": RatioController.text
        },
        {
          "Stage": "Short Frame",
          "WithoutSealant": ShortAController.text,
          "WithSealant": ShortBController.text,
          "DifferenceWeight": ShortDController.text,
          "BaseWeight": BaseAController.text,
          "CatalystWeight": CatalystBController.text,
          "Ratio": RatioController.text
        },
        {
          "Stage": "Junction Box",
          "WithoutSealant": JunctionAController.text,
          "WithSealant": JunctionBController.text,
          "DifferenceWeight": JunctionDController.text,
          "BaseWeight": BaseAController.text,
          "CatalystWeight": CatalystBController.text,
          "Ratio": RatioController.text
        },
      ]
    };
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;
    final url = (site! + "IPQC/AddSealentWeight");
    var response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print("Bhanuu bhai");
    print(response.statusCode);
    if (response.statusCode == 200) {
      var objData = json.decode(response.body);
      setState(() {
        jobCarId = objData['UUID'];

        _isLoading = false;
      });
      if (objData['success'] == false) {
        Toast.show(objData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.redColor);
      } else {
        if (sendStatus == 'Pending') {
          uploadPDF((referencePdfFileBytes ?? []));
        } else {
          Toast.show("Data has been saved.",
              duration: Toast.lengthLong,
              gravity: Toast.center,
              backgroundColor: AppColors.blueColor);
        }
      }
    } else {
      Toast.show("Error In Server",
          duration: Toast.lengthLong, gravity: Toast.center);
    }
  }

  uploadPDF(List<int> referenceBytes) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    var formData = FormData.fromMap({
      "JobCardDetailId": jobCarId,
      "SealentWeightPdf": MultipartFile.fromBytes(
        referenceBytes,
        filename:
            (referencePdfController.text + (currentdate.toString()) + '.pdf'),
        contentType: MediaType("application", 'pdf'),
      ),
    });

    _response = await _dio.post((site! + 'IPQC/UploadSealentWeightPdf'), // Prod

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

        Toast.show("Sealent Test Completed.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => IpqcTestList()));
      } else {
        Toast.show("Error In Server",
            duration: Toast.lengthLong, gravity: Toast.center);
      }
    } catch (err) {
      print("Error");
    }
  }

  Widget _getFAB() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: FloatingActionButton(
        onPressed: () {
          if (status != 'Pending') {
            setState(() {
              sendStatus = 'Inprogress';
            });
            createData();
          }
        },
        child: ClipOval(
          child: Image.asset(
            AppAssets.save,
            height: 70,
            width: 60,
          ),
        ),
      ),
    );
  }
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
                return widget.id != "" && widget.id != null
                    ? IpqcTestList()
                    : IpqcPage();
              }));
            },
          ),
          body: _isLoading
              ? AppLoader()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: setPage == ''
                      ? Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: [
                            SingleChildScrollView(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                          "Checksheet For Sealant Weight Measurement",
                                          style: TextStyle(
                                            fontSize: 27,
                                            color:
                                                Color.fromARGB(255, 56, 57, 56),
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
                                    Row(
                                      children: [
                                        Text(
                                          'Document No : ',
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'GSPL/IPQC/SP/012',
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                      ],
                                    ),

                                    // *************************** Revisional Number ********************
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Rev.No./Dated : ',
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Ver.  1.0 & 12-08-2023',
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                      ],
                                    ),

                                    // ****************** Date *****************************************
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Date",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: dateController,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Date",
                                        counterText: '',
                                        suffixIcon: Icon(Icons.calendar_month),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      onTap: () async {
                                        if (status != 'Pending') {
                                          DateTime date = DateTime(2021);
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          date = (await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now(),
                                          ))!;
                                          dateController.text =
                                              DateFormat("EEE MMM dd, yyyy")
                                                  .format(
                                            DateTime.parse(date.toString()),
                                          );
                                          setState(() {
                                            dateOfQualityCheck =
                                                DateFormat("yyyy-MM-dd").format(
                                              DateTime.parse(date.toString()),
                                            );
                                          });
                                        }
                                      },
                                      validator: MultiValidator(
                                        [
                                          RequiredValidator(
                                            errorText: "Please Enter Date",
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),

                                    // ************************************* Shift *********************
                                    Text(
                                      "Shift",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: selectedShift,
                                      onChanged: designation != "QC" &&
                                              status == "Pending"
                                          ? null
                                          : (String? newValue) {
                                              setState(() {
                                                selectedShift = newValue!;
                                                shiftController.text =
                                                    selectedShift!;
                                              });
                                            },
                                      items: <String>[
                                        'Night Shift',
                                        'Day Shift'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Select Shift",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Select Shift";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),

                                    //  *******************************************   Sealant Weight Measurement  ********************

                                    const SizedBox(
                                      height: 25,
                                    ),

                                    const Center(
                                      child: Text(
                                        "Long Frame",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 27, 41, 237),
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      "Without Sealant = A(gm)",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: LongAController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Enter the without Sealant",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: MultiValidator(
                                        [
                                          RequiredValidator(
                                            errorText:
                                                "Please fill the required field",
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "With Sealant = B(gm)",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: LongBController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Enter the with Sealant",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: MultiValidator(
                                        [
                                          RequiredValidator(
                                            errorText:
                                                "Please fill the required field ",
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Difference Weight = B-A (gm)",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: LongDController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Enter the Total Sealant",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                      //  status == 'Pending' &&
                                      //         designation != "QC"
                                      //     ? true
                                      //     : false,
                                      validator: MultiValidator(
                                        [
                                          RequiredValidator(
                                            errorText:
                                                "Please fill the required field",
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                    _isLoading
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : AppButton(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.white,
                                              fontSize: 16,
                                            ),
                                            onTap: () {
                                              AppHelper.hideKeyboard(context);
                                              if (status != 'Pending') {
                                                setState(() {
                                                  sendStatus = 'Inprogress';
                                                });
                                                createData();
                                              }
                                              setState(() {
                                                setPage = "shortFrame";
                                              });
                                            },
                                            label: "Next",
                                            organization: '',
                                          ),

                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                          ],
                        )
                      : setPage == "shortFrame"
                          ? Stack(
                              alignment: Alignment.center,
                              fit: StackFit.expand,
                              children: [
                                SingleChildScrollView(
                                  child: Form(
                                    key: _registerFormKey,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                              "Checksheet For Sealant Weight Measurement",
                                              style: TextStyle(
                                                fontSize: 27,
                                                color: Color.fromARGB(
                                                    255, 56, 57, 56),
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
                                        Row(
                                          children: [
                                            Text(
                                              'Document No : ',
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'GSPL/IPQC/SP/012',
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                          ],
                                        ),

                                        // *************************** Revisional Number ********************
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Rev.No./Dated : ',
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              'Ver.  1.0 & 12-08-2023',
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                          ],
                                        ),

                                        //  *******************************************   Sealant Weight Measurement  ********************

                                        const SizedBox(
                                          height: 25,
                                        ),

                                        const Center(
                                          child: Text(
                                            "Short Frame",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 27, 41, 237),
                                              fontFamily: appFontFamily,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 25,
                                        ),
                                        Text(
                                          "Without Sealant = A(gm)",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: ShortAController,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Enter the without Sealant",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: MultiValidator(
                                            [
                                              RequiredValidator(
                                                errorText:
                                                    "Please fill the required field",
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "With Sealant = B(gm)",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: ShortBController,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Enter the with Sealant",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: MultiValidator(
                                            [
                                              RequiredValidator(
                                                errorText:
                                                    "Please fill the required field ",
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Difference Weight = B-A (gm)",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: ShortDController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Enter the Total Sealant",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                          // status == 'Pending' &&
                                          //         designation != "QC"
                                          //     ? true
                                          //     : false,
                                          validator: MultiValidator(
                                            [
                                              RequiredValidator(
                                                errorText:
                                                    "Please fill the required field",
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0)),
                                        _isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : AppButton(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.white,
                                                  fontSize: 16,
                                                ),
                                                onTap: () {
                                                  AppHelper.hideKeyboard(
                                                      context);
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      sendStatus = 'Inprogress';
                                                    });
                                                    createData();
                                                  }

                                                  setState(() {
                                                    setPage = 'JunctionBox';
                                                  });
                                                },
                                                label: "Next",
                                                organization: '',
                                              ),

                                        const SizedBox(
                                          height: 15,
                                        ),

                                        // Back button
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  setPage = '';
                                                });
                                                // Navigator.of(context).pushReplacement(
                                                //     MaterialPageRoute(
                                                //         builder: (BuildContext context) =>
                                                //             LoginPage(
                                                //                 appName: widget.appName)));
                                              },
                                              child: const Text(
                                                "BACK",
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                              ],
                            )
                          : setPage == "JunctionBox"
                              ? Stack(
                                  alignment: Alignment.center,
                                  fit: StackFit.expand,
                                  children: [
                                    SingleChildScrollView(
                                      child: Form(
                                        key: _registerFormKey,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
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
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Checksheet For Sealant Weight Measurement",
                                                  style: TextStyle(
                                                    fontSize: 27,
                                                    color: Color.fromARGB(
                                                        255, 56, 57, 56),
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
                                            Row(
                                              children: [
                                                Text(
                                                  'Document No : ',
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  'GSPL/IPQC/SP/012',
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                              ],
                                            ),

                                            // *************************** Revisional Number ********************
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Rev.No./Dated : ',
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  'Ver.  1.0 & 12-08-2023',
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                              ],
                                            ),

                                            //  *******************************************   Sealant Weight Measurement  ********************

                                            const SizedBox(
                                              height: 25,
                                            ),

                                            const Center(
                                              child: Text(
                                                "Junction Box",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                      255, 27, 41, 237),
                                                  fontFamily: appFontFamily,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 25,
                                            ),
                                            Text(
                                              "Without Sealant = A(gm)",
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller: JunctionAController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Enter the without Sealant",
                                                counterText: '',
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
                                              readOnly: status == 'Pending' &&
                                                      designation != "QC"
                                                  ? true
                                                  : false,
                                              validator: MultiValidator(
                                                [
                                                  RequiredValidator(
                                                    errorText:
                                                        "Please fill the required field",
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "With Sealant = B(gm)",
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller: JunctionBController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Enter the with Sealant",
                                                counterText: '',
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
                                              readOnly: status == 'Pending' &&
                                                      designation != "QC"
                                                  ? true
                                                  : false,
                                              validator: MultiValidator(
                                                [
                                                  RequiredValidator(
                                                    errorText:
                                                        "Please fill the required field ",
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "Difference Weight = B-A (gm)",
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller: JunctionDController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Enter the Total Sealant",
                                                counterText: '',
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
                                              readOnly: true,
                                              // status == 'Pending' &&
                                              //         designation != "QC"
                                              //     ? true
                                              //     : false,
                                              validator: MultiValidator(
                                                [
                                                  RequiredValidator(
                                                    errorText:
                                                        "Please fill the required field",
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 10, 0, 0)),
                                            _isLoading
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : AppButton(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors.white,
                                                      fontSize: 16,
                                                    ),
                                                    onTap: () {
                                                      AppHelper.hideKeyboard(
                                                          context);
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          sendStatus =
                                                              'Inprogress';
                                                        });
                                                        createData();
                                                      }
                                                      setState(() {
                                                        setPage = 'Potting';
                                                      });
                                                    },
                                                    label: "Next",
                                                    organization: '',
                                                  ),

                                            const SizedBox(
                                              height: 15,
                                            ),

                                            // Back button
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      setPage = 'shortFrame';
                                                    });
                                                    // Navigator.of(context).pushReplacement(
                                                    //     MaterialPageRoute(
                                                    //         builder: (BuildContext context) =>
                                                    //             LoginPage(
                                                    //                 appName: widget.appName)));
                                                  },
                                                  child: const Text(
                                                    "BACK",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            appFontFamily,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColors.redColor),
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Powered By Gautam Solar Pvt. Ltd.",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: appFontFamily,
                                                      color:
                                                          AppColors.greyColor,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                  ],
                                )
                              : setPage == "Potting"
                                  ? Stack(
                                      alignment: Alignment.center,
                                      fit: StackFit.expand,
                                      children: [
                                        SingleChildScrollView(
                                          child: Form(
                                            key: _registerFormKey,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
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
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text(
                                                      "Checksheet For Sealant Weight Measurement",
                                                      style: TextStyle(
                                                        fontSize: 27,
                                                        color: Color.fromARGB(
                                                            255, 56, 57, 56),
                                                        fontFamily:
                                                            appFontFamily,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                // **************** Document Number *******************
                                                const SizedBox(
                                                  height: 35,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Document No : ',
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      'GSPL/IPQC/SP/012',
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                  ],
                                                ),

                                                // *************************** Revisional Number ********************
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Rev.No./Dated : ',
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      'Ver.  1.0 & 12-08-2023',
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                  ],
                                                ),

                                                //  ************************   Sealant Weight Measurement  ********************

                                                const SizedBox(
                                                  height: 25,
                                                ),

                                                const Center(
                                                  child: Text(
                                                    "Total Potting Weight per module: ",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color.fromARGB(
                                                          255, 27, 41, 237),
                                                      fontFamily: appFontFamily,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                Text(
                                                  "Base Weight(A):",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller: BaseAController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Enter the Base Weight(A):",
                                                    counterText: '',
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: status ==
                                                              'Pending' &&
                                                          designation != "QC"
                                                      ? true
                                                      : false,
                                                  validator: MultiValidator(
                                                    [
                                                      RequiredValidator(
                                                        errorText:
                                                            "Please fill the required field",
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  "Catalyst Weight(B):",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CatalystBController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Enter the Catalyst Weight(B)",
                                                    counterText: '',
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: status ==
                                                              'Pending' &&
                                                          designation != "QC"
                                                      ? true
                                                      : false,
                                                  validator: MultiValidator(
                                                    [
                                                      RequiredValidator(
                                                        errorText:
                                                            "Please fill the required field ",
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  "Ratio(A:B)",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller: RatioController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Enter the Total Ratio",
                                                    counterText: '',
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: status ==
                                                              'Pending' &&
                                                          designation != "QC"
                                                      ? true
                                                      : false,
                                                  validator: MultiValidator(
                                                    [
                                                      RequiredValidator(
                                                        errorText:
                                                            "Please fill the required field",
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  "Reference PDF Document ",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      referencePdfController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                          hintText:
                                                              "Please Select Reference Pdf",
                                                          suffixIcon:
                                                              IconButton(
                                                            onPressed:
                                                                () async {
                                                              if (widget.id !=
                                                                      null &&
                                                                  widget.id !=
                                                                      '' &&
                                                                  referencePdfController
                                                                          .text !=
                                                                      '') {
                                                                UrlLauncher.launch(
                                                                    referencePdfController
                                                                        .text);
                                                              } else if (status !=
                                                                  'Pending') {
                                                                _pickReferencePDF();
                                                              }
                                                            },
                                                            icon: widget.id != null &&
                                                                    widget.id !=
                                                                        '' &&
                                                                    referencePdfController
                                                                            .text !=
                                                                        ''
                                                                ? const Icon(Icons
                                                                    .download)
                                                                : const Icon(Icons
                                                                    .upload_file),
                                                          ),
                                                          counterText: ''),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  maxLines: 1,
                                                  readOnly: true,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Please Select Reference Pdf";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 10, 0, 0)),
                                                _isLoading
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : (widget.id == "" ||
                                                                widget.id ==
                                                                    null) ||
                                                            (status ==
                                                                    'Inprogress' &&
                                                                widget.id !=
                                                                    null)
                                                        ? AppButton(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: AppColors
                                                                  .white,
                                                              fontSize: 16,
                                                            ),
                                                            onTap: () {
                                                              AppHelper
                                                                  .hideKeyboard(
                                                                      context);
                                                              _registerFormKey
                                                                  .currentState!
                                                                  .save;
                                                              if (_registerFormKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                setState(() {
                                                                  sendStatus =
                                                                      "Pending";
                                                                });
                                                                createData();
                                                              }
                                                            },
                                                            label: "Save",
                                                            organization: '',
                                                          )
                                                        : Container(),

                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                if (widget.id != "" &&
                                                    widget.id != null &&
                                                    status == 'Pending')
                                                  Container(
                                                    color: Color.fromARGB(
                                                        255,
                                                        191,
                                                        226,
                                                        187), // Change the background color to your desired color
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Divider(),
                                                        SizedBox(height: 15),
                                                        AppButton(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontSize: 16),
                                                          onTap: () {
                                                            AppHelper
                                                                .hideKeyboard(
                                                                    context);
                                                            setApprovalStatus();
                                                          },
                                                          label: "Approve",
                                                          organization: '',
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Divider(),
                                                      ],
                                                    ),
                                                  ),

                                                // Back button
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          setPage = setPage =
                                                              'JunctionBox';
                                                        });
                                                        // Navigator.of(context).pushReplacement(
                                                        //     MaterialPageRoute(
                                                        //         builder: (BuildContext context) =>
                                                        //             LoginPage(
                                                        //                 appName: widget.appName)));
                                                      },
                                                      child: const Text(
                                                        "BACK",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                appFontFamily,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .redColor),
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Powered By Gautam Solar Pvt. Ltd.",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              appFontFamily,
                                                          color: AppColors
                                                              .greyColor,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                      ],
                                    )
                                  : Container(),
                ),
          floatingActionButton: (status == "Pending") ? null : _getFAB(),
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
          //           // onTap: () {
          //           //   Navigator.of(context).pushReplacement(MaterialPageRoute(
          //           //       builder: (BuildContext context) => Attendance()));
          //           // },
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
