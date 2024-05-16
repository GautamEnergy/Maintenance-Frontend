import 'dart:convert';
import 'dart:io';
import 'package:QCM/CommonDrawer.dart';
import 'package:QCM/Ipqc.dart';
import 'package:QCM/Welcomepage.dart';
import 'package:QCM/components/app_button_widget.dart';
import 'package:QCM/components/app_loader.dart';
import 'package:QCM/ipqcTestList.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:dio/src/response.dart' as Response;
import '../components/appbar.dart';
import '../constant/app_assets.dart';
import '../constant/app_color.dart';
import '../constant/app_fonts.dart';
import '../constant/app_helper.dart';

import '../constant/app_styles.dart';

class BomCard extends StatefulWidget {
  final String? id;
  BomCard({this.id});

  @override
  _BomCardState createState() => _BomCardState();
}

class _BomCardState extends State<BomCard> {
  final _bomCardFormKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  TextEditingController LineController = TextEditingController();
  TextEditingController poController = TextEditingController();

  TextEditingController solarCellSupplierController = TextEditingController();
  TextEditingController solarCellSpecificationController =
      TextEditingController();
  TextEditingController solarCellLotBatchController = TextEditingController();
  TextEditingController solarCellremarkController = TextEditingController();

  TextEditingController fluxLotBatchController = TextEditingController();
  TextEditingController fluxSpecificationController = TextEditingController();
  TextEditingController fluxSupplierController = TextEditingController();
  TextEditingController fluxremarkController = TextEditingController();

  TextEditingController ribbonSupplierController = TextEditingController();
  TextEditingController ribbonSpecificationController = TextEditingController();
  TextEditingController ribbonLotBatchController = TextEditingController();
  TextEditingController ribbonremarkController = TextEditingController();

  TextEditingController InterconnectorSupplierController =
      TextEditingController();
  TextEditingController InterconnectorLotBatchController =
      TextEditingController();
  TextEditingController InterconnectorSpecificationController =
      TextEditingController();
  TextEditingController InterconnectorremarkController =
      TextEditingController();

  TextEditingController GlassSupplierController = TextEditingController();
  TextEditingController GlassSpecificationController = TextEditingController();
  TextEditingController GlassLotBatchController = TextEditingController();
  TextEditingController GlassremarkController = TextEditingController();

  TextEditingController EvaGlassSupplierController = TextEditingController();
  TextEditingController EvaGlassSpecificationController =
      TextEditingController();
  TextEditingController EvaGlassLotBatchController = TextEditingController();
  TextEditingController EvaGlassremarkController = TextEditingController();

  TextEditingController EvaGlassSideSupplierController =
      TextEditingController();
  TextEditingController EvaGlassSideSpecificationController =
      TextEditingController();
  TextEditingController EvaGlassSideLotBatchController =
      TextEditingController();
  TextEditingController EvaGlassSideremarkController = TextEditingController();

  TextEditingController BackSheetSupplierController = TextEditingController();
  TextEditingController BackSheetSpecificationController =
      TextEditingController();
  TextEditingController BackSheetLotBatchController = TextEditingController();
  TextEditingController BackSheetremarkController = TextEditingController();

  TextEditingController FrameSupplierController = TextEditingController();
  TextEditingController FrameSpecificationController = TextEditingController();
  TextEditingController FrameLotBatchController = TextEditingController();
  TextEditingController FrameremarkController = TextEditingController();

  TextEditingController JunctionBoxSupplierController = TextEditingController();
  TextEditingController JunctionBoxSpecificationController =
      TextEditingController();
  TextEditingController JunctionBoxLotBatchController = TextEditingController();
  TextEditingController JunctionBoxremarkController = TextEditingController();

  TextEditingController pottingJBSupplierController = TextEditingController();
  TextEditingController pottingJBSpecificationController =
      TextEditingController();
  TextEditingController pottingJBLotBatchController = TextEditingController();
  TextEditingController pottingJBremarkController = TextEditingController();

  TextEditingController FrameAdhesiveSupplierController =
      TextEditingController();
  TextEditingController FrameAdhesiveSpecificationController =
      TextEditingController();
  TextEditingController FrameAdhesiveLotBatchController =
      TextEditingController();
  TextEditingController FrameAdhesiveremarkController = TextEditingController();

