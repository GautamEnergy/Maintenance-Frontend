import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/chip_config.dart';
import 'package:multi_dropdown/models/network_config.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:multi_dropdown/widgets/hint_text.dart';
import 'package:multi_dropdown/widgets/selection_chip.dart';
import 'package:multi_dropdown/widgets/single_selected_item.dart';
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

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:dio/src/response.dart' as Response;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class addSparePart extends StatefulWidget {
  final String? id;
  addSparePart({this.id});
  @override
  _addSparePartState createState() => _addSparePartState();
}

class _addSparePartState extends State<addSparePart> {
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController sparePartNameController = TextEditingController();
  TextEditingController masterSparePartNameController = TextEditingController();
  TextEditingController sparePartNumberController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController specificationController = TextEditingController();
  TextEditingController machineModelNumberController = TextEditingController();
  final MultiSelectController _controller = MultiSelectController();
  TextEditingController drawingPdfController = new TextEditingController();
  TextEditingController imageController = new TextEditingController();

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
  String _selectedValue = "Spare Part Name";
  List MachineData = [];
  List sampleAInputtext = [];
  List sampleBInputText = [];
  List machineList = [];
  List<ValueItem> options = [];
  late String sendStatus;
  List<int>? imageBytes, drawingPdfFileBytes;
  String status = '',
      jobCarId = '',
      machineNameController = "",
      approvalStatus = "Approved",
      designation = '',
      SparePartId = '',
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
    getMachineListData();
  }

  void _handleRadioValueChange(value) {
    setState(() {
      _selectedValue = value!;
    });
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      File pdffile = File(result.files.single.path!);
      setState(() {
        imageBytes = pdffile.readAsBytesSync();
        imageController.text = result.files.single.name;
      });
    } else {
      // User canceled the file picker
    }
  }

  Future<void> _pickcocPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File pdffile = File(result.files.single.path!);
      setState(() {
        drawingPdfFileBytes = pdffile.readAsBytesSync();
        drawingPdfController.text = result.files.single.name;
      });
    } else {
      // User canceled the file picker
    }
  }

  getMachineModelNumber(machineId) async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    final url = (site! + 'Maintenance/MachineDetailById');

    http.post(
      Uri.parse(url),
      body: json.encode({"MachineId": machineId}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        var machineBody = jsonDecode(response.body);

        setState(() {
          machineModelNumberController.text =
              machineBody['data'][0]['MachineModelNumber'];
        });
        // print("machine list data");
        // print(machineModelNumberController.text);
      }
    });
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
          machineList = machineBody;
          // options = machineList
          //     .map((item) => ValueItem(
          //         label: item['MachineName']!, value: item['MachineId']!))
          //     .toList();
        });
        print("machine list data");
        print(machineList);
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

  uploadPDF(List<int> imageBytes, List<int> drawingPdfBytes) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    var formData = FormData.fromMap({
      "SparePartId": SparePartId,
      "SparePartImage": MultipartFile.fromBytes(
        imageBytes,
        filename: (imageController.text + (currentdate.toString()) + '.png'),
        contentType: MediaType("application", 'png'),
      ),
      "DrawingImage": MultipartFile.fromBytes(
        drawingPdfBytes,
        filename:
            (drawingPdfController.text + (currentdate.toString()) + '.pdf'),
        contentType: MediaType("application", 'pdf'),
      ),
    });

    _response = await _dio.post((site! + 'Maintenance/SparePartsImage'), // Prod

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

        Toast.show("Spare Part Added Successfully.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => WelcomePage()));
      } else {
        setState(() {
          _isLoading = false;
        });
        Toast.show("Error In Server",
            duration: Toast.lengthLong, gravity: Toast.center);
      }
    } catch (err) {
      print("Error");
    }
  }

  Future createData() async {
    var data = {
      "SparePartType": _selectedValue,
      "SparePartName": sparePartNameController.text,
      "Specification": specificationController.text,
      "SpareNumber": sparePartNumberController.text,
      "BrandName": brandNameController.text,
      "MachineName": MachineData ?? [],
      //  "MachineModelNumber": machineModelNumberController.text,
      "Status": "Active",
      "CurrentUser": personid
    };

    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    final url = (site! + "Maintenance/AddSparePart");

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

      if (objData['success'] == false) {
        setState(() {
          _isLoading = false;
        });
        Toast.show(objData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.redColor);
      } else {
        setState(() {
          SparePartId = objData['SparePartId'];
        });

        if ((imageBytes != null && imageBytes != "") ||
            (drawingPdfFileBytes != null && drawingPdfFileBytes != "")) {
          uploadPDF((imageBytes ?? []), (drawingPdfFileBytes ?? []));
        } else {
          Toast.show("Spare Part Added Successfully.",
              duration: Toast.lengthLong,
              gravity: Toast.center,
              backgroundColor: AppColors.blueColor);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => WelcomePage()),
              (Route<dynamic> route) => false);
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      Toast.show("Error In Server",
          duration: Toast.lengthLong, gravity: Toast.center);
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
                              color: Color.fromARGB(255, 136, 240, 132)
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
                                      "Add New Spare Part",
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
                                  "Spare Part Type",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                ListTile(
                                  title: const Text('Spare Part Name'),
                                  leading: Radio<String>(
                                    value: "Spare Part Name",
                                    groupValue: _selectedValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                ),

                                ListTile(
                                  title: const Text('Master Spare Part Name'),
                                  leading: Radio<String>(
                                    value: "Master Spare Part Name",
                                    groupValue: _selectedValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Text(
                                  _selectedValue == "Spare Part Name"
                                      ? "Spare Part Name"
                                      : "Master Spare Part Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: sparePartNameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: _selectedValue ==
                                            "Spare Part Name"
                                        ? "Please Enter Spare Part Name"
                                        : "Please Enter Master Spare Part Name",
                                    fillColor: Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: _selectedValue ==
                                                "Spare Part Name"
                                            ? "Please Enter Spare Part Name"
                                            : "Please Enter Master Spare Part Name",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Spare Part Model Number",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: sparePartNumberController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText:
                                        "Please Enter Spare Part Model Number",
                                    fillColor: Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText:
                                            "Please Enter Spare Part Model Number",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Brand Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: brandNameController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                    hintText: "Please Enter Brand Name",
                                    fillColor: Color.fromARGB(
                                            255, 187, 241, 185)
                                        .withOpacity(0.5), // Your desired color
                                    filled: true,
                                  ),
                                  style: AppStyles.textInputTextStyle,
                                  validator: MultiValidator(
                                    [
                                      RequiredValidator(
                                        errorText: "Please Enter Brand Name",
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
                                            255, 187, 241, 185)
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
                                  "Machine Name",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                                Container(
                                  child: MultiSelectDropDown.network(
                                    onOptionSelected: (options) {
                                      List<String> MachineData = [];
                                      options.forEach((element) {
                                        MachineData.add(element.value!);
                                      });
                                      print(
                                          '#########################################');
                                      print(MachineData);
                                    },
                                    networkConfig: NetworkConfig(
                                      url:
                                          'http://srv515471.hstgr.cloud:8080/Maintenance/MachineDetailById',
                                      method: RequestMethod.get,
                                      headers: {
                                        'Content-Type': 'application/json',
                                      },
                                    ),
                                    fieldBackgroundColor:
                                        Color.fromARGB(255, 187, 241, 185),
                                    chipConfig: const ChipConfig(
                                        backgroundColor: Colors.amber,
                                        labelColor: Colors.black,
                                        wrapType: WrapType.wrap),
                                    responseParser: (response) {
                                      final list =
                                          (response as List<dynamic>).map((e) {
                                        final item = e as Map<String, dynamic>;
                                        return ValueItem(
                                          label: item['MachineName'],
                                          value: item['MachineId'].toString(),
                                        );
                                      }).toList();

                                      return Future.value(list);
                                    },
                                    responseErrorBuilder: (context, body) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text('Error fetching the data'),
                                      );
                                    },
                                  ),
                                ),

                                // DropdownButtonFormField<String>(
                                //   decoration: AppStyles.textFieldInputDecoration
                                //       .copyWith(
                                //           hintText:
                                //               "Please Select Machine Name",
                                //           fillColor:
                                //               Color.fromARGB(255, 187, 241, 185)
                                //                   .withOpacity(0.5),
                                //           counterText: '',
                                //           contentPadding: EdgeInsets.all(10)),
                                //   borderRadius: BorderRadius.circular(20),
                                //   items: machineList
                                //       .map((label) => DropdownMenuItem(
                                //             child: Text(label['MachineName'],
                                //                 style: AppStyles
                                //                     .textInputTextStyle),
                                //             value:
                                //                 label['MachineId'].toString(),
                                //           ))
                                //       .toList(),
                                //   onChanged: (val) {
                                //     setState(() {
                                //       machineNameController = val!;
                                //     });
                                //     getMachineModelNumber(val!);
                                //   },
                                //   value: machineNameController != ''
                                //       ? machineNameController
                                //       : null,
                                //   validator: (value) {
                                //     if (value == null || value.isEmpty) {
                                //       return 'Please Select Machine Name';
                                //     }
                                //     return null;
                                //   },
                                // ),

                                // const SizedBox(
                                //   height: 15,
                                // ),
                                // Text(
                                //   "Machine Model Number",
                                //   style: AppStyles.textfieldCaptionTextStyle,
                                // ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                // TextFormField(
                                //   controller: machineModelNumberController,
                                //   keyboardType: TextInputType.text,
                                //   textInputAction: TextInputAction.next,
                                //   decoration: AppStyles.textFieldInputDecoration
                                //       .copyWith(
                                //     hintText:
                                //         "Please Enter Machine Model Number",
                                //     fillColor: Color.fromARGB(
                                //             255, 187, 241, 185)
                                //         .withOpacity(0.5), // Your desired color
                                //     filled: true,
                                //   ),
                                //   style: AppStyles.textInputTextStyle,
                                //   readOnly: true,
                                //   validator: MultiValidator(
                                //     [
                                //       RequiredValidator(
                                //         errorText:
                                //             "Please Enter Machine Model Number",
                                //       ),
                                //     ],
                                //   ),
                                // ),

                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Upload Image",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: imageController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                          hintText: "Please Select Image",
                                          fillColor: Color.fromARGB(
                                                  255, 187, 241, 185)
                                              .withOpacity(
                                                  0.5), // Your desired color
                                          filled: true,
                                          suffixIcon: IconButton(
                                            onPressed: () async {
                                              _pickImage();
                                            },
                                            icon: const Icon(
                                                Icons.open_in_browser),
                                          ),
                                          counterText: ''),
                                  style: AppStyles.textInputTextStyle,
                                  maxLines: 1,
                                  readOnly: true,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return "Please Select Image";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Upload Drawing Pdf",
                                  style: AppStyles.textfieldCaptionTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: drawingPdfController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                          hintText: "Please Select Drawing Pdf",
                                          fillColor: Color.fromARGB(
                                                  255, 187, 241, 185)
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
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return "Please Select Drawing Pdf";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
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
