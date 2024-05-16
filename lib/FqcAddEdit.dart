import 'dart:convert';
import 'dart:io';
import 'package:QCM/CommonDrawer.dart';
import 'package:QCM/Fqc.dart';
import 'package:QCM/FqcTestList.dart';
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

class FqcAddEdit extends StatefulWidget {
  final String? id;
  FqcAddEdit({this.id});
  _FqcAddEditState createState() => _FqcAddEditState();
}

class _FqcAddEditState extends State<FqcAddEdit> {
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
  // FQC...............................................................................................
  bool visualParameterS1TestValue930 = false,
      visualParameterS2TestValue930 = false,
      visualParameterS3TestValue930 = false,
      visualParameterS4TestValue930 = false,
      moduleRatingParameterS1TestValue930 = false,
      moduleRatingParameterS2TestValue930 = false,
      otherParameterS1TestValue930 = false,
      otherParameterS2TestValue930 = false,
      otherParameterS3TestValue930 = false,
      otherParameterS4TestValue930 = false,
      otherParameterS5TestValue930 = false,
      otherParameterS6TestValue930 = false,
      otherParameterS7TestValue930 = false,
      otherParameterS8TestValue930 = false,
      otherParameterS9TestValue930 = false,
      visualParameterS1TestValue230 = false,
      visualParameterS2TestValue230 = false,
      visualParameterS3TestValue230 = false,
      visualParameterS4TestValue230 = false,
      moduleRatingParameterS1TestValue230 = false,
      moduleRatingParameterS2TestValue230 = false,
      otherParameterS1TestValue230 = false,
      otherParameterS2TestValue230 = false,
      otherParameterS3TestValue230 = false,
      otherParameterS4TestValue230 = false,
      otherParameterS5TestValue230 = false,
      otherParameterS6TestValue230 = false,
      otherParameterS7TestValue230 = false,
      otherParameterS8TestValue230 = false,
      otherParameterS9TestValue230 = false,
      visualParameterS1TestValue645 = false,
      visualParameterS2TestValue645 = false,
      visualParameterS3TestValue645 = false,
      visualParameterS4TestValue645 = false,
      moduleRatingParameterS1TestValue645 = false,
      moduleRatingParameterS2TestValue645 = false,
      otherParameterS1TestValue645 = false,
      otherParameterS2TestValue645 = false,
      otherParameterS3TestValue645 = false,
      otherParameterS4TestValue645 = false,
      otherParameterS5TestValue645 = false,
      otherParameterS6TestValue645 = false,
      otherParameterS7TestValue645 = false,
      otherParameterS8TestValue645 = false,
      otherParameterS9TestValue645 = false;

  // FQC End.......................................................................................
  List<int>? invoicePdfFileBytes, cocPdfFileBytes;

  final _dio = Dio();

  Response.Response? _response;
  String? packingDate,
      result = "Fail",
      sendStatus,
      status,
      FqcId,
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

  TextEditingController productBatchNoController = new TextEditingController();
  TextEditingController packingDateController = new TextEditingController();
  TextEditingController receiptDateController = new TextEditingController();
  TextEditingController reportNumberController = new TextEditingController();
  TextEditingController dateOfQualityCheckController =
      new TextEditingController();
  TextEditingController rMBatchNoController = new TextEditingController();
  TextEditingController partyNameController = new TextEditingController();
  TextEditingController productSpecsController = new TextEditingController();
// Packaging
  TextEditingController cocPdfController = new TextEditingController();
  TextEditingController invoicePdfController = new TextEditingController();

  TextEditingController rejectionReasonController = new TextEditingController();
  TextEditingController rejectionReasonStatusController =
      new TextEditingController();

// FQC....................................................................................................
// Visual Check 9:30
  TextEditingController visualParametersController930 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion1Controller930 =
      new TextEditingController();
  TextEditingController visualParameterS1Controller930 =
      new TextEditingController();
  TextEditingController visualParameterS1RemarksControllers930 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion2Controller930 =
      new TextEditingController();
  TextEditingController visualParameterS2Controller930 =
      new TextEditingController();
  TextEditingController visualParameterS2RemarksControllers930 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion3Controller930 =
      new TextEditingController();
  TextEditingController visualParameterS3Controller930 =
      new TextEditingController();
  TextEditingController visualParameterS3RemarksControllers930 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion4Controller930 =
      new TextEditingController();
  TextEditingController visualParameterS4Controller930 =
      new TextEditingController();
  TextEditingController visualParameterS4RemarksControllers930 =
      new TextEditingController();

// Module Rating

  TextEditingController moduleRatingParameters1Controller930 =
      new TextEditingController();
  TextEditingController moduleRatingParameterCrietrion1Controller930 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS1Controller930 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS1RemarksControllers930 =
      new TextEditingController();

  TextEditingController moduleRatingParameters2Controller930 =
      new TextEditingController();
  TextEditingController moduleRatingParameterCrietrion2Controller930 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS2Controller930 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS2RemarksControllers930 =
      new TextEditingController();

  // Other Check Points

  TextEditingController otherParameters1Controller930 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion1Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS1Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS1RemarksControllers930 =
      new TextEditingController();

  TextEditingController otherParameters2Controller930 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion2Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS2Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS2RemarksControllers930 =
      new TextEditingController();

  TextEditingController otherParameters3Controller930 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion3Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS3Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS3RemarksControllers930 =
      new TextEditingController();

  TextEditingController otherParameters4Controller930 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion4Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS4Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS4RemarksControllers930 =
      new TextEditingController();

  TextEditingController otherParameters5Controller930 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion5Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS5Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS5RemarksControllers930 =
      new TextEditingController();

  TextEditingController otherParameters6Controller930 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion6Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS6Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS6RemarksControllers930 =
      new TextEditingController();

  TextEditingController otherParameters7Controller930 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion7Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS7Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS7RemarksControllers930 =
      new TextEditingController();

  TextEditingController otherParameters8Controller930 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion8Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS8Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS8RemarksControllers930 =
      new TextEditingController();

  TextEditingController otherParameters9Controller930 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion9Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS9Controller930 =
      new TextEditingController();
  TextEditingController otherParameterS9RemarksControllers930 =
      new TextEditingController();

// Visual Check 2:30
  TextEditingController visualParametersController230 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion1Controller230 =
      new TextEditingController();
  TextEditingController visualParameterS1Controller230 =
      new TextEditingController();
  TextEditingController visualParameterS1RemarksControllers230 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion2Controller230 =
      new TextEditingController();
  TextEditingController visualParameterS2Controller230 =
      new TextEditingController();
  TextEditingController visualParameterS2RemarksControllers230 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion3Controller230 =
      new TextEditingController();
  TextEditingController visualParameterS3Controller230 =
      new TextEditingController();
  TextEditingController visualParameterS3RemarksControllers230 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion4Controller230 =
      new TextEditingController();
  TextEditingController visualParameterS4Controller230 =
      new TextEditingController();
  TextEditingController visualParameterS4RemarksControllers230 =
      new TextEditingController();

// Module Rating

  TextEditingController moduleRatingParameters1Controller230 =
      new TextEditingController();
  TextEditingController moduleRatingParameterCrietrion1Controller230 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS1Controller230 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS1RemarksControllers230 =
      new TextEditingController();

  TextEditingController moduleRatingParameters2Controller230 =
      new TextEditingController();
  TextEditingController moduleRatingParameterCrietrion2Controller230 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS2Controller230 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS2RemarksControllers230 =
      new TextEditingController();

  // Other Check Points

  TextEditingController otherParameters1Controller230 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion1Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS1Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS1RemarksControllers230 =
      new TextEditingController();

  TextEditingController otherParameters2Controller230 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion2Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS2Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS2RemarksControllers230 =
      new TextEditingController();

  TextEditingController otherParameters3Controller230 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion3Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS3Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS3RemarksControllers230 =
      new TextEditingController();

  TextEditingController otherParameters4Controller230 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion4Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS4Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS4RemarksControllers230 =
      new TextEditingController();

  TextEditingController otherParameters5Controller230 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion5Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS5Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS5RemarksControllers230 =
      new TextEditingController();

  TextEditingController otherParameters6Controller230 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion6Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS6Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS6RemarksControllers230 =
      new TextEditingController();

  TextEditingController otherParameters7Controller230 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion7Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS7Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS7RemarksControllers230 =
      new TextEditingController();

  TextEditingController otherParameters8Controller230 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion8Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS8Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS8RemarksControllers230 =
      new TextEditingController();

  TextEditingController otherParameters9Controller230 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion9Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS9Controller230 =
      new TextEditingController();
  TextEditingController otherParameterS9RemarksControllers230 =
      new TextEditingController();

  // Visual Check 6:45
  TextEditingController visualParametersController645 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion1Controller645 =
      new TextEditingController();
  TextEditingController visualParameterS1Controller645 =
      new TextEditingController();
  TextEditingController visualParameterS1RemarksControllers645 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion2Controller645 =
      new TextEditingController();
  TextEditingController visualParameterS2Controller645 =
      new TextEditingController();
  TextEditingController visualParameterS2RemarksControllers645 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion3Controller645 =
      new TextEditingController();
  TextEditingController visualParameterS3Controller645 =
      new TextEditingController();
  TextEditingController visualParameterS3RemarksControllers645 =
      new TextEditingController();

  TextEditingController visualParameterCrietrion4Controller645 =
      new TextEditingController();
  TextEditingController visualParameterS4Controller645 =
      new TextEditingController();
  TextEditingController visualParameterS4RemarksControllers645 =
      new TextEditingController();

// Module Rating

  TextEditingController moduleRatingParameters1Controller645 =
      new TextEditingController();
  TextEditingController moduleRatingParameterCrietrion1Controller645 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS1Controller645 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS1RemarksControllers645 =
      new TextEditingController();

  TextEditingController moduleRatingParameters2Controller645 =
      new TextEditingController();
  TextEditingController moduleRatingParameterCrietrion2Controller645 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS2Controller645 =
      new TextEditingController();
  TextEditingController moduleRatingParameterS2RemarksControllers645 =
      new TextEditingController();

  // Other Check Points

  TextEditingController otherParameters1Controller645 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion1Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS1Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS1RemarksControllers645 =
      new TextEditingController();

  TextEditingController otherParameters2Controller645 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion2Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS2Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS2RemarksControllers645 =
      new TextEditingController();

  TextEditingController otherParameters3Controller645 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion3Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS3Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS3RemarksControllers645 =
      new TextEditingController();

  TextEditingController otherParameters4Controller645 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion4Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS4Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS4RemarksControllers645 =
      new TextEditingController();

  TextEditingController otherParameters5Controller645 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion5Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS5Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS5RemarksControllers645 =
      new TextEditingController();

  TextEditingController otherParameters6Controller645 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion6Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS6Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS6RemarksControllers645 =
      new TextEditingController();

  TextEditingController otherParameters7Controller645 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion7Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS7Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS7RemarksControllers645 =
      new TextEditingController();

  TextEditingController otherParameters8Controller645 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion8Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS8Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS8RemarksControllers645 =
      new TextEditingController();

  TextEditingController otherParameters9Controller645 =
      new TextEditingController();
  TextEditingController otherParameterCrietrion9Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS9Controller645 =
      new TextEditingController();
  TextEditingController otherParameterS9RemarksControllers645 =
      new TextEditingController();

// FQC End..............................................................................................
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
      // S1
      // Visual Checks
      visualParametersController930.text = "Visual Parameters";
      visualParameterCrietrion1Controller930.text = "Should be neat and clean";
      visualParameterCrietrion2Controller930.text = "No breakage allowed";
      visualParameterCrietrion3Controller930.text = "Packing Condition";
      visualParameterCrietrion4Controller930.text = "Framing Condition";

      // Module Rating
      moduleRatingParameters1Controller930.text = "Module Wattage";
      moduleRatingParameterCrietrion1Controller930.text =
          "Should be as per job no / Client";

      moduleRatingParameters2Controller930.text = "Rated Voltage";
      moduleRatingParameterCrietrion2Controller930.text =
          "Should be as per job no / Client";