  TextEditingController RfidSupplierController = TextEditingController();
  TextEditingController RfidSpecificationController = TextEditingController();
  TextEditingController RfidLotBatchController = TextEditingController();
  TextEditingController RfidremarkController = TextEditingController();
  TextEditingController referencePdfController = new TextEditingController();
  bool menu = false, user = false, face = false, home = false;
  bool _isLoading = false;
  String setPage = '',
      pic = '',
      site = '',
      designation = '',
      status = '',
      BomId = '',
      token = '',
      personid = '',
      bomCardDate = '',
      approvalStatus = "Approved",
      department = '';
  String invoiceDate = '';
  late String dateOfQualityCheck;

  List<int>? referencePdfFileBytes;
  late String sendStatus;
  bool? isCycleTimeTrue;
  bool? isBacksheetCuttingTrue;
  Response.Response? _response;
  final _dio = dio.Dio();

  @override
  void initState() {
    super.initState();
    store();
  }

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
    final AllSolarData = ((site!) + 'IPQC/GetSpecificBOMVerification');
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
          status = resBody['data']['Status'] ?? '';
          bomCardDate = resBody['data']['Date'] ?? '';
          dateController.text = resBody['data']['Date'] != ''
              ? DateFormat("EEE MMM dd, yyyy")
                  .format(DateTime.parse(resBody['data']['Date'].toString()))
              : '';
          shiftController.text = resBody['data']['Shift'] ?? '';
          LineController.text = resBody['data']['Line'] ?? '';
          poController.text = resBody['data']['PONo'] ?? '';
          // Solar Cell
          solarCellSupplierController.text =
              resBody['data']['SolarCell Supplier'] ?? '';
          solarCellSpecificationController.text =
              resBody['data']['SolarCell ModelNo'] ?? '';
          solarCellLotBatchController.text =
              resBody['data']['SolarCell BatchNo'] ?? '';
          solarCellremarkController.text =
              resBody['data']['SolarCell Remarks'] ?? '';
          // Flux
          fluxSupplierController.text = resBody['data']['Flux Supplier'] ?? '';
          fluxSpecificationController.text =
              resBody['data']['Flux ModelNo'] ?? '';
          fluxLotBatchController.text = resBody['data']['Flux BatchNo'] ?? '';
          fluxremarkController.text = resBody['data']['Flux Remarks'] ?? '';
          // Ribbon
          ribbonSupplierController.text =
              resBody['data']['Ribbon Supplier'] ?? '';
          ribbonSpecificationController.text =
              resBody['data']['Ribbon ModelNo'] ?? '';
          ribbonLotBatchController.text =
              resBody['data']['Ribbon BatchNo'] ?? '';
          ribbonremarkController.text = resBody['data']['Ribbon Remarks'] ?? '';
          // InterConnector Busbar
          InterconnectorSupplierController.text =
              resBody['data']['Interconnector/Bus-bar Supplier'] ?? '';
          InterconnectorSpecificationController.text =
              resBody['data']['Interconnector/Bus-bar ModelNo'] ?? '';
          InterconnectorLotBatchController.text =
              resBody['data']['Interconnector/Bus-bar BatchNo'] ?? '';
          InterconnectorremarkController.text =
              resBody['data']['Interconnector/Bus-bar Remarks'] ?? '';
          // Glass
          GlassSupplierController.text =
              resBody['data']['Glass Supplier'] ?? '';
          GlassSpecificationController.text =
              resBody['data']['Glass ModelNo'] ?? '';
          GlassLotBatchController.text = resBody['data']['Glass BatchNo'] ?? '';
          GlassremarkController.text = resBody['data']['Glass Remarks'] ?? '';
          // EvaGlass(Front)
          EvaGlassSupplierController.text =
              resBody['data']['Eva Glass side(frontEVA) Supplier'] ?? '';
          EvaGlassSpecificationController.text =
              resBody['data']['Eva Glass side(frontEVA) ModelNo'] ?? '';
          EvaGlassLotBatchController.text =
              resBody['data']['Eva Glass side(frontEVA) BatchNo'] ?? '';
          EvaGlassremarkController.text =
              resBody['data']['Eva Glass side(frontEVA) Remarks'] ?? '';
          // EvaGlass(rear)
          EvaGlassSideSupplierController.text =
              resBody['data']['Eva Glass Side(rear EVA) Supplier'] ?? '';
          EvaGlassSideSpecificationController.text =
              resBody['data']['Eva Glass Side(rear EVA) ModelNo'] ?? '';
          EvaGlassSideLotBatchController.text =
              resBody['data']['Eva Glass Side(rear EVA) BatchNo'] ?? '';
          EvaGlassSideremarkController.text =
              resBody['data']['Eva Glass Side(rear EVA) Remarks'] ?? '';
          // BackSheet
          BackSheetSupplierController.text =
              resBody['data']['Back Sheet Supplier'] ?? '';
          BackSheetSpecificationController.text =
              resBody['data']['Back Sheet ModelNo'] ?? '';
          BackSheetLotBatchController.text =
              resBody['data']['Back Sheet BatchNo'] ?? '';
          BackSheetremarkController.text =
              resBody['data']['Back Sheet Remarks'] ?? '';
          // Frame
          FrameSupplierController.text =
              resBody['data']['Frame Supplier'] ?? '';
          FrameSpecificationController.text =
              resBody['data']['Frame ModelNo'] ?? '';
          FrameLotBatchController.text = resBody['data']['Frame BatchNo'] ?? '';
          FrameremarkController.text = resBody['data']['Frame Remarks'] ?? '';
          // junction Box
          JunctionBoxSupplierController.text =
              resBody['data']['Junction Box Supplier'] ?? '';
          JunctionBoxSpecificationController.text =
              resBody['data']['Junction Box ModelNo'] ?? '';
          JunctionBoxLotBatchController.text =
              resBody['data']['Junction Box BatchNo'] ?? '';
          JunctionBoxremarkController.text =
              resBody['data']['Junction Box Remarks'] ?? '';
          // Potting
          pottingJBSupplierController.text =
              resBody['data']['Potting JB Sealant(A:B) Supplier'] ?? '';
          pottingJBSpecificationController.text =
              resBody['data']['Potting JB Sealant(A:B) ModelNo'] ?? '';
          pottingJBLotBatchController.text =
              resBody['data']['Potting JB Sealant(A:B) BatchNo'] ?? '';
          pottingJBremarkController.text =
              resBody['data']['Potting JB Sealant(A:B) Remarks'] ?? '';
          // Frame Adhesive
          FrameAdhesiveSupplierController.text =
              resBody['data']['Frame Adhesive sealant Supplier'] ?? '';
          FrameAdhesiveSpecificationController.text =
              resBody['data']['Frame Adhesive sealant ModelNo'] ?? '';
          FrameAdhesiveLotBatchController.text =
              resBody['data']['Frame Adhesive sealant BatchNo'] ?? '';
          FrameAdhesiveremarkController.text =
              resBody['data']['Frame Adhesive sealant Remarks'] ?? '';
          // RFID
          RfidSupplierController.text = resBody['data']['RFID Supplier'] ?? '';
          RfidSpecificationController.text =
              resBody['data']['RFID ModelNo'] ?? '';
          RfidLotBatchController.text = resBody['data']['RFID BatchNo'] ?? '';
          RfidremarkController.text = resBody['data']['RFID Remarks'] ?? '';
          referencePdfController.text = resBody['data']['ReferencePdf'] ?? '';
        }
      });
    }
  }

  Future setApprovalStatus() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();
    final url = (site! + "IPQC/UpdateBOMStatus");

    var params = {
      "token": token,
      "CurrentUser": personid,
      "Status": approvalStatus,
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
        Toast.show("BOM Verification Test $approvalStatus .",
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

  Future findData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;
    var Bom = [
      {
        "Type": "BOM Verification",
        "BOMDetailId": BomId != '' && BomId != null
            ? BomId
            : widget.id != '' && widget.id != null
                ? widget.id
                : '',
        "CurrentUser": personid,
        "Status": sendStatus,
        "DocNo": "GSPL/IPQC/BM/002",
        "RevNo": "1.0 & 12.08.2023",
        "PONo": poController.text,
        "Date": bomCardDate,
        "Shift": shiftController.text,
        "Line": LineController.text,
      },
      [
        {
          "BOMitem": "SolarCell",
          "Supplier": solarCellSupplierController.text,
          "ModelNo": solarCellSpecificationController.text,
          "BatchNo": solarCellLotBatchController.text,
          "Remarks": solarCellremarkController.text
        },
        {
          "BOMitem": "Flux",
          "BatchNo": fluxLotBatchController.text,
          "ModelNo": fluxSpecificationController.text,
          "Supplier": fluxSupplierController.text,
          "Remarks": fluxremarkController.text
        },
        {
          "BOMitem": "Ribbon",
          "Supplier": ribbonSupplierController.text,
          "ModelNo": ribbonSpecificationController.text,
          "BatchNo": ribbonLotBatchController.text,
          "Remarks": ribbonremarkController.text
        },
        {
          "BOMitem": "Interconnector/Bus-bar",
          "Supplier": InterconnectorSupplierController.text,
          "ModelNo": InterconnectorSpecificationController.text,
          "BatchNo": InterconnectorLotBatchController.text,
          "Remarks": InterconnectorremarkController.text
        },
        {
          "BOMitem": "Glass",
          "Supplier": GlassSupplierController.text,
          "ModelNo": GlassSpecificationController.text,
          "BatchNo": GlassLotBatchController.text,
          "Remarks": GlassremarkController.text
        },
        {
          "BOMitem": "Eva Glass side(frontEVA)",
          "Supplier": EvaGlassSupplierController.text,
          "ModelNo": EvaGlassSpecificationController.text,
          "BatchNo": EvaGlassLotBatchController.text,
          "Remarks": EvaGlassremarkController.text
        },
        {
          "BOMitem": "Eva Glass Side(rear EVA)",
          "Supplier": EvaGlassSideSupplierController.text,
          "ModelNo": EvaGlassSideSpecificationController.text,
          "BatchNo": EvaGlassSideLotBatchController.text,
          "Remarks": EvaGlassSideremarkController.text
        },
        {
          "BOMitem": "Back Sheet",
          "Supplier": BackSheetSupplierController.text,
          "ModelNo": BackSheetSpecificationController.text,
          "BatchNo": BackSheetLotBatchController.text,
          "Remarks": BackSheetremarkController.text
        },
        {
          "BOMitem": "Frame",
          "Supplier": FrameSupplierController.text,
          "ModelNo": FrameSpecificationController.text,
          "BatchNo": FrameLotBatchController.text,
          "Remarks": FrameremarkController.text
        },
        {
          "BOMitem": "Junction Box",
          "Supplier": JunctionBoxSupplierController.text,
          "ModelNo": JunctionBoxSpecificationController.text,
          "BatchNo": JunctionBoxLotBatchController.text,
          "Remarks": JunctionBoxremarkController.text
        },
        {
          "BOMitem": "Potting JB Sealant(A:B)",
          "Supplier": pottingJBSupplierController.text,
          "ModelNo": pottingJBSpecificationController.text,
          "BatchNo": pottingJBLotBatchController.text,
          "Remarks": pottingJBremarkController.text
        },
        {
          "BOMitem": "Frame Adhesive sealant",
          "Supplier": FrameAdhesiveSupplierController.text,
          "ModelNo": FrameAdhesiveSpecificationController.text,
          "BatchNo": FrameAdhesiveLotBatchController.text,
          "Remarks": FrameAdhesiveremarkController.text
        },
        {
          "BOMitem": "RFID",
          "Supplier": RfidSupplierController.text,
          "ModelNo": RfidSpecificationController.text,
          "BatchNo": RfidLotBatchController.text,
          "Remarks": RfidremarkController.text
        },
      ]
    ];
    print('Sending data to backend: $Bom');
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    final url = (site! + "IPQC/AddBOMVerification");
    var response = await http.post(
      Uri.parse(url),
      body: json.encode(Bom),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var objData = json.decode(response.body);
      setState(() {
        BomId = objData['UUID'];
        _isLoading = false;
      });
      print(objData);
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
      "JobCardDetailId": BomId,
      "ReferencePdf": MultipartFile.fromBytes(
        referenceBytes,
        filename:
            (referencePdfController.text + (currentdate.toString()) + '.pdf'),
        contentType: MediaType("application", 'pdf'),
      ),
    });

    _response = await _dio.post((site! + 'IPQC/BOMUploadPdf'), // Prod

        options: Options(
          contentType: 'multipart/form-data',
          followRedirects: false,
          validateStatus: (status) => true,
        ),
        data: formData);

    try {
      print(_response?.statusCode);
      if (_response?.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });

        Toast.show("BOM Verification Test Completed.",
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
            findData();
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
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      SingleChildScrollView(
                        child: Form(
                          key: _bomCardFormKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      child: Text("Inprocess Quality Controll",
                                          style: TextStyle(
                                              fontSize: 27,
                                              color: AppColors.black,
                                              fontFamily: appFontFamily,
                                              fontWeight: FontWeight.w700)))),
                              const Center(
                                  child: Text("(BOM Verificatio CheckSheet)",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: AppColors.black,
                                          fontFamily: appFontFamily,
                                          fontWeight: FontWeight.w700))),
                              const SizedBox(
                                height: 35,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Document No : ',
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'GSPL/IPQC/BM/002',
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                ],
                              ),

                              // *************************** Revisional Number ********************
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Rev.No./Dated : ',
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Ver.1.0 & 12-08-2023',
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                ],
                              ),

                              // ************ Date *********
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Date",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              TextFormField(
                                  controller: dateController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: AppStyles.textFieldInputDecoration
                                      .copyWith(
                                          hintText: "Please Enter Date",
                                          counterText: '',
                                          suffixIcon: Image.asset(
                                            AppAssets.icCalenderBlue,
                                            color: AppColors.primaryColor,
                                          )),
                                  style: AppStyles.textInputTextStyle,
                                  readOnly:
                                      status == 'Pending' && designation != "QC"
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
                                          lastDate: DateTime.now()))!;
                                      dateController.text =
                                          DateFormat("EEE MMM dd, yyyy").format(
                                              DateTime.parse(date.toString()));
                                      setState(() {
                                        bomCardDate = DateFormat("yyyy-MM-dd")
                                            .format(DateTime.parse(
                                                date.toString()));
                                      });
                                    }
                                  },
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: "Please Enter Date")
                                  ])),
                              const SizedBox(
                                height: 15,
                              ),
                              // ******************** Shift *********************
                              Text(
                                "Shift",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              TextFormField(
                                controller: shiftController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter Shift",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter Shift";
                                  } else {
                                    return null;
                                  }
                                },
                              ),

                              // *********** Line ********

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Line.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: LineController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter Line.",
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter Line.",
                                    ),
                                  ],
                                ),
                              ),

                              // ************  PO Number ***********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "PO Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),

                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: poController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please PO Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please PO Number",
                                    ),
                                  ],
                                ),
                              ),

                              //  ********   BOM Verification Check sheet ********************

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "Solar Cell",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              // *************  Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: solarCellSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter Supplier",
                                    ),
                                  ],
                                ),
                              ),

                              // ********** Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: solarCellSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

                              // ************* Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: solarCellLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

                              // *************************** Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: solarCellremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter Remark",
                                    ),
                                  ],
                                ),
                              ),

                              // *********** Flux *********************

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "Flux ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              // *********************  Flux-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: fluxSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter flux-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter flux-Supplier",
                                    ),
                                  ],
                                ),
                              ),

                              // **************** Flux-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: fluxSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter flux-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter flux-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

                              // *************************** Flux- Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: fluxLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter flux-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter flux-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

                              // *************** Remark *********************
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: fluxremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter  flux-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter flux-Remark",
                                    ),
                                  ],
                                ),
                              ),

                              // ############   Ribbon ########################################

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "Ribbon ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              // ****  ribbon-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: ribbonSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter ribbon-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter ribbon-Supplier",
                                    ),
                                  ],
                                ),
                              ),

                              // ********* ribbon-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: ribbonSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter ribbon-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter ribbon-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

                              // ********************* ribbon-Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: ribbonLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter ribbon-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter ribbon-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

                              // *************************** ribbon-Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: ribbonremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter  ribbon-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter ribbon-Remark",
                                    ),
                                  ],
                                ),
                              ),

                              // ################   Interconnector-Bus-bar ######################

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "Interconnector Bus-bar",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              // *********************  Interconnector-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: InterconnectorSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Interconnector-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Interconnector-Supplier",
                                    ),
                                  ],
                                ),
                              ),

                              // *********  Interconnector-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller:
                                    InterconnectorSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Interconnector-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Interconnector-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

                              // *******  Interconnector-Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: InterconnectorLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Interconnector-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Interconnector-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

                              // ********** Interconnector-Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: InterconnectorremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter  Interconnector-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Interconnector-Remark",
                                    ),
                                  ],
                                ),
                              ),

                              // ########   Glass ########

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "Glass ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              // ***************  Glass-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: GlassSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter Glass-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter Glass-Supplier",
                                    ),
                                  ],
                                ),
                              ),

                              // ************ Glass-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: GlassSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Glass-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Glass-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

                              // ******* Glass-Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: GlassLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Glass-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Glass-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

                              // *************** Glass-Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: GlassremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter  Glass-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter Glass-Remark",
                                    ),
                                  ],
                                ),
                              ),

                              // ########  Eva Glass side(FrontEVA)  ##########

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "EVA Glass side(frontEVA) ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              // *********************  Eva-Glass-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: EvaGlassSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter Eva-Glass-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Eva-Glass-Supplier",
                                    ),
                                  ],
                                ),
                              ),

