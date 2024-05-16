import 'dart:convert';
import 'dart:io';
import 'package:QCM/CommonDrawer.dart';
import 'package:QCM/Iqcp.dart';
import 'package:QCM/IqcpTestList.dart';
import 'package:QCM/Welcomepage.dart';
import 'package:QCM/components/app_button_widget.dart';
import 'package:QCM/components/app_loader.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/src/response.dart' as Response;
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../components/appbar.dart';
import '../constant/app_assets.dart';
import '../constant/app_color.dart';
import '../constant/app_fonts.dart';
import '../constant/app_helper.dart';
import '../constant/app_styles.dart';

class Ribbon extends StatefulWidget {
  final String? id;
  Ribbon({this.id});
  _RibbonState createState() => _RibbonState();
}

class _RibbonState extends State<Ribbon> {
  int numberOfPackagingSampleFields = 1,
      numberOfVisualSampleFields = 0,
      numberOfPhysicalSampleFields = 0,
      numberOfFrontbusSampleFields = 0,
      numberOfVerificationSampleFields = 0,
      numberOfElectricalSampleFields = 0,
      numberOfPerformanceSampleFields = 0;

  List<TextEditingController> packagingBarcodeControllers = [];
  List<TextEditingController> packagingRemarksControllers = [];
  List<TextEditingController> visualBarcodeControllers = [];
  List<TextEditingController> visualRemarksControllers = [];
  List<TextEditingController> physicalBarcodeControllers = [];
  List<TextEditingController> physicalRemarksControllers = [];
  List<TextEditingController> frontbusBarcodeControllers = [];
  List<TextEditingController> frontbusRemarksControllers = [];
  List<TextEditingController> verificationBarcodeControllers = [];
  List<TextEditingController> verificationRemarksControllers = [];
  List<TextEditingController> electricalBarcodeControllers = [];
  List<TextEditingController> electricalRemarksControllers = [];
  List<TextEditingController> performanceBarcodeControllers = [];
  List<TextEditingController> performanceRemarksControllers = [];
  late List<bool> selectedPackagingTestValues,
      selectedVisualTestValues,
      selectedPhysicalTestValues,
      selectedFrontbusTestValues,
      selectedVerificationTestValues,
      selectedElectricalTestValues,
      selectedPerformanceTestValues; // Radio button values
  // late GlobalKey<FormState> packagingFormkey;

  List<int>? invoicePdfFileBytes, cocPdfFileBytes;
  final _dio = Dio();

  Response.Response? _response;
  String? invoiceDate,
      result = "Fail",
      sendStatus,
      status,
      SolarDetailId,
      approvalStatus = "Approved",
      receiptDate,
      dateOfQualityCheck,
      personid,
      firstname,
      lastname,
      pic,
      designation,
      token,
      department,
      ImagePath,
      organizationName,
      // organizationtype,
      organizationid,
      logo,
      site,
      businessname,
      setPage = "heading",
      choice = 'no',
      otp = '',
      otpexpiretime = '',
      barcodeScanRes;

  bool menu = false, user = false, face = false, home = false;

  double padding = 10;

  List data = [];

  List Packaging = [],
      Visual = [],
      Physical = [],
      FrontBus = [],
      Verification = [],
      Electrical = [],
      Performance = [];
  // ..............Start..........................
  List packagingSampleData = [];
  List visualSampleData = [];
  List physicalSampleData = [];
  List frontbusSampleData = [];
  List verificationSampleData = [];
  List electricalSampleData = [];
  List performanceSampleData = [];

  bool packagingRejection = false,
      visualRejection = false,
      physicalRejection = false,
      frontbusRejection = false,
      verificationRejection = false,
      electricalRejection = false,
      performanceRejection = false;
  // .............End...........................

  bool _isLoading = false;

  TextEditingController supplierNameController = new TextEditingController();
  TextEditingController invoiceDateController = new TextEditingController();
  TextEditingController receiptDateController = new TextEditingController();
  TextEditingController rawMaterialSpecsController =
      new TextEditingController();
  TextEditingController dateOfQualityCheckController =
      new TextEditingController();
  TextEditingController rMBatchNoController = new TextEditingController();
  TextEditingController invoiceNoController = new TextEditingController();
  TextEditingController lotSizeController = new TextEditingController();
// Packaging
  TextEditingController cocPdfController = new TextEditingController();
  TextEditingController invoicePdfController = new TextEditingController();

  TextEditingController rejectionReasonController = new TextEditingController();
  TextEditingController rejectionReasonStatusController =
      new TextEditingController();

  TextEditingController packagingCharactersticsController =
      new TextEditingController();
  TextEditingController packagingMeasuringMethodController =
      new TextEditingController();
  TextEditingController packagingSamplingController =
      new TextEditingController();
  TextEditingController packagingSampleSizeController =
      new TextEditingController();
  TextEditingController packagingReferenceDocController =
      new TextEditingController();
  TextEditingController packagingAcceptanceCriteriaController =
      new TextEditingController();
// Visual
  TextEditingController visualCharactersticsController =
      new TextEditingController();
  TextEditingController visualMeasuringMethodController =
      new TextEditingController();
  TextEditingController visualSamplingController = new TextEditingController();
  TextEditingController visualSampleSizeController =
      new TextEditingController();
  TextEditingController visualReferenceDocController =
      new TextEditingController();
  TextEditingController visualAcceptanceCriteriaController =
      new TextEditingController();

  // Physical
  TextEditingController physicalCharactersticsController =
      new TextEditingController();
  TextEditingController physicalMeasuringMethodController =
      new TextEditingController();
  TextEditingController physicalSamplingController =
      new TextEditingController();
  TextEditingController physicalSampleSizeController =
      new TextEditingController();
  TextEditingController physicalReferenceDocController =
      new TextEditingController();
  TextEditingController physicalAcceptanceCriteriaController =
      new TextEditingController();

  // Front Bus
  TextEditingController frontbusCharactersticsController =
      new TextEditingController();
  TextEditingController frontbusMeasuringMethodController =
      new TextEditingController();
  TextEditingController frontbusSamplingController =
      new TextEditingController();
  TextEditingController frontbusSampleSizeController =
      new TextEditingController();
  TextEditingController frontbusReferenceDocController =
      new TextEditingController();
  TextEditingController frontbusAcceptanceCriteriaController =
      new TextEditingController();

  // Verification
  TextEditingController verificationCharactersticsController =
      new TextEditingController();
  TextEditingController verificationMeasuringMethodController =
      new TextEditingController();
  TextEditingController verificationSamplingController =
      new TextEditingController();
  TextEditingController verificationSampleSizeController =
      new TextEditingController();
  TextEditingController verificationReferenceDocController =
      new TextEditingController();
  TextEditingController verificationAcceptanceCriteriaController =
      new TextEditingController();

  // Electrical
  TextEditingController electricalCharactersticsController =
      new TextEditingController();
  TextEditingController electricalMeasuringMethodController =
      new TextEditingController();
  TextEditingController electricalSamplingController =
      new TextEditingController();
  TextEditingController electricalSampleSizeController =
      new TextEditingController();
  TextEditingController electricalReferenceDocController =
      new TextEditingController();
  TextEditingController electricalAcceptanceCriteriaController =
      new TextEditingController();

  // Performance
  TextEditingController performanceCharactersticsController =
      new TextEditingController();
  TextEditingController performanceMeasuringMethodController =
      new TextEditingController();
  TextEditingController performanceSamplingController =
      new TextEditingController();
  TextEditingController performanceSampleSizeController =
      new TextEditingController();
  TextEditingController performanceReferenceDocController =
      new TextEditingController();
  TextEditingController performanceAcceptanceCriteriaController =
      new TextEditingController();
//....................End......................................

  GlobalKey<FormState> packagingFormkey = GlobalKey<FormState>();
  GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _visualFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _visualsampleformKey = GlobalKey<FormState>();
  GlobalKey<FormState> _physicalFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _physicalsampleformKey = GlobalKey<FormState>();
  GlobalKey<FormState> _frontbusFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _frontbussampleformKey = GlobalKey<FormState>();
  GlobalKey<FormState> _verificationFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _verificationsampleformKey = GlobalKey<FormState>();
  GlobalKey<FormState> _electricalFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _electricalsampleformKey = GlobalKey<FormState>();
  GlobalKey<FormState> _performanceFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _performancesampleformKey = GlobalKey<FormState>();
  GlobalKey<FormState> _resultFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    store();
    setState(() {
      // Packaging  // Visual
      packagingCharactersticsController.text = "Packing (Make Type)";
      packagingMeasuringMethodController.text = "N/A";
      packagingSamplingController.text = "Whole Lot";
      packagingSampleSizeController.text = "100 %";
      packagingReferenceDocController.text = "PO/INVOICE";
      packagingAcceptanceCriteriaController.text =
          "No Physical Damage / No Mismatch against PO/Invoice";
      // Visual  // Physical
      visualCharactersticsController.text = "Width X Thickness";
      visualMeasuringMethodController.text = "Verner Calliper/Measuring Scale";
      visualSamplingController.text = "SIL S3 AQL 4.0";
      // visualSampleSizeController.text = "100 %";
      visualReferenceDocController.text = "COC";
      visualAcceptanceCriteriaController.text = "Data sheet/IQC Ribbon";

      //  Physical   // Verification
      physicalCharactersticsController.text = "Coating Thickness";
      physicalMeasuringMethodController.text = "N/A";
      physicalSamplingController.text = "As Per Material Data sheet";
      // physicalSampleSizeController.text = "100 %";
      physicalReferenceDocController.text = "COC";
      physicalAcceptanceCriteriaController.text =
          "Coating Thickness > 20-25 Microns";

      //  Front Bus  // Performance
      frontbusCharactersticsController.text = "Soldering Peel Test";
      frontbusMeasuringMethodController.text = "Digital Force Gauge";
      frontbusSamplingController.text = "One Sample Per Lot";
      frontbusSampleSizeController.text = '1';
      // frontbusSampleSizeController.text = "100 %";
      frontbusReferenceDocController.text = "GSPL Technical Specification";
      frontbusAcceptanceCriteriaController.text =
          "1 N to 2N-Cell Frontside 1N to 3N Cell Back Side";

      //  Verification  // Verification 1
      verificationCharactersticsController.text = "Tensile Strength";
      verificationMeasuringMethodController.text = "N/A";
      verificationSamplingController.text = "N/A";
      // verificationSampleSizeController.text = "100 %";
      verificationReferenceDocController.text = "As Per COC";
      verificationAcceptanceCriteriaController.text =
          "GSPL Technical Specification/COC";

      //  Electrical  // Verification 2
      electricalCharactersticsController.text = "Yield Strength";
      electricalMeasuringMethodController.text = "N/A";
      electricalSamplingController.text = "N/A";
      // electricalSampleSizeController.text = "";
      // frontbusSampleSizeController.text = "100 %";
      electricalReferenceDocController.text = "As Per COC";
      electricalAcceptanceCriteriaController.text =
          "GSPL Technical Specification/COC";

      //  Performance  Verification 3
      performanceCharactersticsController.text = "Resistivity";
      performanceMeasuringMethodController.text = "N/A";
      performanceSamplingController.text = "N/A";
      // performanceSampleSizeController.text = "";
      // performanceSampleSizeController.text = "100 %";
      performanceReferenceDocController.text = "As Per COC";
      performanceAcceptanceCriteriaController.text =
          "GSPL Technical Specification/COC";
    });

