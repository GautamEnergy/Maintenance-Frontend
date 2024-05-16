import 'dart:convert';
import 'dart:io';
import 'package:QCM/components/app_loader.dart';
import 'package:QCM/components/appbar.dart';
import 'package:QCM/ipqcTestList.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:QCM/stringerCards.dart';
import 'package:http/http.dart' as http;
import 'package:dio/src/response.dart' as Response;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:QCM/components/app_button_widget.dart';
import 'package:QCM/constant/app_assets.dart';
import 'package:QCM/constant/app_color.dart';
import 'package:QCM/constant/app_fonts.dart';
import 'package:QCM/constant/app_helper.dart';
import 'package:QCM/constant/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class stringer1 extends StatefulWidget {
  final String? id;
  stringer1({this.id});
  @override
  _stringer1State createState() => _stringer1State();
}

class _stringer1State extends State<stringer1> {
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController shiftController = TextEditingController();

  TextEditingController ASet1Controller = TextEditingController();
  TextEditingController AS1TackAs1Controller = TextEditingController();

  TextEditingController ASet2Controller = TextEditingController();
  TextEditingController AS1TackAs2Controller = TextEditingController();

  TextEditingController AWtime1Controller = TextEditingController();
  TextEditingController AS1TrackAW1Controller = TextEditingController();

  TextEditingController AWtime2Controller = TextEditingController();
  TextEditingController AS1TrackAW2Controller = TextEditingController();

  TextEditingController AWtime3Controller = TextEditingController();
  TextEditingController AS1TrackAW3Controller = TextEditingController();

  TextEditingController AWtime4Controller = TextEditingController();
  TextEditingController AS1TrackAW4Controller = TextEditingController();

  TextEditingController AWtime5Controller = TextEditingController();
  TextEditingController AS1TrackAW5Controller = TextEditingController();

  TextEditingController AWtime6Controller = TextEditingController();
  TextEditingController AS1TrackAW6Controller = TextEditingController();

  TextEditingController AHeating1Controller = TextEditingController();
  TextEditingController AS1TrackAH1Controller = TextEditingController();

  TextEditingController AHeating2Controller = TextEditingController();
  TextEditingController AS1TrackAH2Controller = TextEditingController();

  TextEditingController AHeating3Controller = TextEditingController();
  TextEditingController AS1TrackAH3Controller = TextEditingController();

  TextEditingController AHeating4Controller = TextEditingController();
  TextEditingController AS1TrackAH4Controller = TextEditingController();

  TextEditingController AHeating5Controller = TextEditingController();
  TextEditingController AS1TrackAH5Controller = TextEditingController();

  TextEditingController AHeating6Controller = TextEditingController();
  TextEditingController AS1TrackAH6Controller = TextEditingController();

  TextEditingController ALowestController = TextEditingController();
  TextEditingController AS1TrackALController = TextEditingController();

  TextEditingController AHighestController = TextEditingController();
  TextEditingController AS1TrackAHController = TextEditingController();

  TextEditingController BSet1Controller = TextEditingController();
  TextEditingController BS1TackAs1Controller = TextEditingController();
  TextEditingController BSet2Controller = TextEditingController();
  TextEditingController BS1TackAs2Controller = TextEditingController();
  TextEditingController BWtime1Controller = TextEditingController();
  TextEditingController BS1TrackAW1Controller = TextEditingController();
  TextEditingController BWtime2Controller = TextEditingController();
  TextEditingController BS1TrackAW2Controller = TextEditingController();
  TextEditingController BWtime3Controller = TextEditingController();
  TextEditingController BS1TrackAW3Controller = TextEditingController();
  TextEditingController BWtime4Controller = TextEditingController();
  TextEditingController BS1TrackAW4Controller = TextEditingController();
  TextEditingController BWtime5Controller = TextEditingController();
  TextEditingController BS1TrackAW5Controller = TextEditingController();
  TextEditingController BWtime6Controller = TextEditingController();
  TextEditingController BS1TrackAW6Controller = TextEditingController();
  TextEditingController BHeating1Controller = TextEditingController();
  TextEditingController BS1TrackAH1Controller = TextEditingController();
  TextEditingController BHeating2Controller = TextEditingController();
  TextEditingController BS1TrackAH2Controller = TextEditingController();
  TextEditingController BHeating3Controller = TextEditingController();
  TextEditingController BS1TrackAH3Controller = TextEditingController();
  TextEditingController BHeating4Controller = TextEditingController();
  TextEditingController BS1TrackAH4Controller = TextEditingController();
  TextEditingController BHeating5Controller = TextEditingController();
  TextEditingController BS1TrackAH5Controller = TextEditingController();
  TextEditingController BHeating6Controller = TextEditingController();
  TextEditingController BS1TrackAH6Controller = TextEditingController();
  TextEditingController BLowestController = TextEditingController();
  TextEditingController BS1TrackALController = TextEditingController();
  TextEditingController BHighestController = TextEditingController();
  TextEditingController BS1TrackAHController = TextEditingController();
  TextEditingController referencePdfController = new TextEditingController();