// *************************** Eva-Glass-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: EvaGlassSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Eva-Glass-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Eva-Glass-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

// *************************** Eva-Glass-Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: EvaGlassLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Eva-Glass-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Eva-Glass-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

// *************************** EvaGlass-Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: EvaGlassremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter  EvaGlass-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter EvaGlass-Remark",
                                    ),
                                  ],
                                ),
                              ),

// ####################################  Eva Glass side(rear EVA)  ########################################

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "EVA Glass Side(rearEVA)",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

// ********************* EvaGlassSide-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: EvaGlassSideSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter EvaGlassSide-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter EvaGlassSide-Supplier",
                                    ),
                                  ],
                                ),
                              ),

// *************************** EvaGlassSide-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: EvaGlassSideSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter EvaGlassSide-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter EvaGlassSide-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

// *************************** EvaGlassSide-Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: EvaGlassSideLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter EvaGlassSide-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter EvaGlassSide-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

// *************************** EvaGlassSide-Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: EvaGlassSideremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter  EvaGlassSide-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter EvaGlassSide-Remark",
                                    ),
                                  ],
                                ),
                              ),

// ####################################  Back Sheet  ########################################

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "Back Sheet",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

// ********************* BackSheet-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: BackSheetSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter BackSheet-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter BackSheet-Supplier",
                                    ),
                                  ],
                                ),
                              ),