    super.initState();
  }

  void store() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pic = prefs.getString('pic');
      personid = prefs.getString('personid');
      site = prefs.getString('site');
      designation = prefs.getString('designation');
      department = prefs.getString('department');
      token = prefs.getString('token');
    });

    _get();
  }

  Future<void> _pickInvoicePDF() async {
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

  Future<void> _pickcocPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File pdffile = File(result.files.single.path!);
      setState(() {
        cocPdfFileBytes = pdffile.readAsBytesSync();
        cocPdfController.text = result.files.single.name;
      });
    } else {
      // User canceled the file picker
    }
  }

  Future _get() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.id != '' && widget.id != null) {
        _isLoading = true;
      }
      site = prefs.getString('site');
    });
    final AllSolarData = ((site!) + 'IQCSolarCell/GetSpecificTest');
    final allSolarData = await http.post(
      Uri.parse(AllSolarData),
      body: jsonEncode(
          <String, String>{"SolarDetailID": widget.id ?? '', "token": token!}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var resBody = json.decode(allSolarData.body);

    if (mounted) {
      setState(() {
        data = resBody;

        if (data != null && data.length > 0) {
          _isLoading = false;
          final dataMap = data.asMap();
          numberOfVisualSampleFields = (dataMap[0]['SampleSizeVisual'] ??
              dataMap[0]['SampleSizeVisual']);

          lotSizeController.text = dataMap[0]['LotSize'] ?? '';
          supplierNameController.text = dataMap[0]['SupplierName'] ?? '';
          invoiceNoController.text = dataMap[0]['InvoiceNo'] ?? '';
          invoiceDateController.text = DateFormat("EEE MMM dd, yyyy").format(
                  DateTime.parse(dataMap[0]['InvoiceDate'].toString())) ??
              '';
          invoiceDate = dataMap[0]['InvoiceDate'] ?? '';
          rawMaterialSpecsController.text =
              dataMap[0]['RawMaterialSpecs'] ?? '';
          dateOfQualityCheckController
              .text = DateFormat("EEE MMM dd, yyyy").format(
                  DateTime.parse(dataMap[0]['QualityCheckDate'].toString())) ??
              '';

          dateOfQualityCheck = dataMap[0]['QualityCheckDate'] ?? '';

          rMBatchNoController.text = dataMap[0]['SupplierRMBatchNo'] ?? '';
          receiptDateController.text = DateFormat("EEE MMM dd, yyyy").format(
                  DateTime.parse(dataMap[0]['ReceiptDate'].toString())) ??
              '';

          receiptDate = dataMap[0]['ReceiptDate'] ?? '';

          numberOfPackagingSampleFields =
              (dataMap[0]['SampleSizePackaging'] != 0
                  ? dataMap[0]['SampleSizePackaging']
                  : 1);
          Packaging = dataMap[0]['Packaging'] ?? [];

          // numberOfVisualSampleFields = (dataMap[0]['SampleSizeVisual'] ??
          //     dataMap[0]['SampleSizeVisual']);
          visualSampleSizeController.text = (dataMap[0]['SampleSizeVisual'] != 0
                  ? dataMap[0]['SampleSizeVisual']
                  : "")
              .toString();
          Visual = dataMap[0]['Visual'] ?? [];

          physicalSampleSizeController.text =
              (dataMap[0]['SampleSizePhysical'] != 0
                      ? dataMap[0]['SampleSizePhysical']
                      : "")
                  .toString();
          Physical = dataMap[0]['Physical'] ?? [];

          frontbusSampleSizeController.text =
              (dataMap[0]['SampleSizeFrontBus'] != 0
                      ? dataMap[0]['SampleSizeFrontBus']
                      : "")
                  .toString();
          FrontBus = dataMap[0]['FrontBus'] ?? [];

          verificationSampleSizeController.text =
              (dataMap[0]['SampleSizeVerification'] != 0
                      ? dataMap[0]['SampleSizeVerification']
                      : "")
                  .toString();
          Verification = dataMap[0]['Verification'] ?? [];

          electricalSampleSizeController.text =
              (dataMap[0]['SampleSizeElectrical'] != 0
                      ? dataMap[0]['SampleSizeElectrical']
                      : "")
                  .toString();
          Electrical = dataMap[0]['Electrical'] ?? [];

          performanceSampleSizeController.text =
              (dataMap[0]['SampleSizePerformance'] != 0
                      ? dataMap[0]['SampleSizePerformance']
                      : "")
                  .toString();
          Performance = dataMap[0]['Performance'] ?? [];

          result = dataMap[0]['Result'] ?? 'Fail';
          status = dataMap[0]['Status'] ?? '';

          packagingRejection = dataMap[0]['RejectPackaging'] ?? false;
          visualRejection = dataMap[0]['RejectVisual'] ?? false;
          physicalRejection = dataMap[0]['RejectPhysical'] ?? false;
          frontbusRejection = dataMap[0]['RejectFrontBus'] ?? false;
          verificationRejection = dataMap[0]['RejectVerification'] ?? false;
          electricalRejection = dataMap[0]['RejectElectrical'] ?? false;
          performanceRejection = dataMap[0]['RejectPerformance'] ?? false;
          rejectionReasonController.text = dataMap[0]['Reason'] ?? '';

          invoicePdfController.text = dataMap[0]['InvoicePdf'] ?? '';
          cocPdfController.text = dataMap[0]['COCPdf'] ?? '';
        }
      });
    }
  }

  Future setApprovalStatus() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    final url = (site! + "IQCSolarCell/UpdateStatus");

    var params = {
      "token": token,
      "CurrentUser": personid,
      "ApprovalStatus": approvalStatus,
      "RejectionReasonStatus": rejectionReasonStatusController.text,
      "TestId": widget.id ?? ""
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
        Toast.show("Ribbon Test $approvalStatus .",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => IqcpTestList()));
      }
    } else {
      Toast.show("Error In Server",
          duration: Toast.lengthLong, gravity: Toast.center);
    }
  }

  uploadPDF(List<int> invoiceBytes, List<int> cocBytes) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    var formData = FormData.fromMap({
      "SolarDetailId": SolarDetailId,
      "InvoicePdf": MultipartFile.fromBytes(
        invoiceBytes,
        filename:
            (invoicePdfController.text + (currentdate.toString()) + '.pdf'),
        contentType: MediaType("application", 'pdf'),
      ),
      "COCPdf": MultipartFile.fromBytes(
        cocBytes,
        filename: (cocPdfController.text + (currentdate.toString()) + '.pdf'),
        contentType: MediaType("application", 'pdf'),
      ),
    });

    _response = await _dio.post((site! + 'IQCSolarCell//UploadPdf'), // Prod

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

        Toast.show("Ribbon Test Completed.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => IqcpTestList()));
      } else {
        Toast.show("Error In Server",
            duration: Toast.lengthLong, gravity: Toast.center);
      }
    } catch (err) {
      print("Error");
    }
  }

  Future createData() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    final url = (site! + "IQCSolarCell/AddIQCSolarCell");

    var params = {
      "MaterialName": "PV Ribbon",
      "SolarDetailId": SolarDetailId != '' && SolarDetailId != null
          ? SolarDetailId
          : widget.id != '' && widget.id != null
              ? widget.id
              : '',
      "Page": setPage,
      "Status": sendStatus,
      "CurrentUser": personid,
      "SolarCellDetails": {
        "LotNo": lotSizeController.text,
        "SupplierName": supplierNameController.text,
        "InvoiceNo": invoiceNoController.text,
        "InvoiceDate": invoiceDate,
        "RawMaterialSpecs": rawMaterialSpecsController.text,
        "DateOfQualityCheck": dateOfQualityCheck,
        "SupplierRMBatchNo": rMBatchNoController.text,
        "RecieptDate": receiptDate,
        "DocumentNo": "GSPL/PVR(IQC)/001",
        "RevNo": "Ver2.0/13-03-2024"
      },
      "SolarCell": {
        "Packaging": {
          "Characterstics": packagingCharactersticsController.text,
          "MeasuringMethod": packagingMeasuringMethodController.text,
          "Sampling": packagingSamplingController.text,
          "SampleSize": numberOfPackagingSampleFields,
          "Reference": packagingReferenceDocController.text,
          "AcceptanceCriteria": packagingAcceptanceCriteriaController.text,
          "Samples": packagingSampleData
        },
        "Visual": {
          "Characterstics": visualCharactersticsController.text,
          "MeasuringMethod": visualMeasuringMethodController.text,
          "Sampling": visualSamplingController.text,
          "SampleSize": visualSampleSizeController.text,
          "Reference": visualReferenceDocController.text,
          "AcceptanceCriteria": visualAcceptanceCriteriaController.text,
          "Samples": visualSampleData
        },
        "Physical": {
          "Characterstics": physicalCharactersticsController.text,
          "MeasuringMethod": physicalMeasuringMethodController.text,
          "Sampling": physicalSamplingController.text,
          "SampleSize": physicalSampleSizeController.text,
          "Reference": physicalReferenceDocController.text,
          "AcceptanceCriteria": physicalAcceptanceCriteriaController.text,
          "Samples": physicalSampleData
        },
        "FrontBus": {
          "Characterstics": frontbusCharactersticsController.text,
          "MeasuringMethod": frontbusMeasuringMethodController.text,
          "Sampling": frontbusSamplingController.text,
          "SampleSize": frontbusSampleSizeController.text,
          "Reference": frontbusReferenceDocController.text,
          "AcceptanceCriteria": frontbusAcceptanceCriteriaController.text,
          "Samples": frontbusSampleData
        },
        "Verification": {
          "Characterstics": verificationCharactersticsController.text,
          "MeasuringMethod": verificationMeasuringMethodController.text,
          "Sampling": verificationSamplingController.text,
          "SampleSize": verificationSampleSizeController.text,
          "Reference": verificationReferenceDocController.text,
          "AcceptanceCriteria": verificationAcceptanceCriteriaController.text,
          "Samples": verificationSampleData
        },
        "Electrical": {
          "Characterstics": electricalCharactersticsController.text,
          "MeasuringMethod": electricalMeasuringMethodController.text,
          "Sampling": electricalSamplingController.text,
          "SampleSize": electricalSampleSizeController.text,
          "Reference": electricalReferenceDocController.text,
          "AcceptanceCriteria": electricalAcceptanceCriteriaController.text,
          "Samples": electricalSampleData
        },
        "Performance": {
          "Characterstics": performanceCharactersticsController.text,
          "MeasuringMethod": performanceMeasuringMethodController.text,
          "Sampling": performanceSamplingController.text,
          "SampleSize": performanceSampleSizeController.text,
          "Reference": performanceReferenceDocController.text,
          "AcceptanceCriteria": performanceAcceptanceCriteriaController.text,
          "Samples": performanceSampleData
        }
      },
      "Rejected": {
        "Result": result,
        "CheckTypes": [
          {"Packaging": packagingRejection},
          {"Visual": visualRejection},
          {"Physical": physicalRejection},
          {"FrontBus": frontbusRejection},
          {"Verification": verificationRejection},
          {"Electrical": electricalRejection},
          {"Performance": performanceRejection},
        ],
        "Reason": rejectionReasonController.text
      }
    };

    var response = await http.post(
      Uri.parse(url),
      body: json.encode(params),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var objData = json.decode(response.body);
      setState(() {
        SolarDetailId = objData['SolarDetailID'];
        _isLoading = false;
      });

      if (objData['success'] == false) {
        Toast.show(objData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.redColor);
      } else {
        if (sendStatus == 'Pending') {
          uploadPDF((invoicePdfFileBytes ?? []), (cocPdfFileBytes ?? []));
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
                    ? IqcpTestList()
                    : IqcpPage();
              }));
            },
          ),
          body: _isLoading
              ? AppLoader()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: setPage == "heading"
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
                                        Image.asset(
                                          AppAssets.imgLogo,
                                          height: 100,
                                          width: 230,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Center(
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                              "Incoming Quality Control Plan",
                                              style: TextStyle(
                                                  fontSize: 27,
                                                  color: AppColors.black,
                                                  fontFamily: appFontFamily,
                                                  fontWeight:
                                                      FontWeight.w700)))),
                                  const Center(
                                      child: Text("(Ribbon)",
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
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'GSPL/PVR(IQC)/001',
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Rev.No. / Rev. Date : ',
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Ver.2.0 / 13-03-2024',
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Lot Size",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                      controller: lotSizeController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                              hintText: "Please Enter Lot Size",
                                              counterText: ''),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly:
                                          status == 'Pending' ? true : false,
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText: "Please Enter Lot Size")
                                      ])),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Supplier Name",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TextFormField(
                                    controller: supplierNameController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: AppStyles
                                        .textFieldInputDecoration
                                        .copyWith(
                                            hintText:
                                                "Please Enter Supplier Name",
                                            counterText: ''),
                                    style: AppStyles.textInputTextStyle,
                                    readOnly:
                                        status == 'Pending' ? true : false,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Supplier Name";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Invoice No.",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                      controller: invoiceNoController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Invoice No.",
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly:
                                          status == 'Pending' ? true : false,
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Please Enter Invoice No.")
                                      ])),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Invoice Date",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TextFormField(
                                      controller: invoiceDateController,
                                      readOnly:
                                          status == 'Pending' ? true : false,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                              hintText:
                                                  "Please Enter Invoice Date",
                                              counterText: '',
                                              suffixIcon: Image.asset(
                                                AppAssets.icCalenderBlue,
                                                color: AppColors.primaryColor,
                                              )),
                                      style: AppStyles.textInputTextStyle,
                                      onTap: () async {
                                        if (status != 'Pending') {
                                          DateTime date = DateTime(2021);
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          date = (await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2024),
                                              lastDate: DateTime.now()))!;
                                          invoiceDateController.text =
                                              DateFormat("EEE MMM dd, yyyy")
                                                  .format(DateTime.parse(
                                                      date.toString()));
                                          setState(() {
                                            invoiceDate =
                                                DateFormat("yyyy-MM-dd").format(
                                                    DateTime.parse(
                                                        date.toString()));
                                          });
                                        }
                                      },
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Please Enter Invoice Date")
                                      ])),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Raw Material Specs",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TextFormField(
                                    controller: rawMaterialSpecsController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: AppStyles
                                        .textFieldInputDecoration
                                        .copyWith(
                                            hintText:
                                                "Please Enter Raw Material Specs",
                                            counterText: ''),
                                    style: AppStyles.textInputTextStyle,
                                    readOnly:
                                        status == 'Pending' ? true : false,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Raw Material Specs";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Date Of Quality Check",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TextFormField(
                                      controller: dateOfQualityCheckController,
                                      readOnly:
                                          status == 'Pending' ? true : false,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                              hintText:
                                                  "Please Enter Date Of Quality Check",
                                              counterText: '',
                                              suffixIcon: Image.asset(
                                                AppAssets.icCalenderBlue,
                                                color: AppColors.primaryColor,
                                              )),
                                      style: AppStyles.textInputTextStyle,
                                      onTap: () async {
                                        if (status != 'Pending') {
                                          DateTime date = DateTime(2021);
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          date = (await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2024),
                                              lastDate: DateTime.now()))!;
                                          dateOfQualityCheckController.text =
                                              DateFormat("EEE MMM dd, yyyy")
                                                  .format(DateTime.parse(
                                                      date.toString()));
                                          setState(() {
                                            dateOfQualityCheck =
                                                DateFormat("yyyy-MM-dd").format(
                                                    DateTime.parse(
                                                        date.toString()));
                                          });
                                        }
                                      },
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Please Enter Date Of Quality Check")
                                      ])),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Supplier's RM Batch No.",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                      controller: rMBatchNoController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Please Enter Supplier's RM Batch No.",
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly:
                                          status == 'Pending' ? true : false,
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Please Enter Supplier's RM Batch No.")
                                      ])),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Receipt Date",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TextFormField(
                                      controller: receiptDateController,
                                      readOnly:
                                          status == 'Pending' ? true : false,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                              hintText:
                                                  "Please Enter Receipt Date",
                                              counterText: '',
                                              suffixIcon: Image.asset(
                                                AppAssets.icCalenderBlue,
                                                color: AppColors.primaryColor,
                                              )),
                                      style: AppStyles.textInputTextStyle,
                                      onTap: () async {
                                        if (status != 'Pending') {
                                          DateTime date = DateTime(2021);
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          date = (await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2024),
                                              lastDate: DateTime.now()))!;
                                          receiptDateController.text =
                                              DateFormat("EEE MMM dd, yyyy")
                                                  .format(DateTime.parse(
                                                      date.toString()));
                                          setState(() {
                                            receiptDate =
                                                DateFormat("yyyy-MM-dd").format(
                                                    DateTime.parse(
                                                        date.toString()));
                                          });
                                        }
                                      },
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Please Enter Receipt Date")
                                      ])),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                  _isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : AppButton(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.white,
                                              fontSize: 16),
                                          onTap: () {
                                            AppHelper.hideKeyboard(context);
                                            _registerFormKey.currentState!.save;
                                            if (_registerFormKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                setPage = 'packaging';
                                              });
                                              if (status != 'Pending') {
                                                setState(() {
                                                  sendStatus = 'Inprogress';
                                                });
                                                createData();
                                              }
                                            }
                                            // setState(() {
                                            //   setPage = 'packaging';
                                            // });
                                          },
                                          label: "Next",
                                          organization: '',
                                        ),
                                  const SizedBox(
                                    height: 10,
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
                                                fontWeight: FontWeight.w400)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                          ],
                        )
                      : setPage == "packaging"
                          // Packaging
                          ? Stack(
                              alignment: Alignment.center,
                              fit: StackFit.expand,
                              children: [
                                SingleChildScrollView(
                                    child: Form(
                                  //  key: _registerFormKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                            Image.asset(
                                              AppAssets.imgLogo,
                                              height: 100,
                                              width: 230,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Center(
                                          child: Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Text(
                                                  "Incoming Quality Control Plan",
                                                  style: TextStyle(
                                                      fontSize: 27,
                                                      color: AppColors.black,
                                                      fontFamily: appFontFamily,
                                                      fontWeight:
                                                          FontWeight.w700)))),
                                      const Center(
                                          child: Text("(Ribbon)",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: AppColors.black,
                                                  fontFamily: appFontFamily,
                                                  fontWeight:
                                                      FontWeight.w700))),
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
                                            'GSPL/PVR(IQC)/001',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Rev.No. / Rev. Date : ',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            'Ver.2.0 / 13-03-2024',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Center(
                                          child: Text("Visual",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                      255, 13, 160, 0),
                                                  fontFamily: appFontFamily,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Characterstics",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            packagingCharactersticsController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                                // hintText: "Please Enter Day Lot No.",
                                                ),
                                        style: AppStyles.textInputTextStyle,
                                        readOnly: true,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Measuring Method",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            packagingMeasuringMethodController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                                // hintText: "Please Enter Day Lot No.",
                                                ),
                                        style: AppStyles.textInputTextStyle,
                                        readOnly: true,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Sampling",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller: packagingSamplingController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                                // hintText: "Please Enter Day Lot No.",
                                                ),
                                        style: AppStyles.textInputTextStyle,
                                        readOnly: true,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Sample Size",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            packagingSampleSizeController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                                // hintText: "Please Enter Day Lot No.",
                                                ),
                                        style: AppStyles.textInputTextStyle,
                                        readOnly: true,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Reference Doc",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            packagingReferenceDocController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                                // hintText: "Please Enter Day Lot No.",
                                                ),
                                        style: AppStyles.textInputTextStyle,
                                        readOnly: true,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Acceptance Criteria",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            packagingAcceptanceCriteriaController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                                // hintText: "Please Enter Day Lot No.",
                                                ),
                                        style: AppStyles.textInputTextStyle,
                                        readOnly: true,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                      _isLoading
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : AppButton(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.white,
                                                  fontSize: 16),
                                              onTap: () {
                                                AppHelper.hideKeyboard(context);

                                                setState(() {
                                                  setPage = 'checkpackaging';
                                                });

                                                // Dynamic Start......
                                                selectedPackagingTestValues = List<
                                                        bool>.generate(
                                                    numberOfPackagingSampleFields,
                                                    (index) => false);
                                                for (int i = 0;
                                                    i < numberOfPackagingSampleFields;
                                                    i++) {
                                                  packagingBarcodeControllers.add(
                                                      TextEditingController());
                                                  packagingRemarksControllers.add(
                                                      TextEditingController());

                                                  // Update Time.......
                                                  if (widget.id != "" &&
                                                      widget.id != null &&
                                                      Packaging.length > 0) {
                                                    packagingRemarksControllers[
                                                                i]
                                                            .text =
                                                        Packaging[i]
                                                            ['SampleRemarks'];

                                                    selectedPackagingTestValues[
                                                            i] =
                                                        Packaging[i]
                                                            ['SampleTest'];

                                                    packagingBarcodeControllers[
                                                                i]
                                                            .text =
                                                        Packaging[i]
                                                            ['SampleBarcode'];
                                                  }
                                                }

                                                // Dynamic  End......

                                                if (status != 'Pending') {
                                                  setState(() {
                                                    sendStatus = 'Inprogress';
                                                  });
                                                  createData();
                                                }
                                              },
                                              label: "Check",
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
                                              setState(() {
                                                setPage = "heading";
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
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                              ],
                            )
                          : setPage == "checkpackaging"
                              ? Scaffold(
                                  body: Form(
                                    key: packagingFormkey,
                                    child: ListView.builder(
                                      itemCount: numberOfPackagingSampleFields,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                "Sample ${index + 1}",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(height: 8),
                                              //  if (barcodeScanRes != '-1')
                                              TextFormField(
                                                controller:
                                                    packagingBarcodeControllers[
                                                        index],
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Sample Barcode",
                                                  counterText: '',
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  suffixIcon: IconButton(
                                                    onPressed: () async {
                                                      if (status != 'Pending') {
                                                        barcodeScanRes =
                                                            await FlutterBarcodeScanner
                                                                .scanBarcode(
                                                          '#FF6666',
                                                          'Cancel',
                                                          true,
                                                          ScanMode.DEFAULT,
                                                        );

                                                        setState(() {
                                                          packagingBarcodeControllers[
                                                                      index]
                                                                  .text =
                                                              (barcodeScanRes !=
                                                                      "-1"
                                                                  ? barcodeScanRes
                                                                  : '')!;
                                                        });
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        Icons.qr_code),
                                                  ),
                                                ),
                                                readOnly: status == 'Pending'
                                                    ? true
                                                    : false,
                                                style: AppStyles
                                                    .textInputTextStyle,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Scan Sample Barcode.';
                                                  }
                                                  return null;
                                                },
                                              ),

                                              const SizedBox(
                                                  height:
                                                      8), // Add space between TextFormField and Radio Buttons
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        selectedPackagingTestValues[
                                                            index],
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          selectedPackagingTestValues[
                                                              index] = value!;
                                                          packagingRemarksControllers[
                                                                  index]
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'True',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        selectedPackagingTestValues[
                                                            index],
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          selectedPackagingTestValues[
                                                              index] = value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'False',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              if (selectedPackagingTestValues[
                                                      index] ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (selectedPackagingTestValues[
                                                      index] ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      packagingRemarksControllers[
                                                          index],
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    counterText: '',
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: status == 'Pending'
                                                      ? true
                                                      : false,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please Enter Remarks.';
                                                    }
                                                    return null;
                                                  },
                                                ),

                                              const SizedBox(height: 8),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: AppColors.dividerColor,
                                                height: 1,
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  floatingActionButton: status != 'Pending'
                                      ? FloatingActionButton(
                                          onPressed: () {
                                            setState(() {
                                              numberOfPackagingSampleFields++; // Increment the number of fields
                                              packagingBarcodeControllers
                                                  .add(TextEditingController());
                                              packagingRemarksControllers
                                                  .add(TextEditingController());
                                              selectedPackagingTestValues
                                                  .add(false);
                                            });
                                          },
                                          child: Icon(Icons.add),
                                        )
                                      : Container(),
                                  bottomNavigationBar: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              setPage = "packaging";
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
                                        ElevatedButton(
                                          onPressed: () {
                                            AppHelper.hideKeyboard(context);
                                            // Validate the form
                                            packagingFormkey.currentState!.save;
                                            if (packagingFormkey.currentState!
                                                .validate()) {
                                              packagingSampleData = [];

                                              for (int i = 0;
                                                  i < numberOfPackagingSampleFields;
                                                  i++) {
                                                packagingSampleData.add({
                                                  "SampleBarcode":
                                                      packagingBarcodeControllers[
                                                              i]
                                                          .text,
                                                  "SampleTest":
                                                      selectedPackagingTestValues[
                                                          i],
                                                  "SampleRemarks":
                                                      packagingRemarksControllers[
                                                              i]
                                                          .text
                                                });
                                              }
                                              if (status != 'Pending') {
                                                setState(() {
                                                  sendStatus = 'Inprogress';
                                                });
                                                createData();
                                              }
                                              setState(() {
                                                setPage = "visual";
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color
                                                .fromARGB(255, 134, 8,
                                                4), // Set button color to red
                                          ),
                                          child: const Text(
                                            'Next',
                                            style: TextStyle(
                                              color: Colors
                                                  .white, // Set text color to white
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : setPage == "visual"
                                  // Start Visual Block.....................................................................
                                  ? Stack(
                                      alignment: Alignment.center,
                                      fit: StackFit.expand,
                                      children: [
                                        SingleChildScrollView(
                                            child: Form(
                                          key: _visualFormKey,
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
                                              const Center(
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Text(
                                                          "Incoming Quality Control Plan",
                                                          style: TextStyle(
                                                              fontSize: 27,
                                                              color: AppColors
                                                                  .black,
                                                              fontFamily:
                                                                  appFontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700)))),
                                              const Center(
                                                  child: Text("(Ribbon)",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              AppColors.black,
                                                          fontFamily:
                                                              appFontFamily,
                                                          fontWeight: FontWeight
                                                              .w700))),
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
                                                    'GSPL/PVR(IQC)/001',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Rev.No. / Rev. Date : ',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    'Ver.2.0 / 13-03-2024',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              const Center(
                                                  child: Text("Physical",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Color.fromARGB(
                                                              255, 13, 160, 0),
                                                          fontFamily:
                                                              appFontFamily,
                                                          fontWeight: FontWeight
                                                              .w700))),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                "Characterstics",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualCharactersticsController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                        // hintText: "Please Enter Day Lot No.",
                                                        ),
                                                maxLines: 2,
                                                style: AppStyles
                                                    .textInputTextStyle,
                                                readOnly: true,
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                "Measuring Method",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualMeasuringMethodController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                        // hintText: "Please Enter Day Lot No.",
                                                        ),
                                                style: AppStyles
                                                    .textInputTextStyle,
                                                readOnly: true,
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                "Sampling",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualSamplingController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                        // hintText: "Please Enter Day Lot No.",
                                                        ),
                                                style: AppStyles
                                                    .textInputTextStyle,
                                                readOnly: true,
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                "Sample Size*",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                  controller:
                                                      visualSampleSizeController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Sample Size",
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  maxLength: 2,
                                                  readOnly: status == 'Pending'
                                                      ? true
                                                      : false,
                                                  validator: MultiValidator([
                                                    RequiredValidator(
                                                        errorText:
                                                            "Please Enter Sample Size.")
                                                  ])
                                                  // bikki
                                                  ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                "Reference Doc",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualReferenceDocController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                        // hintText: "Please Enter Day Lot No.",
                                                        ),
                                                style: AppStyles
                                                    .textInputTextStyle,
                                                readOnly: true,
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                "Acceptance Criteria",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualAcceptanceCriteriaController,
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                        // hintText: "Please Enter Day Lot No.",
                                                        ),
                                                maxLines: 2,
                                                style: AppStyles
                                                    .textInputTextStyle,
                                                readOnly: true,
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 0)),
                                              _isLoading
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : AppButton(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: AppColors
                                                                  .white,
                                                              fontSize: 16),
                                                      onTap: () {
                                                        AppHelper.hideKeyboard(
                                                            context);
                                                        _visualFormKey
                                                            .currentState!.save;
                                                        if (_visualFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          // ignore: unnecessary_null_comparison
                                                          if (visualSampleSizeController
                                                                  .text !=
                                                              "") {
                                                            int num = int.parse(
                                                                visualSampleSizeController
                                                                    .text);
                                                            setState(() {
                                                              setPage =
                                                                  'checkvisual';
                                                              numberOfVisualSampleFields =
                                                                  num;
                                                            });
                                                          }
                                                          if (status !=
                                                              'Pending') {
                                                            setState(() {
                                                              sendStatus =
                                                                  'Inprogress';
                                                            });
                                                            createData();
                                                          }
                                                        }

                                                        // Dynamic Start......
                                                        selectedVisualTestValues =
                                                            List<bool>.generate(
                                                                numberOfVisualSampleFields,
                                                                (index) =>
                                                                    false);
                                                        for (int i = 0;
                                                            i < numberOfVisualSampleFields;
                                                            i++) {
                                                          visualBarcodeControllers
                                                              .add(
                                                                  TextEditingController());
                                                          visualRemarksControllers
                                                              .add(
                                                                  TextEditingController());
                                                          // Update Time.......
                                                          if (widget.id != "" &&
                                                              widget.id !=
                                                                  null &&
                                                              Visual.length >
                                                                  0) {
                                                            visualRemarksControllers[
                                                                    i]
                                                                .text = Visual[
                                                                    i][
                                                                'SampleRemarks'];

                                                            selectedVisualTestValues[
                                                                i] = Visual[
                                                                    i]
                                                                ['SampleTest'];

                                                            visualBarcodeControllers[
                                                                    i]
                                                                .text = Visual[
                                                                    i][
                                                                'SampleBarcode'];
                                                          }
                                                        }

                                                        // _visualFormKey =
                                                        //     GlobalKey<FormState>();

                                                        // Dynamic  End......
                                                      },
                                                      label: "Check",
                                                      organization: '',
                                                    ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        setPage =
                                                            "checkpackaging";
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
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                                FontWeight
                                                                    .w400)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                      ],
                                    )
                                  : setPage == "checkvisual"
                                      ? Scaffold(
                                          body: Form(
                                            key: _visualsampleformKey,
                                            child: ListView.builder(
                                              itemCount:
                                                  numberOfVisualSampleFields,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Text(
                                                        "Sample ${index + 1}",
                                                        style: AppStyles
                                                            .textfieldCaptionTextStyle,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      //  if (barcodeScanRes != '-1')
                                                      TextFormField(
                                                        controller:
                                                            visualBarcodeControllers[
                                                                index],
                                                        decoration: AppStyles
                                                            .textFieldInputDecoration
                                                            .copyWith(
                                                          hintText:
                                                              "Please Scan Sample Barcode",
                                                          counterText: '',
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          suffixIcon:
                                                              IconButton(
                                                            onPressed:
                                                                () async {
                                                              if (status !=
                                                                  'Pending') {
                                                                barcodeScanRes =
                                                                    await FlutterBarcodeScanner
                                                                        .scanBarcode(
                                                                  '#FF6666',
                                                                  'Cancel',
                                                                  true,
                                                                  ScanMode
                                                                      .DEFAULT,
                                                                );

                                                                setState(() {
                                                                  visualBarcodeControllers[
                                                                          index]
                                                                      .text = (barcodeScanRes !=
                                                                          "-1"
                                                                      ? barcodeScanRes
                                                                      : '')!;
                                                                });
                                                              }
                                                            },
                                                            icon: const Icon(
                                                                Icons.qr_code),
                                                          ),
                                                        ),
                                                        readOnly:
                                                            status == 'Pending'
                                                                ? true
                                                                : false,
                                                        style: AppStyles
                                                            .textInputTextStyle,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please Scan Sample Barcode.';
                                                          }
                                                          return null;
                                                        },
                                                      ),

                                                      const SizedBox(
                                                          height:
                                                              8), // Add space between TextFormField and Radio Buttons
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: true,
                                                            groupValue:
                                                                selectedVisualTestValues[
                                                                    index],
                                                            onChanged:
                                                                (bool? value) {
                                                              if (status !=
                                                                  'Pending') {
                                                                setState(() {
                                                                  selectedVisualTestValues[
                                                                          index] =
                                                                      value!;
                                                                  visualRemarksControllers[
                                                                          index]
                                                                      .text = '';
                                                                });
                                                              }
                                                            },
                                                          ),
                                                          Text(
                                                            'True',
                                                            style: AppStyles
                                                                .textfieldCaptionTextStyle,
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Radio(
                                                            value: false,
                                                            groupValue:
                                                                selectedVisualTestValues[
                                                                    index],
                                                            onChanged:
                                                                (bool? value) {
                                                              if (status !=
                                                                  'Pending') {
                                                                setState(() {
                                                                  selectedVisualTestValues[
                                                                          index] =
                                                                      value!;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                          Text(
                                                            'False',
                                                            style: AppStyles
                                                                .textfieldCaptionTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                      if (selectedVisualTestValues[
                                                              index] ==
                                                          false)
                                                        const SizedBox(
                                                            height: 8),
                                                      if (selectedVisualTestValues[
                                                              index] ==
                                                          false)
                                                        TextFormField(
                                                          controller:
                                                              visualRemarksControllers[
                                                                  index],
                                                          decoration: AppStyles
                                                              .textFieldInputDecoration
                                                              .copyWith(
                                                            hintText:
                                                                "Please Enter Remarks",
                                                            counterText: '',
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: status ==
                                                                  'Pending'
                                                              ? true
                                                              : false,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please Enter Remarks.';
                                                            }
                                                            return null;
                                                          },
                                                        ),

                                                      const SizedBox(height: 8),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        color: AppColors
                                                            .dividerColor,
                                                        height: 1,
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          bottomNavigationBar: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      setPage = "visual";
                                                    });
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
                                                ElevatedButton(
                                                  onPressed: () {
                                                    AppHelper.hideKeyboard(
                                                        context);
                                                    _visualsampleformKey
                                                        .currentState!.save;

                                                    // Validate the form
                                                    if (_visualsampleformKey
                                                        .currentState!
                                                        .validate()) {
                                                      visualSampleData = [];

                                                      for (int i = 0;
                                                          i < numberOfVisualSampleFields;
                                                          i++) {
                                                        visualSampleData.add({
                                                          "SampleBarcode":
                                                              visualBarcodeControllers[
                                                                      i]
                                                                  .text,
                                                          "SampleTest":
                                                              selectedVisualTestValues[
                                                                  i],
                                                          "SampleRemarks":
                                                              visualRemarksControllers[
                                                                      i]
                                                                  .text
                                                        });
                                                      }

                                                      setState(() {
                                                        setPage = "physical";
                                                      });
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          sendStatus =
                                                              'Inprogress';
                                                        });
                                                        createData();
                                                      }
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: const Color
                                                        .fromARGB(255, 134, 8,
                                                        4), // Set button color to red
                                                  ),
                                                  child: const Text(
                                                    'Next',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .white, // Set text color to white
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : setPage == "physical"
                                          // Start Physical Block.....................................................................
                                          ? Stack(
                                              alignment: Alignment.center,
                                              fit: StackFit.expand,
                                              children: [
                                                SingleChildScrollView(
                                                    child: Form(
                                                  key: _physicalFormKey,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
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
                                                      const Center(
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10),
                                                              child: Text(
                                                                  "Incoming Quality Control Plan",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          27,
                                                                      color: AppColors
                                                                          .black,
                                                                      fontFamily:
                                                                          appFontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)))),
                                                      const Center(
                                                          child: Text(
                                                              "(Ribbon)",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontFamily:
                                                                      appFontFamily,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
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
                                                            'GSPL/PVR(IQC)/001',
                                                            style: AppStyles
                                                                .textfieldCaptionTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Rev.No. / Rev. Date : ',
                                                            style: AppStyles
                                                                .textfieldCaptionTextStyle,
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            'Ver.2.0 / 13-03-2024',
                                                            style: AppStyles
                                                                .textfieldCaptionTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      const Center(
                                                          child: Text(
                                                              "Verification-1",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          13,
                                                                          160,
                                                                          0),
                                                                  fontFamily:
                                                                      appFontFamily,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "Characterstics",
                                                        style: AppStyles
                                                            .textfieldCaptionTextStyle,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            physicalCharactersticsController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration: AppStyles
                                                            .textFieldInputDecoration
                                                            .copyWith(
                                                                // hintText: "Please Enter Day Lot No.",
                                                                ),
                                                        maxLines: 2,
                                                        style: AppStyles
                                                            .textInputTextStyle,
                                                        readOnly: true,
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Measuring Method",
                                                        style: AppStyles
                                                            .textfieldCaptionTextStyle,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            physicalMeasuringMethodController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration: AppStyles
                                                            .textFieldInputDecoration
                                                            .copyWith(
                                                                // hintText: "Please Enter Day Lot No.",
                                                                ),
                                                        style: AppStyles
                                                            .textInputTextStyle,
                                                        readOnly: true,
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Sampling",
                                                        style: AppStyles
                                                            .textfieldCaptionTextStyle,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            physicalSamplingController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration: AppStyles
                                                            .textFieldInputDecoration
                                                            .copyWith(
                                                                // hintText: "Please Enter Day Lot No.",
                                                                ),
                                                        style: AppStyles
                                                            .textInputTextStyle,
                                                        readOnly: true,
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Sample Size*",
                                                        style: AppStyles
                                                            .textfieldCaptionTextStyle,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                          controller:
                                                              physicalSampleSizeController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          decoration: AppStyles
                                                              .textFieldInputDecoration
                                                              .copyWith(
                                                            hintText:
                                                                "Please Enter Sample Size",
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          maxLength: 2,
                                                          readOnly: status ==
                                                                  'Pending'
                                                              ? true
                                                              : false,
                                                          validator:
                                                              MultiValidator([
                                                            RequiredValidator(
                                                                errorText:
                                                                    "Please Enter Sample Size.")
                                                          ])
                                                          // bikki
                                                          ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Reference Doc",
                                                        style: AppStyles
                                                            .textfieldCaptionTextStyle,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            physicalReferenceDocController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration: AppStyles
                                                            .textFieldInputDecoration
                                                            .copyWith(
                                                                // hintText: "Please Enter Day Lot No.",
                                                                ),
                                                        style: AppStyles
                                                            .textInputTextStyle,
                                                        readOnly: true,
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "Acceptance Criteria",
                                                        style: AppStyles
                                                            .textfieldCaptionTextStyle,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            physicalAcceptanceCriteriaController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration: AppStyles
                                                            .textFieldInputDecoration
                                                            .copyWith(
                                                                // hintText: "Please Enter Day Lot No.",
                                                                ),
                                                        maxLines: 2,
                                                        style: AppStyles
                                                            .textInputTextStyle,
                                                        readOnly: true,
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      const Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 10, 0, 0)),
                                                      _isLoading
                                                          ? const Center(
                                                              child:
                                                                  CircularProgressIndicator())
                                                          : AppButton(
                                                              textStyle: const TextStyle(
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
                                                                _physicalFormKey
                                                                    .currentState!
                                                                    .save;
                                                                if (_physicalFormKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  // ignore: unnecessary_null_comparison
                                                                  if (physicalSampleSizeController
                                                                          .text !=
                                                                      "") {
                                                                    int num = int.parse(
                                                                        physicalSampleSizeController
                                                                            .text);
                                                                    setState(
                                                                        () {
                                                                      setPage =
                                                                          'checkphysical';
                                                                      numberOfPhysicalSampleFields =
                                                                          num;
                                                                    });
                                                                  }
                                                                  if (status !=
                                                                      'Pending') {
                                                                    setState(
                                                                        () {
                                                                      sendStatus =
                                                                          'Inprogress';
                                                                    });
                                                                    createData();
                                                                  }
                                                                }

                                                                // Dynamic Start......
                                                                selectedPhysicalTestValues = List<
                                                                        bool>.generate(
                                                                    numberOfPhysicalSampleFields,
                                                                    (index) =>
                                                                        false);
                                                                for (int i = 0;
                                                                    i < numberOfPhysicalSampleFields;
                                                                    i++) {
                                                                  physicalBarcodeControllers
                                                                      .add(
                                                                          TextEditingController());
                                                                  physicalRemarksControllers
                                                                      .add(
                                                                          TextEditingController());

                                                                  // Update Time.......
                                                                  if (widget.id !=
                                                                          "" &&
                                                                      widget.id !=
                                                                          null &&
                                                                      Physical.length >
                                                                          0) {
                                                                    physicalRemarksControllers[
                                                                            i]
                                                                        .text = Physical[
                                                                            i][
                                                                        'SampleRemarks'];

                                                                    selectedPhysicalTestValues[
                                                                        i] = Physical[
                                                                            i][
                                                                        'SampleTest'];

                                                                    physicalBarcodeControllers[
                                                                            i]
                                                                        .text = Physical[
                                                                            i][
                                                                        'SampleBarcode'];
                                                                  }
                                                                }

                                                                // Dynamic  End......
                                                              },
                                                              label: "Check",
                                                              organization: '',
                                                            ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                setPage =
                                                                    "checkvisual";
                                                              });
                                                            },
                                                            child: const Text(
                                                              "BACK",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      appFontFamily,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
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
                                                        alignment:
                                                            Alignment.center,
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
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        appFontFamily,
                                                                    color: AppColors
                                                                        .greyColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                              ],
                                            )
                                          : setPage == "checkphysical"
                                              ? Scaffold(
                                                  body: Form(
                                                    key: _physicalsampleformKey,
                                                    child: ListView.builder(
                                                      itemCount:
                                                          numberOfPhysicalSampleFields,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: [
                                                              Text(
                                                                "Sample ${index + 1}",
                                                                style: AppStyles
                                                                    .textfieldCaptionTextStyle,
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              //  if (barcodeScanRes != '-1')
                                                              TextFormField(
                                                                controller:
                                                                    physicalBarcodeControllers[
                                                                        index],
                                                                decoration: AppStyles
                                                                    .textFieldInputDecoration
                                                                    .copyWith(
                                                                  hintText:
                                                                      "Please Scan Sample Barcode",
                                                                  counterText:
                                                                      '',
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  suffixIcon:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      if (status !=
                                                                          'Pending') {
                                                                        barcodeScanRes =
                                                                            await FlutterBarcodeScanner.scanBarcode(
                                                                          '#FF6666',
                                                                          'Cancel',
                                                                          true,
                                                                          ScanMode
                                                                              .DEFAULT,
                                                                        );

                                                                        setState(
                                                                            () {
                                                                          physicalBarcodeControllers[index]
                                                                              .text = (barcodeScanRes !=
                                                                                  "-1"
                                                                              ? barcodeScanRes
                                                                              : '')!;
                                                                        });
                                                                      }
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .qr_code),
                                                                  ),
                                                                ),
                                                                readOnly: status ==
                                                                        'Pending'
                                                                    ? true
                                                                    : false,
                                                                style: AppStyles
                                                                    .textInputTextStyle,
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return 'Please Scan Sample Barcode.';
                                                                  }
                                                                  return null;
                                                                },
                                                              ),

                                                              const SizedBox(
                                                                  height:
                                                                      8), // Add space between TextFormField and Radio Buttons
                                                              Row(
                                                                children: [
                                                                  Radio(
                                                                    value: true,
                                                                    groupValue:
                                                                        selectedPhysicalTestValues[
                                                                            index],
                                                                    onChanged:
                                                                        (bool?
                                                                            value) {
                                                                      if (status !=
                                                                          'Pending') {
                                                                        setState(
                                                                            () {
                                                                          selectedPhysicalTestValues[index] =
                                                                              value!;
                                                                          physicalRemarksControllers[index].text =
                                                                              '';
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                  Text(
                                                                    'True',
                                                                    style: AppStyles
                                                                        .textfieldCaptionTextStyle,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Radio(
                                                                    value:
                                                                        false,
                                                                    groupValue:
                                                                        selectedPhysicalTestValues[
                                                                            index],
                                                                    onChanged:
                                                                        (bool?
                                                                            value) {
                                                                      if (status !=
                                                                          'Pending') {
                                                                        setState(
                                                                            () {
                                                                          selectedPhysicalTestValues[index] =
                                                                              value!;
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                  Text(
                                                                    'False',
                                                                    style: AppStyles
                                                                        .textfieldCaptionTextStyle,
                                                                  ),
                                                                ],
                                                              ),

                                                              if (selectedPhysicalTestValues[
                                                                      index] ==
                                                                  false)
                                                                const SizedBox(
                                                                    height: 8),
                                                              if (selectedPhysicalTestValues[
                                                                      index] ==
                                                                  false)
                                                                TextFormField(
                                                                  controller:
                                                                      physicalRemarksControllers[
                                                                          index],
                                                                  decoration: AppStyles
                                                                      .textFieldInputDecoration
                                                                      .copyWith(
                                                                    hintText:
                                                                        "Please Enter Remarks",
                                                                    counterText:
                                                                        '',
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                          'Pending'
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please Enter Remarks.';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),

                                                              const SizedBox(
                                                                  height: 8),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                color: AppColors
                                                                    .dividerColor,
                                                                height: 1,
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  bottomNavigationBar: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            14.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              setPage =
                                                                  "physical";
                                                            });
                                                          },
                                                          child: const Text(
                                                            "BACK",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    appFontFamily,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .redColor),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            AppHelper
                                                                .hideKeyboard(
                                                                    context);
                                                            _physicalsampleformKey
                                                                .currentState!
                                                                .save;

                                                            // // Validate the form
                                                            if (_physicalsampleformKey
                                                                .currentState!
                                                                .validate()) {
                                                              physicalSampleData =
                                                                  [];

                                                              for (int i = 0;
                                                                  i < numberOfPhysicalSampleFields;
                                                                  i++) {
                                                                physicalSampleData
                                                                    .add({
                                                                  "SampleBarcode":
                                                                      physicalBarcodeControllers[
                                                                              i]
                                                                          .text,
                                                                  "SampleTest":
                                                                      selectedPhysicalTestValues[
                                                                          i],
                                                                  "SampleRemarks":
                                                                      physicalRemarksControllers[
                                                                              i]
                                                                          .text
                                                                });

                                                                setState(() {
                                                                  setPage =
                                                                      "frontbus";
                                                                });
                                                              }
                                                              if (status !=
                                                                  'Pending') {
                                                                setState(() {
                                                                  sendStatus =
                                                                      'Inprogress';
                                                                });
                                                                createData();
                                                              }
                                                            }
                                                            // setState(() {
                                                            //   setPage = "frontbus";
                                                            // });
                                                            // _physicalsampleformKey =
                                                            //     GlobalKey<
                                                            //         FormState>();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    134,
                                                                    8,
                                                                    4), // Set button color to red
                                                          ),
                                                          child: const Text(
                                                            'Next',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white, // Set text color to white
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : setPage == "frontbus"
                                                  // Start Front Bus Block.....................................................................
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      fit: StackFit.expand,
                                                      children: [
                                                        SingleChildScrollView(
                                                            child: Form(
                                                          key: _frontbusFormKey,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Image.asset(
                                                                      AppAssets
                                                                          .imgLogo,
                                                                      height:
                                                                          100,
                                                                      width:
                                                                          230,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Center(
                                                                  child: Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top:
                                                                              10),
                                                                      child: Text(
                                                                          "Incoming Quality Control Plan",
                                                                          style: TextStyle(
                                                                              fontSize: 27,
                                                                              color: AppColors.black,
                                                                              fontFamily: appFontFamily,
                                                                              fontWeight: FontWeight.w700)))),
                                                              const Center(
                                                                  child: Text(
                                                                      "(Ribbon)",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          color: AppColors
                                                                              .black,
                                                                          fontFamily:
                                                                              appFontFamily,
                                                                          fontWeight:
                                                                              FontWeight.w700))),
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
                                                                    'GSPL/PVR(IQC)/001',
                                                                    style: AppStyles
                                                                        .textfieldCaptionTextStyle,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Rev.No. / Rev. Date : ',
                                                                    style: AppStyles
                                                                        .textfieldCaptionTextStyle,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    'Ver.2.0 / 13-03-2024',
                                                                    style: AppStyles
                                                                        .textfieldCaptionTextStyle,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              const Center(
                                                                  child: Text(
                                                                      "Performance",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              13,
                                                                              160,
                                                                              0),
                                                                          fontFamily:
                                                                              appFontFamily,
                                                                          fontWeight:
                                                                              FontWeight.w700))),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Text(
                                                                "Characterstics",
                                                                style: AppStyles
                                                                    .textfieldCaptionTextStyle,
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    frontbusCharactersticsController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                decoration: AppStyles
                                                                    .textFieldInputDecoration
                                                                    .copyWith(
                                                                        // hintText: "Please Enter Day Lot No.",
                                                                        ),
                                                                maxLines: 2,
                                                                style: AppStyles
                                                                    .textInputTextStyle,
                                                                readOnly: true,
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "Measuring Method",
                                                                style: AppStyles
                                                                    .textfieldCaptionTextStyle,
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    frontbusMeasuringMethodController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                decoration: AppStyles
                                                                    .textFieldInputDecoration
                                                                    .copyWith(
                                                                        // hintText: "Please Enter Day Lot No.",
                                                                        ),
                                                                style: AppStyles
                                                                    .textInputTextStyle,
                                                                readOnly: true,
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "Sampling",
                                                                style: AppStyles
                                                                    .textfieldCaptionTextStyle,
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    frontbusSamplingController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                decoration: AppStyles
                                                                    .textFieldInputDecoration
                                                                    .copyWith(
                                                                        // hintText: "Please Enter Day Lot No.",
                                                                        ),
                                                                style: AppStyles
                                                                    .textInputTextStyle,
                                                                readOnly: true,
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "Sample Size*",
                                                                style: AppStyles
                                                                    .textfieldCaptionTextStyle,
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              TextFormField(
                                                                  controller:
                                                                      frontbusSampleSizeController,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                  decoration: AppStyles
                                                                      .textFieldInputDecoration
                                                                      .copyWith(
                                                                    hintText:
                                                                        "Please Enter Sample Size",
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                  validator:
                                                                      MultiValidator([
                                                                    RequiredValidator(
                                                                        errorText:
                                                                            "Please Enter Sample Size.")
                                                                  ])
                                                                  // bikki
                                                                  ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "Reference Doc",
                                                                style: AppStyles
                                                                    .textfieldCaptionTextStyle,
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    frontbusReferenceDocController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                decoration: AppStyles
                                                                    .textFieldInputDecoration
                                                                    .copyWith(
                                                                        // hintText: "Please Enter Day Lot No.",
                                                                        ),
                                                                style: AppStyles
                                                                    .textInputTextStyle,
                                                                readOnly: true,
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "Acceptance Criteria",
                                                                style: AppStyles
                                                                    .textfieldCaptionTextStyle,
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    frontbusAcceptanceCriteriaController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                decoration: AppStyles
                                                                    .textFieldInputDecoration
                                                                    .copyWith(
                                                                        // hintText: "Please Enter Day Lot No.",
                                                                        ),
                                                                maxLines: 2,
                                                                style: AppStyles
                                                                    .textInputTextStyle,
                                                                readOnly: true,
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          10,
                                                                          0,
                                                                          0)),
                                                              _isLoading
                                                                  ? const Center(
                                                                      child:
                                                                          CircularProgressIndicator())
                                                                  : AppButton(
                                                                      textStyle: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color: AppColors
                                                                              .white,
                                                                          fontSize:
                                                                              16),
                                                                      onTap:
                                                                          () {
                                                                        AppHelper.hideKeyboard(
                                                                            context);
                                                                        _frontbusFormKey
                                                                            .currentState!
                                                                            .save;
                                                                        if (_frontbusFormKey
                                                                            .currentState!
                                                                            .validate()) {
                                                                          // ignore: unnecessary_null_comparison
                                                                          if (frontbusSampleSizeController.text !=
                                                                              "") {
                                                                            int num =
                                                                                int.parse(frontbusSampleSizeController.text);
                                                                            setState(() {
                                                                              setPage = 'checkfrontbus';
                                                                              numberOfFrontbusSampleFields = num;
                                                                            });
                                                                          }
                                                                          if (status !=
                                                                              'Pending') {
                                                                            setState(() {
                                                                              sendStatus = 'Inprogress';
                                                                            });
                                                                            createData();
                                                                          }
                                                                        }

                                                                        // Dynamic Start......
                                                                        selectedFrontbusTestValues = List<bool>.generate(
                                                                            numberOfFrontbusSampleFields,
                                                                            (index) =>
                                                                                false);
                                                                        for (int i =
                                                                                0;
                                                                            i < numberOfFrontbusSampleFields;
                                                                            i++) {
                                                                          frontbusBarcodeControllers
                                                                              .add(TextEditingController());
                                                                          frontbusRemarksControllers
                                                                              .add(TextEditingController());

                                                                          // Update Time.......
                                                                          if (widget.id != "" &&
                                                                              widget.id != null &&
                                                                              FrontBus.length > 0) {
                                                                            frontbusRemarksControllers[i].text =
                                                                                FrontBus[i]['SampleRemarks'];

                                                                            selectedFrontbusTestValues[i] =
                                                                                FrontBus[i]['SampleTest'];

                                                                            frontbusBarcodeControllers[i].text =
                                                                                FrontBus[i]['SampleBarcode'];
                                                                          }
                                                                        }

                                                                        // _frontbusFormKey =
                                                                        //     GlobalKey<
                                                                        //         FormState>();

                                                                        // Dynamic  End......
                                                                      },
                                                                      label:
                                                                          "Check",
                                                                      organization:
                                                                          '',
                                                                    ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        setPage =
                                                                            "checkphysical";
                                                                      });
                                                                      // Navigator.of(context).pushReplacement(
                                                                      //     MaterialPageRoute(
                                                                      //         builder: (BuildContext context) =>
                                                                      //             LoginPage(
                                                                      //                 appName: widget.appName)));
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      "BACK",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              appFontFamily,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w500,
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
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    const Column(
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
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                appFontFamily,
                                                                            color:
                                                                                AppColors.greyColor,
                                                                            fontWeight: FontWeight.w400)),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                      ],
                                                    )
                                                  : setPage == "checkfrontbus"
                                                      ? Scaffold(
                                                          body: Form(
                                                            key:
                                                                _frontbussampleformKey,
                                                            child: ListView
                                                                .builder(
                                                              itemCount:
                                                                  numberOfFrontbusSampleFields,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: [
                                                                      Text(
                                                                        "Sample ${index + 1}",
                                                                        style: AppStyles
                                                                            .textfieldCaptionTextStyle,
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      //  if (barcodeScanRes != '-1')
                                                                      TextFormField(
                                                                        controller:
                                                                            frontbusBarcodeControllers[index],
                                                                        decoration: AppStyles
                                                                            .textFieldInputDecoration
                                                                            .copyWith(
                                                                          hintText:
                                                                              "Please Scan Sample Barcode",
                                                                          counterText:
                                                                              '',
                                                                          contentPadding:
                                                                              EdgeInsets.all(10),
                                                                          suffixIcon:
                                                                              IconButton(
                                                                            onPressed:
                                                                                () async {
                                                                              if (status != 'Pending') {
                                                                                barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                                                  '#FF6666',
                                                                                  'Cancel',
                                                                                  true,
                                                                                  ScanMode.DEFAULT,
                                                                                );

                                                                                setState(() {
                                                                                  frontbusBarcodeControllers[index].text = (barcodeScanRes != "-1" ? barcodeScanRes : '')!;
                                                                                });
                                                                              }
                                                                            },
                                                                            icon:
                                                                                const Icon(Icons.qr_code),
                                                                          ),
                                                                        ),
                                                                        readOnly: status ==
                                                                                'Pending'
                                                                            ? true
                                                                            : false,
                                                                        style: AppStyles
                                                                            .textInputTextStyle,
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Please Scan Sample Barcode.';
                                                                          }
                                                                          return null;
                                                                        },
                                                                      ),

                                                                      const SizedBox(
                                                                          height:
                                                                              8), // Add space between TextFormField and Radio Buttons
                                                                      Row(
                                                                        children: [
                                                                          Radio(
                                                                            value:
                                                                                true,
                                                                            groupValue:
                                                                                selectedFrontbusTestValues[index],
                                                                            onChanged:
                                                                                (bool? value) {
                                                                              if (status != 'Pending') {
                                                                                setState(() {
                                                                                  selectedFrontbusTestValues[index] = value!;
                                                                                  frontbusRemarksControllers[index].text = '';
                                                                                });
                                                                              }
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            'True',
                                                                            style:
                                                                                AppStyles.textfieldCaptionTextStyle,
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 8),
                                                                          Radio(
                                                                            value:
                                                                                false,
                                                                            groupValue:
                                                                                selectedFrontbusTestValues[index],
                                                                            onChanged:
                                                                                (bool? value) {
                                                                              if (status != 'Pending') {
                                                                                setState(() {
                                                                                  selectedFrontbusTestValues[index] = value!;
                                                                                });
                                                                              }
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            'False',
                                                                            style:
                                                                                AppStyles.textfieldCaptionTextStyle,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      if (selectedFrontbusTestValues[
                                                                              index] ==
                                                                          false)
                                                                        const SizedBox(
                                                                            height:
                                                                                8),
                                                                      if (selectedFrontbusTestValues[
                                                                              index] ==
                                                                          false)
                                                                        TextFormField(
                                                                          controller:
                                                                              frontbusRemarksControllers[index],
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "Please Enter Remarks",
                                                                            counterText:
                                                                                '',
                                                                            contentPadding:
                                                                                EdgeInsets.all(10),
                                                                          ),
                                                                          style:
                                                                              AppStyles.textInputTextStyle,
                                                                          readOnly: status == 'Pending'
                                                                              ? true
                                                                              : false,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return 'Please Enter Remarks.';
                                                                            }
                                                                            return null;
                                                                          },
                                                                        ),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        color: AppColors
                                                                            .dividerColor,
                                                                        height:
                                                                            1,
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          bottomNavigationBar:
                                                              Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(14.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      setPage =
                                                                          "frontbus";
                                                                    });
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "BACK",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            appFontFamily,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: AppColors
                                                                            .redColor),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    AppHelper
                                                                        .hideKeyboard(
                                                                            context);
                                                                    _frontbussampleformKey
                                                                        .currentState!
                                                                        .save;

                                                                    // Validate the form
                                                                    if (_frontbussampleformKey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      frontbusSampleData =
                                                                          [];

                                                                      for (int i =
                                                                              0;
                                                                          i < numberOfFrontbusSampleFields;
                                                                          i++) {
                                                                        frontbusSampleData
                                                                            .add({
                                                                          "SampleBarcode":
                                                                              frontbusBarcodeControllers[i].text,
                                                                          "SampleTest":
                                                                              selectedFrontbusTestValues[i],
                                                                          "SampleRemarks":
                                                                              frontbusRemarksControllers[i].text
                                                                        });
                                                                      }

                                                                      setState(
                                                                          () {
                                                                        setPage =
                                                                            "verification";
                                                                      });
                                                                      if (status !=
                                                                          'Pending') {
                                                                        setState(
                                                                            () {
                                                                          sendStatus =
                                                                              'Inprogress';
                                                                        });
                                                                        createData();
                                                                      }
                                                                    }

                                                                    // setState(() {
                                                                    //   setPage =
                                                                    //       "verification";
                                                                    // });
                                                                    // _frontbussampleformKey =
                                                                    //     GlobalKey<
                                                                    //         FormState>();
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            134,
                                                                            8,
                                                                            4), // Set button color to red
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    'Next',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white, // Set text color to white
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : setPage ==
                                                              "verification"
                                                          // Start Verification Block.....................................................................
                                                          ? Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              fit: StackFit
                                                                  .expand,
                                                              children: [
                                                                SingleChildScrollView(
                                                                    child: Form(
                                                                  key:
                                                                      _verificationFormKey,
                                                                  autovalidateMode:
                                                                      AutovalidateMode
                                                                          .onUserInteraction,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <Widget>[
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Column(
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
                                                                      const Center(
                                                                          child: Padding(
                                                                              padding: EdgeInsets.only(top: 10),
                                                                              child: Text("Incoming Quality Control Plan", style: TextStyle(fontSize: 27, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700)))),
                                                                      const Center(
                                                                          child: Text(
                                                                              "(Ribbon)",
                                                                              style: TextStyle(fontSize: 20, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
                                                                      const SizedBox(
                                                                        height:
                                                                            35,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Document No : ',
                                                                            style:
                                                                                AppStyles.textfieldCaptionTextStyle,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            'GSPL/PVR(IQC)/001',
                                                                            style:
                                                                                AppStyles.textfieldCaptionTextStyle,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Rev.No. / Rev. Date : ',
                                                                            style:
                                                                                AppStyles.textfieldCaptionTextStyle,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            'Ver.2.0 / 13-03-2024',
                                                                            style:
                                                                                AppStyles.textfieldCaptionTextStyle,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      const Center(
                                                                          child: Text(
                                                                              "Verification-2",
                                                                              style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 13, 160, 0), fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
                                                                      const SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Text(
                                                                        "Characterstics",
                                                                        style: AppStyles
                                                                            .textfieldCaptionTextStyle,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      TextFormField(
                                                                        controller:
                                                                            verificationCharactersticsController,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        textInputAction:
                                                                            TextInputAction.next,
                                                                        decoration: AppStyles
                                                                            .textFieldInputDecoration
                                                                            .copyWith(
                                                                                // hintText: "Please Enter Day Lot No.",
                                                                                ),
                                                                        maxLines:
                                                                            2,
                                                                        style: AppStyles
                                                                            .textInputTextStyle,
                                                                        readOnly:
                                                                            true,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      Text(
                                                                        "Measuring Method",
                                                                        style: AppStyles
                                                                            .textfieldCaptionTextStyle,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      TextFormField(
                                                                        controller:
                                                                            verificationMeasuringMethodController,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        textInputAction:
                                                                            TextInputAction.next,
                                                                        decoration: AppStyles
                                                                            .textFieldInputDecoration
                                                                            .copyWith(
                                                                                // hintText: "Please Enter Day Lot No.",
                                                                                ),
                                                                        style: AppStyles
                                                                            .textInputTextStyle,
                                                                        readOnly:
                                                                            true,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      Text(
                                                                        "Sampling",
                                                                        style: AppStyles
                                                                            .textfieldCaptionTextStyle,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      TextFormField(
                                                                        controller:
                                                                            verificationSamplingController,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        textInputAction:
                                                                            TextInputAction.next,
                                                                        decoration: AppStyles
                                                                            .textFieldInputDecoration
                                                                            .copyWith(
                                                                                // hintText: "Please Enter Day Lot No.",
                                                                                ),
                                                                        style: AppStyles
                                                                            .textInputTextStyle,
                                                                        readOnly:
                                                                            true,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      Text(
                                                                        "Sample Size*",
                                                                        style: AppStyles
                                                                            .textfieldCaptionTextStyle,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      TextFormField(
                                                                          controller:
                                                                              verificationSampleSizeController,
                                                                          keyboardType: TextInputType
                                                                              .number,
                                                                          textInputAction: TextInputAction
                                                                              .next,
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "Please Enter Sample Size",
                                                                          ),
                                                                          style: AppStyles
                                                                              .textInputTextStyle,
                                                                          maxLength:
                                                                              2,
                                                                          readOnly: status == 'Pending'
                                                                              ? true
                                                                              : false,
                                                                          validator:
                                                                              MultiValidator([
                                                                            RequiredValidator(errorText: "Please Enter Sample Size.")
                                                                          ])
                                                                          // bikki
                                                                          ),
                                                                      const SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      Text(
                                                                        "Reference Doc",
                                                                        style: AppStyles
                                                                            .textfieldCaptionTextStyle,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      TextFormField(
                                                                        controller:
                                                                            verificationReferenceDocController,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        textInputAction:
                                                                            TextInputAction.next,
                                                                        decoration: AppStyles
                                                                            .textFieldInputDecoration
                                                                            .copyWith(
                                                                                // hintText: "Please Enter Day Lot No.",
                                                                                ),
                                                                        style: AppStyles
                                                                            .textInputTextStyle,
                                                                        readOnly:
                                                                            true,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      Text(
                                                                        "Acceptance Criteria",
                                                                        style: AppStyles
                                                                            .textfieldCaptionTextStyle,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      TextFormField(
                                                                        controller:
                                                                            verificationAcceptanceCriteriaController,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        textInputAction:
                                                                            TextInputAction.next,
                                                                        decoration: AppStyles
                                                                            .textFieldInputDecoration
                                                                            .copyWith(
                                                                                // hintText: "Please Enter Day Lot No.",
                                                                                ),
                                                                        maxLines:
                                                                            2,
                                                                        style: AppStyles
                                                                            .textInputTextStyle,
                                                                        readOnly:
                                                                            true,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      const Padding(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0)),
                                                                      _isLoading
                                                                          ? const Center(
                                                                              child: CircularProgressIndicator())
                                                                          : AppButton(
                                                                              textStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.white, fontSize: 16),
                                                                              onTap: () {
                                                                                AppHelper.hideKeyboard(context);
                                                                                _verificationFormKey.currentState!.save;
                                                                                if (_verificationFormKey.currentState!.validate()) {
                                                                                  // ignore: unnecessary_null_comparison
                                                                                  if (verificationSampleSizeController.text != "") {
                                                                                    int num = int.parse(verificationSampleSizeController.text);
                                                                                    setState(() {
                                                                                      setPage = 'checkverification';
                                                                                      numberOfVerificationSampleFields = num;
                                                                                    });
                                                                                  }
                                                                                  if (status != 'Pending') {
                                                                                    setState(() {
                                                                                      sendStatus = 'Inprogress';
                                                                                    });
                                                                                    createData();
                                                                                  }
                                                                                }

                                                                                // Dynamic Start......
                                                                                selectedVerificationTestValues = List<bool>.generate(numberOfVerificationSampleFields, (index) => false);
                                                                                for (int i = 0; i < numberOfVerificationSampleFields; i++) {
                                                                                  verificationBarcodeControllers.add(TextEditingController());
                                                                                  verificationRemarksControllers.add(TextEditingController());

                                                                                  // Update Time.......
                                                                                  if (widget.id != "" && widget.id != null && Verification.length > 0) {
                                                                                    verificationRemarksControllers[i].text = Verification[i]['SampleRemarks'];

                                                                                    selectedVerificationTestValues[i] = Verification[i]['SampleTest'];

                                                                                    verificationBarcodeControllers[i].text = Verification[i]['SampleBarcode'];
                                                                                  }
                                                                                }

                                                                                // _verificationFormKey =
                                                                                //     GlobalKey<FormState>();

                                                                                // Dynamic  End......
                                                                              },
                                                                              label: "Check",
                                                                              organization: '',
                                                                            ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                setPage = "checkfrontbus";
                                                                              });
                                                                              // Navigator.of(context).pushReplacement(
                                                                              //     MaterialPageRoute(
                                                                              //         builder: (BuildContext context) =>
                                                                              //             LoginPage(
                                                                              //                 appName: widget.appName)));
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              "BACK",
                                                                              style: TextStyle(fontFamily: appFontFamily, fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.redColor),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            25,
                                                                      ),
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            const Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text("Powered By Gautam Solar Pvt. Ltd.",
                                                                                style: TextStyle(fontSize: 14, fontFamily: appFontFamily, color: AppColors.greyColor, fontWeight: FontWeight.w400)),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )),
                                                              ],
                                                            )
                                                          : setPage ==
                                                                  "checkverification"
                                                              ? Scaffold(
                                                                  body: Form(
                                                                    key:
                                                                        _verificationsampleformKey,
                                                                    child: ListView
                                                                        .builder(
                                                                      itemCount:
                                                                          numberOfVerificationSampleFields,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.stretch,
                                                                            children: [
                                                                              Text(
                                                                                "Sample ${index + 1}",
                                                                                style: AppStyles.textfieldCaptionTextStyle,
                                                                              ),
                                                                              const SizedBox(height: 8),

                                                                              TextFormField(
                                                                                controller: verificationBarcodeControllers[index],
                                                                                decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                  hintText: "Please Scan Sample Barcode",
                                                                                  counterText: '',
                                                                                  contentPadding: EdgeInsets.all(10),
                                                                                  suffixIcon: IconButton(
                                                                                    onPressed: () async {
                                                                                      if (status != 'Pending') {
                                                                                        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                                                          '#FF6666',
                                                                                          'Cancel',
                                                                                          true,
                                                                                          ScanMode.DEFAULT,
                                                                                        );

                                                                                        setState(() {
                                                                                          verificationBarcodeControllers[index].text = (barcodeScanRes != "-1" ? barcodeScanRes : '')!;
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    icon: const Icon(Icons.qr_code),
                                                                                  ),
                                                                                ),
                                                                                readOnly: status == 'Pending' ? true : false,
                                                                                style: AppStyles.textInputTextStyle,
                                                                                validator: (value) {
                                                                                  if (value == null || value.isEmpty) {
                                                                                    return 'Please Scan Sample Barcode.';
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                              ),

                                                                              const SizedBox(height: 8), // Add space between TextFormField and Radio Buttons
                                                                              Row(
                                                                                children: [
                                                                                  Radio(
                                                                                    value: true,
                                                                                    groupValue: selectedVerificationTestValues[index],
                                                                                    onChanged: (bool? value) {
                                                                                      if (status != 'Pending') {
                                                                                        setState(() {
                                                                                          selectedVerificationTestValues[index] = value!;
                                                                                          verificationRemarksControllers[index].text = '';
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                  Text(
                                                                                    'True',
                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                  ),
                                                                                  const SizedBox(width: 8),
                                                                                  Radio(
                                                                                    value: false,
                                                                                    groupValue: selectedVerificationTestValues[index],
                                                                                    onChanged: (bool? value) {
                                                                                      if (status != 'Pending') {
                                                                                        setState(() {
                                                                                          selectedVerificationTestValues[index] = value!;
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                  Text(
                                                                                    'False',
                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              if (selectedVerificationTestValues[index] == false)
                                                                                const SizedBox(height: 8),
                                                                              if (selectedVerificationTestValues[index] == false)
                                                                                TextFormField(
                                                                                  controller: verificationRemarksControllers[index],
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Please Enter Remarks",
                                                                                    counterText: '',
                                                                                    contentPadding: EdgeInsets.all(10),
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: status == 'Pending' ? true : false,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return 'Please Enter Remarks.';
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                ),
                                                                              const SizedBox(height: 8),
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width,
                                                                                color: AppColors.dividerColor,
                                                                                height: 1,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  bottomNavigationBar:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            14.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              setPage = "verification";
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            "BACK",
                                                                            style: TextStyle(
                                                                                fontFamily: appFontFamily,
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: AppColors.redColor),
                                                                          ),
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            AppHelper.hideKeyboard(context);
                                                                            _verificationsampleformKey.currentState!.save;

                                                                            // Validate the form
                                                                            if (_verificationsampleformKey.currentState!.validate()) {
                                                                              verificationSampleData = [];

                                                                              for (int i = 0; i < numberOfVerificationSampleFields; i++) {
                                                                                verificationSampleData.add({
                                                                                  "SampleBarcode": verificationBarcodeControllers[i].text,
                                                                                  "SampleTest": selectedVerificationTestValues[i],
                                                                                  "SampleRemarks": verificationRemarksControllers[i].text
                                                                                });
                                                                              }

                                                                              setState(() {
                                                                                setPage = "electrical";
                                                                              });
                                                                              if (status != 'Pending') {
                                                                                setState(() {
                                                                                  sendStatus = 'Inprogress';
                                                                                });
                                                                                createData();
                                                                              }
                                                                            }
                                                                            // setState(
                                                                            //     () {
                                                                            //   setPage =
                                                                            //       "electrical";
                                                                            // });
                                                                            // _verificationsampleformKey =
                                                                            //     GlobalKey<
                                                                            //         FormState>();
                                                                          },
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor: const Color.fromARGB(
                                                                                255,
                                                                                134,
                                                                                8,
                                                                                4), // Set button color to red
                                                                          ),
                                                                          child:
                                                                              const Text(
                                                                            'Next',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white, // Set text color to white
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              : setPage ==
                                                                      "electrical"
                                                                  // Start Electrical Block.....................................................................
                                                                  ? Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      fit: StackFit
                                                                          .expand,
                                                                      children: [
                                                                        SingleChildScrollView(
                                                                            child:
                                                                                Form(
                                                                          key:
                                                                              _electricalFormKey,
                                                                          autovalidateMode:
                                                                              AutovalidateMode.onUserInteraction,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
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
                                                                              const Center(child: Padding(padding: EdgeInsets.only(top: 10), child: Text("Incoming Quality Control Plan", style: TextStyle(fontSize: 27, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700)))),
                                                                              const Center(child: Text("(Ribbon)", style: TextStyle(fontSize: 20, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
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
                                                                                    'GSPL/PVR(IQC)/001',
                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    'Rev.No. / Rev. Date : ',
                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 8,
                                                                                  ),
                                                                                  Text(
                                                                                    'Ver.2.0 / 13-03-2024',
                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              const Center(child: Text("Verification-3", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 13, 160, 0), fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
                                                                              const SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                              Text(
                                                                                "Characterstics",
                                                                                style: AppStyles.textfieldCaptionTextStyle,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              TextFormField(
                                                                                controller: electricalCharactersticsController,
                                                                                keyboardType: TextInputType.text,
                                                                                textInputAction: TextInputAction.next,
                                                                                decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    // hintText: "Please Enter Day Lot No.",
                                                                                    ),
                                                                                maxLines: 2,
                                                                                style: AppStyles.textInputTextStyle,
                                                                                readOnly: true,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              Text(
                                                                                "Measuring Method",
                                                                                style: AppStyles.textfieldCaptionTextStyle,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              TextFormField(
                                                                                controller: electricalMeasuringMethodController,
                                                                                keyboardType: TextInputType.text,
                                                                                textInputAction: TextInputAction.next,
                                                                                decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    // hintText: "Please Enter Day Lot No.",
                                                                                    ),
                                                                                style: AppStyles.textInputTextStyle,
                                                                                readOnly: true,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              Text(
                                                                                "Sampling",
                                                                                style: AppStyles.textfieldCaptionTextStyle,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              TextFormField(
                                                                                controller: electricalSamplingController,
                                                                                keyboardType: TextInputType.text,
                                                                                textInputAction: TextInputAction.next,
                                                                                decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    // hintText: "Please Enter Day Lot No.",
                                                                                    ),
                                                                                style: AppStyles.textInputTextStyle,
                                                                                readOnly: true,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              Text(
                                                                                "Sample Size*",
                                                                                style: AppStyles.textfieldCaptionTextStyle,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              TextFormField(
                                                                                  controller:
                                                                                      electricalSampleSizeController,
                                                                                  keyboardType: TextInputType
                                                                                      .number,
                                                                                  textInputAction: TextInputAction
                                                                                      .next,
                                                                                  decoration: AppStyles.textFieldInputDecoration
                                                                                      .copyWith(
                                                                                    hintText: "Please Enter Sample Size",
                                                                                  ),
                                                                                  style: AppStyles
                                                                                      .textInputTextStyle,
                                                                                  maxLength:
                                                                                      2,
                                                                                  readOnly: status == 'Pending'
                                                                                      ? true
                                                                                      : false,
                                                                                  validator: MultiValidator([
                                                                                    RequiredValidator(errorText: "Please Enter Sample Size.")
                                                                                  ])
                                                                                  // bikki
                                                                                  ),
                                                                              const SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              Text(
                                                                                "Reference Doc",
                                                                                style: AppStyles.textfieldCaptionTextStyle,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              TextFormField(
                                                                                controller: electricalReferenceDocController,
                                                                                keyboardType: TextInputType.text,
                                                                                textInputAction: TextInputAction.next,
                                                                                decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    // hintText: "Please Enter Day Lot No.",
                                                                                    ),
                                                                                style: AppStyles.textInputTextStyle,
                                                                                readOnly: true,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              Text(
                                                                                "Acceptance Criteria",
                                                                                style: AppStyles.textfieldCaptionTextStyle,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              TextFormField(
                                                                                controller: electricalAcceptanceCriteriaController,
                                                                                keyboardType: TextInputType.text,
                                                                                textInputAction: TextInputAction.next,
                                                                                decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    // hintText: "Please Enter Day Lot No.",
                                                                                    ),
                                                                                maxLines: 2,
                                                                                style: AppStyles.textInputTextStyle,
                                                                                readOnly: true,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                                                              _isLoading
                                                                                  ? const Center(child: CircularProgressIndicator())
                                                                                  : AppButton(
                                                                                      textStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.white, fontSize: 16),
                                                                                      onTap: () {
                                                                                        AppHelper.hideKeyboard(context);
                                                                                        _electricalFormKey.currentState!.save;
                                                                                        if (_electricalFormKey.currentState!.validate()) {
                                                                                          // ignore: unnecessary_null_comparison
                                                                                          if (electricalSampleSizeController.text != "") {
                                                                                            int num = int.parse(electricalSampleSizeController.text);
                                                                                            setState(() {
                                                                                              setPage = 'checkelectrical';
                                                                                              numberOfElectricalSampleFields = num;
                                                                                            });
                                                                                          }
                                                                                          if (status != 'Pending') {
                                                                                            setState(() {
                                                                                              sendStatus = 'Inprogress';
                                                                                            });
                                                                                            createData();
                                                                                          }
                                                                                        }

                                                                                        // Dynamic Start......
                                                                                        selectedElectricalTestValues = List<bool>.generate(numberOfElectricalSampleFields, (index) => false);

                                                                                        for (int i = 0; i < numberOfElectricalSampleFields; i++) {
                                                                                          electricalBarcodeControllers.add(TextEditingController());
                                                                                          electricalRemarksControllers.add(TextEditingController());

                                                                                          // Update Time.......
                                                                                          if (widget.id != "" && widget.id != null && Electrical.length > 0) {
                                                                                            electricalBarcodeControllers[i].text = Electrical[i]['SampleBarcode'];

                                                                                            selectedElectricalTestValues[i] = Electrical[i]['SampleTest'] ?? false;

                                                                                            electricalRemarksControllers[i].text = Electrical[i]['SampleRemarks'];
                                                                                          }
                                                                                        }

                                                                                        // Dynamic  End......
                                                                                      },
                                                                                      label: "Check",
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
                                                                                      setState(() {
                                                                                        setPage = "checkverification";
                                                                                      });
                                                                                      // Navigator.of(context).pushReplacement(
                                                                                      //     MaterialPageRoute(
                                                                                      //         builder: (BuildContext context) =>
                                                                                      //             LoginPage(
                                                                                      //                 appName: widget.appName)));
                                                                                    },
                                                                                    child: const Text(
                                                                                      "BACK",
                                                                                      style: TextStyle(fontFamily: appFontFamily, fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.redColor),
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
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Text("Powered By Gautam Solar Pvt. Ltd.", style: TextStyle(fontSize: 14, fontFamily: appFontFamily, color: AppColors.greyColor, fontWeight: FontWeight.w400)),
                                                                                    SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )),
                                                                      ],
                                                                    )
                                                                  : setPage ==
                                                                          "checkelectrical"
                                                                      ? Scaffold(
                                                                          body:
                                                                              Form(
                                                                            key:
                                                                                _electricalsampleformKey,
                                                                            child:
                                                                                ListView.builder(
                                                                              itemCount: numberOfElectricalSampleFields,
                                                                              itemBuilder: (context, index) {
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                    children: [
                                                                                      Text(
                                                                                        "Sample ${index + 1}",
                                                                                        style: AppStyles.textfieldCaptionTextStyle,
                                                                                      ),
                                                                                      const SizedBox(height: 8),

                                                                                      TextFormField(
                                                                                        controller: electricalBarcodeControllers[index],
                                                                                        decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                          hintText: "Please Scan Sample Barcode",
                                                                                          counterText: '',
                                                                                          contentPadding: EdgeInsets.all(10),
                                                                                          suffixIcon: IconButton(
                                                                                            onPressed: () async {
                                                                                              if (status != 'Pending') {
                                                                                                barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                                                                  '#FF6666',
                                                                                                  'Cancel',
                                                                                                  true,
                                                                                                  ScanMode.DEFAULT,
                                                                                                );

                                                                                                setState(() {
                                                                                                  electricalBarcodeControllers[index].text = (barcodeScanRes != "-1" ? barcodeScanRes : '')!;
                                                                                                });
                                                                                              }
                                                                                            },
                                                                                            icon: const Icon(Icons.qr_code),
                                                                                          ),
                                                                                        ),
                                                                                        readOnly: status == 'Pending' ? true : false,
                                                                                        style: AppStyles.textInputTextStyle,
                                                                                        validator: (value) {
                                                                                          if (value == null || value.isEmpty) {
                                                                                            return 'Please Scan Sample Barcode.';
                                                                                          }
                                                                                          return null;
                                                                                        },
                                                                                      ),

                                                                                      const SizedBox(height: 8), // Add space between TextFormField and Radio Buttons
                                                                                      Row(
                                                                                        children: [
                                                                                          Radio(
                                                                                            value: true,
                                                                                            groupValue: selectedElectricalTestValues[index],
                                                                                            onChanged: (bool? value) {
                                                                                              if (status != 'Pending') {
                                                                                                setState(() {
                                                                                                  selectedElectricalTestValues[index] = value!;
                                                                                                  electricalRemarksControllers[index].text = '';
                                                                                                });
                                                                                              }
                                                                                            },
                                                                                          ),
                                                                                          Text(
                                                                                            'True',
                                                                                            style: AppStyles.textfieldCaptionTextStyle,
                                                                                          ),
                                                                                          const SizedBox(width: 8),
                                                                                          Radio(
                                                                                            value: false,
                                                                                            groupValue: selectedElectricalTestValues[index],
                                                                                            onChanged: (bool? value) {
                                                                                              if (status != 'Pending') {
                                                                                                setState(() {
                                                                                                  selectedElectricalTestValues[index] = value!;
                                                                                                });
                                                                                              }
                                                                                            },
                                                                                          ),
                                                                                          Text(
                                                                                            'False',
                                                                                            style: AppStyles.textfieldCaptionTextStyle,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      if (selectedElectricalTestValues[index] == false) const SizedBox(height: 8),
                                                                                      if (selectedElectricalTestValues[index] == false)
                                                                                        TextFormField(
                                                                                          controller: electricalRemarksControllers[index],
                                                                                          decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                            hintText: "Please Enter Remarks",
                                                                                            counterText: '',
                                                                                            contentPadding: EdgeInsets.all(10),
                                                                                          ),
                                                                                          style: AppStyles.textInputTextStyle,
                                                                                          readOnly: status == 'Pending' ? true : false,
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              return 'Please Enter Remarks.';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                        ),
                                                                                      const SizedBox(height: 8),
                                                                                      Container(
                                                                                        width: MediaQuery.of(context).size.width,
                                                                                        color: AppColors.dividerColor,
                                                                                        height: 1,
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                          bottomNavigationBar:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(14.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      setPage = "electrical";
                                                                                    });
                                                                                  },
                                                                                  child: const Text(
                                                                                    "BACK",
                                                                                    style: TextStyle(fontFamily: appFontFamily, fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.redColor),
                                                                                  ),
                                                                                ),
                                                                                ElevatedButton(
                                                                                  onPressed: () {
                                                                                    AppHelper.hideKeyboard(context);
                                                                                    _electricalsampleformKey.currentState!.save;

                                                                                    // Validate the form
                                                                                    if (_electricalsampleformKey.currentState!.validate()) {
                                                                                      electricalSampleData = [];

                                                                                      for (int i = 0; i < numberOfElectricalSampleFields; i++) {
                                                                                        electricalSampleData.add({
                                                                                          "SampleBarcode": electricalBarcodeControllers[i].text,
                                                                                          "SampleTest": selectedElectricalTestValues[i],
                                                                                          "SampleRemarks": electricalRemarksControllers[i].text
                                                                                        });
                                                                                      }

                                                                                      setState(() {
                                                                                        setPage = "performance";
                                                                                      });
                                                                                      if (status != 'Pending') {
                                                                                        setState(() {
                                                                                          sendStatus = 'Inprogress';
                                                                                        });
                                                                                        createData();
                                                                                      }
                                                                                    }
                                                                                    // setState(() {
                                                                                    //   setPage = "performance";
                                                                                    // });
                                                                                    // _electricalsampleformKey = GlobalKey<FormState>();
                                                                                  },
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: const Color.fromARGB(255, 134, 8, 4), // Set button color to red
                                                                                  ),
                                                                                  child: const Text(
                                                                                    'Next',
                                                                                    style: TextStyle(
                                                                                      color: Colors.white, // Set text color to white
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : setPage ==
                                                                              "performance"
                                                                          // Start Performance Block.....................................................................
                                                                          ? Stack(
                                                                              alignment: Alignment.center,
                                                                              fit: StackFit.expand,
                                                                              children: [
                                                                                SingleChildScrollView(
                                                                                    child: Form(
                                                                                  key: _performanceFormKey,
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
                                                                                            Image.asset(
                                                                                              AppAssets.imgLogo,
                                                                                              height: 100,
                                                                                              width: 230,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      const Center(child: Padding(padding: EdgeInsets.only(top: 10), child: Text("Incoming Quality Control Plan", style: TextStyle(fontSize: 27, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700)))),
                                                                                      const Center(child: Text("(Ribbon)", style: TextStyle(fontSize: 20, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
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
                                                                                            'GSPL/PVR(IQC)/001',
                                                                                            style: AppStyles.textfieldCaptionTextStyle,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 8,
                                                                                      ),
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            'Rev.No. / Rev. Date : ',
                                                                                            style: AppStyles.textfieldCaptionTextStyle,
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            width: 8,
                                                                                          ),
                                                                                          Text(
                                                                                            'Ver.2.0 / 13-03-2024',
                                                                                            style: AppStyles.textfieldCaptionTextStyle,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 15,
                                                                                      ),
                                                                                      const Center(child: Text("Verification-4", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 13, 160, 0), fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
                                                                                      const SizedBox(
                                                                                        height: 20,
                                                                                      ),
                                                                                      Text(
                                                                                        "Characterstics",
                                                                                        style: AppStyles.textfieldCaptionTextStyle,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      TextFormField(
                                                                                        controller: performanceCharactersticsController,
                                                                                        keyboardType: TextInputType.text,
                                                                                        textInputAction: TextInputAction.next,
                                                                                        decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                            // hintText: "Please Enter Day Lot No.",
                                                                                            ),
                                                                                        maxLines: 2,
                                                                                        style: AppStyles.textInputTextStyle,
                                                                                        readOnly: true,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 15,
                                                                                      ),
                                                                                      Text(
                                                                                        "Measuring Method",
                                                                                        style: AppStyles.textfieldCaptionTextStyle,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      TextFormField(
                                                                                        controller: performanceMeasuringMethodController,
                                                                                        keyboardType: TextInputType.text,
                                                                                        textInputAction: TextInputAction.next,
                                                                                        decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                            // hintText: "Please Enter Day Lot No.",
                                                                                            ),
                                                                                        style: AppStyles.textInputTextStyle,
                                                                                        readOnly: true,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 15,
                                                                                      ),
                                                                                      Text(
                                                                                        "Sampling",
                                                                                        style: AppStyles.textfieldCaptionTextStyle,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      TextFormField(
                                                                                        controller: performanceSamplingController,
                                                                                        keyboardType: TextInputType.text,
                                                                                        textInputAction: TextInputAction.next,
                                                                                        decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                            // hintText: "Please Enter Day Lot No.",
                                                                                            ),
                                                                                        style: AppStyles.textInputTextStyle,
                                                                                        readOnly: true,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 15,
                                                                                      ),
                                                                                      Text(
                                                                                        "Sample Size*",
                                                                                        style: AppStyles.textfieldCaptionTextStyle,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      TextFormField(
                                                                                          controller: performanceSampleSizeController,
                                                                                          keyboardType: TextInputType.number,
                                                                                          textInputAction: TextInputAction.next,
                                                                                          decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                            hintText: "Please Enter Sample Size",
                                                                                          ),
                                                                                          style: AppStyles.textInputTextStyle,
                                                                                          maxLength: 2,
                                                                                          readOnly: status == 'Pending' ? true : false,
                                                                                          validator: MultiValidator([RequiredValidator(errorText: "Please Enter Sample Size.")])
                                                                                          // bikki
                                                                                          ),
                                                                                      const SizedBox(
                                                                                        height: 15,
                                                                                      ),
                                                                                      Text(
                                                                                        "Reference Doc",
                                                                                        style: AppStyles.textfieldCaptionTextStyle,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      TextFormField(
                                                                                        controller: performanceReferenceDocController,
                                                                                        keyboardType: TextInputType.text,
                                                                                        textInputAction: TextInputAction.next,
                                                                                        decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                            // hintText: "Please Enter Day Lot No.",
                                                                                            ),
                                                                                        style: AppStyles.textInputTextStyle,
                                                                                        readOnly: true,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 15,
                                                                                      ),
                                                                                      Text(
                                                                                        "Acceptance Criteria",
                                                                                        style: AppStyles.textfieldCaptionTextStyle,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      TextFormField(
                                                                                        controller: performanceAcceptanceCriteriaController,
                                                                                        keyboardType: TextInputType.text,
                                                                                        textInputAction: TextInputAction.next,
                                                                                        decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                            // hintText: "Please Enter Day Lot No.",
                                                                                            ),
                                                                                        maxLines: 2,
                                                                                        style: AppStyles.textInputTextStyle,
                                                                                        readOnly: true,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 15,
                                                                                      ),
                                                                                      const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                                                                      _isLoading
                                                                                          ? const Center(child: CircularProgressIndicator())
                                                                                          : AppButton(
                                                                                              textStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.white, fontSize: 16),
                                                                                              onTap: () {
                                                                                                AppHelper.hideKeyboard(context);
                                                                                                _performanceFormKey.currentState!.save;
                                                                                                if (_performanceFormKey.currentState!.validate()) {
                                                                                                  // ignore: unnecessary_null_comparison
                                                                                                  if (performanceSampleSizeController.text != "") {
                                                                                                    int num = int.parse(performanceSampleSizeController.text);
                                                                                                    setState(() {
                                                                                                      setPage = 'checkperformance';
                                                                                                      numberOfPerformanceSampleFields = num;
                                                                                                    });
                                                                                                  }
                                                                                                  if (status != 'Pending') {
                                                                                                    setState(() {
                                                                                                      sendStatus = 'Inprogress';
                                                                                                    });
                                                                                                    createData();
                                                                                                  }
                                                                                                }

                                                                                                // Dynamic Start......
                                                                                                selectedPerformanceTestValues = List<bool>.generate(numberOfPerformanceSampleFields, (index) => false);
                                                                                                // _performanceFormKey = GlobalKey<FormState>();
                                                                                                for (int i = 0; i < numberOfPerformanceSampleFields; i++) {
                                                                                                  performanceBarcodeControllers.add(TextEditingController());
                                                                                                  performanceRemarksControllers.add(TextEditingController());

                                                                                                  // Update Time.......
                                                                                                  if (widget.id != "" && widget.id != null && Performance.length > 0) {
                                                                                                    performanceRemarksControllers[i].text = Performance[i]['SampleRemarks'];

                                                                                                    selectedPerformanceTestValues[i] = Performance[i]['SampleTest'];

                                                                                                    performanceBarcodeControllers[i].text = Performance[i]['SampleBarcode'];
                                                                                                  }
                                                                                                }

                                                                                                // Dynamic  End......
                                                                                              },
                                                                                              label: "Check",
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
                                                                                              setState(() {
                                                                                                setPage = "checkelectrical";
                                                                                              });
                                                                                              // Navigator.of(context).pushReplacement(
                                                                                              //     MaterialPageRoute(
                                                                                              //         builder: (BuildContext context) =>
                                                                                              //             LoginPage(
                                                                                              //                 appName: widget.appName)));
                                                                                            },
                                                                                            child: const Text(
                                                                                              "BACK",
                                                                                              style: TextStyle(fontFamily: appFontFamily, fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.redColor),
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
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Text("Powered By Gautam Solar Pvt. Ltd.", style: TextStyle(fontSize: 14, fontFamily: appFontFamily, color: AppColors.greyColor, fontWeight: FontWeight.w400)),
                                                                                            SizedBox(
                                                                                              height: 10,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                )),
                                                                              ],
                                                                            )
                                                                          : setPage == "checkperformance"
                                                                              ? Scaffold(
                                                                                  body: Form(
                                                                                    key: _performancesampleformKey,
                                                                                    child: ListView.builder(
                                                                                      itemCount: numberOfPerformanceSampleFields,
                                                                                      itemBuilder: (context, index) {
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                            children: [
                                                                                              Text(
                                                                                                "Sample ${index + 1}",
                                                                                                style: AppStyles.textfieldCaptionTextStyle,
                                                                                              ),
                                                                                              const SizedBox(height: 8),

                                                                                              TextFormField(
                                                                                                controller: performanceBarcodeControllers[index],
                                                                                                decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                                  hintText: "Please Scan Sample Barcode",
                                                                                                  counterText: '',
                                                                                                  contentPadding: EdgeInsets.all(10),
                                                                                                  suffixIcon: IconButton(
                                                                                                    onPressed: () async {
                                                                                                      if (status != 'Pending') {
                                                                                                        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                                                                          '#FF6666',
                                                                                                          'Cancel',
                                                                                                          true,
                                                                                                          ScanMode.DEFAULT,
                                                                                                        );

                                                                                                        setState(() {
                                                                                                          performanceBarcodeControllers[index].text = (barcodeScanRes != "-1" ? barcodeScanRes : '')!;
                                                                                                        });
                                                                                                      }
                                                                                                    },
                                                                                                    icon: const Icon(Icons.qr_code),
                                                                                                  ),
                                                                                                ),
                                                                                                readOnly: status == 'Pending' ? true : false,
                                                                                                style: AppStyles.textInputTextStyle,
                                                                                                validator: (value) {
                                                                                                  if (value == null || value.isEmpty) {
                                                                                                    return 'Please Scan Sample Barcode.';
                                                                                                  }
                                                                                                  return null;
                                                                                                },
                                                                                              ),

                                                                                              const SizedBox(height: 8), // Add space between TextFormField and Radio Buttons
                                                                                              Row(
                                                                                                children: [
                                                                                                  Radio(
                                                                                                    value: true,
                                                                                                    groupValue: selectedPerformanceTestValues[index],
                                                                                                    onChanged: (bool? value) {
                                                                                                      if (status != 'Pending') {
                                                                                                        setState(() {
                                                                                                          selectedPerformanceTestValues[index] = value!;
                                                                                                          performanceRemarksControllers[index].text = '';
                                                                                                        });
                                                                                                      }
                                                                                                    },
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'True',
                                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                                  ),
                                                                                                  const SizedBox(width: 8),
                                                                                                  Radio(
                                                                                                    value: false,
                                                                                                    groupValue: selectedPerformanceTestValues[index],
                                                                                                    onChanged: (bool? value) {
                                                                                                      if (status != 'Pending') {
                                                                                                        setState(() {
                                                                                                          selectedPerformanceTestValues[index] = value!;
                                                                                                        });
                                                                                                      }
                                                                                                    },
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'False',
                                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              if (selectedPerformanceTestValues[index] == false) const SizedBox(height: 8),
                                                                                              if (selectedPerformanceTestValues[index] == false)
                                                                                                TextFormField(
                                                                                                  controller: performanceRemarksControllers[index],
                                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                                    hintText: "Please Enter Remarks",
                                                                                                    counterText: '',
                                                                                                    contentPadding: EdgeInsets.all(10),
                                                                                                  ),
                                                                                                  style: AppStyles.textInputTextStyle,
                                                                                                  readOnly: status == 'Pending' ? true : false,
                                                                                                  validator: (value) {
                                                                                                    if (value == null || value.isEmpty) {
                                                                                                      return 'Please Enter Remarks.';
                                                                                                    }
                                                                                                    return null;
                                                                                                  },
                                                                                                ),
                                                                                              const SizedBox(height: 8),
                                                                                              Container(
                                                                                                width: MediaQuery.of(context).size.width,
                                                                                                color: AppColors.dividerColor,
                                                                                                height: 1,
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  bottomNavigationBar: Padding(
                                                                                    padding: const EdgeInsets.all(14.0),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                      children: [
                                                                                        InkWell(
                                                                                          onTap: () {
                                                                                            setState(() {
                                                                                              setPage = "performance";
                                                                                            });
                                                                                          },
                                                                                          child: const Text(
                                                                                            "BACK",
                                                                                            style: TextStyle(fontFamily: appFontFamily, fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.redColor),
                                                                                          ),
                                                                                        ),
                                                                                        ElevatedButton(
                                                                                          onPressed: () {
                                                                                            AppHelper.hideKeyboard(context);
                                                                                            _performancesampleformKey.currentState!.save;

                                                                                            // Validate the form
                                                                                            if (_performancesampleformKey.currentState!.validate()) {
                                                                                              performanceSampleData = [];
                                                                                              for (int i = 0; i < numberOfPerformanceSampleFields; i++) {
                                                                                                performanceSampleData.add({
                                                                                                  "SampleBarcode": performanceBarcodeControllers[i].text,
                                                                                                  "SampleTest": selectedPerformanceTestValues[i],
                                                                                                  "SampleRemarks": performanceRemarksControllers[i].text
                                                                                                });
                                                                                              }

                                                                                              setState(() {
                                                                                                setPage = "result";
                                                                                              });
                                                                                              if (status != 'Pending') {
                                                                                                setState(() {
                                                                                                  sendStatus = 'Inprogress';
                                                                                                });
                                                                                                createData();
                                                                                              }
                                                                                            }
                                                                                            // setState(() {
                                                                                            //   setPage = "result";
                                                                                            // });
                                                                                            // _performancesampleformKey = GlobalKey<FormState>();
                                                                                          },
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            backgroundColor: const Color.fromARGB(255, 134, 8, 4), // Set button color to red
                                                                                          ),
                                                                                          child: const Text(
                                                                                            'Next',
                                                                                            style: TextStyle(
                                                                                              color: Colors.white, // Set text color to white
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : setPage == "result"
                                                                                  ? Stack(
                                                                                      alignment: Alignment.center,
                                                                                      fit: StackFit.expand,
                                                                                      children: [
                                                                                        SingleChildScrollView(
                                                                                            child: Form(
                                                                                          key: _resultFormKey,
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
                                                                                                    Image.asset(
                                                                                                      AppAssets.imgLogo,
                                                                                                      height: 100,
                                                                                                      width: 230,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              const Center(child: Padding(padding: EdgeInsets.only(top: 10), child: Text("Incoming Quality Control Plan", style: TextStyle(fontSize: 27, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700)))),
                                                                                              const Center(child: Text("(Ribbon)", style: TextStyle(fontSize: 20, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
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
                                                                                                    'GSPL/PVR(IQC)/001',
                                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              const SizedBox(
                                                                                                height: 8,
                                                                                              ),
                                                                                              Row(
                                                                                                children: [
                                                                                                  Text(
                                                                                                    'Rev.No. / Rev. Date : ',
                                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    width: 8,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Ver.2.0 / 13-03-2024',
                                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              const SizedBox(
                                                                                                height: 15,
                                                                                              ),
                                                                                              const Center(child: Text("Result", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 6, 2, 240), fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: <Widget>[
                                                                                                  Radio(
                                                                                                    value: "Pass",
                                                                                                    groupValue: result,
                                                                                                    onChanged: (val) {
                                                                                                      if (status != 'Pending') {
                                                                                                        setState(() {
                                                                                                          result = val;
                                                                                                          rejectionReasonController.text = '';
                                                                                                          packagingRejection = false;
                                                                                                          visualRejection = false;
                                                                                                          physicalRejection = false;
                                                                                                          frontbusRejection = false;
                                                                                                          electricalRejection = false;
                                                                                                          performanceRejection = false;
                                                                                                          verificationRejection = false;
                                                                                                        });
                                                                                                      }
                                                                                                    },
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Pass',
                                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    width: 10,
                                                                                                  ),
                                                                                                  Radio(
                                                                                                    value: "Fail",
                                                                                                    groupValue: result,
                                                                                                    onChanged: (val) {
                                                                                                      if (status != 'Pending') {
                                                                                                        setState(() {
                                                                                                          result = val;
                                                                                                        });
                                                                                                      }
                                                                                                    },
                                                                                                  ),
                                                                                                  Text(
                                                                                                    'Fail',
                                                                                                    style: AppStyles.textfieldCaptionTextStyle,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              if (result == "Fail")
                                                                                                const SizedBox(
                                                                                                  height: 10,
                                                                                                ),
                                                                                              if (result == "Fail") const Center(child: Text("Rejection Note", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 238, 5, 5), fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
                                                                                              if (result == "Fail")
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: <Widget>[
                                                                                                    Checkbox(
                                                                                                      value: packagingRejection,
                                                                                                      onChanged: (value) {
                                                                                                        if (status != 'Pending') {
                                                                                                          setState(() {
                                                                                                            packagingRejection = value!;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    Text(
                                                                                                      'Visual',
                                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                                    ),
                                                                                                    Checkbox(
                                                                                                      value: visualRejection,
                                                                                                      onChanged: (value) {
                                                                                                        if (status != 'Pending') {
                                                                                                          setState(() {
                                                                                                            visualRejection = value!;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    Text(
                                                                                                      'Physical',
                                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                                    ),
                                                                                                    Checkbox(
                                                                                                      value: physicalRejection,
                                                                                                      onChanged: (value) {
                                                                                                        if (status != 'Pending') {
                                                                                                          setState(() {
                                                                                                            physicalRejection = value!;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    Text(
                                                                                                      'Verification-1',
                                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              if (result == "Fail")
                                                                                                const SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                              if (result == "Fail")
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: <Widget>[
                                                                                                    Checkbox(
                                                                                                      value: frontbusRejection,
                                                                                                      onChanged: (value) {
                                                                                                        if (status != 'Pending') {
                                                                                                          setState(() {
                                                                                                            frontbusRejection = value!;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    Text(
                                                                                                      'Performance',
                                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                                    ),
                                                                                                    Checkbox(
                                                                                                      value: verificationRejection,
                                                                                                      onChanged: (value) {
                                                                                                        if (status != 'Pending') {
                                                                                                          setState(() {
                                                                                                            verificationRejection = value!;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    Text(
                                                                                                      'Verification-2',
                                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                                    ),
                                                                                                    Checkbox(
                                                                                                      value: electricalRejection,
                                                                                                      onChanged: (value) {
                                                                                                        if (status != 'Pending') {
                                                                                                          setState(() {
                                                                                                            electricalRejection = value!;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    Text(
                                                                                                      'Verification-3',
                                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              if (result == "Fail")
                                                                                                const SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                              if (result == "Fail")
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: <Widget>[
                                                                                                    Checkbox(
                                                                                                      value: performanceRejection,
                                                                                                      onChanged: (value) {
                                                                                                        if (status != 'Pending') {
                                                                                                          setState(() {
                                                                                                            performanceRejection = value!;
                                                                                                          });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                    Text(
                                                                                                      'Verification-4',
                                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              if (result == "Fail")
                                                                                                const SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                              if (result == "Fail")
                                                                                                Text(
                                                                                                  'Rejection Reason',
                                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                                ),
                                                                                              if (result == "Fail")
                                                                                                const SizedBox(
                                                                                                  height: 5,
                                                                                                ),
                                                                                              if (result == "Fail")
                                                                                                TextFormField(
                                                                                                  controller: rejectionReasonController,
                                                                                                  keyboardType: TextInputType.text,
                                                                                                  textInputAction: TextInputAction.next,
                                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(hintText: "Please Enter Rejection Reason", counterText: ''),
                                                                                                  style: AppStyles.textInputTextStyle,
                                                                                                  maxLines: 3,
                                                                                                  readOnly: status == 'Pending' ? true : false,
                                                                                                  validator: (value) {
                                                                                                    if (value!.isEmpty) {
                                                                                                      return "Please Enter Rejection Reason";
                                                                                                    } else {
                                                                                                      return null;
                                                                                                    }
                                                                                                  },
                                                                                                ),
                                                                                              const SizedBox(
                                                                                                height: 15,
                                                                                              ),
                                                                                              Text(
                                                                                                "Upload Invoice Pdf*",
                                                                                                style: AppStyles.textfieldCaptionTextStyle,
                                                                                              ),
                                                                                              const SizedBox(
                                                                                                height: 5,
                                                                                              ),
                                                                                              TextFormField(
                                                                                                controller: invoicePdfController,
                                                                                                keyboardType: TextInputType.text,
                                                                                                textInputAction: TextInputAction.next,
                                                                                                decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                                    hintText: "Please Select Invoice Pdf",
                                                                                                    suffixIcon: IconButton(
                                                                                                      onPressed: () async {
                                                                                                        if (widget.id != null && widget.id != '' && invoicePdfController.text != '') {
                                                                                                          UrlLauncher.launch(invoicePdfController.text);
                                                                                                        } else if (status != 'Pending') {
                                                                                                          _pickInvoicePDF();
                                                                                                        }
                                                                                                      },
                                                                                                      icon: widget.id != null && widget.id != '' && invoicePdfController.text != '' ? const Icon(Icons.download) : const Icon(Icons.open_in_browser),
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
                                                                                                height: 15,
                                                                                              ),
                                                                                              Text(
                                                                                                "Upload Coc Pdf*",
                                                                                                style: AppStyles.textfieldCaptionTextStyle,
                                                                                              ),
                                                                                              const SizedBox(
                                                                                                height: 5,
                                                                                              ),
                                                                                              TextFormField(
                                                                                                controller: cocPdfController,
                                                                                                keyboardType: TextInputType.text,
                                                                                                textInputAction: TextInputAction.next,
                                                                                                decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                                    hintText: "Please Select Coc Pdf",
                                                                                                    suffixIcon: IconButton(
                                                                                                      onPressed: () async {
                                                                                                        if (widget.id != null && widget.id != '' && cocPdfController.text != '') {
                                                                                                          UrlLauncher.launch(cocPdfController.text);
                                                                                                        } else if (status != 'Pending') {
                                                                                                          _pickcocPDF();
                                                                                                        }
                                                                                                      },
                                                                                                      icon: widget.id != null && widget.id != '' && cocPdfController.text != '' ? const Icon(Icons.download) : const Icon(Icons.open_in_browser),
                                                                                                    ),
                                                                                                    counterText: ''),
                                                                                                style: AppStyles.textInputTextStyle,
                                                                                                maxLines: 1,
                                                                                                readOnly: true,
                                                                                                validator: (value) {
                                                                                                  if (value!.isEmpty) {
                                                                                                    return "Please Select Coc Pdf";
                                                                                                  } else {
                                                                                                    return null;
                                                                                                  }
                                                                                                },
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 15,
                                                                                              ),
                                                                                              const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                                                                              _isLoading
                                                                                                  ? const Center(child: CircularProgressIndicator())
                                                                                                  : (widget.id == "" || widget.id == null) || (status == 'Inprogress' && widget.id != null)
                                                                                                      ? AppButton(
                                                                                                          textStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.white, fontSize: 16),
                                                                                                          onTap: () {
                                                                                                            AppHelper.hideKeyboard(context);
                                                                                                            _resultFormKey.currentState!.save;
                                                                                                            if (_resultFormKey.currentState!.validate()) {
                                                                                                              if (status != 'Pending') {
                                                                                                                setState(() {
                                                                                                                  sendStatus = 'Pending';
                                                                                                                });
                                                                                                                createData();
                                                                                                              }
                                                                                                            }
                                                                                                          },
                                                                                                          label: "Save",
                                                                                                          organization: '',
                                                                                                        )
                                                                                                      : Container(),
                                                                                              if (widget.id != "" && widget.id != null && status == 'Pending')
                                                                                                Container(
                                                                                                  color: Color.fromARGB(255, 191, 226, 187), // Change the background color to your desired color
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                                    children: [
                                                                                                      Divider(),
                                                                                                      const Center(child: Text("Approve/Reject Block", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 217, 3, 245), fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
                                                                                                      Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: <Widget>[
                                                                                                          Radio(
                                                                                                            value: "Approved",
                                                                                                            groupValue: approvalStatus,
                                                                                                            onChanged: (val) {
                                                                                                              setState(() {
                                                                                                                approvalStatus = val;
                                                                                                                rejectionReasonStatusController.text = '';
                                                                                                              });
                                                                                                            },
                                                                                                          ),
                                                                                                          Text(
                                                                                                            'Approved',
                                                                                                            style: AppStyles.textfieldCaptionTextStyle,
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            width: 10,
                                                                                                          ),
                                                                                                          Radio(
                                                                                                            value: "Rejected",
                                                                                                            groupValue: approvalStatus,
                                                                                                            onChanged: (val) {
                                                                                                              setState(() {
                                                                                                                approvalStatus = val;
                                                                                                              });
                                                                                                            },
                                                                                                          ),
                                                                                                          Text(
                                                                                                            'Rejected',
                                                                                                            style: AppStyles.textfieldCaptionTextStyle,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      const SizedBox(
                                                                                                        height: 15,
                                                                                                      ),
                                                                                                      if (approvalStatus == "Approved")
                                                                                                        AppButton(
                                                                                                          textStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.white, fontSize: 16),
                                                                                                          onTap: () {
                                                                                                            AppHelper.hideKeyboard(context);
                                                                                                            _resultFormKey.currentState!.save;
                                                                                                            if (_resultFormKey.currentState!.validate()) {
                                                                                                              setApprovalStatus();
                                                                                                            }
                                                                                                          },
                                                                                                          label: "Approved",
                                                                                                          organization: '',
                                                                                                        ),
                                                                                                      if (approvalStatus == "Rejected")
                                                                                                        TextFormField(
                                                                                                          controller: rejectionReasonStatusController,
                                                                                                          keyboardType: TextInputType.text,
                                                                                                          textInputAction: TextInputAction.next,
                                                                                                          decoration: AppStyles.textFieldInputDecoration.copyWith(hintText: "Please Enter Rejection Reason", counterText: ''),
                                                                                                          style: AppStyles.textInputTextStyle,
                                                                                                          maxLines: 3,
                                                                                                          validator: (value) {
                                                                                                            if (value!.isEmpty) {
                                                                                                              return "Please Enter Rejection Reason";
                                                                                                            } else {
                                                                                                              return null;
                                                                                                            }
                                                                                                          },
                                                                                                        ),
                                                                                                      SizedBox(
                                                                                                        height: 15,
                                                                                                      ),
                                                                                                      if (approvalStatus == "Rejected")
                                                                                                        AppButton(
                                                                                                          textStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.white, fontSize: 16),
                                                                                                          onTap: () {
                                                                                                            AppHelper.hideKeyboard(context);
                                                                                                            _resultFormKey.currentState!.save;
                                                                                                            if (_resultFormKey.currentState!.validate()) {
                                                                                                              setApprovalStatus();
                                                                                                            }
                                                                                                          },
                                                                                                          label: "Rejected",
                                                                                                          organization: '',
                                                                                                        ),
                                                                                                      const SizedBox(
                                                                                                        height: 10,
                                                                                                      ),
                                                                                                      Divider(),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              Center(
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                  child: InkWell(
                                                                                                    onTap: () {
                                                                                                      setState(() {
                                                                                                        _isLoading = false;
                                                                                                        setPage = "checkperformance";
                                                                                                      });
                                                                                                      // Navigator.of(context).pushReplacement(
                                                                                                      //     MaterialPageRoute(
                                                                                                      //         builder: (BuildContext context) =>
                                                                                                      //             LoginPage(
                                                                                                      //                 appName: widget.appName)));
                                                                                                    },
                                                                                                    child: const Text(
                                                                                                      "BACK",
                                                                                                      style: TextStyle(fontFamily: appFontFamily, fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.redColor),
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
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Text("Powered By Gautam Solar Pvt. Ltd.", style: TextStyle(fontSize: 14, fontFamily: appFontFamily, color: AppColors.greyColor, fontWeight: FontWeight.w400)),
                                                                                                    SizedBox(
                                                                                                      height: 10,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        )),
                                                                                      ],
                                                                                    )
                                                                                  : Container(),
                ),
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
          //                     department == 'IQCP' &&
          //                             designation != 'Super Admin'
          //                         ? IqcpPage()
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
    // return
    // }
  }
}