  List shiftList = [
    {"key": 'Day Shift', "value": 'Day Shift'},
    {"key": 'Night Shift', "value": 'Night Shift'},
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
  String selectedShift = "Day Shift";
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

  @override
  void initState() {
    super.initState();
    store();
    isCycleTimeTrue = true;
    setState(() {
      ASet1Controller.text = "Set Temperature1 | 230+-30  | °C";
      ASet2Controller.text = "Set Temperature2 | 230+-30  | °C";
      AWtime1Controller.text = "Welding Time1 | 1.7-2.5  | sec.";
      AWtime2Controller.text = "Welding Time2 | 1.7-2.5  | sec.";
      AWtime3Controller.text = "Welding Time3 | 1.7-2.5  | sec.";
      AWtime4Controller.text = "Welding Time3 | 1.7-2.5  | sec.";
      AWtime5Controller.text = "Welding Time3 | 1.7-2.5  | sec.";
      AWtime6Controller.text = "Welding Time3 | 1.7-2.5  | sec.";
      AHeating1Controller.text = "Heating Platform 1 | 80+-30 | °C ";
      AHeating2Controller.text = "Heating Platform 2 | 90+-30 | °C ";
      AHeating3Controller.text = "Heating Platform 3 | 110+-30 | °C ";
      AHeating4Controller.text = "Heating Platform 4 | 100+-30 | °C ";
      AHeating5Controller.text = "Heating Platform 5 | 90+-30 | °C ";
      AHeating6Controller.text = "Heating Platform 6 | 80+-30 | °C ";
      ALowestController.text = "Lowest Temp.setting |  30  |  °C ";
      AHighestController.text = "Highest Temp.setting |  150  |  °C ";

      BSet1Controller.text = "Set Temperature1 | 230+-30  | °C";
      BSet2Controller.text = "Set Temperature2 | 230+-30  | °C";
      BWtime1Controller.text = "Welding Time1 | 1.7-2.5  | sec.";
      BWtime2Controller.text = "Welding Time2 | 1.7-2.5  | sec.";
      BWtime3Controller.text = "Welding Time3 | 1.7-2.5  | sec.";
      BWtime4Controller.text = "Welding Time3 | 1.7-2.5  | sec.";
      BWtime5Controller.text = "Welding Time3 | 1.7-2.5  | sec.";
      BWtime6Controller.text = "Welding Time3 | 1.7-2.5  | sec.";
      BHeating1Controller.text = "Heating Platform 1 | 80+-30 | °C ";
      BHeating2Controller.text = "Heating Platform 2 | 90+-30 | °C ";
      BHeating3Controller.text = "Heating Platform 3 | 110+-30 | °C ";
      BHeating4Controller.text = "Heating Platform 4 | 100+-30 | °C ";
      BHeating5Controller.text = "Heating Platform 5 | 90+-30 | °C ";
      BHeating6Controller.text = "Heating Platform 6 | 80+-30 | °C ";
      BLowestController.text = "Lowest Temp.setting |  30  |  °C ";
      BHighestController.text = "Highest Temp.setting |  150  |  °C ";
    });
  }

  // ------- Send the Data where will be Used to Backend -----------

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
    final AllSolarData = ((site!) + 'IPQC/GetSpecificStringerMachine');
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
          AS1TackAs1Controller.text =
              resBody['response']['SetTemperature1_TrackA'] ?? '';
          BS1TackAs1Controller.text =
              resBody['response']['SetTemperature1_TrackB'] ?? '';
          AS1TackAs2Controller.text =
              resBody['response']['SetTemperature2_TrackA'] ?? '';
          BS1TackAs2Controller.text =
              resBody['response']['SetTemperature2_TrackB'] ?? '';
          AS1TrackAW1Controller.text =
              resBody['response']['WeldingTime1_TrackA'] ?? '';
          BS1TrackAW1Controller.text =
              resBody['response']['WeldingTime1_TrackB'] ?? '';
          AS1TrackAW2Controller.text =
              resBody['response']['WeldingTime2_TrackA'] ?? '';
          BS1TrackAW2Controller.text =
              resBody['response']['WeldingTime2_TrackB'] ?? '';
          AS1TrackAW3Controller.text =
              resBody['response']['WeldingTime3_TrackA'] ?? '';
          BS1TrackAW3Controller.text =
              resBody['response']['WeldingTime3_TrackB'] ?? '';
          AS1TrackAW4Controller.text =
              resBody['response']['WeldingTime4_TrackA'] ?? '';
          BS1TrackAW4Controller.text =
              resBody['response']['WeldingTime4_TrackB'] ?? '';
          AS1TrackAW5Controller.text =
              resBody['response']['WeldingTime5_TrackA'] ?? '';
          BS1TrackAW5Controller.text =
              resBody['response']['WeldingTime5_TrackB'] ?? '';
          AS1TrackAW6Controller.text =
              resBody['response']['WeldingTime6_TrackA'] ?? '';
          BS1TrackAW6Controller.text =
              resBody['response']['WeldingTime6_TrackB'] ?? '';
          AS1TrackAH1Controller.text =
              resBody['response']['Heatingplatform1_TrackA'] ?? '';
          BS1TrackAH1Controller.text =
              resBody['response']['Heatingplatform1_TrackB'] ?? '';
          AS1TrackAH2Controller.text =
              resBody['response']['Heatingplatform2_TrackA'] ?? '';
          BS1TrackAH2Controller.text =
              resBody['response']['Heatingplatform2_TrackB'] ?? '';
          AS1TrackAH3Controller.text =
              resBody['response']['Heatingplatform3_TrackA'] ?? '';
          BS1TrackAH3Controller.text =
              resBody['response']['Heatingplatform3_TrackB'] ?? '';
          AS1TrackAH4Controller.text =
              resBody['response']['Heatingplatform4_TrackA'] ?? '';
          BS1TrackAH4Controller.text =
              resBody['response']['Heatingplatform4_TrackB'] ?? '';
          AS1TrackAH5Controller.text =
              resBody['response']['Heatingplatform5_TrackA'] ?? '';
          BS1TrackAH5Controller.text =
              resBody['response']['Heatingplatform5_TrackB'] ?? '';
          AS1TrackAH6Controller.text =
              resBody['response']['Heatingplatform6_TrackA'] ?? '';
          BS1TrackAH6Controller.text =
              resBody['response']['Heatingplatform6_TrackB'] ?? '';
          AS1TrackALController.text =
              resBody['response']['LowestTemp.setting_TrackA'] ?? '';
          BS1TrackALController.text =
              resBody['response']['LowestTemp.setting_TrackB'] ?? '';
          AS1TrackAHController.text =
              resBody['response']['HighestTemp.setting_TrackA'] ?? '';
          BS1TrackAHController.text =
              resBody['response']['HighestTemp.setting_TrackB'] ?? '';
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
    final url = (site! + "IPQC/UpdatePreLamStatus");

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
        Toast.show("Stringer 1 Test $approvalStatus .",
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
    } else {}
  }