// *************************** BackSheet-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: BackSheetSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter BackSheet-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter BackSheet-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

// *************************** BackSheet-Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: BackSheetLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter BackSheet-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter BackSheet-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

// *************************** BackSheet-Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: BackSheetremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter  BackSheet-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter BackSheet-Remark",
                                    ),
                                  ],
                                ),
                              ),

// ####################################  Frame  ########################################

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "Frame ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

// ********************* Frame-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: FrameSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter Frame-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter Frame-Supplier",
                                    ),
                                  ],
                                ),
                              ),

// ***************************Frame-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: FrameSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Frame-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Frame-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

// *************************** Frame-Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: FrameLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Frame-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Frame-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

// *************************** Frame-Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: FrameremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter  Frame-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter Frame-Remark",
                                    ),
                                  ],
                                ),
                              ),

// ####################################  JunctionBox  ########################################

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "Junction Box ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

// ********************* JunctionBox-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: JunctionBoxSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter JunctionBox-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter JunctionBox-Supplier",
                                    ),
                                  ],
                                ),
                              ),

// *************************** JunctionBox-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: JunctionBoxSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter JunctionBox-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter JunctionBox-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

// *************************** JunctionBox-Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: JunctionBoxLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter JunctionBox-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter JunctionBox-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

