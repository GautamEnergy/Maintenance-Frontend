import 'dart:convert';
import 'dart:io';
import 'package:QCM/Fqc.dart';
import 'package:QCM/Ipqc.dart';
import 'package:QCM/Iqcp.dart';
import 'package:QCM/QualityList.dart';
import 'package:QCM/QualityPage.dart';
import 'package:QCM/Welcomepage.dart';
import 'package:QCM/components/app_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/src/response.dart' as Response;
import 'package:QCM/components/app_button_widget.dart';
import 'package:QCM/dialogs/city_list_model.dart';
import 'package:QCM/dialogs/dialog_role_city.dart';
import 'package:QCM/dialogs/dialog_role_state.dart';
import 'package:QCM/dialogs/state_list_model.dart';
import 'package:QCM/directory.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart' as email_validator;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'components/appbar.dart';
import 'constant/app_assets.dart';
import 'constant/app_color.dart';
import 'constant/app_fonts.dart';
import 'constant/app_strings.dart';
import 'constant/app_styles.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class AddQuality extends StatefulWidget {
  final String? id;
  AddQuality({this.id});
  _AddQualityState createState() => _AddQualityState();
}

class _AddQualityState extends State<AddQuality> {
  File? _image, personPreview;
  List<int>? personlogoBytes, pdfFileBytes, _imageBytes;
  List data = [];
  List statedata1 = [];
  List citydata1 = [];
  bool sameAsPresentAddress = false;
  final picker = ImagePicker();

  final _dio = Dio();
  // Response? _response;
  Response.Response? _response;
  String? _errorMessage,
      bloodGroupController,
      token,
      barcodeScanRes,
      issuetypeController,
      shiftController,
      reportingManagerController,
      modelNumberController,
      profilepicture,
      personLogoname,
      personid,
      designation,
      department,
      setpersonid,
      firstname,
      _selectedFileName,
      lastname,
      pic,
      ImagePath,
      logo,
      site,
      businessname,
      organizationtype,
      dobdate,
      dojdate,
      doidate,
      announcementId,
      endDate,
      announcementStatus;
  bool _isLoading = false;

  List bloodGroupList = [
    {"label": 'A+', "value": 'A+'},
    {"label": 'A-', "value": 'A-'},
    {"label": 'AB+', "value": 'AB+'},
    {"label": 'AB-', "value": 'AB-'},
    {"label": 'B+', "value": 'B+'},
    {"label": 'B-', "value": 'B-'},
    {"label": 'O+', "value": 'O+'},
    {"label": 'O-', "value": 'O-'},
  ];

  // List departmentList = [
  //       {"key": "Wire Frame", "value": "Wire Frame"},
  //       {"key": "Breakdown", "value": "Breakdown"},
  //     ],
  List issueList = [],
      modelNumberList = [],
      reportingManagerList = [],
      shiftList = [
        {"key": "Day", "value": "Day"},
        {"key": "Night", "value": "Night"},
      ];

  SharedPreferences? prefs;
  TextEditingController shiftinchargeprelimeController =
      new TextEditingController();
  TextEditingController shiftinchargepostlimeController =
      new TextEditingController();

  TextEditingController productBarcodeController = new TextEditingController();
  TextEditingController wattageController = new TextEditingController();
  TextEditingController othermodelnumberController =
      new TextEditingController();
  TextEditingController responsiblepersonController =
      new TextEditingController();
  TextEditingController reasonofissueController = new TextEditingController();
  TextEditingController stageController = new TextEditingController();
  TextEditingController issuecomefromController = new TextEditingController();
  TextEditingController actiontakenController = new TextEditingController();
  TextEditingController otherissuetypeController = new TextEditingController();