  Future createData() async {
    var data = {
      "JobCardDetailId": jobCarId != '' && jobCarId != null
          ? jobCarId
          : widget.id != '' && widget.id != null
              ? widget.id
              : '',
      "CurrentUser": personid,
      "DocNo": "GSPL/IPQC/ST/004",
      "RevNo": "1.0 dated 12.08.2023",
      "Date": dateOfQualityCheck,
      "Shift": selectedShift,
      "Status": sendStatus,
      "Type": "Stringer1",
      "Track": [
        {
          "Parameter": "Set Temperature1 ",
          "Specification": "230±30",
          "UOM": "°C",
          "TrackA": AS1TackAs1Controller.text,
          "TrackB": BS1TackAs1Controller.text
        },
        {
          "Parameter": "Set Temperature2",
          "Specification": "230±30",
          "UOM": "°C",
          "TrackA": AS1TackAs2Controller.text,
          "TrackB": BS1TackAs2Controller.text
        },
        {
          "Parameter": "Welding Time1",
          "Specification": "1.7-2.5",
          "UOM": "sec",
          "TrackA": AS1TrackAW1Controller.text,
          "TrackB": BS1TrackAW1Controller.text,
        },
        {
          "Parameter": "Welding Time2",
          "Specification": "1.7-2.5",
          "UOM": "sec",
          "TrackA": AS1TrackAW2Controller.text,
          "TrackB": BS1TrackAW2Controller.text,
        },
        {
          "Parameter": "Welding Time3",
          "Specification": "1.7-2.5",
          "UOM": "sec",
          "TrackA": AS1TrackAW3Controller.text,
          "TrackB": BS1TrackAW3Controller.text,
        },
        {
          "Parameter": "Welding Time4",
          "Specification": "1.7-2.5",
          "UOM": "sec",
          "TrackA": AS1TrackAW4Controller.text,
          "TrackB": BS1TrackAW4Controller.text,
        },
        {
          "Parameter": "Welding Time5",
          "Specification": "1.7-2.5",
          "UOM": "sec",
          "TrackA": AS1TrackAW5Controller.text,
          "TrackB": BS1TrackAW5Controller.text,
        },
        {
          "Parameter": "Welding Time6",
          "Specification": "1.7-2.5",
          "UOM": "sec",
          "TrackA": AS1TrackAW6Controller.text,
          "TrackB": BS1TrackAW6Controller.text,
        },
        {
          "Parameter": "Heating platform 1",
          "Specification": "80+-30",
          "UOM": "°C",
          "TrackA": AS1TrackAH1Controller.text,
          "TrackB": BS1TrackAH1Controller.text,
        },
        {
          "Parameter": "Heating platform 2",
          "Specification": "90+-30",
          "UOM": "°C",
          "TrackA": AS1TrackAH2Controller.text,
          "TrackB": BS1TrackAH2Controller.text,
        },
        {
          "Parameter": "Heating platform 3",
          "Specification": "110+-30",
          "UOM": "°C",
          "TrackA": AS1TrackAH3Controller.text,
          "TrackB": BS1TrackAH3Controller.text,
        },
        {
          "Parameter": "Heating platform 4",
          "Specification": "100+-30",
          "UOM": "°C",
          "TrackA": AS1TrackAH4Controller.text,
          "TrackB": BS1TrackAH4Controller.text,
        },
        {
          "Parameter": "Heating platform 5",
          "Specification": "90+-30",
          "UOM": "°C",
          "TrackA": AS1TrackAH5Controller.text,
          "TrackB": BS1TrackAH5Controller.text,
        },
        {
          "Parameter": "Heating platform 6",
          "Specification": "80+-30",
          "UOM": "°C",
          "TrackA": AS1TrackAH6Controller.text,
          "TrackB": BS1TrackAH6Controller.text,
        },
        {
          "Parameter": "Lowest Temp.setting",
          "Specification": "30",
          "UOM": "°C",
          "TrackA": AS1TrackALController.text,
          "TrackB": BS1TrackALController.text,
        },
        {
          "Parameter": "Highest Temp. setting",
          "Specification": "50",
          "UOM": "°C",
          "TrackA": AS1TrackAHController.text,
          "TrackB": BS1TrackAHController.text,
        }
      ]
    };

    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    final url = (site! + "IPQC/AddStringerMachine");

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
        jobCarId = objData['UUID'];

        _isLoading = false;
      });
      print(objData['UUID']);
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
      "PreLamPdf": MultipartFile.fromBytes(
        referenceBytes,
        filename:
            (referencePdfController.text + (currentdate.toString()) + '.pdf'),
        contentType: MediaType("application", 'pdf'),
      ),
    });

    _response = await _dio.post((site! + 'IPQC/UploadPreLamPdf'), // Prod

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

        Toast.show("Stringer 1 Test Completed.",
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
                    : StringersCard();
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
                                          "Monitoring For Tabber & Stringer Machine",
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
                                          'GSPL/IPQC/ST/004',
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
                                          'Ver.1.0 & 12-08-2023',
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
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                              hintText: "Please Select Shift",
                                              counterText: '',
                                              contentPadding:
                                                  EdgeInsets.all(10)),
                                      borderRadius: BorderRadius.circular(20),
                                      items: shiftList
                                          .map((label) => DropdownMenuItem(
                                                child: Text(label['key'],
                                                    style: AppStyles
                                                        .textInputTextStyle),
                                                value:
                                                    label['value'].toString(),
                                              ))
                                          .toList(),
                                      onChanged: designation != "QC" &&
                                              status == "Pending"
                                          ? null
                                          : (val) {
                                              setState(() {
                                                selectedShift = val!;
                                              });
                                            },
                                      value: selectedShift != ''
                                          ? selectedShift
                                          : null,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a Shift';
                                        }
                                        return null; // Return null if the validation is successful
                                      },
                                    ),

                                    //  ***************   Monitoring For tabber & Stringer Machine ************

                                    const SizedBox(
                                      height: 15,
                                    ),

                                    const Center(
                                      child: Text(
                                        "Track A",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(255, 250, 4, 4),
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Center(
                                      child: Text(
                                        "PARAMETER",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color:
                                              Color.fromARGB(255, 86, 104, 243),
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),

                                    // ***************  Temperature's  ****************

                                    TextFormField(
                                      controller: ASet1Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Set Temperature1 | 230+-30  | °C",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TackAs1Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: ASet2Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Set Temperature2 | 230+-30  | °C",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TackAs2Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    TextFormField(
                                      controller: AWtime1Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Welding Time1 | 1.7-2.5  | sec.",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAW1Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    TextFormField(
                                      controller: AWtime2Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Welding Time2 | 1.7-2.5  | sec.",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAW2Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: AWtime3Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Welding Time3 | 1.7-2.5  | sec.",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAW3Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: AWtime4Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Welding Time4 | 1.7-2.5  | sec.",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAW4Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: AWtime5Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Welding Time5 | 1.7-2.5  | sec.",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAW5Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    TextFormField(
                                      controller: AWtime6Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Welding Time6 | 1.7-2.5  | sec.",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAW6Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    TextFormField(
                                      controller: AHeating1Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Heating Platform 1 | 80+-30 | °C ",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAH1Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: AHeating2Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Heating Platform 2 | 90+-30 | °C ",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAH2Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: AHeating3Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Heating Platform 3 | 110+-30 | °C ",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAH3Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: AHeating4Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Heating Platform 4 | 100+-30 | °C ",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAH4Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: AHeating5Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Heating Platform 5 | 90+-30 | °C ",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAH5Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: AHeating6Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Heating Platform 6 | 80+-30 | °C ",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAH6Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: ALowestController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Lowest Temp.setting |  30  |  °C ",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackALController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: AHighestController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Highest Temp.setting |  150  |  °C ",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: AS1TrackAHController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Track-A Data",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: status == 'Pending' &&
                                              designation != "QC"
                                          ? true
                                          : false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Correct Track A Data";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
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
                                                setPage = "TrackB";
                                              });
                                              print(setPage);
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
                      : setPage == "TrackB"
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
                                              "Monitoring For Tabber & Stringer Machine",
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
                                              'GSPL/IPQC/ST/004',
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
                                              'Ver.1.0 & 12-08-2023',
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                          ],
                                        ),

                                        //  ***************   Monitoring For tabber & Stringer Machine ****************

                                        const SizedBox(
                                          height: 15,
                                        ),

                                        const Center(
                                          child: Text(
                                            "Track B",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 250, 4, 4),
                                              fontFamily: appFontFamily,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Center(
                                          child: Text(
                                            "PARAMETER",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 86, 104, 243),
                                              fontFamily: appFontFamily,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),

                                        // *********************  Temperature's  ************************

                                        TextFormField(
                                          controller: BSet1Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Set Temperature1 | 230+-30  | °C",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TackAs1Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: BSet2Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Set Temperature2 | 230+-30  | °C",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TackAs2Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        TextFormField(
                                          controller: BWtime1Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Welding Time1 | 1.7-2.5  | sec.",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAW1Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        TextFormField(
                                          controller: BWtime2Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Welding Time2 | 1.7-2.5  | sec.",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAW2Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: BWtime3Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Welding Time3 | 1.7-2.5  | sec.",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAW3Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: BWtime4Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Welding Time4 | 1.7-2.5  | sec.",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAW4Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: BWtime5Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Welding Time5 | 1.7-2.5  | sec.",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAW5Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        TextFormField(
                                          controller: BWtime6Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Welding Time6 | 1.7-2.5  | sec.",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAW6Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        TextFormField(
                                          controller: BHeating1Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Heating Platform 1 | 80+-30 | °C ",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAH1Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: BHeating2Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Heating Platform 2 | 90+-30 | °C ",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAH2Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: BHeating3Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Heating Platform 3 | 110+-30 | °C ",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAH3Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: BHeating4Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Heating Platform 4 | 100+-30 | °C ",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAH4Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: BHeating5Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Heating Platform 5 | 90+-30 | °C ",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAH5Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: BHeating6Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Heating Platform 6 | 80+-30 | °C ",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAH6Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: BLowestController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Lowest Temp.setting |  30  |  °C ",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackALController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: BHighestController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Highest Temp.setting |  150  |  °C ",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: BS1TrackAHController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Please Enter Track-B Data",
                                            counterText: '',
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: status == 'Pending' &&
                                                  designation != "QC"
                                              ? true
                                              : false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please Enter Correct Track A Data";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),

                                        // -------------------------  It's Working End point's -----------------------------

                                        Text(
                                          "Reference PDF Document ",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: referencePdfController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                                  hintText:
                                                      "Please Select Reference Pdf",
                                                  suffixIcon: IconButton(
                                                    onPressed: () async {
                                                      if (widget.id != null &&
                                                          widget.id != '' &&
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
                                                            widget.id != '' &&
                                                            referencePdfController
                                                                    .text !=
                                                                ''
                                                        ? const Icon(
                                                            Icons.download)
                                                        : const Icon(
                                                            Icons.upload_file),
                                                  ),
                                                  counterText: ''),
                                          style: AppStyles.textInputTextStyle,
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
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0)),
                                        _isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : (widget.id == "" ||
                                                        widget.id == null) ||
                                                    (status == 'Inprogress' &&
                                                        widget.id != null)
                                                ? AppButton(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors.white,
                                                      fontSize: 16,
                                                    ),
                                                    onTap: () {
                                                      AppHelper.hideKeyboard(
                                                          context);
                                                      _registerFormKey
                                                          .currentState!.save;
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
                                                    label: "SAVE",
                                                    organization: '',
                                                  )
                                                : Container(),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        if (widget.id != "" &&
                                            widget.id != null &&
                                            status == 'Pending')
                                          Container(
                                            color: Color.fromARGB(
                                                255, 191, 226, 187),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Divider(),
                                                SizedBox(height: 15),
                                                AppButton(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors.white,
                                                      fontSize: 16),
                                                  onTap: () {
                                                    AppHelper.hideKeyboard(
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  setPage = '';
                                                });
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