// *************************** JunctionBox-Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: JunctionBoxremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter  JunctionBox-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter JunctionBox-Remark",
                                    ),
                                  ],
                                ),
                              ),

// ####################################  Potting JB Sealant(A-B)   ########################################

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "Potting JB Sealant(A-B) ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

// ********************* pottingJB-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: pottingJBSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter pottingJB-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter pottingJB-Supplier",
                                    ),
                                  ],
                                ),
                              ),

// *************************** pottingJB-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: pottingJBSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter pottingJB-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter pottingJB-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

// *************************** pottingJB-Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: pottingJBLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter pottingJB-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter pottingJB-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

// *************************** pottingJB-Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: pottingJBremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter  pottingJB-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter pottingJB-Remark",
                                    ),
                                  ],
                                ),
                              ),

// #################################### Frame Adhesive Sealant   ########################################

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "Frame Adhesive Sealant",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

// ********************* FrameAdhesive-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: FrameAdhesiveSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter FrameAdhesive-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter FrameAdhesive-Supplier",
                                    ),
                                  ],
                                ),
                              ),

// *************************** FrameAdhesive-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller:
                                    FrameAdhesiveSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter FrameAdhesive-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter FrameAdhesive-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

// *************************** FrameAdhesive-Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: FrameAdhesiveLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter FrameAdhesive-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter FrameAdhesive-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