  GlobalKey<FormState> qualityformKey = GlobalKey<FormState>();

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File pdffile = File(result.files.single.path!);
      setState(() {
        pdfFileBytes = pdffile.readAsBytesSync();
        _selectedFileName = result.files.single.name;
      });
    } else {
      // User canceled the file picker
    }
  }

  @override
  void initState() {
    store();
    getLocationData();

    getIssueData();
    getModelNumberData();
    print("ProfilePicccc");
    print(profilepicture);
    super.initState();
  }

  void store() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      designation = prefs.getString('designation');
      department = prefs.getString('department');
      pic = prefs.getString('pic');
      personid = prefs.getString('personid');
      site = prefs.getString('site');
      token = prefs.getString('token');
    });
    _get();
    print("Iddd...........");
    print(widget.id);
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      // cameraDevice: CameraDevice.rear,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _compressImage(_image!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _compressImage(File imageFile) async {
    var _imageBytesOriginal = imageFile.readAsBytesSync();
    _imageBytes = await FlutterImageCompress.compressWithList(
      _imageBytesOriginal!,
      quality: 60,
    );
    print("kya hai bytes??");
    print(_imageBytes);
  }

  Future _get() async {
    print("Id.....AddEditProfile");
    print(personid);
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.id != '' && widget.id != null) {
        _isLoading = true;
      }
      site = prefs.getString('site');
    });
    final EmployeeData = ((site!) + 'Employee/GetSpecificEmployee');
    final employeeData = await http.post(
      Uri.parse(EmployeeData),
      body: jsonEncode(<String, String>{"PersonID": widget.id ?? ''}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var resBody = json.decode(employeeData.body);

    if (mounted) {
      setState(() {
        data = resBody['data'];

        if (data != null && data.length > 0) {
          _isLoading = false;
          final dataMap = data.asMap();

          // shiftinchargeprelimeController.text = dataMap[0]['EmployeeID'] ?? '';
          // shiftinchargepostlimeController.text = dataMap[0]['LoginID'] ?? '';

          // shiftController = dataMap[0]['WorkLocation'] ?? '';
          // issuetypeController = dataMap[0]['Department'] ?? '';
          //   modelNumberController = dataMap[0]['Desgination'] ?? '';
          //   profilepicture = dataMap[0]['ProfileImg'] ?? '';
        }
      });
    }
  }

  Future<bool> redirectto() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QualityPage();
    }));
    return true;
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
        // ignore: deprecated_member_use
        child: WillPopScope(
            // ignore: missing_return
            onWillPop: redirectto,
            child: Scaffold(
              appBar: GautamAppBar(
                organization: "organizationtype",
                isBackRequired: true,
                memberId: personid,
                imgPath: "ImagePath",
                memberPic: pic,
                logo: "logo",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return QualityPage();
                  }));
                },
              ),
              body: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 15),
                child: _isLoading ? AppLoader() : _user(),
              ),
            )));
  }

  TextFormField textShiftInchargePrelime() {
    return TextFormField(
      controller: shiftinchargeprelimeController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Shift Incharge Prelime",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter shift incharge prelime';
        }
        return null;
      },
    );
  }

  TextFormField textShiftInchargePostlime() {
    return TextFormField(
      controller: shiftinchargepostlimeController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Shift Incharge Postlime",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter shift incharge postlime';
        }
        return null;
      },
    );
  }

  TextFormField textProductBarcode() {
    return TextFormField(
      controller: productBarcodeController,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
        hintText: "Please Scan Product Barcode.",
        counterText: '',
        contentPadding: EdgeInsets.all(10),
        suffixIcon: IconButton(
          onPressed: () async {
            barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              '#FF6666',
              'Cancel',
              true,
              ScanMode.DEFAULT,
            );

            setState(() {
              productBarcodeController.text =
                  (barcodeScanRes != "-1" ? barcodeScanRes : '')!;
            });
          },
          icon: const Icon(Icons.qr_code),
        ),
      ),
      readOnly: false,
      style: AppStyles.textInputTextStyle,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Scan Product Barcode.';
        }
        return null;
      },
    );
  }

  TextFormField textWattage() {
    return TextFormField(
      controller: wattageController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Wattage",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter wattage';
        }
        return null;
      },
    );
  }

  TextFormField textOtherModelNumber() {
    return TextFormField(
      controller: othermodelnumberController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Model Number",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter model number';
        }
        return null;
      },
    );
  }

  TextFormField textOtherIssueType() {
    return TextFormField(
      controller: otherissuetypeController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Issue Type",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter issue type';
        }
        return null;
      },
    );
  }

  TextFormField textStage() {
    return TextFormField(
      controller: stageController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Stage",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter stage';
        }
        return null;
      },
    );
  }

  TextFormField textResponsiblePerson() {
    return TextFormField(
      controller: responsiblepersonController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Responsible Person",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter responsible person';
        }
        return null;
      },
    );
  }

  TextFormField textReasonOfIssue() {
    return TextFormField(
      controller: reasonofissueController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Reason Of Issue",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter reason of issue';
        }
        return null;
      },
    );
  }

  TextFormField textIssueComeFrom() {
    return TextFormField(
      controller: issuecomefromController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Issue Come From",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter issue come from';
        }
        return null;
      },
    );
  }

  TextFormField textActionTaken() {
    return TextFormField(
      controller: actiontakenController,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.next,
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Enter Action Taken For This Issue",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      style: AppStyles.textInputTextStyle,
      readOnly: false,
      validator: (value) {
        if (value!.isEmpty) {
          print("hiiiiiiiiii");
          return 'Please enter action taken for this issue';
        }
        return null;
      },
    );
  }

  getIssueData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    final url = (site! + 'Quality/GetIssues');

    http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var issueBody = jsonDecode(response.body);
        setState(() {
          issueList = issueBody['Issues'];
          issueList.add({
            "IssueId": "9f00c67d-0b99-11ef-8005-52549f6cc694",
            "Issue": "Other"
          });
        });
      }
    });
  }

  getModelNumberData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    final url = (site! + 'Quality/GetModels');

    http.get(
      Uri.parse(url),
      // body: jsonEncode(<String, String>{"departmentid": departmentId}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var modelNumberBody = jsonDecode(response.body);
        setState(() {
          modelNumberList = modelNumberBody['Models'];
          modelNumberList.add({
            "ModelId": "8634275c-0b99-11ef-8005-52549f6cc694",
            "ModelName": "Other"
          });
        });
      }
    });
  }

  getLocationData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    final url = (site! + 'QCM/GetWorkLocationList');

    http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var designationBody = jsonDecode(response.body);
        setState(() {
          // locationList = designationBody['data'];
        });
      }
    });
  }

  DropdownButtonFormField textShift() {
    return DropdownButtonFormField<String>(
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Select Shift",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      borderRadius: BorderRadius.circular(20),
      items: shiftList
          .map((label) => DropdownMenuItem(
                child: Text(label['key']!, style: AppStyles.textInputTextStyle),
                value: label['value'].toString(),
              ))
          .toList(),
      onChanged: (val) {
        setState(() {
          shiftController = val!;
        });
      },
      value: shiftController != '' ? shiftController : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a shift';
        }
        return null; // Return null if the validation is successful
      },
    );
  }

  DropdownButtonFormField textIssueType() {
    return DropdownButtonFormField<String>(
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Select Issue Type",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      borderRadius: BorderRadius.circular(20),
      items: issueList
          .map((label) => DropdownMenuItem(
                child:
                    Text(label['Issue'], style: AppStyles.textInputTextStyle),
                value: label['IssueId'].toString(),
              ))
          .toList(),
      onChanged: (val) {
        setState(() {
          issuetypeController = val!;
          print("hiiiiiiiiii");
        });
      },
      value: issuetypeController != '' ? issuetypeController : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a issue type';
        }
        return null; // Return null if the validation is successful
      },
    );
  }

  DropdownButtonFormField textModelNumber() {
    return DropdownButtonFormField<String>(
      decoration: AppStyles.textFieldInputDecoration.copyWith(
          hintText: "Please Select Model Number",
          counterText: '',
          contentPadding: EdgeInsets.all(10)),
      borderRadius: BorderRadius.circular(20),
      items: modelNumberList
          .map((label) => DropdownMenuItem(
                child: Text(label['ModelName'],
                    style: AppStyles.textInputTextStyle),
                value: label['ModelId'].toString(),
              ))
          .toList(),
      onChanged: (val) {
        setState(() {
          modelNumberController = val!;
          print("hiiiiiiiiii");
        });
      },
      value: modelNumberController != '' ? modelNumberController : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a model number';
        }
        return null; // Return null if the validation is successful
      },
    );
  }

  Future createData(
    String shift,
    String shiftinchargeprelime,
    String shiftinchargepostlime,
    String productBarcode,
    String wattage,
    String modelnumber,
    String othermodelnumber,
    String issuetype,
    String otherissuetype,
    String stage,
    String responsibleperson,
    String reasonofissue,
    String issuecomefrom,
    String actiontaken,
  ) async {
    setState(() {
      _isLoading = true;
    });
    print("whyyyyyyyyyyyyyyyyyyyy");

    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');
    print("Howwwwwwwwwwwwwwwwwwwww");
    print(site);
    final url = (site! + 'Quality/AddQuality'); // Prod

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(<String, String>{
        "currentuser": personid ?? '',
        "shift": shift,
        "shiftinchargename": "",
        "shiftinchargeprelime": shiftinchargeprelime,
        "shiftinchargepostlime": shiftinchargepostlime,
        "productBarcode": productBarcode,
        "wattage": wattage,
        "modelnumber": modelnumber,
        "othermodelnumber": othermodelnumber,
        "issuetype": issuetype,
        "otherissuetype": otherissuetype,
        "stage": stage,
        "responsibleperson": responsibleperson,
        "reasonofissue": reasonofissue,
        "issuecomefrom": issuecomefrom,
        "actiontaken": actiontaken,
      }),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print("Resssssssss.....???");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      print(data['UUID']);

      setState(() {
        setpersonid = data['UUID'];
      });
      if (_imageBytes != null && _imageBytes != '') {
        upload((_imageBytes ?? []), (productBarcode ?? ''));
      } else {
        Toast.show("Issue reporting successfully.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.primaryColor);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => QualityList()),
            (Route<dynamic> route) => false);
      }
    } else if (response.statusCode == 400) {
      setState(() {
        _isLoading = false;
      });
      Toast.show("This Issue is Already Reported.",
          duration: Toast.lengthLong,
          gravity: Toast.center,
          backgroundColor: Colors.redAccent);
    } else {
      setState(() {
        _isLoading = false;
      });
      Toast.show("Error on Server",
          duration: Toast.lengthLong,
          gravity: Toast.center,
          backgroundColor: Colors.redAccent);
    }
  }

  upload(List<int> bytes, String name) async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    var formData = FormData.fromMap({
      'QualityId': setpersonid != '' && setpersonid != null ? setpersonid : '',
      "ModuleImage": MultipartFile.fromBytes(
        bytes,
        filename: (name + (currentdate.toString()) + '.jpg'),
        contentType: MediaType("image", 'jpg'),
      ),
    });

    _response = await _dio.post((site! + 'Quality/UploadModuleImage'), // Prod

        options: Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
          validateStatus: (status) => true,
        ),
        data: formData);

    try {
      if (_response!.data != null) {
        setState(() {
          _isLoading = false;
        });
        print("Upload....?");
        print(_response!.data);

        Toast.show("Issue reporting successfully.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.primaryColor);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => QualityList()),
            (Route<dynamic> route) => false);
      }
    } catch (err) {
      print("Error");
    }
  }

  Widget _user() {
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: qualityformKey,
        child: ListView(
          children: [
            // Padding(padding: EdgeInsets.only(top: 10)),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
              ),
            ),
            //  Padding(padding: EdgeInsets.only(top: 5)),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.imgLogo,
                    height: 100,
                    width: 230,
                  ),
                ],
              ),
            ),
            // const Center(
            //     child: Padding(
            //         padding: EdgeInsets.only(top: 10),
            //         child: Text("Incoming Quality Control Plan",
            //             style: TextStyle(
            //                 fontSize: 27,
            //                 color: AppColors.black,
            //                 fontFamily: appFontFamily,
            //                 fontWeight: FontWeight.w700)))),
            const Center(
                child: Text("Quality",
                    style: TextStyle(
                        fontSize: 25,
                        color: AppColors.black,
                        fontFamily: appFontFamily,
                        fontWeight: FontWeight.w700))),
            const SizedBox(
              height: 25,
            ),

            Text(
              "Capture Module Pic*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(height: 10),
            _image == null
                ? Container(
                    width: 300, // Set the desired width
                    height: 300, // Set the desired height
                    child: GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius to your preference
                        child: Image.asset(
                          AppAssets.camera,
                          fit: BoxFit.cover,
                          width:
                              300, // Set width and height to match Container's size
                          height: 300,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 300, // Set the desired width
                    height: 300, // Set the desired height
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _image!, // Assuming _image is a File object
                        fit: BoxFit.cover,
                        width:
                            300, // Set width and height to match Container's size
                        height: 300,
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            Text(
              "Shift*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(height: 5),
            textShift(),

            const SizedBox(
              height: 15,
            ),

            Text(
              "Shift Incharge Name Prelime*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            textShiftInchargePrelime(),
            const SizedBox(
              height: 15,
            ),

            Text(
              "Shift Incharge Name Postlime*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            textShiftInchargePostlime(),
            const SizedBox(
              height: 15,
            ),

            Text(
              "Product Barcode*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(height: 5),
            textProductBarcode(),
            const SizedBox(height: 15),

            Text(
              "Wattage*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(height: 5),
            textWattage(),
            const SizedBox(height: 15),

            Text(
              "Model Number*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            textModelNumber(),
            const SizedBox(
              height: 15,
            ),
            if (modelNumberController == "8634275c-0b99-11ef-8005-52549f6cc694")
              Text(
                "Other Model Number*",
                style: AppStyles.textfieldCaptionTextStyle,
              ),
            if (modelNumberController == "8634275c-0b99-11ef-8005-52549f6cc694")
              const SizedBox(height: 5),
            if (modelNumberController == "8634275c-0b99-11ef-8005-52549f6cc694")
              textOtherModelNumber(),
            if (modelNumberController == "8634275c-0b99-11ef-8005-52549f6cc694")
              const SizedBox(height: 15),
            Text(
              "Issue Type*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            textIssueType(),
            const SizedBox(
              height: 15,
            ),
            if (issuetypeController == "9f00c67d-0b99-11ef-8005-52549f6cc694")
              Text(
                "Other Issue Type*",
                style: AppStyles.textfieldCaptionTextStyle,
              ),
            if (issuetypeController == "9f00c67d-0b99-11ef-8005-52549f6cc694")
              const SizedBox(
                height: 5,
              ),
            if (issuetypeController == "9f00c67d-0b99-11ef-8005-52549f6cc694")
              textOtherIssueType(),
            if (issuetypeController == "9f00c67d-0b99-11ef-8005-52549f6cc694")
              const SizedBox(
                height: 15,
              ),

            Text(
              "Stage*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(height: 5),
            textStage(),
            const SizedBox(height: 15),

            Text(
              "Responsible Person*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(height: 5),
            textResponsiblePerson(),
            const SizedBox(height: 15),

            Text(
              "Reason Of Issue*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(height: 5),
            textReasonOfIssue(),
            const SizedBox(height: 15),

            Text(
              "Issue Come From*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(height: 5),
            textIssueComeFrom(),
            const SizedBox(height: 15),

            Text(
              "Action Taken For This Issue*",
              style: AppStyles.textfieldCaptionTextStyle,
            ),
            const SizedBox(height: 5),
            textActionTaken(),
            const SizedBox(height: 15),
            // Text(
            //   "Capture Module Pic*",
            //   style: AppStyles.textfieldCaptionTextStyle,
            // ),
            // const SizedBox(height: 10),
            // _image == null
            //     ? Container(
            //         width: 300, // Set the desired width
            //         height: 300, // Set the desired height
            //         child: GestureDetector(
            //           onTap: () {
            //             getImage();
            //           },
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(
            //                 10), // Adjust the radius to your preference
            //             child: Image.asset(
            //               AppAssets.camera,
            //               fit: BoxFit.cover,
            //               width:
            //                   300, // Set width and height to match Container's size
            //               height: 300,
            //             ),
            //           ),
            //         ),
            //       )
            //     : Container(
            //         width: 300, // Set the desired width
            //         height: 300, // Set the desired height
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(10),
            //           child: Image.file(
            //             _image!, // Assuming _image is a File object
            //             fit: BoxFit.cover,
            //             width:
            //                 300, // Set width and height to match Container's size
            //             height: 300,
            //           ),
            //         ),
            //       ),

            const SizedBox(height: 30),

            AppButton(
              organization: (organizationtype ?? ''),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                  fontSize: 16),
              onTap: () async {
                print("personlogoBytes ??????");
                print(_imageBytes);
                if (qualityformKey.currentState!.validate()) {
                  if (_imageBytes != "" &&
                      _imageBytes != null &&
                      shiftController != null &&
                      shiftController != "" &&
                      shiftinchargeprelimeController.text != "" &&
                      shiftinchargepostlimeController.text != "" &&
                      productBarcodeController.text != "" &&
                      wattageController.text != "" &&
                      modelNumberController != "" &&
                      modelNumberController != null &&
                      issuetypeController != "" &&
                      issuetypeController != null &&
                      stageController.text != "" &&
                      responsiblepersonController.text != "" &&
                      reasonofissueController.text != "" &&
                      actiontakenController.text != "") {
                    createData(
                      shiftController ?? "",
                      shiftinchargeprelimeController.text,
                      shiftinchargepostlimeController.text,
                      productBarcodeController.text,
                      wattageController.text,
                      modelNumberController ?? "",
                      othermodelnumberController.text,
                      issuetypeController ?? "",
                      otherissuetypeController.text,
                      stageController.text,
                      responsiblepersonController.text,
                      reasonofissueController.text,
                      issuecomefromController.text,
                      actiontakenController.text,
                    );
                  } else {
                    Toast.show("Please Enter All Required Fields.",
                        duration: Toast.lengthLong,
                        gravity: Toast.center,
                        backgroundColor: Colors.redAccent);
                  }
                  qualityformKey.currentState!.save();
                }
              },
              label: AppStrings.SAVE,
            ),
            SizedBox(height: 10),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => QualityPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: appFontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.redColor),
                  ),
                ),
              ),
            ),
            const Divider(),
          ],
        ));
  }
}