      //  Other Check Points

      otherParameters1Controller930.text = "QC Sticker";
      otherParameterCrietrion1Controller930.text = "Should be oasted";

      otherParameters2Controller930.text = "Module info Label";
      otherParameterCrietrion2Controller930.text =
          "Should be as per job no / Test Result";

      otherParameters3Controller930.text = "RFID";
      otherParameterCrietrion3Controller930.text = "Should be oasted";

      otherParameters4Controller930.text = "Company Logo";
      otherParameterCrietrion4Controller930.text = "Should be Pasted";

      otherParameters5Controller930.text = "Junction Box";
      otherParameterCrietrion5Controller930.text = "Should be Pasted";

      otherParameters6Controller930.text = "Cable and MC4 Connector";
      otherParameterCrietrion6Controller930.text = "Should be provided with JB";

      otherParameters7Controller930.text = "Module Serial Number";
      otherParameterCrietrion7Controller930.text =
          "Serial no should be provided";

      otherParameters8Controller930.text = "Framing Condition";
      otherParameterCrietrion8Controller930.text = "N/A";

      otherParameters9Controller930.text = "HIPOT";
      otherParameterCrietrion9Controller930.text = "N/A";

      // S2
      // Visual Checks
      visualParametersController230.text = "Visual Parameters";
      visualParameterCrietrion1Controller230.text = "Should be neat and clean";
      visualParameterCrietrion2Controller230.text = "No breakage allowed";
      visualParameterCrietrion3Controller230.text = "Packing Condition";
      visualParameterCrietrion4Controller230.text = "Framing Condition";

      // Module Rating
      moduleRatingParameters1Controller230.text = "Module Wattage";
      moduleRatingParameterCrietrion1Controller230.text =
          "Should be as per job no / Client";

      moduleRatingParameters2Controller230.text = "Rated Voltage";
      moduleRatingParameterCrietrion2Controller230.text =
          "Should be as per job no / Client";

      //  Other Check Points

      otherParameters1Controller230.text = "QC Sticker";
      otherParameterCrietrion1Controller230.text = "Should be oasted";

      otherParameters2Controller230.text = "Module info Label";
      otherParameterCrietrion2Controller230.text =
          "Should be as per job no / Test Result";

      otherParameters3Controller230.text = "RFID";
      otherParameterCrietrion3Controller230.text = "Should be oasted";

      otherParameters4Controller230.text = "Company Logo";
      otherParameterCrietrion4Controller230.text = "Should be Pasted";

      otherParameters5Controller230.text = "Junction Box";
      otherParameterCrietrion5Controller230.text = "Should be Pasted";

      otherParameters6Controller230.text = "Cable and MC4 Connector";
      otherParameterCrietrion6Controller230.text = "Should be provided with JB";

      otherParameters7Controller230.text = "Module Serial Number";
      otherParameterCrietrion7Controller230.text =
          "Serial no should be provided";

      otherParameters8Controller230.text = "Framing Condition";
      otherParameterCrietrion8Controller230.text = "N/A";

      otherParameters9Controller230.text = "HIPOT";
      otherParameterCrietrion9Controller230.text = "N/A";

      // S3
      // Visual Checks
      visualParametersController645.text = "Visual Parameters";
      visualParameterCrietrion1Controller645.text = "Should be neat and clean";
      visualParameterCrietrion2Controller645.text = "No breakage allowed";
      visualParameterCrietrion3Controller645.text = "Packing Condition";
      visualParameterCrietrion4Controller645.text = "Framing Condition";

      // Module Rating
      moduleRatingParameters1Controller645.text = "Module Wattage";
      moduleRatingParameterCrietrion1Controller645.text =
          "Should be as per job no / Client";

      moduleRatingParameters2Controller645.text = "Rated Voltage";
      moduleRatingParameterCrietrion2Controller645.text =
          "Should be as per job no / Client";

      //  Other Check Points

      otherParameters1Controller645.text = "QC Sticker";
      otherParameterCrietrion1Controller645.text = "Should be oasted";

      otherParameters2Controller645.text = "Module info Label";
      otherParameterCrietrion2Controller645.text =
          "Should be as per job no / Test Result";

      otherParameters3Controller645.text = "RFID";
      otherParameterCrietrion3Controller645.text = "Should be oasted";

      otherParameters4Controller645.text = "Company Logo";
      otherParameterCrietrion4Controller645.text = "Should be Pasted";

      otherParameters5Controller645.text = "Junction Box";
      otherParameterCrietrion5Controller645.text = "Should be Pasted";

      otherParameters6Controller645.text = "Cable and MC4 Connector";
      otherParameterCrietrion6Controller645.text = "Should be provided with JB";

      otherParameters7Controller645.text = "Module Serial Number";
      otherParameterCrietrion7Controller645.text =
          "Serial no should be provided";

      otherParameters8Controller645.text = "Framing Condition";
      otherParameterCrietrion8Controller645.text = "N/A";