// *************************** FrameAdhesive-Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: FrameAdhesiveremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter  FrameAdhesive-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter FrameAdhesive-Remark",
                                    ),
                                  ],
                                ),
                              ),

// #################################### RFID   ########################################

                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  "RFID",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.primaryColor,
                                    fontFamily: appFontFamily,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

// ********************* Rfid-Supplier ************************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Supplier",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: RfidSupplierController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter Rfid-Supplier",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter Rfid-Supplier",
                                    ),
                                  ],
                                ),
                              ),

// *************************** Rfid-Specification / Model No. *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Specification / Model No.",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: RfidSpecificationController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Rfid-Specification / Model No.",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Rfid-Specification / Model No.",
                                    ),
                                  ],
                                ),
                              ),

// *************************** Rfid-Lot/Batch Number *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lot/Batch Number",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: RfidLotBatchController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText:
                                      "Please Enter Rfid-Lot/Batch Number",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText:
                                          "Please Enter Rfid-Lot/Batch Number",
                                    ),
                                  ],
                                ),
                              ),

// *************************** Rfid-Remark *********************

                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remark",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: RfidremarkController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                  hintText: "Please Enter  Rfid-Remark",
                                  counterText: '',
                                ),
                                style: AppStyles.textInputTextStyle,
                                readOnly:
                                    status == 'Pending' && designation != "QC"
                                        ? true
                                        : false,
                                maxLines: 3,
                                validator: MultiValidator(
                                  [
                                    RequiredValidator(
                                      errorText: "Please Enter Rfid-Remark",
                                    ),
                                  ],
                                ),
                              ),

// *************************** Some style for the All Data *********************

                              const SizedBox(
                                height: 15,
                              ),

// ****************** ****** *********
                              Text(
                                "Reference PDF Document ",
                                style: AppStyles.textfieldCaptionTextStyle,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: referencePdfController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration:
                                    AppStyles.textFieldInputDecoration.copyWith(
                                        hintText: "Please Select Reference Pdf",
                                        suffixIcon: IconButton(
                                          onPressed: () async {
                                            if (widget.id != null &&
                                                widget.id != '' &&
                                                referencePdfController.text !=
                                                    '') {
                                              UrlLauncher.launch(
                                                  referencePdfController.text);
                                            } else if (status != 'Pending') {
                                              _pickReferencePDF();
                                            }
                                          },
                                          icon: widget.id != null &&
                                                  widget.id != '' &&
                                                  referencePdfController.text !=
                                                      ''
                                              ? const Icon(Icons.download)
                                              : const Icon(Icons.upload_file),
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

                              const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                              _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : (widget.id == "" || widget.id == null) ||
                                          (status == 'Inprogress' &&
                                              widget.id != null)
                                      ? AppButton(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.white,
                                            fontSize: 16,
                                          ),
                                          onTap: () {
                                            AppHelper.hideKeyboard(context);
                                            setState(() {
                                              sendStatus = "Inprogress";
                                            });
                                            findData();
                                          },
                                          label: "Save",
                                          organization: '',
                                        )
                                      : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              (widget.id == "" || widget.id == null) ||
                                      (status == 'Inprogress' &&
                                          widget.id != null)
                                  ? AppButton(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.white,
                                        fontSize: 16,
                                      ),
                                      onTap: () {
                                        AppHelper.hideKeyboard(context);
                                        _bomCardFormKey.currentState!.save;
                                        if (_bomCardFormKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            sendStatus = "Pending";
                                          });
                                          findData();
                                        }
                                      },
                                      label: "Submit",
                                      organization: '',
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              if (widget.id != "" &&
                                  widget.id != null &&
                                  status == 'Pending')
                                Container(
                                  color: Color.fromARGB(255, 191, 226, 187),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Divider(),
                                      SizedBox(height: 15),
                                      AppButton(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.white,
                                            fontSize: 16),
                                        onTap: () {
                                          AppHelper.hideKeyboard(context);
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
                              const SizedBox(
                                height: 25,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                  ),
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