      otherParameters9Controller645.text = "HIPOT";
      otherParameterCrietrion9Controller645.text = "N/A";
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
    final AllSolarData = ((site!) + 'IQCSolarCell/GetSpecificFQC');
    final allSolarData = await http.post(
      Uri.parse(AllSolarData),
      body: jsonEncode(
          <String, String>{"FQCDetailId": widget.id ?? '', "token": token!}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var resBody = json.decode(allSolarData.body);

    if (mounted) {
      setState(() {
        _isLoading = false;
        data = resBody['data'];
        if (data != null && data.length > 0) {
          final dataMap = data.asMap();

          productSpecsController.text = dataMap[0]['ProductSpecs'] ?? '';
          productBatchNoController.text = dataMap[0]['ProductBatchNo'] ?? '';
          partyNameController.text = dataMap[0]['PartyName'] ?? '';
          packingDateController.text = DateFormat("EEE MMM dd, yyyy").format(
                  DateTime.parse(dataMap[0]['PackingDate'].toString())) ??
              '';
          packingDate = dataMap[0]['PackingDate'] ?? '';
          reportNumberController.text = dataMap[0]['ReportNumber'] ?? '';
          dateOfQualityCheckController.text = DateFormat("EEE MMM dd, yyyy")
                  .format(DateTime.parse(
                      dataMap[0]['DateOfQualityCheck'].toString())) ??
              '';

          dateOfQualityCheck = dataMap[0]['DateOfQualityCheck'] ?? '';
          status = dataMap[0]['Status'] ?? '';
          // S1
          visualParameterS1Controller930.text =
              dataMap[0]['Sample1']['visualParameterS1Controller930'] ?? '';
          visualParameterS1TestValue930 =
              dataMap[0]['Sample1']['visualParameterS1TestValue930'] ?? false;

          visualParameterS1RemarksControllers930.text = dataMap[0]['Sample1']
                  ['visualParameterS1RemarksControllers930'] ??
              '';

          visualParameterS2Controller930.text =
              dataMap[0]['Sample1']['visualParameterS2Controller930'] ?? '';
          visualParameterS2TestValue930 =
              dataMap[0]['Sample1']['visualParameterS2TestValue930'] ?? false;
          visualParameterS2RemarksControllers930.text = dataMap[0]['Sample1']
                  ['visualParameterS2RemarksControllers930'] ??
              '';

          visualParameterS3Controller930.text =
              dataMap[0]['Sample1']['visualParameterS3Controller930'] ?? '';
          visualParameterS3TestValue930 =
              dataMap[0]['Sample1']['visualParameterS3TestValue930'] ?? false;
          visualParameterS3RemarksControllers930.text = dataMap[0]['Sample1']
                  ['visualParameterS3RemarksControllers930'] ??
              '';

          visualParameterS4Controller930.text =
              dataMap[0]['Sample1']['visualParameterS4Controller930'] ?? '';
          visualParameterS4TestValue930 =
              dataMap[0]['Sample1']['visualParameterS4TestValue930'] ?? false;
          visualParameterS4RemarksControllers930.text = dataMap[0]['Sample1']
                  ['visualParameterS4RemarksControllers930'] ??
              '';

          // Module Rating

          moduleRatingParameterS1Controller930.text = dataMap[0]['Sample1']
                  ['moduleRatingParameterS1Controller930'] ??
              '';
          moduleRatingParameterS1TestValue930 = dataMap[0]['Sample1']
                  ['moduleRatingParameterS1TestValue930'] ??
              false;
          moduleRatingParameterS1RemarksControllers930.text = dataMap[0]
                  ['Sample1']['moduleRatingParameterS1RemarksControllers930'] ??
              '';

          moduleRatingParameterS2Controller930.text = dataMap[0]['Sample1']
                  ['moduleRatingParameterS2Controller930'] ??
              '';
          moduleRatingParameterS2TestValue930 = dataMap[0]['Sample1']
                  ['moduleRatingParameterS2TestValue930'] ??
              false;
          moduleRatingParameterS2RemarksControllers930.text = dataMap[0]
                  ['Sample1']['moduleRatingParameterS2RemarksControllers930'] ??
              '';
          // Others

          otherParameterS1Controller930.text =
              dataMap[0]['Sample1']['otherParameterS1Controller930'] ?? '';
          otherParameterS1TestValue930 =
              dataMap[0]['Sample1']['otherParameterS1TestValue930'] ?? false;
          otherParameterS1RemarksControllers930.text = dataMap[0]['Sample1']
                  ['otherParameterS1RemarksControllers930'] ??
              '';

          otherParameterS2Controller930.text =
              dataMap[0]['Sample1']['otherParameterS2Controller930'] ?? '';
          otherParameterS2TestValue930 =
              dataMap[0]['Sample1']['otherParameterS2TestValue930'] ?? false;
          otherParameterS2RemarksControllers930.text = dataMap[0]['Sample1']
                  ['otherParameterS2RemarksControllers930'] ??
              '';

          otherParameterS3Controller930.text =
              dataMap[0]['Sample1']['otherParameterS3Controller930'] ?? '';
          otherParameterS3TestValue930 =
              dataMap[0]['Sample1']['otherParameterS3TestValue930'] ?? false;
          otherParameterS3RemarksControllers930.text = dataMap[0]['Sample1']
                  ['otherParameterS3RemarksControllers930'] ??
              '';

          otherParameterS4Controller930.text =
              dataMap[0]['Sample1']['otherParameterS4Controller930'] ?? '';
          otherParameterS4TestValue930 =
              dataMap[0]['Sample1']['otherParameterS4TestValue930'] ?? false;
          otherParameterS4RemarksControllers930.text = dataMap[0]['Sample1']
                  ['otherParameterS4RemarksControllers930'] ??
              '';

          otherParameterS5Controller930.text =
              dataMap[0]['Sample1']['otherParameterS5Controller930'] ?? '';
          otherParameterS5TestValue930 =
              dataMap[0]['Sample1']['otherParameterS5TestValue930'] ?? false;
          otherParameterS5RemarksControllers930.text = dataMap[0]['Sample1']
                  ['otherParameterS5RemarksControllers930'] ??
              '';

          otherParameterS6Controller930.text =
              dataMap[0]['Sample1']['otherParameterS6Controller930'] ?? '';
          otherParameterS6TestValue930 =
              dataMap[0]['Sample1']['otherParameterS6TestValue930'] ?? false;
          otherParameterS6RemarksControllers930.text = dataMap[0]['Sample1']
                  ['otherParameterS6RemarksControllers930'] ??
              '';

          otherParameterS7Controller930.text =
              dataMap[0]['Sample1']['otherParameterS7Controller930'] ?? '';
          otherParameterS7TestValue930 =
              dataMap[0]['Sample1']['otherParameterS7TestValue930'] ?? false;
          otherParameterS7RemarksControllers930.text = dataMap[0]['Sample1']
                  ['otherParameterS7RemarksControllers930'] ??
              '';

          otherParameterS8Controller930.text =
              dataMap[0]['Sample1']['otherParameterS8Controller930'] ?? '';
          otherParameterS8TestValue930 =
              dataMap[0]['Sample1']['otherParameterS8TestValue930'] ?? false;
          otherParameterS8RemarksControllers930.text = dataMap[0]['Sample1']
                  ['otherParameterS8RemarksControllers930'] ??
              '';

          otherParameterS9Controller930.text =
              dataMap[0]['Sample1']['otherParameterS9Controller930'] ?? '';
          otherParameterS9TestValue930 =
              dataMap[0]['Sample1']['otherParameterS9TestValue930'] ?? false;
          otherParameterS9RemarksControllers930.text = dataMap[0]['Sample1']
                  ['otherParameterS9RemarksControllers930'] ??
              '';

          // S2

          visualParameterS1Controller230.text =
              dataMap[0]['Sample2']['visualParameterS1Controller230'] ?? '';
          visualParameterS1TestValue230 =
              dataMap[0]['Sample2']['visualParameterS1TestValue230'] ?? false;

          visualParameterS1RemarksControllers230.text = dataMap[0]['Sample2']
                  ['visualParameterS1RemarksControllers230'] ??
              '';

          visualParameterS2Controller230.text =
              dataMap[0]['Sample2']['visualParameterS2Controller230'] ?? '';
          visualParameterS2TestValue230 =
              dataMap[0]['Sample2']['visualParameterS2TestValue230'] ?? false;
          visualParameterS2RemarksControllers230.text = dataMap[0]['Sample2']
                  ['visualParameterS2RemarksControllers230'] ??
              '';

          visualParameterS3Controller230.text =
              dataMap[0]['Sample2']['visualParameterS3Controller230'] ?? '';
          visualParameterS3TestValue230 =
              dataMap[0]['Sample2']['visualParameterS3TestValue230'] ?? false;
          visualParameterS3RemarksControllers230.text = dataMap[0]['Sample2']
                  ['visualParameterS3RemarksControllers230'] ??
              '';

          visualParameterS4Controller230.text =
              dataMap[0]['Sample2']['visualParameterS4Controller230'] ?? '';
          visualParameterS4TestValue230 =
              dataMap[0]['Sample2']['visualParameterS4TestValue230'] ?? false;
          visualParameterS4RemarksControllers230.text = dataMap[0]['Sample2']
                  ['visualParameterS4RemarksControllers230'] ??
              '';

          // Module Rating

          moduleRatingParameterS1Controller230.text = dataMap[0]['Sample2']
                  ['moduleRatingParameterS1Controller230'] ??
              '';
          moduleRatingParameterS1TestValue230 = dataMap[0]['Sample2']
                  ['moduleRatingParameterS1TestValue230'] ??
              false;
          moduleRatingParameterS1RemarksControllers230.text = dataMap[0]
                  ['Sample2']['moduleRatingParameterS1RemarksControllers230'] ??
              '';

          moduleRatingParameterS2Controller230.text = dataMap[0]['Sample2']
                  ['moduleRatingParameterS2Controller230'] ??
              '';
          moduleRatingParameterS2TestValue230 = dataMap[0]['Sample2']
                  ['moduleRatingParameterS2TestValue230'] ??
              false;
          moduleRatingParameterS2RemarksControllers230.text = dataMap[0]
                  ['Sample2']['moduleRatingParameterS2RemarksControllers230'] ??
              '';
          // Others

          otherParameterS1Controller230.text =
              dataMap[0]['Sample2']['otherParameterS1Controller230'] ?? '';
          otherParameterS1TestValue230 =
              dataMap[0]['Sample2']['otherParameterS1TestValue230'] ?? false;
          otherParameterS1RemarksControllers230.text = dataMap[0]['Sample2']
                  ['otherParameterS1RemarksControllers230'] ??
              '';

          otherParameterS2Controller230.text =
              dataMap[0]['Sample2']['otherParameterS2Controller230'] ?? '';
          otherParameterS2TestValue230 =
              dataMap[0]['Sample2']['otherParameterS2TestValue230'] ?? false;
          otherParameterS2RemarksControllers230.text = dataMap[0]['Sample2']
                  ['otherParameterS2RemarksControllers230'] ??
              '';

          otherParameterS3Controller230.text =
              dataMap[0]['Sample2']['otherParameterS3Controller230'] ?? '';
          otherParameterS3TestValue230 =
              dataMap[0]['Sample2']['otherParameterS3TestValue230'] ?? false;
          otherParameterS3RemarksControllers230.text = dataMap[0]['Sample2']
                  ['otherParameterS3RemarksControllers230'] ??
              '';

          otherParameterS4Controller230.text =
              dataMap[0]['Sample2']['otherParameterS4Controller230'] ?? '';
          otherParameterS4TestValue230 =
              dataMap[0]['Sample2']['otherParameterS4TestValue230'] ?? false;
          otherParameterS4RemarksControllers230.text = dataMap[0]['Sample2']
                  ['otherParameterS4RemarksControllers230'] ??
              '';

          otherParameterS5Controller230.text =
              dataMap[0]['Sample2']['otherParameterS5Controller230'] ?? '';
          otherParameterS5TestValue230 =
              dataMap[0]['Sample2']['otherParameterS5TestValue230'] ?? false;
          otherParameterS5RemarksControllers230.text = dataMap[0]['Sample2']
                  ['otherParameterS5RemarksControllers230'] ??
              '';

          otherParameterS6Controller230.text =
              dataMap[0]['Sample2']['otherParameterS6Controller230'] ?? '';
          otherParameterS6TestValue230 =
              dataMap[0]['Sample2']['otherParameterS6TestValue230'] ?? false;
          otherParameterS6RemarksControllers230.text = dataMap[0]['Sample2']
                  ['otherParameterS6RemarksControllers230'] ??
              '';

          otherParameterS7Controller230.text =
              dataMap[0]['Sample2']['otherParameterS7Controller230'] ?? '';
          otherParameterS7TestValue230 =
              dataMap[0]['Sample2']['otherParameterS7TestValue230'] ?? false;
          otherParameterS7RemarksControllers230.text = dataMap[0]['Sample2']
                  ['otherParameterS7RemarksControllers230'] ??
              '';

          otherParameterS8Controller230.text =
              dataMap[0]['Sample2']['otherParameterS8Controller230'] ?? '';
          otherParameterS8TestValue230 =
              dataMap[0]['Sample2']['otherParameterS8TestValue230'] ?? false;
          otherParameterS8RemarksControllers230.text = dataMap[0]['Sample2']
                  ['otherParameterS8RemarksControllers230'] ??
              '';

          otherParameterS9Controller230.text =
              dataMap[0]['Sample2']['otherParameterS9Controller230'] ?? '';
          otherParameterS9TestValue230 =
              dataMap[0]['Sample2']['otherParameterS9TestValue230'] ?? false;
          otherParameterS9RemarksControllers230.text = dataMap[0]['Sample2']
                  ['otherParameterS9RemarksControllers230'] ??
              '';

          // S3

          visualParameterS1Controller645.text =
              dataMap[0]['Sample3']['visualParameterS1Controller645'] ?? '';
          visualParameterS1TestValue645 =
              dataMap[0]['Sample3']['visualParameterS1TestValue645'] ?? false;

          visualParameterS1RemarksControllers645.text = dataMap[0]['Sample3']
                  ['visualParameterS1RemarksControllers645'] ??
              '';

          visualParameterS2Controller645.text =
              dataMap[0]['Sample3']['visualParameterS2Controller645'] ?? '';
          visualParameterS2TestValue645 =
              dataMap[0]['Sample3']['visualParameterS2TestValue645'] ?? false;
          visualParameterS2RemarksControllers645.text = dataMap[0]['Sample3']
                  ['visualParameterS2RemarksControllers645'] ??
              '';

          visualParameterS3Controller645.text =
              dataMap[0]['Sample3']['visualParameterS3Controller645'] ?? '';
          visualParameterS3TestValue645 =
              dataMap[0]['Sample3']['visualParameterS3TestValue645'] ?? false;
          visualParameterS3RemarksControllers645.text = dataMap[0]['Sample3']
                  ['visualParameterS3RemarksControllers645'] ??
              '';

          visualParameterS4Controller645.text =
              dataMap[0]['Sample3']['visualParameterS4Controller645'] ?? '';
          visualParameterS4TestValue645 =
              dataMap[0]['Sample3']['visualParameterS4TestValue645'] ?? false;
          visualParameterS4RemarksControllers645.text = dataMap[0]['Sample3']
                  ['visualParameterS4RemarksControllers645'] ??
              '';

          // Module Rating

          moduleRatingParameterS1Controller645.text = dataMap[0]['Sample3']
                  ['moduleRatingParameterS1Controller645'] ??
              '';
          moduleRatingParameterS1TestValue645 = dataMap[0]['Sample3']
                  ['moduleRatingParameterS1TestValue645'] ??
              false;
          moduleRatingParameterS1RemarksControllers645.text = dataMap[0]
                  ['Sample3']['moduleRatingParameterS1RemarksControllers645'] ??
              '';

          moduleRatingParameterS2Controller645.text = dataMap[0]['Sample3']
                  ['moduleRatingParameterS2Controller645'] ??
              '';
          moduleRatingParameterS2TestValue645 = dataMap[0]['Sample3']
                  ['moduleRatingParameterS2TestValue645'] ??
              false;
          moduleRatingParameterS2RemarksControllers645.text = dataMap[0]
                  ['Sample3']['moduleRatingParameterS2RemarksControllers645'] ??
              '';
          // Others

          otherParameterS1Controller645.text =
              dataMap[0]['Sample3']['otherParameterS1Controller645'] ?? '';
          otherParameterS1TestValue645 =
              dataMap[0]['Sample3']['otherParameterS1TestValue645'] ?? false;
          otherParameterS1RemarksControllers645.text = dataMap[0]['Sample3']
                  ['otherParameterS1RemarksControllers645'] ??
              '';

          otherParameterS2Controller645.text =
              dataMap[0]['Sample3']['otherParameterS2Controller645'] ?? '';
          otherParameterS2TestValue645 =
              dataMap[0]['Sample3']['otherParameterS2TestValue645'] ?? false;
          otherParameterS2RemarksControllers645.text = dataMap[0]['Sample3']
                  ['otherParameterS2RemarksControllers645'] ??
              '';

          otherParameterS3Controller645.text =
              dataMap[0]['Sample3']['otherParameterS3Controller645'] ?? '';
          otherParameterS3TestValue645 =
              dataMap[0]['Sample3']['otherParameterS3TestValue645'] ?? false;
          otherParameterS3RemarksControllers645.text = dataMap[0]['Sample3']
                  ['otherParameterS3RemarksControllers645'] ??
              '';

          otherParameterS4Controller645.text =
              dataMap[0]['Sample3']['otherParameterS4Controller645'] ?? '';
          otherParameterS4TestValue645 =
              dataMap[0]['Sample3']['otherParameterS4TestValue645'] ?? false;
          otherParameterS4RemarksControllers645.text = dataMap[0]['Sample3']
                  ['otherParameterS4RemarksControllers645'] ??
              '';

          otherParameterS5Controller645.text =
              dataMap[0]['Sample3']['otherParameterS5Controller645'] ?? '';
          otherParameterS5TestValue645 =
              dataMap[0]['Sample3']['otherParameterS5TestValue645'] ?? false;
          otherParameterS5RemarksControllers645.text = dataMap[0]['Sample3']
                  ['otherParameterS5RemarksControllers645'] ??
              '';

          otherParameterS6Controller645.text =
              dataMap[0]['Sample3']['otherParameterS6Controller645'] ?? '';
          otherParameterS6TestValue645 =
              dataMap[0]['Sample3']['otherParameterS6TestValue645'] ?? false;
          otherParameterS6RemarksControllers645.text = dataMap[0]['Sample3']
                  ['otherParameterS6RemarksControllers645'] ??
              '';

          otherParameterS7Controller645.text =
              dataMap[0]['Sample3']['otherParameterS7Controller645'] ?? '';
          otherParameterS7TestValue645 =
              dataMap[0]['Sample3']['otherParameterS7TestValue645'] ?? false;
          otherParameterS7RemarksControllers645.text = dataMap[0]['Sample3']
                  ['otherParameterS7RemarksControllers645'] ??
              '';

          otherParameterS8Controller645.text =
              dataMap[0]['Sample3']['otherParameterS8Controller645'] ?? '';
          otherParameterS8TestValue645 =
              dataMap[0]['Sample3']['otherParameterS8TestValue645'] ?? false;
          otherParameterS8RemarksControllers645.text = dataMap[0]['Sample3']
                  ['otherParameterS8RemarksControllers645'] ??
              '';

          otherParameterS9Controller645.text =
              dataMap[0]['Sample3']['otherParameterS9Controller645'] ?? '';
          otherParameterS9TestValue645 =
              dataMap[0]['Sample3']['otherParameterS9TestValue645'] ?? false;
          otherParameterS9RemarksControllers645.text = dataMap[0]['Sample3']
                  ['otherParameterS9RemarksControllers645'] ??
              '';

          // numberOfPackagingSampleFields =
          //     (dataMap[0]['SampleSizePackaging'] != 0
          //         ? dataMap[0]['SampleSizePackaging']
          //         : 1);
          // Packaging = dataMap[0]['Packaging'] ?? [];

          // visualSampleSizeController.text = (dataMap[0]['SampleSizeVisual'] != 0
          //         ? dataMap[0]['SampleSizeVisual']
          //         : "")
          //     .toString();
          // Visual = dataMap[0]['Visual'] ?? [];

          // physicalSampleSizeController.text =
          //     (dataMap[0]['SampleSizePhysical'] != 0
          //             ? dataMap[0]['SampleSizePhysical']
          //             : '1')
          //         .toString();
          // Physical = dataMap[0]['Physical'] ?? [];

          // frontbusSampleSizeController.text =
          //     (dataMap[0]['SampleSizeFrontBus'] != 0
          //             ? dataMap[0]['SampleSizeFrontBus']
          //             : "")
          //         .toString();
          // FrontBus = dataMap[0]['FrontBus'] ?? [];

          // verificationSampleSizeController.text =
          //     (dataMap[0]['SampleSizeVerification'] != 0
          //             ? dataMap[0]['SampleSizeVerification']
          //             : "")
          //         .toString();
          // Verification = dataMap[0]['Verification'] ?? [];

          result = dataMap[0]['Result'] ?? 'Fail';

          packagingRejection = dataMap[0]['CheckTypes'][0]['S1'] ?? false;
          visualRejection = dataMap[0]['CheckTypes'][1]['S2'] ?? false;
          physicalRejection = dataMap[0]['CheckTypes'][2]['S3'] ?? false;
          // frontbusRejection = dataMap[0]['RejectFrontBus'] ?? false;
          // verificationRejection = dataMap[0]['RejectVerification'] ?? false;
          // electricalRejection = dataMap[0]['RejectElectrical'] ?? false;
          // performanceRejection = dataMap[0]['RejectPerformance'] ?? false;
          rejectionReasonController.text = dataMap[0]['Reason'] ?? '';

          cocPdfController.text = dataMap[0]['Pdf'] ?? '';
        }
      });
    }
  }

  Future setApprovalStatus() async {
    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    final url = (site! + "IQCSolarCell/FQCUpdateStatus");

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
        Toast.show("FQC Test $approvalStatus .",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => FqcTestList()));
      }
    } else {
      Toast.show("Error In Server",
          duration: Toast.lengthLong, gravity: Toast.center);
    }
  }

  uploadPDF(List<int> cocBytes) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    var formData = FormData.fromMap({
      "FQCDetailId": FqcId,
      "FQCPdf": MultipartFile.fromBytes(
        cocBytes,
        filename: (cocPdfController.text + (currentdate.toString()) + '.pdf'),
        contentType: MediaType("application", 'pdf'),
      ),
    });

    _response = await _dio.post((site! + 'IQCSolarCell/UploadFQCPdf'), // Prod

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

        Toast.show("FQC Test Completed.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.blueColor);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => FqcTestList()));
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

    final url = (site! + "IQCSolarCell/AddFQC");

    var params = {
      "Product": "PV Module",
      "FqcId": FqcId != '' && FqcId != null
          ? FqcId
          : widget.id != '' && widget.id != null
              ? widget.id
              : '',
      "Status": sendStatus,
      "CurrentUser": personid,
      "FqcDetails": {
        "ProductSpecs": productSpecsController.text,
        "ProductBatchNo": productBatchNoController.text,
        "PartyName": partyNameController.text,
        "PackingDate": packingDate,
        "ReportNumber": reportNumberController.text,
        "DateOfQualityCheck": dateOfQualityCheck,
        "DocumentNo": "GSPL/FQC/PDI/002",
        "RevNo": "Ver1.0/12-08-2023"
      },
      "FqcTest": {
        "S1": {
          // Visual Checks
          // 1
          "visualParametersController930": visualParametersController930.text,
          "visualParameterCrietrion1Controller930":
              visualParameterCrietrion1Controller930.text,
          "visualParameterS1Controller930": visualParameterS1Controller930.text,
          "visualParameterS1TestValue930": visualParameterS1TestValue930,
          "visualParameterS1RemarksControllers930":
              visualParameterS1RemarksControllers930.text,
          // 2
          "visualParameterCrietrion2Controller930":
              visualParameterCrietrion2Controller930.text,
          "visualParameterS2Controller930": visualParameterS2Controller930.text,
          "visualParameterS2TestValue930": visualParameterS2TestValue930,
          "visualParameterS2RemarksControllers930":
              visualParameterS2RemarksControllers930.text,
          // 3
          "visualParameterCrietrion3Controller930":
              visualParameterCrietrion3Controller930.text,
          "visualParameterS3Controller930": visualParameterS3Controller930.text,
          "visualParameterS3TestValue930": visualParameterS3TestValue930,
          "visualParameterS3RemarksControllers930":
              visualParameterS3RemarksControllers930.text,
          // 4
          "visualParameterCrietrion4Controller930":
              visualParameterCrietrion4Controller930.text,
          "visualParameterS4Controller930": visualParameterS4Controller930.text,
          "visualParameterS4TestValue930": visualParameterS4TestValue930,
          "visualParameterS4RemarksControllers930":
              visualParameterS4RemarksControllers930.text,

          // Module Rating
          // 1
          "moduleRatingParameters1Controller930":
              moduleRatingParameters1Controller930.text,
          "moduleRatingParameterCrietrion1Controller930":
              moduleRatingParameterCrietrion1Controller930.text,
          "moduleRatingParameterS1Controller930":
              moduleRatingParameterS1Controller930.text,
          "moduleRatingParameterS1TestValue930":
              moduleRatingParameterS1TestValue930,
          "moduleRatingParameterS1RemarksControllers930":
              moduleRatingParameterS1RemarksControllers930.text,
          // 2
          "moduleRatingParameters2Controller930":
              moduleRatingParameters2Controller930.text,
          "moduleRatingParameterCrietrion2Controller930":
              moduleRatingParameterCrietrion2Controller930.text,
          "moduleRatingParameterS2Controller930":
              moduleRatingParameterS2Controller930.text,
          "moduleRatingParameterS2TestValue930":
              moduleRatingParameterS2TestValue930,
          "moduleRatingParameterS2RemarksControllers930":
              moduleRatingParameterS2RemarksControllers930.text,

          // Other Check Points
          // 1
          "otherParameters1Controller930": otherParameters1Controller930.text,
          "otherParameterCrietrion1Controller930":
              otherParameterCrietrion1Controller930.text,
          "otherParameterS1Controller930": otherParameterS1Controller930.text,
          "otherParameterS1TestValue930": otherParameterS1TestValue930,
          "otherParameterS1RemarksControllers930":
              otherParameterS1RemarksControllers930.text,
          // 2
          "otherParameters2Controller930": otherParameters2Controller930.text,
          "otherParameterCrietrion2Controller930":
              otherParameterCrietrion2Controller930.text,
          "otherParameterS2Controller930": otherParameterS2Controller930.text,
          "otherParameterS2TestValue930": otherParameterS2TestValue930,
          "otherParameterS2RemarksControllers930":
              otherParameterS2RemarksControllers930.text,
          // 3
          "otherParameters3Controller930": otherParameters3Controller930.text,
          "otherParameterCrietrion3Controller930":
              otherParameterCrietrion3Controller930.text,
          "otherParameterS3Controller930": otherParameterS3Controller930.text,
          "otherParameterS3TestValue930": otherParameterS3TestValue930,
          "otherParameterS3RemarksControllers930":
              otherParameterS3RemarksControllers930.text,
          // 4
          "otherParameters4Controller930": otherParameters4Controller930.text,
          "otherParameterCrietrion4Controller930":
              otherParameterCrietrion4Controller930.text,
          "otherParameterS4Controller930": otherParameterS4Controller930.text,
          "otherParameterS4TestValue930": otherParameterS4TestValue930,
          "otherParameterS4RemarksControllers930":
              otherParameterS4RemarksControllers930.text,
          // 5
          "otherParameters5Controller930": otherParameters5Controller930.text,
          "otherParameterCrietrion5Controller930":
              otherParameterCrietrion5Controller930.text,
          "otherParameterS5Controller930": otherParameterS5Controller930.text,
          "otherParameterS5TestValue930": otherParameterS5TestValue930,
          "otherParameterS5RemarksControllers930":
              otherParameterS5RemarksControllers930.text,
          // 6
          "otherParameters6Controller930": otherParameters6Controller930.text,
          "otherParameterCrietrion6Controller930":
              otherParameterCrietrion6Controller930.text,
          "otherParameterS6Controller930": otherParameterS6Controller930.text,
          "otherParameterS6TestValue930": otherParameterS6TestValue930,
          "otherParameterS6RemarksControllers930":
              otherParameterS6RemarksControllers930.text,
          // 7
          "otherParameters7Controller930": otherParameters7Controller930.text,
          "otherParameterCrietrion7Controller930":
              otherParameterCrietrion7Controller930.text,
          "otherParameterS7Controller930": otherParameterS7Controller930.text,
          "otherParameterS7TestValue930": otherParameterS7TestValue930,
          "otherParameterS7RemarksControllers930":
              otherParameterS7RemarksControllers930.text,
          // 8
          "otherParameters8Controller930": otherParameters8Controller930.text,
          "otherParameterCrietrion8Controller930":
              otherParameterCrietrion8Controller930.text,
          "otherParameterS8Controller930": otherParameterS8Controller930.text,
          "otherParameterS8TestValue930": otherParameterS8TestValue930,
          "otherParameterS8RemarksControllers930":
              otherParameterS8RemarksControllers930.text,
          // 9
          "otherParameters9Controller930": otherParameters9Controller930.text,
          "otherParameterCrietrion9Controller930":
              otherParameterCrietrion9Controller930.text,
          "otherParameterS9Controller930": otherParameterS9Controller930.text,
          "otherParameterS9TestValue930": otherParameterS9TestValue930,
          "otherParameterS9RemarksControllers930":
              otherParameterS9RemarksControllers930.text
        },
        "S2": {
          // Visual Checks
          // 1
          "visualParametersController230": visualParametersController230.text,
          "visualParameterCrietrion1Controller230":
              visualParameterCrietrion1Controller230.text,
          "visualParameterS1Controller230": visualParameterS1Controller230.text,
          "visualParameterS1TestValue230": visualParameterS1TestValue230,
          "visualParameterS1RemarksControllers230":
              visualParameterS1RemarksControllers230.text,
          // 2
          "visualParameterCrietrion2Controller230":
              visualParameterCrietrion2Controller230.text,
          "visualParameterS2Controller230": visualParameterS2Controller230.text,
          "visualParameterS2TestValue230": visualParameterS2TestValue230,
          "visualParameterS2RemarksControllers230":
              visualParameterS2RemarksControllers230.text,
          // 3
          "visualParameterCrietrion3Controller230":
              visualParameterCrietrion3Controller230.text,
          "visualParameterS3Controller230": visualParameterS3Controller230.text,
          "visualParameterS3TestValue230": visualParameterS3TestValue230,
          "visualParameterS3RemarksControllers230":
              visualParameterS3RemarksControllers230.text,
          // 4
          "visualParameterCrietrion4Controller230":
              visualParameterCrietrion4Controller230.text,
          "visualParameterS4Controller230": visualParameterS4Controller230.text,
          "visualParameterS4TestValue230": visualParameterS4TestValue230,
          "visualParameterS4RemarksControllers230":
              visualParameterS4RemarksControllers230.text,

          // Module Rating
          // 1
          "moduleRatingParameters1Controller230":
              moduleRatingParameters1Controller230.text,
          "moduleRatingParameterCrietrion1Controller230":
              moduleRatingParameterCrietrion1Controller230.text,
          "moduleRatingParameterS1Controller230":
              moduleRatingParameterS1Controller230.text,
          "moduleRatingParameterS1TestValue230":
              moduleRatingParameterS1TestValue230,
          "moduleRatingParameterS1RemarksControllers230":
              moduleRatingParameterS1RemarksControllers230.text,
          // 2
          "moduleRatingParameters2Controller230":
              moduleRatingParameters2Controller230.text,
          "moduleRatingParameterCrietrion2Controller230":
              moduleRatingParameterCrietrion2Controller230.text,
          "moduleRatingParameterS2Controller230":
              moduleRatingParameterS2Controller230.text,
          "moduleRatingParameterS2TestValue230":
              moduleRatingParameterS2TestValue230,
          "moduleRatingParameterS2RemarksControllers230":
              moduleRatingParameterS2RemarksControllers230.text,

          // Other Check Points
          // 1
          "otherParameters1Controller230": otherParameters1Controller230.text,
          "otherParameterCrietrion1Controller230":
              otherParameterCrietrion1Controller230.text,
          "otherParameterS1Controller230": otherParameterS1Controller230.text,
          "otherParameterS1TestValue230": otherParameterS1TestValue230,
          "otherParameterS1RemarksControllers230":
              otherParameterS1RemarksControllers230.text,
          // 2
          "otherParameters2Controller230": otherParameters2Controller230.text,
          "otherParameterCrietrion2Controller230":
              otherParameterCrietrion2Controller230.text,
          "otherParameterS2Controller230": otherParameterS2Controller230.text,
          "otherParameterS2TestValue230": otherParameterS2TestValue230,
          "otherParameterS2RemarksControllers230":
              otherParameterS2RemarksControllers230.text,
          // 3
          "otherParameters3Controller230": otherParameters3Controller230.text,
          "otherParameterCrietrion3Controller230":
              otherParameterCrietrion3Controller230.text,
          "otherParameterS3Controller230": otherParameterS3Controller230.text,
          "otherParameterS3TestValue230": otherParameterS3TestValue230,
          "otherParameterS3RemarksControllers230":
              otherParameterS3RemarksControllers230.text,
          // 4
          "otherParameters4Controller230": otherParameters4Controller230.text,
          "otherParameterCrietrion4Controller230":
              otherParameterCrietrion4Controller230.text,
          "otherParameterS4Controller230": otherParameterS4Controller230.text,
          "otherParameterS4TestValue230": otherParameterS4TestValue230,
          "otherParameterS4RemarksControllers230":
              otherParameterS4RemarksControllers230.text,
          // 5
          "otherParameters5Controller230": otherParameters5Controller230.text,
          "otherParameterCrietrion5Controller230":
              otherParameterCrietrion5Controller230.text,
          "otherParameterS5Controller230": otherParameterS5Controller230.text,
          "otherParameterS5TestValue230": otherParameterS5TestValue230,
          "otherParameterS5RemarksControllers230":
              otherParameterS5RemarksControllers230.text,
          // 6
          "otherParameters6Controller230": otherParameters6Controller230.text,
          "otherParameterCrietrion6Controller230":
              otherParameterCrietrion6Controller230.text,
          "otherParameterS6Controller230": otherParameterS6Controller230.text,
          "otherParameterS6TestValue230": otherParameterS6TestValue230,
          "otherParameterS6RemarksControllers230":
              otherParameterS6RemarksControllers230.text,
          // 7
          "otherParameters7Controller230": otherParameters7Controller230.text,
          "otherParameterCrietrion7Controller230":
              otherParameterCrietrion7Controller230.text,
          "otherParameterS7Controller230": otherParameterS7Controller230.text,
          "otherParameterS7TestValue230": otherParameterS7TestValue230,
          "otherParameterS7RemarksControllers230":
              otherParameterS7RemarksControllers230.text,
          // 8
          "otherParameters8Controller230": otherParameters8Controller230.text,
          "otherParameterCrietrion8Controller230":
              otherParameterCrietrion8Controller230.text,
          "otherParameterS8Controller230": otherParameterS8Controller230.text,
          "otherParameterS8TestValue230": otherParameterS8TestValue230,
          "otherParameterS8RemarksControllers230":
              otherParameterS8RemarksControllers230.text,
          // 9
          "otherParameters9Controller230": otherParameters9Controller230.text,
          "otherParameterCrietrion9Controller230":
              otherParameterCrietrion9Controller230.text,
          "otherParameterS9Controller230": otherParameterS9Controller230.text,
          "otherParameterS9TestValue230": otherParameterS9TestValue230,
          "otherParameterS9RemarksControllers230":
              otherParameterS9RemarksControllers230.text
        },
        "S3": {
          // Visual Checks
          // 1
          "visualParametersController645": visualParametersController645.text,
          "visualParameterCrietrion1Controller645":
              visualParameterCrietrion1Controller645.text,
          "visualParameterS1Controller645": visualParameterS1Controller645.text,
          "visualParameterS1TestValue645": visualParameterS1TestValue645,
          "visualParameterS1RemarksControllers645":
              visualParameterS1RemarksControllers645.text,
          // 2
          "visualParameterCrietrion2Controller645":
              visualParameterCrietrion2Controller645.text,
          "visualParameterS2Controller645": visualParameterS2Controller645.text,
          "visualParameterS2TestValue645": visualParameterS2TestValue645,
          "visualParameterS2RemarksControllers645":
              visualParameterS2RemarksControllers645.text,
          // 3
          "visualParameterCrietrion3Controller645":
              visualParameterCrietrion3Controller645.text,
          "visualParameterS3Controller645": visualParameterS3Controller645.text,
          "visualParameterS3TestValue645": visualParameterS3TestValue645,
          "visualParameterS3RemarksControllers645":
              visualParameterS3RemarksControllers645.text,
          // 4
          "visualParameterCrietrion4Controller645":
              visualParameterCrietrion4Controller645.text,
          "visualParameterS4Controller645": visualParameterS4Controller645.text,
          "visualParameterS4TestValue645": visualParameterS4TestValue645,
          "visualParameterS4RemarksControllers645":
              visualParameterS4RemarksControllers645.text,

          // Module Rating
          // 1
          "moduleRatingParameters1Controller645":
              moduleRatingParameters1Controller645.text,
          "moduleRatingParameterCrietrion1Controller645":
              moduleRatingParameterCrietrion1Controller645.text,
          "moduleRatingParameterS1Controller645":
              moduleRatingParameterS1Controller645.text,
          "moduleRatingParameterS1TestValue645":
              moduleRatingParameterS1TestValue645,
          "moduleRatingParameterS1RemarksControllers645":
              moduleRatingParameterS1RemarksControllers645.text,
          // 2
          "moduleRatingParameters2Controller645":
              moduleRatingParameters2Controller645.text,
          "moduleRatingParameterCrietrion2Controller645":
              moduleRatingParameterCrietrion2Controller645.text,
          "moduleRatingParameterS2Controller645":
              moduleRatingParameterS2Controller645.text,
          "moduleRatingParameterS2TestValue645":
              moduleRatingParameterS2TestValue645,
          "moduleRatingParameterS2RemarksControllers645":
              moduleRatingParameterS2RemarksControllers645.text,

          // Other Check Points
          // 1
          "otherParameters1Controller645": otherParameters1Controller645.text,
          "otherParameterCrietrion1Controller645":
              otherParameterCrietrion1Controller645.text,
          "otherParameterS1Controller645": otherParameterS1Controller645.text,
          "otherParameterS1TestValue645": otherParameterS1TestValue645,
          "otherParameterS1RemarksControllers645":
              otherParameterS1RemarksControllers645.text,
          // 2
          "otherParameters2Controller645": otherParameters2Controller645.text,
          "otherParameterCrietrion2Controller645":
              otherParameterCrietrion2Controller645.text,
          "otherParameterS2Controller645": otherParameterS2Controller645.text,
          "otherParameterS2TestValue645": otherParameterS2TestValue645,
          "otherParameterS2RemarksControllers645":
              otherParameterS2RemarksControllers645.text,
          // 3
          "otherParameters3Controller645": otherParameters3Controller645.text,
          "otherParameterCrietrion3Controller645":
              otherParameterCrietrion3Controller645.text,
          "otherParameterS3Controller645": otherParameterS3Controller645.text,
          "otherParameterS3TestValue645": otherParameterS3TestValue645,
          "otherParameterS3RemarksControllers645":
              otherParameterS3RemarksControllers645.text,
          // 4
          "otherParameters4Controller645": otherParameters4Controller645.text,
          "otherParameterCrietrion4Controller645":
              otherParameterCrietrion4Controller645.text,
          "otherParameterS4Controller645": otherParameterS4Controller645.text,
          "otherParameterS4TestValue645": otherParameterS4TestValue645,
          "otherParameterS4RemarksControllers645":
              otherParameterS4RemarksControllers645.text,
          // 5
          "otherParameters5Controller645": otherParameters5Controller645.text,
          "otherParameterCrietrion5Controller645":
              otherParameterCrietrion5Controller645.text,
          "otherParameterS5Controller645": otherParameterS5Controller645.text,
          "otherParameterS5TestValue645": otherParameterS5TestValue645,
          "otherParameterS5RemarksControllers645":
              otherParameterS5RemarksControllers645.text,
          // 6
          "otherParameters6Controller645": otherParameters6Controller645.text,
          "otherParameterCrietrion6Controller645":
              otherParameterCrietrion6Controller645.text,
          "otherParameterS6Controller645": otherParameterS6Controller645.text,
          "otherParameterS6TestValue645": otherParameterS6TestValue645,
          "otherParameterS6RemarksControllers645":
              otherParameterS6RemarksControllers645.text,
          // 7
          "otherParameters7Controller645": otherParameters7Controller645.text,
          "otherParameterCrietrion7Controller645":
              otherParameterCrietrion7Controller645.text,
          "otherParameterS7Controller645": otherParameterS7Controller645.text,
          "otherParameterS7TestValue645": otherParameterS7TestValue645,
          "otherParameterS7RemarksControllers645":
              otherParameterS7RemarksControllers645.text,
          // 8
          "otherParameters8Controller645": otherParameters8Controller645.text,
          "otherParameterCrietrion8Controller645":
              otherParameterCrietrion8Controller645.text,
          "otherParameterS8Controller645": otherParameterS8Controller645.text,
          "otherParameterS8TestValue645": otherParameterS8TestValue645,
          "otherParameterS8RemarksControllers645":
              otherParameterS8RemarksControllers645.text,
          // 9
          "otherParameters9Controller645": otherParameters9Controller645.text,
          "otherParameterCrietrion9Controller645":
              otherParameterCrietrion9Controller645.text,
          "otherParameterS9Controller645": otherParameterS9Controller645.text,
          "otherParameterS9TestValue645": otherParameterS9TestValue645,
          "otherParameterS9RemarksControllers645":
              otherParameterS9RemarksControllers645.text
        },
      },
      "Rejected": {
        "Result": result,
        "CheckTypes": [
          {"S1": packagingRejection},
          {"S2": visualRejection},
          {"S3": physicalRejection},
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

    print("resssssssssssssssss...........?????");
    print(response.statusCode);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      var objData = json.decode(response.body);
      setState(() {
        FqcId = objData['FQCDetailId'];
        _isLoading = false;
      });

      if (objData['success'] == false) {
        Toast.show(objData['message'],
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColors.redColor);
      } else {
        if (sendStatus == 'Pending') {
          setState(() {
            _isLoading = false;
          });
          uploadPDF((cocPdfFileBytes ?? []));
        } else {
          Toast.show("Data has been saved.",
              duration: Toast.lengthLong,
              gravity: Toast.center,
              backgroundColor: AppColors.blueColor);
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (BuildContext context) => FqcTestList()));
        }
      }
    } else {
      Toast.show("Error In Server",
          duration: Toast.lengthLong, gravity: Toast.center);
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
                    ? FqcTestList()
                    : FqcPage();
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
                                          child: Text("FQC",
                                              style: TextStyle(
                                                  fontSize: 27,
                                                  color: AppColors.black,
                                                  fontFamily: appFontFamily,
                                                  fontWeight:
                                                      FontWeight.w700)))),
                                  const Center(
                                      child: Text("(PV Module)",
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
                                        'GSPL/FQC/PDI/002',
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
                                        'Ver.1.0 / 12-08-2023',
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Product Specs",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                      controller: productSpecsController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                              hintText:
                                                  "Please Enter Product Specs",
                                              counterText: ''),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly:
                                          status == 'Pending' ? true : false,
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Please Enter Product Specs")
                                      ])),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Product Batch/Lot No.",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TextFormField(
                                    controller: productBatchNoController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: AppStyles
                                        .textFieldInputDecoration
                                        .copyWith(
                                            hintText:
                                                "Please Enter Product Batch/Lot No.",
                                            counterText: ''),
                                    style: AppStyles.textInputTextStyle,
                                    readOnly:
                                        status == 'Pending' ? true : false,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Product Batch/Lot No.";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Party Name",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                      controller: partyNameController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Party Name",
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly:
                                          status == 'Pending' ? true : false,
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Please Enter Party Name")
                                      ])),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Packing Date",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TextFormField(
                                      controller: packingDateController,
                                      readOnly:
                                          status == 'Pending' ? true : false,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                              hintText:
                                                  "Please Enter Packing Date",
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
                                          packingDateController.text =
                                              DateFormat("EEE MMM dd, yyyy")
                                                  .format(DateTime.parse(
                                                      date.toString()));
                                          setState(() {
                                            packingDate =
                                                DateFormat("yyyy-MM-dd").format(
                                                    DateTime.parse(
                                                        date.toString()));
                                          });
                                        }
                                      },
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Please Enter Packing Date")
                                      ])),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Report Number",
                                    style: AppStyles.textfieldCaptionTextStyle,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TextFormField(
                                    controller: reportNumberController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: AppStyles
                                        .textFieldInputDecoration
                                        .copyWith(
                                            hintText:
                                                "Please Enter Report Number",
                                            counterText: ''),
                                    style: AppStyles.textInputTextStyle,
                                    readOnly:
                                        status == 'Pending' ? true : false,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Report Number";
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
                                                setPage = 'S1';
                                              });
                                              if (status != 'Pending') {
                                                setState(() {
                                                  sendStatus = 'Inprogress';
                                                });
                                                createData();
                                              }
                                            }
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
                      : setPage == "S1"
                          // Packaging
                          ? Stack(
                              alignment: Alignment.center,
                              fit: StackFit.expand,
                              children: [
                                SingleChildScrollView(
                                    child: Form(
                                  key: packagingFormkey,
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
                                              child: Text("FQC",
                                                  style: TextStyle(
                                                      fontSize: 27,
                                                      color: AppColors.black,
                                                      fontFamily: appFontFamily,
                                                      fontWeight:
                                                          FontWeight.w700)))),
                                      const Center(
                                          child: Text("(PV Module)",
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
                                            'GSPL/FQC/PDI/002',
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
                                            'Ver.1.0 / 12-08-2023',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Center(
                                          child: Text("S1(09:30 Am)",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: Color.fromARGB(
                                                      255, 0, 36, 243),
                                                  fontFamily: appFontFamily,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Center(
                                          child: Text("Visual Checks",
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
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            visualParametersController930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            visualParameterCrietrion1Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            visualParameterS1Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  visualParameterS1Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                visualParameterS1TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  visualParameterS1TestValue930 =
                                                      value!;
                                                  visualParameterS1RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                visualParameterS1TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  visualParameterS1TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (visualParameterS1TestValue930 ==
                                          false)
                                        const SizedBox(height: 8),
                                      if (visualParameterS1TestValue930 ==
                                          false)
                                        TextFormField(
                                          controller:
                                              visualParameterS1RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            visualParameterCrietrion2Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            visualParameterS2Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  visualParameterS2Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                visualParameterS2TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  visualParameterS2TestValue930 =
                                                      value!;
                                                  visualParameterS2RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                visualParameterS2TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  visualParameterS2TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (visualParameterS2TestValue930 ==
                                          false)
                                        const SizedBox(height: 8),
                                      if (visualParameterS2TestValue930 ==
                                          false)
                                        TextFormField(
                                          controller:
                                              visualParameterS2RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            visualParameterCrietrion3Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            visualParameterS3Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  visualParameterS3Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                visualParameterS3TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  visualParameterS3TestValue930 =
                                                      value!;
                                                  visualParameterS3RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                visualParameterS3TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  visualParameterS3TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (visualParameterS3TestValue930 ==
                                          false)
                                        const SizedBox(height: 8),
                                      if (visualParameterS3TestValue930 ==
                                          false)
                                        TextFormField(
                                          controller:
                                              visualParameterS3RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            visualParameterCrietrion4Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            visualParameterS4Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  visualParameterS4Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                visualParameterS4TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  visualParameterS4TestValue930 =
                                                      value!;
                                                  visualParameterS4RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                visualParameterS4TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  visualParameterS4TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (visualParameterS4TestValue930 ==
                                          false)
                                        const SizedBox(height: 8),
                                      if (visualParameterS4TestValue930 ==
                                          false)
                                        TextFormField(
                                          controller:
                                              visualParameterS4RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Center(
                                          child: Text("Module Rating",
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
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            moduleRatingParameters1Controller930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            moduleRatingParameterCrietrion1Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            moduleRatingParameterS1Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  moduleRatingParameterS1Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                moduleRatingParameterS1TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  moduleRatingParameterS1TestValue930 =
                                                      value!;
                                                  moduleRatingParameterS1RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                moduleRatingParameterS1TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  moduleRatingParameterS1TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (moduleRatingParameterS1TestValue930 ==
                                          false)
                                        const SizedBox(height: 8),
                                      if (moduleRatingParameterS1TestValue930 ==
                                          false)
                                        TextFormField(
                                          controller:
                                              moduleRatingParameterS1RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            moduleRatingParameters2Controller930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            moduleRatingParameterCrietrion2Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            moduleRatingParameterS2Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  moduleRatingParameterS2Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                moduleRatingParameterS2TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  moduleRatingParameterS2TestValue930 =
                                                      value!;
                                                  moduleRatingParameterS2RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                moduleRatingParameterS2TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  moduleRatingParameterS2TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (moduleRatingParameterS2TestValue930 ==
                                          false)
                                        const SizedBox(height: 8),
                                      if (moduleRatingParameterS2TestValue930 ==
                                          false)
                                        TextFormField(
                                          controller:
                                              moduleRatingParameterS2RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Center(
                                          child: Text("Other Check Points",
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
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameters1Controller930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterCrietrion1Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterS1Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  otherParameterS1Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                otherParameterS1TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS1TestValue930 =
                                                      value!;
                                                  otherParameterS1RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                otherParameterS1TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS1TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (otherParameterS1TestValue930 == false)
                                        const SizedBox(height: 8),
                                      if (otherParameterS1TestValue930 == false)
                                        TextFormField(
                                          controller:
                                              otherParameterS1RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameters2Controller930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterCrietrion2Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterS2Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  otherParameterS2Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                otherParameterS2TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS2TestValue930 =
                                                      value!;
                                                  otherParameterS2RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                otherParameterS2TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS2TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (otherParameterS2TestValue930 == false)
                                        const SizedBox(height: 8),
                                      if (otherParameterS2TestValue930 == false)
                                        TextFormField(
                                          controller:
                                              otherParameterS2RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameters3Controller930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterCrietrion3Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterS3Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  otherParameterS3Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                otherParameterS3TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS3TestValue930 =
                                                      value!;
                                                  otherParameterS3RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                otherParameterS3TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS3TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (otherParameterS3TestValue930 == false)
                                        const SizedBox(height: 8),
                                      if (otherParameterS3TestValue930 == false)
                                        TextFormField(
                                          controller:
                                              otherParameterS3RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameters4Controller930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterCrietrion4Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterS4Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  otherParameterS4Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                otherParameterS4TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS4TestValue930 =
                                                      value!;
                                                  otherParameterS4RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                otherParameterS4TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS4TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (otherParameterS4TestValue930 == false)
                                        const SizedBox(height: 8),
                                      if (otherParameterS4TestValue930 == false)
                                        TextFormField(
                                          controller:
                                              otherParameterS4RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameters5Controller930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterCrietrion5Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterS5Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  otherParameterS5Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                otherParameterS5TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS5TestValue930 =
                                                      value!;
                                                  otherParameterS5RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                otherParameterS5TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS5TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (otherParameterS5TestValue930 == false)
                                        const SizedBox(height: 8),
                                      if (otherParameterS5TestValue930 == false)
                                        TextFormField(
                                          controller:
                                              otherParameterS5RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameters6Controller930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterCrietrion6Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterS6Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  otherParameterS6Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                otherParameterS6TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS6TestValue930 =
                                                      value!;
                                                  otherParameterS6RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                otherParameterS6TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS6TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (otherParameterS6TestValue930 == false)
                                        const SizedBox(height: 8),
                                      if (otherParameterS6TestValue930 == false)
                                        TextFormField(
                                          controller:
                                              otherParameterS6RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameters7Controller930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterCrietrion7Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterS7Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  otherParameterS7Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                otherParameterS7TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS7TestValue930 =
                                                      value!;
                                                  otherParameterS7RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                otherParameterS7TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS7TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (otherParameterS7TestValue930 == false)
                                        const SizedBox(height: 8),
                                      if (otherParameterS7TestValue930 == false)
                                        TextFormField(
                                          controller:
                                              otherParameterS7RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameters8Controller930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterCrietrion8Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterS8Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  otherParameterS8Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                otherParameterS8TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS8TestValue930 =
                                                      value!;
                                                  otherParameterS8RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                otherParameterS8TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS8TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (otherParameterS8TestValue930 == false)
                                        const SizedBox(height: 8),
                                      if (otherParameterS8TestValue930 == false)
                                        TextFormField(
                                          controller:
                                              otherParameterS8RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Parameter",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameters9Controller930,
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
                                        "Crietrion",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterCrietrion9Controller930,
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
                                        "Batch Serial No.",
                                        style:
                                            AppStyles.textfieldCaptionTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            otherParameterS9Controller930,
                                        decoration: AppStyles
                                            .textFieldInputDecoration
                                            .copyWith(
                                          hintText:
                                              "Please Scan Batch Serial No.",
                                          fillColor: Color.fromARGB(
                                              255, 215, 243, 207),
                                          counterText: '',
                                          contentPadding: EdgeInsets.all(10),
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
                                                  otherParameterS9Controller930
                                                          .text =
                                                      (barcodeScanRes != "-1"
                                                          ? barcodeScanRes
                                                          : '')!;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.qr_code),
                                          ),
                                        ),
                                        readOnly:
                                            status == 'Pending' ? true : false,
                                        style: AppStyles.textInputTextStyle,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Scan Batch Serial No.';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: true,
                                            groupValue:
                                                otherParameterS9TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS9TestValue930 =
                                                      value!;
                                                  otherParameterS9RemarksControllers930
                                                      .text = '';
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Pass',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(width: 8),
                                          Radio(
                                            value: false,
                                            groupValue:
                                                otherParameterS9TestValue930,
                                            onChanged: (bool? value) {
                                              if (status != 'Pending') {
                                                setState(() {
                                                  otherParameterS9TestValue930 =
                                                      value!;
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            'Fail',
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (otherParameterS9TestValue930 == false)
                                        const SizedBox(height: 8),
                                      if (otherParameterS9TestValue930 == false)
                                        TextFormField(
                                          controller:
                                              otherParameterS9RemarksControllers930,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Please Enter Remarks",
                                            fillColor: Color.fromARGB(
                                                255, 215, 243, 207),
                                            counterText: '',
                                            contentPadding: EdgeInsets.all(10),
                                          ),
                                          style: AppStyles.textInputTextStyle,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(),
                                      const SizedBox(
                                        height: 10,
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
                                                packagingFormkey
                                                    .currentState!.save;
                                                if (packagingFormkey
                                                    .currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    setPage = 'S2';
                                                  });

                                                  // Dynamic Start......

                                                  // Dynamic  End......

                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      sendStatus = 'Inprogress';
                                                    });
                                                    createData();
                                                  }
                                                }
                                              },
                                              label: "Next",
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
                          : setPage == "S2"
                              // Start Visual Block.....................................................................
                              ? Stack(
                                  alignment: Alignment.center,
                                  fit: StackFit.expand,
                                  children: [
                                    SingleChildScrollView(
                                        child: Form(
                                      key: _visualFormKey,
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
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Text("FQC",
                                                      style: TextStyle(
                                                          fontSize: 27,
                                                          color:
                                                              AppColors.black,
                                                          fontFamily:
                                                              appFontFamily,
                                                          fontWeight: FontWeight
                                                              .w700)))),
                                          const Center(
                                              child: Text("(PV Module)",
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
                                                'GSPL/FQC/PDI/002',
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
                                                'Ver.1.0 / 12-08-2023',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Center(
                                              child: Text("S2(02:30 Pm)",
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color: Color.fromARGB(
                                                          255, 0, 36, 243),
                                                      fontFamily: appFontFamily,
                                                      fontWeight:
                                                          FontWeight.w700))),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Center(
                                              child: Text("Visual Checks",
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
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                visualParametersController230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                visualParameterCrietrion1Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                visualParameterS1Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      visualParameterS1Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    visualParameterS1TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      visualParameterS1TestValue230 =
                                                          value!;
                                                      visualParameterS1RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    visualParameterS1TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      visualParameterS1TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (visualParameterS1TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (visualParameterS1TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  visualParameterS1RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                visualParameterCrietrion2Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                visualParameterS2Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      visualParameterS2Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    visualParameterS2TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      visualParameterS2TestValue230 =
                                                          value!;
                                                      visualParameterS2RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    visualParameterS2TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      visualParameterS2TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (visualParameterS2TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (visualParameterS2TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  visualParameterS2RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                visualParameterCrietrion3Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                visualParameterS3Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      visualParameterS3Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    visualParameterS3TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      visualParameterS3TestValue230 =
                                                          value!;
                                                      visualParameterS3RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    visualParameterS3TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      visualParameterS3TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (visualParameterS3TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (visualParameterS3TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  visualParameterS3RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                visualParameterCrietrion4Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                visualParameterS4Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      visualParameterS4Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    visualParameterS4TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      visualParameterS4TestValue230 =
                                                          value!;
                                                      visualParameterS4RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    visualParameterS4TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      visualParameterS4TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (visualParameterS4TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (visualParameterS4TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  visualParameterS4RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Center(
                                              child: Text("Module Rating",
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
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                moduleRatingParameters1Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                moduleRatingParameterCrietrion1Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                moduleRatingParameterS1Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      moduleRatingParameterS1Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    moduleRatingParameterS1TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      moduleRatingParameterS1TestValue230 =
                                                          value!;
                                                      moduleRatingParameterS1RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    moduleRatingParameterS1TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      moduleRatingParameterS1TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (moduleRatingParameterS1TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (moduleRatingParameterS1TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  moduleRatingParameterS1RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                moduleRatingParameters2Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                moduleRatingParameterCrietrion2Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                moduleRatingParameterS2Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      moduleRatingParameterS2Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    moduleRatingParameterS2TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      moduleRatingParameterS2TestValue230 =
                                                          value!;
                                                      moduleRatingParameterS2RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    moduleRatingParameterS2TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      moduleRatingParameterS2TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (moduleRatingParameterS2TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (moduleRatingParameterS2TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  moduleRatingParameterS2RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Center(
                                              child: Text("Other Check Points",
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
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameters1Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterCrietrion1Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterS1Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      otherParameterS1Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    otherParameterS1TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS1TestValue230 =
                                                          value!;
                                                      otherParameterS1RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    otherParameterS1TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS1TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (otherParameterS1TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (otherParameterS1TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  otherParameterS1RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameters2Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterCrietrion2Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterS2Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      otherParameterS2Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    otherParameterS2TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS2TestValue230 =
                                                          value!;
                                                      otherParameterS2RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    otherParameterS2TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS2TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (otherParameterS2TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (otherParameterS2TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  otherParameterS2RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameters3Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterCrietrion3Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterS3Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      otherParameterS3Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    otherParameterS3TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS3TestValue230 =
                                                          value!;
                                                      otherParameterS3RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    otherParameterS3TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS3TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (otherParameterS3TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (otherParameterS3TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  otherParameterS3RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameters4Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterCrietrion4Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterS4Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      otherParameterS4Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    otherParameterS4TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS4TestValue230 =
                                                          value!;
                                                      otherParameterS4RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    otherParameterS4TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS4TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (otherParameterS4TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (otherParameterS4TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  otherParameterS4RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameters5Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterCrietrion5Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterS5Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      otherParameterS5Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    otherParameterS5TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS5TestValue230 =
                                                          value!;
                                                      otherParameterS5RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    otherParameterS5TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS5TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (otherParameterS5TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (otherParameterS5TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  otherParameterS5RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameters6Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterCrietrion6Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterS6Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      otherParameterS6Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    otherParameterS6TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS6TestValue230 =
                                                          value!;
                                                      otherParameterS6RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    otherParameterS6TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS6TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (otherParameterS6TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (otherParameterS6TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  otherParameterS6RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameters7Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterCrietrion7Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterS7Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      otherParameterS7Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    otherParameterS7TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS7TestValue230 =
                                                          value!;
                                                      otherParameterS7RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    otherParameterS7TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS7TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (otherParameterS7TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (otherParameterS7TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  otherParameterS7RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameters8Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterCrietrion8Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterS8Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      otherParameterS8Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    otherParameterS8TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS8TestValue230 =
                                                          value!;
                                                      otherParameterS8RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    otherParameterS8TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS8TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (otherParameterS8TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (otherParameterS8TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  otherParameterS8RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Parameter",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameters9Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Crietrion",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterCrietrion9Controller230,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
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
                                            "Batch Serial No.",
                                            style: AppStyles
                                                .textfieldCaptionTextStyle,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                otherParameterS9Controller230,
                                            decoration: AppStyles
                                                .textFieldInputDecoration
                                                .copyWith(
                                              hintText:
                                                  "Please Scan Batch Serial No.",
                                              fillColor: Color.fromARGB(
                                                  255, 215, 243, 207),
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
                                                      otherParameterS9Controller230
                                                              .text =
                                                          (barcodeScanRes !=
                                                                  "-1"
                                                              ? barcodeScanRes
                                                              : '')!;
                                                    });
                                                  }
                                                },
                                                icon: const Icon(Icons.qr_code),
                                              ),
                                            ),
                                            readOnly: status == 'Pending'
                                                ? true
                                                : false,
                                            style: AppStyles.textInputTextStyle,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Scan Batch Serial No.';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                value: true,
                                                groupValue:
                                                    otherParameterS9TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS9TestValue230 =
                                                          value!;
                                                      otherParameterS9RemarksControllers230
                                                          .text = '';
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Pass',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(width: 8),
                                              Radio(
                                                value: false,
                                                groupValue:
                                                    otherParameterS9TestValue230,
                                                onChanged: (bool? value) {
                                                  if (status != 'Pending') {
                                                    setState(() {
                                                      otherParameterS9TestValue230 =
                                                          value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              Text(
                                                'Fail',
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          if (otherParameterS9TestValue230 ==
                                              false)
                                            const SizedBox(height: 8),
                                          if (otherParameterS9TestValue230 ==
                                              false)
                                            TextFormField(
                                              controller:
                                                  otherParameterS9RemarksControllers230,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Please Enter Remarks",
                                                fillColor: Color.fromARGB(
                                                    255, 215, 243, 207),
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
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
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0)),
                                          _isLoading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : AppButton(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors.white,
                                                      fontSize: 16),
                                                  onTap: () {
                                                    AppHelper.hideKeyboard(
                                                        context);
                                                    _visualFormKey
                                                        .currentState!.save;
                                                    if (_visualFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        setPage = 'S3';
                                                      });

                                                      // Dynamic Start......

                                                      // Dynamic  End......

                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          sendStatus =
                                                              'Inprogress';
                                                        });
                                                        createData();
                                                      }
                                                    }
                                                  },
                                                  label: "Next",
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
                                                    setPage = "S1";
                                                  });
                                                },
                                                child: const Text(
                                                  "BACK",
                                                  style: TextStyle(
                                                      fontFamily: appFontFamily,
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
                                                        fontFamily:
                                                            appFontFamily,
                                                        color:
                                                            AppColors.greyColor,
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
                              : setPage == "S3"
                                  ? Stack(
                                      alignment: Alignment.center,
                                      fit: StackFit.expand,
                                      children: [
                                        SingleChildScrollView(
                                            child: Form(
                                          key: _physicalFormKey,
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
                                                      child: Text("FQC",
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
                                                  child: Text("(PV Module)",
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
                                                    'GSPL/FQC/PDI/002',
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
                                                    'Ver.1.0 / 12-08-2023',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              const Center(
                                                  child: Text("S3(06:45 Pm)",
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          color: Color.fromARGB(
                                                              255, 0, 36, 243),
                                                          fontFamily:
                                                              appFontFamily,
                                                          fontWeight: FontWeight
                                                              .w700))),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Center(
                                                  child: Text("Visual Checks",
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
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualParametersController645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualParameterCrietrion1Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualParameterS1Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          visualParameterS1Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        visualParameterS1TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          visualParameterS1TestValue645 =
                                                              value!;
                                                          visualParameterS1RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        visualParameterS1TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          visualParameterS1TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (visualParameterS1TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (visualParameterS1TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      visualParameterS1RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualParameterCrietrion2Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualParameterS2Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          visualParameterS2Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        visualParameterS2TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          visualParameterS2TestValue645 =
                                                              value!;
                                                          visualParameterS2RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        visualParameterS2TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          visualParameterS2TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (visualParameterS2TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (visualParameterS2TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      visualParameterS2RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualParameterCrietrion3Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualParameterS3Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          visualParameterS3Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        visualParameterS3TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          visualParameterS3TestValue645 =
                                                              value!;
                                                          visualParameterS3RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        visualParameterS3TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          visualParameterS3TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (visualParameterS3TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (visualParameterS3TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      visualParameterS3RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualParameterCrietrion4Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    visualParameterS4Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          visualParameterS4Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        visualParameterS4TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          visualParameterS4TestValue645 =
                                                              value!;
                                                          visualParameterS4RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        visualParameterS4TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          visualParameterS4TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (visualParameterS4TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (visualParameterS4TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      visualParameterS4RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              const Center(
                                                  child: Text("Module Rating",
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
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    moduleRatingParameters1Controller645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    moduleRatingParameterCrietrion1Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    moduleRatingParameterS1Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          moduleRatingParameterS1Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        moduleRatingParameterS1TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          moduleRatingParameterS1TestValue645 =
                                                              value!;
                                                          moduleRatingParameterS1RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        moduleRatingParameterS1TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          moduleRatingParameterS1TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (moduleRatingParameterS1TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (moduleRatingParameterS1TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      moduleRatingParameterS1RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    moduleRatingParameters2Controller645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    moduleRatingParameterCrietrion2Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    moduleRatingParameterS2Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          moduleRatingParameterS2Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        moduleRatingParameterS2TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          moduleRatingParameterS2TestValue645 =
                                                              value!;
                                                          moduleRatingParameterS2RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        moduleRatingParameterS2TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          moduleRatingParameterS2TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (moduleRatingParameterS2TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (moduleRatingParameterS2TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      moduleRatingParameterS2RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              const Center(
                                                  child: Text(
                                                      "Other Check Points",
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
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameters1Controller645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterCrietrion1Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterS1Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          otherParameterS1Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        otherParameterS1TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS1TestValue645 =
                                                              value!;
                                                          otherParameterS1RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        otherParameterS1TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS1TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (otherParameterS1TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (otherParameterS1TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      otherParameterS1RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameters2Controller645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterCrietrion2Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterS2Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          otherParameterS2Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        otherParameterS2TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS2TestValue645 =
                                                              value!;
                                                          otherParameterS2RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        otherParameterS2TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS2TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (otherParameterS2TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (otherParameterS2TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      otherParameterS2RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameters3Controller645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterCrietrion3Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterS3Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          otherParameterS3Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        otherParameterS3TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS3TestValue645 =
                                                              value!;
                                                          otherParameterS3RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        otherParameterS3TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS3TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (otherParameterS3TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (otherParameterS3TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      otherParameterS3RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameters4Controller645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterCrietrion4Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterS4Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          otherParameterS4Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        otherParameterS4TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS4TestValue645 =
                                                              value!;
                                                          otherParameterS4RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        otherParameterS4TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS4TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (otherParameterS4TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (otherParameterS4TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      otherParameterS4RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameters5Controller645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterCrietrion5Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterS5Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          otherParameterS5Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        otherParameterS5TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS5TestValue645 =
                                                              value!;
                                                          otherParameterS5RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        otherParameterS5TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS5TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (otherParameterS5TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (otherParameterS5TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      otherParameterS5RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameters6Controller645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterCrietrion6Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterS6Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          otherParameterS6Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        otherParameterS6TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS6TestValue645 =
                                                              value!;
                                                          otherParameterS6RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        otherParameterS6TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS6TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (otherParameterS6TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (otherParameterS6TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      otherParameterS6RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameters7Controller645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterCrietrion7Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterS7Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          otherParameterS7Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        otherParameterS7TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS7TestValue645 =
                                                              value!;
                                                          otherParameterS7RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        otherParameterS7TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS7TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (otherParameterS7TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (otherParameterS7TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      otherParameterS7RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameters8Controller645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterCrietrion8Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterS8Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          otherParameterS8Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        otherParameterS8TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS8TestValue645 =
                                                              value!;
                                                          otherParameterS8RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        otherParameterS8TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS8TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (otherParameterS8TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (otherParameterS8TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      otherParameterS8RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Parameter",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameters9Controller645,
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
                                                "Crietrion",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterCrietrion9Controller645,
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
                                                "Batch Serial No.",
                                                style: AppStyles
                                                    .textfieldCaptionTextStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    otherParameterS9Controller645,
                                                decoration: AppStyles
                                                    .textFieldInputDecoration
                                                    .copyWith(
                                                  hintText:
                                                      "Please Scan Batch Serial No.",
                                                  fillColor: Color.fromARGB(
                                                      255, 215, 243, 207),
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
                                                          otherParameterS9Controller645
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
                                                    return 'Please Scan Batch Serial No.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: true,
                                                    groupValue:
                                                        otherParameterS9TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS9TestValue645 =
                                                              value!;
                                                          otherParameterS9RemarksControllers645
                                                              .text = '';
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Pass',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Radio(
                                                    value: false,
                                                    groupValue:
                                                        otherParameterS9TestValue645,
                                                    onChanged: (bool? value) {
                                                      if (status != 'Pending') {
                                                        setState(() {
                                                          otherParameterS9TestValue645 =
                                                              value!;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    'Fail',
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              if (otherParameterS9TestValue645 ==
                                                  false)
                                                const SizedBox(height: 8),
                                              if (otherParameterS9TestValue645 ==
                                                  false)
                                                TextFormField(
                                                  controller:
                                                      otherParameterS9RemarksControllers645,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Please Enter Remarks",
                                                    fillColor: Color.fromARGB(
                                                        255, 215, 243, 207),
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
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Divider(),
                                              const SizedBox(
                                                height: 10,
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
                                                        _physicalFormKey
                                                            .currentState!.save;
                                                        if (_physicalFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          setState(() {
                                                            setPage = 'result';
                                                          });

                                                          // Dynamic Start......

                                                          // Dynamic  End......

                                                          if (status !=
                                                              'Pending') {
                                                            setState(() {
                                                              sendStatus =
                                                                  'Inprogress';
                                                            });
                                                            createData();
                                                          }
                                                        }
                                                      },
                                                      label: "Next",
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
                                                        setPage = "S2";
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
                                  : setPage == "result"
                                      ? Stack(
                                          alignment: Alignment.center,
                                          fit: StackFit.expand,
                                          children: [
                                            SingleChildScrollView(
                                                child: Form(
                                              key: _resultFormKey,
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
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          child: Text("FQC",
                                                              style: TextStyle(
                                                                  fontSize: 27,
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontFamily:
                                                                      appFontFamily,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)))),
                                                  const Center(
                                                      child: Text("(PV Module)",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: AppColors
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
                                                        'GSPL/FQC/PDI/002',
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
                                                        'Ver.1.0 / 12-08-2023',
                                                        style: AppStyles
                                                            .textfieldCaptionTextStyle,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  const Center(
                                                      child: Text("Result",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      6,
                                                                      2,
                                                                      240),
                                                              fontFamily:
                                                                  appFontFamily,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700))),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Radio(
                                                        value: "Pass",
                                                        groupValue: result,
                                                        onChanged: (val) {
                                                          if (status !=
                                                              'Pending') {
                                                            setState(() {
                                                              result = val;
                                                              rejectionReasonController
                                                                  .text = '';
                                                              packagingRejection =
                                                                  false;
                                                              visualRejection =
                                                                  false;
                                                              physicalRejection =
                                                                  false;
                                                              // frontbusRejection =
                                                              //     false;
                                                              // electricalRejection = false;
                                                              //  performanceRejection = false;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                      Text(
                                                        'Pass',
                                                        style: AppStyles
                                                            .textfieldCaptionTextStyle,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Radio(
                                                        value: "Fail",
                                                        groupValue: result,
                                                        onChanged: (val) {
                                                          if (status !=
                                                              'Pending') {
                                                            setState(() {
                                                              result = val;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                      Text(
                                                        'Fail',
                                                        style: AppStyles
                                                            .textfieldCaptionTextStyle,
                                                      ),
                                                    ],
                                                  ),
                                                  if (result == "Fail")
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  if (result ==
                                                      "Fail")
                                                    const Center(
                                                        child: Text(
                                                            "Rejection Note",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color:
                                                                    Color
                                                                        .fromARGB(
                                                                            255,
                                                                            238,
                                                                            5,
                                                                            5),
                                                                fontFamily:
                                                                    appFontFamily,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700))),
                                                  if (result == "Fail")
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Checkbox(
                                                          value:
                                                              packagingRejection,
                                                          onChanged: (value) {
                                                            if (status !=
                                                                'Pending') {
                                                              setState(() {
                                                                packagingRejection =
                                                                    value!;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        Text(
                                                          'S1',
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        Checkbox(
                                                          value:
                                                              visualRejection,
                                                          onChanged: (value) {
                                                            if (status !=
                                                                'Pending') {
                                                              setState(() {
                                                                visualRejection =
                                                                    value!;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        Text(
                                                          'S2',
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        Checkbox(
                                                          value:
                                                              physicalRejection,
                                                          onChanged: (value) {
                                                            if (status !=
                                                                'Pending') {
                                                              setState(() {
                                                                physicalRejection =
                                                                    value!;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        Text(
                                                          'S3',
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
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
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                  if (result == "Fail")
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                  if (result == "Fail")
                                                    TextFormField(
                                                      controller:
                                                          rejectionReasonController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                              hintText:
                                                                  "Please Enter Rejection Reason",
                                                              counterText: ''),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      maxLines: 3,
                                                      readOnly:
                                                          status == 'Pending'
                                                              ? true
                                                              : false,
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
                                                    "Upload Po Pdf*",
                                                    style: AppStyles
                                                        .textfieldCaptionTextStyle,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        cocPdfController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: AppStyles
                                                        .textFieldInputDecoration
                                                        .copyWith(
                                                            hintText:
                                                                "Please Select Po Pdf",
                                                            suffixIcon:
                                                                IconButton(
                                                              onPressed:
                                                                  () async {
                                                                if (widget.id !=
                                                                        null &&
                                                                    widget.id !=
                                                                        '' &&
                                                                    cocPdfController
                                                                            .text !=
                                                                        '') {
                                                                  UrlLauncher.launch(
                                                                      cocPdfController
                                                                          .text);
                                                                } else if (status !=
                                                                    'Pending') {
                                                                  _pickcocPDF();
                                                                }
                                                              },
                                                              icon: widget.id !=
                                                                          null &&
                                                                      widget.id !=
                                                                          '' &&
                                                                      cocPdfController
                                                                              .text !=
                                                                          ''
                                                                  ? const Icon(Icons
                                                                      .download)
                                                                  : const Icon(Icons
                                                                      .open_in_browser),
                                                            ),
                                                            counterText: ''),
                                                    style: AppStyles
                                                        .textInputTextStyle,
                                                    maxLines: 1,
                                                    readOnly: true,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Please Select Po Pdf";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 10, 0, 0)),
                                                  _isLoading
                                                      ? const Center(
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
                                                                _resultFormKey
                                                                    .currentState!
                                                                    .save;
                                                                if (_resultFormKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  if (status !=
                                                                      'Pending') {
                                                                    setState(
                                                                        () {
                                                                      sendStatus =
                                                                          'Pending';
                                                                    });
                                                                    createData();
                                                                  }
                                                                }
                                                              },
                                                              label: "Save",
                                                              organization: '',
                                                            )
                                                          : Container(),
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
                                                          const Center(
                                                              child: Text(
                                                                  "Approve/Reject Block",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          217,
                                                                          3,
                                                                          245),
                                                                      fontFamily:
                                                                          appFontFamily,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700))),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Radio(
                                                                value:
                                                                    "Approved",
                                                                groupValue:
                                                                    approvalStatus,
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    approvalStatus =
                                                                        val;
                                                                    rejectionReasonStatusController
                                                                        .text = '';
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                'Approved',
                                                                style: AppStyles
                                                                    .textfieldCaptionTextStyle,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Radio(
                                                                value:
                                                                    "Rejected",
                                                                groupValue:
                                                                    approvalStatus,
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    approvalStatus =
                                                                        val;
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                'Rejected',
                                                                style: AppStyles
                                                                    .textfieldCaptionTextStyle,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          if (approvalStatus ==
                                                              "Approved")
                                                            AppButton(
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
                                                                _resultFormKey
                                                                    .currentState!
                                                                    .save;
                                                                if (_resultFormKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  setApprovalStatus();
                                                                }
                                                              },
                                                              label: "Approved",
                                                              organization: '',
                                                            ),
                                                          if (approvalStatus ==
                                                              "Rejected")
                                                            TextFormField(
                                                              controller:
                                                                  rejectionReasonStatusController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              decoration: AppStyles
                                                                  .textFieldInputDecoration
                                                                  .copyWith(
                                                                      hintText:
                                                                          "Please Enter Rejection Reason",
                                                                      counterText:
                                                                          ''),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              maxLines: 3,
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return "Please Enter Rejection Reason";
                                                                } else {
                                                                  return null;
                                                                }
                                                              },
                                                            ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          if (approvalStatus ==
                                                              "Rejected")
                                                            AppButton(
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
                                                                _resultFormKey
                                                                    .currentState!
                                                                    .save;
                                                                if (_resultFormKey
                                                                    .currentState!
                                                                    .validate()) {
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
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _isLoading = false;
                                                            setPage = "S3";
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
                                      : Container(),
                ),
          floatingActionButton:
              status != 'Pending' && setPage != "heading" ? _getFAB() : null,
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
          //                     department == 'FQC' &&
          //                             designation != 'Super Admin'
          //                         ? FqcPage()
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
