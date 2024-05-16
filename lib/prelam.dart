import 'dart:convert';
import 'dart:io';
import 'package:QCM/Ipqc.dart';
import 'package:QCM/components/app_button_widget.dart';
import 'package:QCM/components/app_loader.dart';
import 'package:QCM/ipqcTestList.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:dio/src/response.dart' as Response;
import 'package:http/http.dart' as http;
import '../components/appbar.dart';
import '../constant/app_assets.dart';
import '../constant/app_color.dart';
import '../constant/app_fonts.dart';
import '../constant/app_helper.dart';
import '../constant/app_styles.dart';

class PreCard extends StatefulWidget {
  final String? id;
  PreCard({this.id});
  @override
  _PreCardState createState() => _PreCardState();
}

class _PreCardState extends State<PreCard> {
  final _preLamFormKey = GlobalKey<FormState>();
  TextEditingController DayController = TextEditingController();
  TextEditingController shiftController = TextEditingController();
  TextEditingController lineController = TextEditingController();
  TextEditingController PoController = TextEditingController();
  //1. Glass Loader
  TextEditingController GlassLoaderFreqquency1Controller =
      TextEditingController();
  TextEditingController GlassLoaderGlassDimensionController =
      TextEditingController();
  TextEditingController GlassLoaderCriteria1Controller =
      TextEditingController();
  TextEditingController GlassLoaderFrequency2Controller =
      TextEditingController();
  TextEditingController GlassLoaderAvaibilityController =
      TextEditingController();
  TextEditingController GlassLoaderCriteria2Controller =
      TextEditingController();
  TextEditingController GlassLoaderRemarkController = TextEditingController();
  //2.  Glass side EVA cutting machine
  TextEditingController GlassEVAFrequency1Controller = TextEditingController();
  TextEditingController GlassEVADimensionController = TextEditingController();
  TextEditingController GlassEVACriteria1Controller = TextEditingController();
  TextEditingController GlasCuttingFrequencyController =
      TextEditingController();
  TextEditingController GlasCuttingEdgeController = TextEditingController();
  TextEditingController GlasCuttingCriteriaController = TextEditingController();
  TextEditingController GlasPositionFrequencyController =
      TextEditingController();
  TextEditingController GlasPositionFrontController = TextEditingController();
  TextEditingController GlasPositionCriteriaController =
      TextEditingController();
  TextEditingController GlasAvabilityFrequencyController =
      TextEditingController();
  TextEditingController GlasAvabilitySpecificationController =
      TextEditingController();
  TextEditingController GlasAvabilityCriteriaController =
      TextEditingController();
  TextEditingController GlasSideRemarkController = TextEditingController();
  //3. Temperature & Relative humidity(%RH) monitoring
  TextEditingController TempShopFrequencyController = TextEditingController();
  TextEditingController TempShopFloorController = TextEditingController();
  TextEditingController TempShopCriteriaController = TextEditingController();
  TextEditingController TempRelativeFrequencyController =
      TextEditingController();
  TextEditingController TempRelativeHumidityController =
      TextEditingController();
  TextEditingController TempRelativeCriteriaController =
      TextEditingController();
  TextEditingController TemperatureRemarkController = TextEditingController();
  //4. Cell Cutting Machine
  TextEditingController CellSizeFrequencyController = TextEditingController();
  TextEditingController CellSizelengthController = TextEditingController();
  TextEditingController CellSizeCriteriaController = TextEditingController();
  TextEditingController CellManufactureFrequencyController =
      TextEditingController();
  TextEditingController CellManufactureEffController = TextEditingController();
  TextEditingController CellManufactureCriteriaController =
      TextEditingController();
  TextEditingController CellcolorFrequencyController = TextEditingController();
  TextEditingController CellcolorController = TextEditingController();
  TextEditingController CellcolorCriteriaController = TextEditingController();
  TextEditingController CellAvabilityofFrequencyController =
      TextEditingController();
  TextEditingController CellAvabilityofSpecificationController =
      TextEditingController();
  TextEditingController CellAvabilityofCriteriaController =
      TextEditingController();
  TextEditingController CellCuttingRemarkController = TextEditingController();
  //5. Cell Loading
  TextEditingController CellLoadingcellFrequencyController =
      TextEditingController();
  TextEditingController CellLoadingcellColorController =
      TextEditingController();
  TextEditingController CellLoadingcellCriteriaController =
      TextEditingController();
  TextEditingController CellLoadingCleanFrequencyController =
      TextEditingController();
  TextEditingController CellLoadingCleanLinessController =
      TextEditingController();
  TextEditingController CellLoadingCleanCriteriaController =
      TextEditingController();
  TextEditingController CellLoadingWIFrequencyController =
      TextEditingController();
  TextEditingController CellLoadingWIController = TextEditingController();
  TextEditingController CellLoadingWICriteriaController =
      TextEditingController();
  TextEditingController CellLoadingAvabilityFrequencyController =
      TextEditingController();
  TextEditingController CellLoadingAvabilityController =
      TextEditingController();
  TextEditingController CellLoadingAvabilityCriteriaController =
      TextEditingController();
  TextEditingController CellLoadingVerificationFrequencyController =
      TextEditingController();
  TextEditingController CellLoadingVerificationController =
      TextEditingController();
  TextEditingController CellLoadingVerificationCriteriaController =
      TextEditingController();
  // ** Entert the number of the Stringer ****
  TextEditingController CellLoadingStringFrequencyController =
      TextEditingController();
  TextEditingController CellLoadingnumberOfStringerController =
      TextEditingController();
  List<TextEditingController> cellLoaderVerificationControllers = [];
  // TextEditingController LoadstrinGapController = TextEditingController();
  TextEditingController cellLoaderStringCriteriaController =
      TextEditingController();
  TextEditingController cellLoaderRemarkController = TextEditingController();
  //6. Tabber & Stringer
  TextEditingController TabberVisualFrequencyController =
      TextEditingController();
  TextEditingController TabberVisualnumberOfStringersController =
      TextEditingController();
  List<TextEditingController> TabberVisualStringerControllers = [];
  TextEditingController TabberVisualCriteriaController =
      TextEditingController();
  TextEditingController TabberEIimageFrequencyController =
      TextEditingController();
  TextEditingController tabberEIimagenumberOfStringersController =
      TextEditingController();
  List<TextEditingController> TabberEIimageofStringerControllers = [];
  TextEditingController TabberEIimageCriteriaController =
      TextEditingController();
  TextEditingController TabberVerificationFrequencyController =
      TextEditingController();
  TextEditingController TabberVerificationNumberofstringController =
      TextEditingController();
  List<TextEditingController> TabberVerificationofsilderingControllers = [];
  TextEditingController TabberVerificationCriteriaController =
      TextEditingController();
  TextEditingController TabberAvaibilityFrequencyController =
      TextEditingController();
  TextEditingController TabberAvabilityofSpecificationController =
      TextEditingController();
  TextEditingController TabberAvabilityofCriteriaController =
      TextEditingController();
  //-- reamrk for the Tabber
  TextEditingController TabberstringerRemarkController =
      TextEditingController();

  //7. Auto String Layup
  TextEditingController AutoCellFrequencyController = TextEditingController();
  TextEditingController AutoCellController = TextEditingController();
  TextEditingController AutoCellCriteriaController = TextEditingController();
  TextEditingController AutoStringFrequencyController = TextEditingController();
  TextEditingController AutoStringController = TextEditingController();
  TextEditingController AutoStringCriteriaController = TextEditingController();
  TextEditingController AutoCelledgeFrequencyController =
      TextEditingController();
  TextEditingController AutoCelledController = TextEditingController();
  TextEditingController AutoCellEdgeCriteriaController =
      TextEditingController();
  TextEditingController AutoStringerRemarkController = TextEditingController();
  //8. Auto Bussing & Tapping
  TextEditingController AutoSolderingFrequencyController =
      TextEditingController();
  TextEditingController AutoSolderingController = TextEditingController();
  TextEditingController AutoSolderingCriteriaController =
      TextEditingController();

  TextEditingController AutoTerminalFrequencyController =
      TextEditingController();
  TextEditingController AutoTerminalStringController = TextEditingController();
  TextEditingController AutoTerminalCriteriaController =
      TextEditingController();

  TextEditingController AutoSolderingQualityFrequencyController =
      TextEditingController();
  TextEditingController AutoSolderingQualityController =
      TextEditingController();
  TextEditingController AutoSolderingQualityCriteriaController =
      TextEditingController();

  TextEditingController AutoClearanceFrequencyController =
      TextEditingController();
  TextEditingController AutoClearanceController = TextEditingController();
  TextEditingController AutoClearanceCriteriaController =
      TextEditingController();

  TextEditingController AutoPositionFrequencyController =
      TextEditingController();
  TextEditingController AutoPositionController = TextEditingController();
  TextEditingController AutoPositionCriteriaController =
      TextEditingController();

  TextEditingController AutoTopFrequencyController = TextEditingController();
  TextEditingController AutoTopController = TextEditingController();
  TextEditingController AutoTopCriteriaController = TextEditingController();

  TextEditingController AutoqualityofFrequencyController =
      TextEditingController();
  TextEditingController AutoQualityController = TextEditingController();
  TextEditingController AutoQualityCriteriaController = TextEditingController();

  TextEditingController AutoAvaibilityFrequencyController =
      TextEditingController();
  TextEditingController AutoAvaibilityController = TextEditingController();
  TextEditingController AutoAvaibilityCriteriaController =
      TextEditingController();

  TextEditingController AutoBussingRemarkController = TextEditingController();
  // 9. EVA/Backsheet Cutting
  TextEditingController EVARearFrequencyController = TextEditingController();
  TextEditingController EVARearController = TextEditingController();
  TextEditingController EVARearCriteriaController = TextEditingController();

  TextEditingController EVABackFrequencyController = TextEditingController();
  TextEditingController EVABackController = TextEditingController();
  TextEditingController EVABackCriteriaController = TextEditingController();

  TextEditingController EVACuttingFrequencyController = TextEditingController();
  TextEditingController EVAcuttingController = TextEditingController();
  TextEditingController EVACuttingCriteriaController = TextEditingController();

  TextEditingController EVAPositionFrequencyController =
      TextEditingController();
  TextEditingController EVAPositionController = TextEditingController();
  TextEditingController EVAPositionCriteriaController = TextEditingController();

  TextEditingController EVAAvaibilityFrequencyController =
      TextEditingController();
  TextEditingController EVAAvaibilityController = TextEditingController();
  TextEditingController EVAAvaibilityCriteriaController =
      TextEditingController();

  TextEditingController EVABacksheetRemarkController = TextEditingController();

  // 10. Pre Lamination El & Visual inspection
  TextEditingController PreLaminationEIinspectionFrequencyController =
      TextEditingController();
  TextEditingController PreLaminationEInumberOfStringersController =
      TextEditingController();
  List<TextEditingController> PreLaminationEIinspectionrControllers = [];
  TextEditingController PreLaminationEIinspectionCriteriaController =
      TextEditingController();

  TextEditingController PreLaminationVisualFrequencyController =
      TextEditingController();
  TextEditingController PreLaminationVisualnumberOfStringersController =
      TextEditingController();
  List<TextEditingController> PreLaminationVisualinspectionrControllers = [];
  TextEditingController PreLaminationVisualinspectionCriteriaController =
      TextEditingController();

  TextEditingController PreLaminationAvaibilityFrequencyController =
      TextEditingController();
  TextEditingController PreLaminationAvaibilityController =
      TextEditingController();
  TextEditingController PreLaminationAvaibilityWIController =
      TextEditingController();

  TextEditingController PreLaminationELRemarkController =
      TextEditingController();
  // 11. String Rework Station
  TextEditingController StringAvaibilityFrequencyController =
      TextEditingController();
  TextEditingController StringAvaibilityController = TextEditingController();
  TextEditingController StringAvaibilityCriteriaController =
      TextEditingController();

  TextEditingController StringCleaningFrequencyController =
      TextEditingController();
  TextEditingController StringCleaningController = TextEditingController();
  TextEditingController StringCleaningCriteriaController =
      TextEditingController();

  TextEditingController StringReworkRemarkController = TextEditingController();

  // 12. Module Rework Station
  TextEditingController ModuleAvaibilityFrequencyController =
      TextEditingController();
  TextEditingController ModuleAvaibilityController = TextEditingController();
  TextEditingController ModuleAvaibilityCriteriaController =
      TextEditingController();

  TextEditingController ModuleMethodCleaningFrequencyController =
      TextEditingController();
  TextEditingController ModuleMethodCleaningController =
      TextEditingController();
  TextEditingController ModuleMethodCleaningCriteriaController =
      TextEditingController();

  TextEditingController ModuleHandlingFrequencyController =
      TextEditingController();
  TextEditingController ModuleHandlingController = TextEditingController();
  TextEditingController ModuleHandlingCriteriaController =
      TextEditingController();

  TextEditingController ModuleCleaningofReworkFrequencyController =
      TextEditingController();
  TextEditingController ModuleCleaningofReworkController =
      TextEditingController();
  TextEditingController ModuleCleaningofReworkCriteriaController =
      TextEditingController();

  TextEditingController ModuleCleaningRemarkController =
      TextEditingController();

  // 13. Laminator
  TextEditingController LaminatorMonitoringFrequencyController =
      TextEditingController();
  TextEditingController LaminatorMonitoringController = TextEditingController();
  TextEditingController LaminatorMonitoringCriteriaController =
      TextEditingController();

  TextEditingController LaminatorAdhesiveFrequencyController =
      TextEditingController();
  TextEditingController LaminatorAdhesiveController = TextEditingController();
  TextEditingController LaminatorAdhesiveCriteriaController =
      TextEditingController();

  TextEditingController LaminatorPeelFrequencyController =
      TextEditingController();
  TextEditingController LaminatorPeelController = TextEditingController();
  TextEditingController LaminatorPeelCriteriaController =
      TextEditingController();

  TextEditingController LaminatorGelFrequencyController =
      TextEditingController();
  TextEditingController LaminatorGelController = TextEditingController();
  TextEditingController LaminatorGelCriteriaController =
      TextEditingController();

  TextEditingController LaminatorRemarkController = TextEditingController();
  TextEditingController referencePdfController = TextEditingController();

  bool menu = false, user = false, face = false, home = false;
  int numberOfStringers = 0;
  int numberOfStringers1 = 0;
  int numberOfStringers2 = 0;
  int numberOfStringers4 = 0;
  int numberOfStringers5 = 0;
  int numberOfStringers6 = 0;
  bool _isLoading = false;
  String setPage = '', pic = '', site = '', personid = '';
  String invoiceDate = '';
  String dateOfQualityCheck = '';
  bool? isCycleTimeTrue;
  String sendStatus = '';
  String status = '',
      prelamId = '',
      approvalStatus = "Approved",
      designation = '',
      token = '',
      department = '';
  final _dio = Dio();
  Response.Response? _response;
  List data = [];
  List<int>? referencePdfFileBytes;

  List sample1Controller = [];
  List sample2Controller = [];
  List sample3Controller = [];
  List sample4Controller = [];
  List sample5Controller = [];
  List sample6Controller = [];

  List cellLoadingInputtext = [];
  List tabberVisual = [];
  List tabberEI = [];
  List tabberVerification = [];
  List preLaminationEi = [];
  List preLaminationVisual = [];

  void addControllers(int count) {
    for (int i = 0; i < count; i++) {
      cellLoaderVerificationControllers.add(TextEditingController());

      if (widget.id != "" &&
          widget.id != null &&
          cellLoadingInputtext.length > 0) {
        cellLoaderVerificationControllers[i].text = cellLoadingInputtext[i]
            ['cellLoaderVerificationControllers${i + 1}'];
      }
    }
  }

  void addTabberVisualControllers(int count) {
    for (int i = 0; i < count; i++) {
      TabberVisualStringerControllers.add(TextEditingController());
      if (widget.id != "" && widget.id != null && tabberVisual.length > 0) {
        TabberVisualStringerControllers[i].text =
            tabberVisual[i]['TabberVisualStringerControllers${i + 1}'];
      }
    }
  }

  void addTabberEImageControllers(int count) {
    for (int i = 0; i < count; i++) {
      TabberEIimageofStringerControllers.add(TextEditingController());
      if (widget.id != "" && widget.id != null && tabberEI.length > 0) {
        TabberEIimageofStringerControllers[i].text =
            tabberEI[i]['TabberEIimageofStringerControllers${i + 1}'];
      }
    }
  }

  void addTabberVerificationControllers(int count) {
    for (int i = 0; i < count; i++) {
      TabberVerificationofsilderingControllers.add(TextEditingController());
      if (widget.id != "" &&
          widget.id != null &&
          tabberVerification.length > 0) {
        TabberVerificationofsilderingControllers[i].text = tabberVerification[i]
            ['TabberVerificationofsilderingControllers${i + 1}'];
      }
    }
  }

  void addPreLaminationEIControllers(int count) {
    for (int i = 0; i < count; i++) {
      PreLaminationEIinspectionrControllers.add(TextEditingController());
      if (widget.id != "" && widget.id != null && preLaminationEi.length > 0) {
        PreLaminationEIinspectionrControllers[i].text =
            preLaminationEi[i]['PreLaminationEIinspectionrControllers${i + 1}'];
      }
    }
  }

  void addPreLaminationVisualControllers(int count) {
    for (int i = 0; i < count; i++) {
      PreLaminationVisualinspectionrControllers.add(TextEditingController());
      if (widget.id != "" &&
          widget.id != null &&
          preLaminationVisual.length > 0) {
        PreLaminationVisualinspectionrControllers[i].text =
            preLaminationVisual[i]
                ['PreLaminationVisualinspectionrControllers${i + 1}'];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      // 1. Glass Loader
      GlassLoaderFreqquency1Controller.text = "Once a Shift";
      GlassLoaderCriteria1Controller.text =
          "Refer Production Order & Module Drawing";
      GlassLoaderFrequency2Controller.text = "Once a Shift";
      GlassLoaderCriteria2Controller.text =
          "Avability of WI & Operator Should be aware with WI";

      // 2. Glass side EVA Cutting
      GlassEVAFrequency1Controller.text = "Once a Shift";
      GlassEVACriteria1Controller.text =
          "Refer Production order & Module Drawing";
      GlasCuttingFrequencyController.text = "Once a Shift";
      GlasCuttingCriteriaController.text = "Should not be uneven";

      GlasPositionFrequencyController.text = "Once a Shift";
      GlasPositionCriteriaController.text =
          "Shifting of EVA on Glass not allowed";

      GlasAvabilityFrequencyController.text = "Once a Shift";
      GlasAvabilityCriteriaController.text =
          "Avability of Specification and WI & operator should be aware with specification";

      // 3. Temperature & Relative
      TempShopFrequencyController.text = "Once a Shift";
      TempShopCriteriaController.text = "Temperature: 25+/- °C";

      TempRelativeFrequencyController.text = "Once per Shift";
      TempRelativeCriteriaController.text = "Humidity(%RH)<= 60%";

      // 4. Cell Cutting Machine
      CellSizeFrequencyController.text = "Thrice per shift";
      CellSizeCriteriaController.text = "Refere Production Order";

      CellManufactureFrequencyController.text = "Thrice per Shift";
      CellManufactureCriteriaController.text = "Refer Production Order";

      CellcolorFrequencyController.text = "Thrice per Shift";
      CellcolorCriteriaController.text =
          "Proper Segregation should be done as per color mixing not allowed";

      CellAvabilityofFrequencyController.text = "Once a Shift";
      CellAvabilityofCriteriaController.text =
          "Avaibility of Specification and WI & operator Should be aware with specification ";

      // 5. Cell Loading
      CellLoadingcellFrequencyController.text = "Thrice per Shift";
      CellLoadingcellCriteriaController.text =
          "Different Color of cell loading at a time not allowed";

      CellLoadingCleanFrequencyController.text = "Once per Shift";
      CellLoadingCleanCriteriaController.text =
          "no unwanted or waste material should be near cell Loading Area";

      CellLoadingWIFrequencyController.text = "Once Per Shift";
      CellLoadingWICriteriaController.text = "As per WI";

      CellLoadingAvabilityFrequencyController.text = "Once per Shift ";
      CellAvabilityofCriteriaController.text =
          "Avability of WI & Operator should be aware with WI";

      CellLoadingVerificationFrequencyController.text = "Once per Shift";
      CellLoadingVerificationCriteriaController.text =
          "As pe Machine per Specification ";

      CellLoadingStringFrequencyController.text = "5 string/stringer/shift ";
      cellLoaderStringCriteriaController.text =
          "Refer Production Order 7 Module Drawing";

      // 6. Tabber & Stringer
      TabberVisualFrequencyController.text = "5 string/stringer/shift ";
      TabberVisualCriteriaController.text = "As per pre Lam Visual Criteria";

      TabberEIimageFrequencyController.text = "5 string/stringer/shift ";
      TabberEIimageCriteriaController.text = "As per pre Lam EI Criteria ";

      TabberVerificationFrequencyController.text = "2 string/stringer/shift ";
      TabberVerificationCriteriaController.text =
          ">=0.5N  |  Refer:GSPL/IPQC/GP/001";
      TabberAvaibilityFrequencyController.text = "Once per Shift";
      TabberAvabilityofCriteriaController.text =
          "Avaibility of specification and wi & operator should be aware with specification";

      // 7. Auto String Layup
      AutoCellFrequencyController.text = "Once per Shift";
      AutoCellCriteriaController.text = "None";

      AutoStringFrequencyController.text = "Once per Shift";
      AutoStringCriteriaController.text = "None";

      AutoCelledgeFrequencyController.text = "Once per Shift";
      AutoCellEdgeCriteriaController.text = "None";

      // 8. Auto Bussing & Tapping
      AutoSolderingFrequencyController.text = "Once per Shift";
      AutoSolderingCriteriaController.text = ">=4N | Refer";

      AutoTerminalFrequencyController.text = "Once per Shift";
      AutoTerminalCriteriaController.text = "As per respective Layup Drawing";

      AutoSolderingQualityFrequencyController.text = "Thrice per Shift";
      AutoSolderingQualityCriteriaController.text = "No Dry Soldering";

      AutoClearanceFrequencyController.text = "Thrice per Shift";
      AutoClearanceCriteriaController.text =
          "Should not be 2mm-4mm gapfrom the cell to the patch";

      AutoPositionFrequencyController.text = "Thrice per Shift";
      AutoPositionCriteriaController.text =
          "Shiould not be tilt,Busbar should not visible";

      AutoTopFrequencyController.text = "Thrice per Shift";
      AutoTopCriteriaController.text = "creepage distance should be 16+-1mm";

      AutoqualityofFrequencyController.text = "Once per Shift";
      AutoQualityCriteriaController.text =
          "No poor taping,cell shifting,cell breakage";

      AutoAvaibilityFrequencyController.text = "Once per Shift";
      AutoAvaibilityCriteriaController.text =
          "Avaibility of specification & WI & operator should be aware of specification ";

      // 9. EVA/Backsheet Cutting
      EVARearFrequencyController.text = "Once per Shift";
      EVARearCriteriaController.text =
          "As per Specification GSPL/EVA(IQC)/001 & production order";

      EVABackFrequencyController.text = "Once per Shift";
      EVABackCriteriaController.text =
          "As per Specification GSPL/BS(IQC)/001 & production order";

      EVACuttingFrequencyController.text = "Once per Shift";
      EVACuttingCriteriaController.text = "Should not be uneven";

      EVAPositionFrequencyController.text = "Once per Shift";
      EVAPositionCriteriaController.text =
          "Shifting of EVA on Glass not allowed";

      EVAAvaibilityFrequencyController.text = "Once per Shift";
      EVAAvaibilityCriteriaController.text =
          "Avaibility of Specification & WI & operator should be";

      // 10. Pre Lamination El & Visual inspection
      PreLaminationEIinspectionFrequencyController.text = "5 Pieces Per Shift ";
      PreLaminationEIinspectionCriteriaController.text =
          "EI image should fulfil the EL Acceptance Critoria ";

      PreLaminationVisualFrequencyController.text = "5 Pieces Per Shift ";
      PreLaminationVisualinspectionCriteriaController.text =
          "Visual image should fulfil the Visual Acceptance Critoria as per GSPL/IPQC/EL/020";

      PreLaminationAvaibilityFrequencyController.text = "Once per Shift";
      PreLaminationAvaibilityWIController.text =
          "Avaibility of Acceptance Criteria and operator should be aware of Criteria";

      // 11. String Rework Station
      StringAvaibilityFrequencyController.text = "Once per Shift";
      StringAvaibilityCriteriaController.text =
          "WI Should be available at station and operator should be aware of WI";

      StringCleaningFrequencyController.text = "Once per Shift";
      StringCleaningCriteriaController.text = "Rework Station should be Clean";

      // 12. Module Rework Station
      ModuleAvaibilityFrequencyController.text = "Once per Shift";
      ModuleAvaibilityCriteriaController.text =
          "WI Should be available at station and operator should be aware of WI";

      ModuleMethodCleaningFrequencyController.text = "Once per Shift";
      ModuleMethodCleaningCriteriaController.text = "As per WI";

      ModuleHandlingFrequencyController.text = "Once per Shift";
      ModuleHandlingCriteriaController.text =
          "Operator Should handle the rework module with both the Hands";

      ModuleCleaningofReworkFrequencyController.text = "Once per Shift";
      ModuleCleaningofReworkCriteriaController.text =
          "Rework station should be clean";
      // 13. Laminator
      LaminatorMonitoringFrequencyController.text = "Once per Shift";
      LaminatorMonitoringCriteriaController.text =
          "Laminator specification GSPL/IPQC/LM/008 |  GSPL/IPQC/LM/009 |  GSPL/IPQC/LM/010";

      LaminatorAdhesiveFrequencyController.text = "Once per Shift";
      LaminatorAdhesiveCriteriaController.text =
          "Teflon should be clean, No EVA residue is allowed ";

      LaminatorPeelFrequencyController.text =
          "All Position | All Laminator Once a Week";
      LaminatorPeelCriteriaController.text =
          "Eva to Glass = 70N/cm EVA to Backsheet >= 80N/cm";

      LaminatorGelFrequencyController.text =
          " All Position | All Laminator once a week ";
      LaminatorGelCriteriaController.text = "75 to 95% ";
    });
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
    final AllSolarData = ((site!) + 'IPQC/GetSpecificPreLam');
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
          DayController.text = resBody['response']['Date'] != ''
              ? DateFormat("EEE MMM dd, yyyy").format(
                  DateTime.parse(resBody['response']['Date'].toString()))
              : '';
          shiftController.text = resBody['response']['Shift'] ?? '';
          lineController.text = resBody['response']['Line'] ?? '';
          PoController.text = resBody['response']['PONo'] ?? '';
          // Glass Loader
          GlassLoaderGlassDimensionController.text = resBody['response']
                      ['GlassLoaderCheckPoint']
                  ['Glass dimension(LengthxWidthxThickness)'] ??
              '';
          GlassLoaderAvaibilityController.text = resBody['response']
                  ['GlassLoaderCheckPoint']['Avaibility of WI'] ??
              '';
          GlassLoaderRemarkController.text =
              resBody['response']['GlassLoaderRemark'] ?? '';

          // Glass Side Eva
          GlassEVADimensionController.text = resBody['response']
                      ['GlasssideEVAcuttingmachineCheckPoint']
                  ['EVA dimension{LengthxWidthxThickness}'] ??
              '';
          GlasCuttingEdgeController.text = resBody['response']
                      ['GlasssideEVAcuttingmachineCheckPoint']
                  ['Cutting Edge EVA '] ??
              '';
          GlasPositionFrontController.text = resBody['response']
                      ['GlasssideEVAcuttingmachineCheckPoint']
                  ['Position of front EVA'] ??
              '';
          GlasAvabilitySpecificationController.text = resBody['response']
                      ['GlasssideEVAcuttingmachineCheckPoint']
                  ['Avability of Specification & WI'] ??
              '';
          GlasSideRemarkController.text =
              resBody['response']['GlasssideEVAcuttingmachineRemark'] ?? '';

          // Tempreture And Relatives
          TempShopFloorController.text = resBody['response']
                      ['Temperature&Relativehumidity(%RH)monitoringCheckPoint']
                  ['shop floor Temperature condition'] ??
              '';
          TempRelativeHumidityController.text = resBody['response']
                      ['Temperature&Relativehumidity(%RH)monitoringCheckPoint']
                  ['Relative humidity(%RH)in shop floor'] ??
              '';
          TemperatureRemarkController.text = resBody['response']
                  ['Temperature&Relativehumidity(%RH)monitoringRemark'] ??
              '';

          // Cell Cutting machine
          CellSizelengthController.text = resBody['response']
                  ['CellcuttingmachineCheckPoint']['cell Size'] ??
              '';
          CellManufactureEffController.text = resBody['response']
                  ['CellcuttingmachineCheckPoint']['Cell manufacture & Eff.'] ??
              '';
          CellcolorController.text = resBody['response']
                  ['CellcuttingmachineCheckPoint']['cell color '] ??
              '';
          CellAvabilityofSpecificationController.text = resBody['response']
                      ['CellcuttingmachineCheckPoint']
                  ['Avability of Specification & WI.'] ??
              '';
          CellCuttingRemarkController.text =
              resBody['response']['CellcuttingmachineRemark'] ?? '';

          // Cell Loading
          CellLoadingcellColorController.text =
              resBody['response']['CellLoadingCheckPoint']['cellcolor'] ?? '';
          CellLoadingCleanLinessController.text = resBody['response']
                      ['CellLoadingCheckPoint']
                  ['cleanlines of cell Loading Area '] ??
              '';
          CellLoadingWIController.text = resBody['response']
                  ['CellLoadingCheckPoint']['Cell loading as per WI'] ??
              '';
          CellLoadingAvabilityController.text = resBody['response']
                  ['CellLoadingCheckPoint']['Avability of WI '] ??
              '';
          CellLoadingVerificationController.text = resBody['response']
                      ['CellLoadingCheckPoint']
                  ['Verification of process parameter'] ??
              '';
          // ---Dynamic Field Byend Data          (cell loading)
          CellLoadingnumberOfStringerController.text = resBody['response']
                          ['CellLoadingFrequency']
                      ['string length Number of String'] !=
                  ""
              ? resBody['response']['CellLoadingFrequency']
                  ['string length Number of String']
              : '';

          cellLoadingInputtext = resBody['response']['CellLoadingFrequency'][
                  'string length Number of String Number of Created Input text'] ??
              [];
          numberOfStringers =
              int.tryParse(CellLoadingnumberOfStringerController.text) ?? 0;
          addControllers(numberOfStringers * 5);
          cellLoaderRemarkController.text =
              resBody['response']['CellLoadingRemark'] ?? '';
          // Tabber and Stringer
          TabberVisualnumberOfStringersController.text = resBody['response']
                          ['Tabber&StringerFrequency']
                      ['Visual Check after stringer Number of Stringer'] !=
                  ""
              ? resBody['response']['Tabber&StringerFrequency']
                  ['Visual Check after stringer Number of Stringer']
              : '';

          tabberVisual = resBody['response']['Tabber&StringerFrequency'][
                  'Visual Check after stringer Number of Created Input text '] ??
              [];
          numberOfStringers1 =
              int.tryParse(TabberVisualnumberOfStringersController.text) ?? 0;
          addTabberVisualControllers(numberOfStringers1 * 5);
          // second Dynamic
          tabberEIimagenumberOfStringersController.text = resBody['response']
                          ['Tabber&StringerFrequency']
                      ['EI image of string  Number of Stringer '] !=
                  ""
              ? resBody['response']['Tabber&StringerFrequency']
                  ['EI image of string  Number of Stringer ']
              : '';

          tabberEI = resBody['response']['Tabber&StringerFrequency']
                  ['EI image of string  Number of Created Input text '] ??
              [];

          numberOfStringers2 =
              int.tryParse(tabberEIimagenumberOfStringersController.text) ?? 0;
          addTabberEImageControllers(numberOfStringers2 * 5);
          // 3rd dynamic
          TabberVerificationNumberofstringController.text = resBody['response']
                          ['Tabber&StringerFrequency'][
                      'Verification of sildering peel strength  Number of Stringer '] !=
                  ""
              ? resBody['response']['Tabber&StringerFrequency'][
                  'Verification of sildering peel strength  Number of Stringer ']
              : '';

          tabberVerification = resBody['response']['Tabber&StringerFrequency'][
                  'Verification of sildering peel strength Created Inputtext'] ??
              [];

          numberOfStringers4 =
              int.tryParse(TabberVerificationNumberofstringController.text) ??
                  0;
          addTabberVerificationControllers(numberOfStringers4 * 2);
          TabberAvabilityofSpecificationController.text = resBody['response']
                      ['Tabber&StringerCheckPoint']
                  ['Avaibility os Specification & WI'] ??
              '';
          TabberstringerRemarkController.text =
              resBody['response']['Tabber&StringerRemark'] ?? '';

          // Auto String Layup
          AutoCellController.text = resBody['response']
                  ['AutoStringLayupCheckPoint']['Cell to cell gap'] ??
              '';
          AutoStringController.text = resBody['response']
                  ['AutoStringLayupCheckPoint']['String to string gap'] ??
              '';
          AutoCelledController.text = resBody['response']
                      ['AutoStringLayupCheckPoint']
                  ['cell edge to glass edge(Top,bottom & sides)'] ??
              '';
          AutoStringerRemarkController.text =
              resBody['response']['AutoStringLayupRemark'] ?? '';

          // Auto Bushing And Tapping
          AutoSolderingController.text = resBody['response']
                      ['AutoBussing&TappingCheckPoint'][
                  'Soldering Peel strength between Ribbon to bushbar interconnector'] ??
              '';
          AutoTerminalStringController.text = resBody['response']
                      ['AutoBussing&TappingCheckPoint']
                  ['Terminal busbar to edge of cell'] ??
              '';
          AutoSolderingQualityController.text = resBody['response']
                      ['AutoBussing&TappingCheckPoint']
                  ['soldering quality of Ribbon to busbar'] ??
              '';
          AutoClearanceController.text = resBody['response']
                      ['AutoBussing&TappingCheckPoint']
                  ['Clearance between RFID&Logo patch to cell in module'] ??
              '';
          AutoPositionController.text = resBody['response']
                      ['AutoBussing&TappingCheckPoint']
                  ['Position verification of RFID& Logo Patch on Module'] ??
              '';
          AutoTopController.text = resBody['response']
                      ['AutoBussing&TappingCheckPoint'][
                  'Top & Bottom Creepage Distance/Terminal busbar to Edge of Glass'] ??
              '';
          AutoQualityController.text = resBody['response']
                  ['AutoBussing&TappingCheckPoint']['quality of auto taping'] ??
              '';
          AutoAvaibilityController.text = resBody['response']
                      ['AutoBussing&TappingCheckPoint']
                  ['Avaibility of specification & WI'] ??
              '';
          AutoBussingRemarkController.text =
              resBody['response']['AutoBussing&TappingRemark'] ?? '';

          // Eva BackSheet
          EVARearController.text = resBody['response']
                      ['EVA/BacksheetcuttingCheckPoint']
                  ['Rear EVA dimension & sift cutting width(mm)'] ??
              '';
          EVABackController.text = resBody['response']
                      ['EVA/BacksheetcuttingCheckPoint']
                  ['Back-sheet dimension& slit cutting diameter'] ??
              '';
          EVAcuttingController.text = resBody['response']
                      ['EVA/BacksheetcuttingCheckPoint']
                  ['cutting Edge of Rear EVA & Backsheet on Glass'] ??
              '';
          EVAPositionController.text = resBody['response']
                      ['EVA/BacksheetcuttingCheckPoint']
                  ['Position of Back EVA & Backsheet on Glass'] ??
              '';
          EVAAvaibilityController.text = resBody['response']
                      ['EVA/BacksheetcuttingCheckPoint']
                  ['Avaibility of specification&wI.'] ??
              '';
          EVABacksheetRemarkController.text =
              resBody['response']['EVA/BacksheetcuttingRemark'] ?? '';

          // Pre LAmination El And Visual
          PreLaminationEInumberOfStringersController.text = resBody['response']
                          ['PrelaminationEL&VisualCheckPoint']
                      ['EI Inspection after stringer Number of Stringer'] !=
                  ""
              ? resBody['response']['PrelaminationEL&VisualCheckPoint']
                  ['EI Inspection after stringer Number of Stringer']
              : '';

          preLaminationEi = resBody['response']
                      ['PrelaminationEL&VisualCheckPoint'][
                  'EI Inspection after stringer Number of Created Input text '] ??
              [];

          numberOfStringers5 =
              int.tryParse(PreLaminationEInumberOfStringersController.text) ??
                  0;
          addPreLaminationEIControllers(numberOfStringers5 * 5);
          // Second Dynamic
          PreLaminationVisualnumberOfStringersController
              .text = resBody['response']['PrelaminationEL&VisualCheckPoint']
                      ['Visual inspection of string  Number of Stringer '] !=
                  ""
              ? resBody['response']['PrelaminationEL&VisualCheckPoint']
                  ['Visual inspection of string  Number of Stringer ']
              : '';

          preLaminationVisual = resBody['response']
                      ['PrelaminationEL&VisualCheckPoint'][
                  'Visual inspection of string  Number of Created Input text '] ??
              [];

          numberOfStringers6 = int.tryParse(
                  PreLaminationVisualnumberOfStringersController.text) ??
              0;
          addPreLaminationVisualControllers(numberOfStringers6 * 5);
          PreLaminationAvaibilityController.text = resBody['response']
                      ['PrelaminationEL&VisualCheckPoint']
                  ['Avaibility of acceptance criteria & WI'] ??
              '';
          PreLaminationELRemarkController.text =
              resBody['response']['PrelaminationEL&VisualRemark'] ?? '';

          // String Rework Station
          StringAvaibilityController.text = resBody['response']
                      ['StringReworkstationCheckPoint']
                  ['Avaibility of work instruvtion(WI)'] ??
              '';
          StringCleaningController.text = resBody['response']
                      ['StringReworkstationCheckPoint']
                  ['Cleaning of Rework station/soldering iron sponge'] ??
              '';
          StringReworkRemarkController.text =
              resBody['response']['StringReworkstationRemark'] ?? '';

          // Modal Rework
          ModuleAvaibilityController.text = resBody['response']
                      ['ModuleReworkStationCheckPoint']
                  ['Avaibility of work instruvtion(WI)'] ??
              '';
          ModuleMethodCleaningController.text = resBody['response']
                  ['ModuleReworkStationCheckPoint']['Method of Rework'] ??
              '';
          ModuleHandlingController.text = resBody['response']
                  ['ModuleReworkStationCheckPoint']['Handling of Modules'] ??
              '';
          ModuleCleaningofReworkController.text = resBody['response']
                      ['ModuleReworkStationCheckPoint']
                  ['Cleaning of Rework station/soldering iron sponge'] ??
              '';
          ModuleCleaningRemarkController.text =
              resBody['response']['ModuleReworkStationRemark'] ?? '';

          // Laminator
          LaminatorMonitoringController.text = resBody['response']
                      ['LaminatorCheckPoint']
                  ['Monitoring of Laminator Process parameter'] ??
              '';
          LaminatorAdhesiveController.text = resBody['response']
                      ['LaminatorCheckPoint']
                  ['Adhesive on backsheet of the module'] ??
              '';
          LaminatorPeelController.text = resBody['response']
                  ['LaminatorCheckPoint']['Peel Adhesive Test'] ??
              '';
          LaminatorGelController.text = resBody['response']
                  ['LaminatorCheckPoint']['Gel Content Test'] ??
              '';
          LaminatorRemarkController.text =
              resBody['response']['LaminatorRemark'] ?? '';
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
        Toast.show("Pre Lam Test $approvalStatus .",
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

  uploadPDF(List<int> referenceBytes) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;

    var currentdate = DateTime.now().microsecondsSinceEpoch;
    var formData = FormData.fromMap({
      "JobCardDetailId": prelamId,
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

        Toast.show("PreLam Test Completed.",
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

  // **************  Send the Data where will be Used to Backend *****************

  Future sendDataToBackend() async {
    var data = [
      {
        "PreLamDetailId": prelamId != '' && prelamId != null
            ? prelamId
            : widget.id != '' && widget.id != null
                ? widget.id
                : '',
        "Type": "PreLam",
        "CurrentUser": personid,
        "Status": sendStatus,
        "DocNo": "GSPL/IPQC/IPC/003",
        "RevNo": "1.0 dated 12.08.2023",
        "Date": dateOfQualityCheck,
        "Shift": shiftController.text,
        "Line": lineController.text,
        "PONo": PoController.text
      },
      [
        {
          "Stage": "Glass Loader",
          "CheckPoint": {
            "Glass dimension(LengthxWidthxThickness)":
                GlassLoaderGlassDimensionController.text,
            "Avaibility of WI": GlassLoaderAvaibilityController.text,
          },
          "AcceptanceCriteria": {
            "Glass dimension(LengthxWidthxThickness)":
                GlassLoaderCriteria1Controller.text,
            "Avaibility of WI": GlassLoaderCriteria2Controller.text
          },
          "Frequency": {
            "Glass dimension(LengthxWidthxThickness)":
                GlassLoaderFreqquency1Controller.text,
            "Avaibility of WI": GlassLoaderFrequency2Controller.text
          },
          "Remark": GlassLoaderRemarkController.text
        },
        {
          "Stage": "Glass side EVA cutting machine",
          "CheckPoint": {
            "EVA dimension{LengthxWidthxThickness}":
                GlassEVADimensionController.text,
            "Cutting Edge EVA ": GlasCuttingEdgeController.text,
            "Position of front EVA": GlasPositionFrontController.text,
            "Avability of Specification & WI":
                GlasAvabilitySpecificationController.text
          },
          "AcceptanceCriteria": {
            "EVA dimension{LengthxWidthxThickness}":
                GlassEVACriteria1Controller.text,
            "Cutting Edge EVA ": GlasCuttingCriteriaController.text,
            "Position of front EVA": GlasPositionCriteriaController.text,
            "Avability of Specification & WI":
                GlasAvabilityCriteriaController.text
          },
          "Frequency": {
            "EVA dimension{LengthxWidthxThickness}":
                GlassEVAFrequency1Controller.text,
            "Cutting Edge EVA ": GlasCuttingFrequencyController.text,
            "Position of front EVA": GlasPositionFrequencyController.text,
            "Avability of Specification & WI":
                GlasAvabilityFrequencyController.text
          },
          "Remark": GlasSideRemarkController.text
        },
        {
          "Stage": "Temperature & Relative humidity(%RH)monitoring",
          "CheckPoint": {
            "shop floor Temperature condition": TempShopFloorController.text,
            "Relative humidity(%RH)in shop floor":
                TempRelativeHumidityController.text,
          },
          "AcceptanceCriteria": {
            "shop floor Temperature condition": TempShopCriteriaController.text,
            "Relative humidity(%RH)in shop floor":
                TempRelativeCriteriaController.text,
          },
          "Frequency": {
            "shop floor Temperature condition":
                TempShopFrequencyController.text,
            "Relative humidity(%RH)in shop floor":
                TempRelativeFrequencyController.text,
          },
          "Remark": TemperatureRemarkController.text
        },
        {
          "Stage": "Cell cutting machine",
          "CheckPoint": {
            "cell Size": CellSizelengthController.text,
            "Cell manufacture & Eff.": CellManufactureEffController.text,
            "cell color ": CellcolorController.text,
            "Avability of Specification & WI.":
                CellAvabilityofSpecificationController.text,
          },
          "AcceptanceCriteria": {
            "cell Size": CellSizeCriteriaController.text,
            "Cell manufacture & Eff.": CellManufactureCriteriaController.text,
            "cell color ": CellcolorCriteriaController.text,
            "Avability of Specification & WI.":
                CellAvabilityofCriteriaController.text,
          },
          "Frequency": {
            "cell Size": CellSizeFrequencyController.text,
            "Cell manufacture & Eff.": CellManufactureFrequencyController.text,
            "cell color ": CellcolorFrequencyController.text,
            "Avability of Specification & WI.":
                CellAvabilityofFrequencyController.text,
          },
          "Remark": CellCuttingRemarkController.text
        },
        {
          "Stage": "Cell Loading",
          "CheckPoint": {
            "cellcolor": CellLoadingcellColorController.text,
            "cleanlines of cell Loading Area ":
                CellLoadingCleanLinessController.text,
            "Cell loading as per WI": CellLoadingWIController.text,
            "Avability of WI ": CellLoadingAvabilityController.text,
            "Verification of process parameter":
                CellLoadingVerificationController.text,
            // "string length & cell to cell gap": LoadstrinGapController.text,
          },
          "AcceptanceCriteria": {
            "cell color": CellLoadingcellCriteriaController.text,
            "cleanlines of cell Loading Area ":
                CellLoadingCleanCriteriaController.text,
            "Cell loading as per WI": CellLoadingWICriteriaController.text,
            "Avability of WI ": CellLoadingAvabilityCriteriaController.text,
            "Verification of process parameter":
                CellLoadingVerificationCriteriaController.text,
            "string length & cell to cell gap":
                cellLoaderStringCriteriaController.text,
          },
          "Frequency": {
            "cell color": CellLoadingcellFrequencyController.text,
            "cleanlines of cell Loading Area ":
                CellLoadingCleanFrequencyController.text,
            "Cell loading as per WI": CellLoadingWIFrequencyController.text,
            "Avability of WI ": CellLoadingAvabilityFrequencyController.text,
            "Verification of process parameter":
                CellLoadingVerificationFrequencyController.text,
            "string length & cell to cell gap":
                CellLoadingStringFrequencyController.text,
            "string length Number of String":
                CellLoadingnumberOfStringerController.text,
            "string length Number of String Number of Created Input text":
                sample1Controller,
          },
          "Remark": cellLoaderRemarkController.text
        },
        {
          "Stage": "Tabber & Stringer",
          "CheckPoint": {
            // "Visual Check after stringer": TabberVisualCheckController.text,
            // "EI image of string": TabberEIimageCheckController.text,
            // "Verification of sildering peel strength":
            //     TabberVerificationCheckController.text,
            "Avaibility os Specification & WI":
                TabberAvabilityofSpecificationController.text,
          },
          "AcceptanceCriteria": {
            "Visual Check after stringer": TabberVisualCriteriaController.text,
            "EI image of string": TabberEIimageCriteriaController.text,
            "Verification of sildering peel strength":
                TabberVerificationCriteriaController.text,
            "Avaibility os Specification & WI":
                TabberAvabilityofCriteriaController.text,
          },
          "Frequency": {
            "Visual Check after stringer": TabberVisualFrequencyController.text,
            "Visual Check after stringer Number of Stringer":
                TabberVisualnumberOfStringersController.text,
            "Visual Check after stringer Number of Created Input text ":
                sample2Controller,
            "EI image of string": TabberEIimageFrequencyController.text,
            "EI image of string  Number of Stringer ":
                tabberEIimagenumberOfStringersController.text,
            "EI image of string  Number of Created Input text ":
                sample3Controller,
            "Verification of sildering peel strength":
                TabberVerificationFrequencyController.text,
            "Verification of sildering peel strength  Number of Stringer ":
                TabberVerificationNumberofstringController.text,
            "Verification of sildering peel strength Created Inputtext":
                sample4Controller,
            "Avaibility os Specification & WI":
                TabberAvaibilityFrequencyController.text,
          },
          "Remark": TabberstringerRemarkController.text
        },
        {
          "Stage": "Auto String Layup",
          "CheckPoint": {
            "Cell to cell gap": AutoCellController.text,
            "String to string gap": AutoStringController.text,
            "cell edge to glass edge(Top,bottom & sides)":
                AutoCelledController.text,
          },
          "AcceptanceCriteria": {
            "Cell to cell gap": AutoCellCriteriaController.text,
            "String to string gap": AutoStringCriteriaController.text,
            "cell edge to glass edge(Top,bottom & sides)":
                AutoCellEdgeCriteriaController.text,
          },
          "Frequency": {
            "Cell to cell gap": AutoCellFrequencyController.text,
            "String to string gap": AutoStringFrequencyController.text,
            "cell edge to glass edge(Top,bottom & sides)":
                AutoCelledgeFrequencyController.text,
          },
          "Remark": AutoStringerRemarkController.text
        },
        {
          "Stage": "Auto Bussing & Tapping",
          "CheckPoint": {
            "Soldering Peel strength between Ribbon to bushbar interconnector":
                AutoSolderingController.text,
            "Terminal busbar to edge of cell":
                AutoTerminalStringController.text,
            "soldering quality of Ribbon to busbar":
                AutoSolderingQualityController.text,
            "Clearance between RFID&Logo patch to cell in module":
                AutoClearanceController.text,
            "Position verification of RFID& Logo Patch on Module":
                AutoPositionController.text,
            "Top & Bottom Creepage Distance/Terminal busbar to Edge of Glass":
                AutoTopController.text,
            "quality of auto taping": AutoQualityController.text,
            "Avaibility of specification & WI": AutoAvaibilityController.text,
          },
          "AcceptanceCriteria": {
            "Soldering Peel strength between Ribbon to bushbar interconnector":
                AutoSolderingCriteriaController.text,
            "Terminal busbar to edge of cell":
                AutoTerminalCriteriaController.text,
            "soldering quality of Ribbon to busbar":
                AutoSolderingQualityCriteriaController.text,
            "Clearance between RFID&Logo patch to cell in module":
                AutoClearanceCriteriaController.text,
            "Position verification of RFID& Logo Patch on Module":
                AutoPositionCriteriaController.text,
            "Top & Bottom Creepage Distance/Terminal busbar to Edge of Glass":
                AutoTopCriteriaController.text,
            "quality of auto taping": AutoQualityCriteriaController.text,
            "Avaibility of specification & WI":
                AutoAvaibilityCriteriaController.text,
          },
          "Frequency": {
            "Soldering Peel strength between Ribbon to bushbar interconnector":
                AutoSolderingFrequencyController.text,
            "Terminal busbar to edge of cell":
                AutoTerminalFrequencyController.text,
            "soldering quality of Ribbon to busbar":
                AutoSolderingFrequencyController.text,
            "Clearance between RFID&Logo patch to cell in module":
                AutoClearanceFrequencyController.text,
            "Position verification of RFID& Logo Patch on Module":
                AutoPositionFrequencyController.text,
            "Top & Bottom Creepage Distance/Terminal busbar to Edge of Glass":
                AutoTopFrequencyController.text,
            "quality of auto taping": AutoqualityofFrequencyController.text,
            "Avaibility of specification & WI":
                AutoAvaibilityFrequencyController.text
          },
          "Remark": AutoBussingRemarkController.text
        },
        {
          "Stage": "EVA/Backsheet cutting",
          "CheckPoint": {
            "Rear EVA dimension & sift cutting width(mm)":
                EVARearController.text,
            "Back-sheet dimension& slit cutting diameter":
                EVABackController.text,
            "cutting Edge of Rear EVA & Backsheet on Glass":
                EVAcuttingController.text,
            "Position of Back EVA & Backsheet on Glass":
                EVAPositionController.text,
            "Avaibility of specification&wI.": EVAAvaibilityController.text,
          },
          "AcceptanceCriteria": {
            "Rear EVA dimension & sift cutting width(mm)":
                EVARearCriteriaController.text,
            "Back-sheet dimension& slit cutting diameter":
                EVABackCriteriaController.text,
            "cutting Edge of Rear EVA & Backsheet on Glass":
                EVACuttingCriteriaController.text,
            "Position of Back EVA & Backsheet on Glass":
                EVAPositionCriteriaController.text,
            "Avaibility of specification&wI.": EVAAvaibilityController.text,
          },
          "Frequency": {
            "Rear EVA dimension & sift cutting width(mm)":
                EVARearFrequencyController.text,
            "Back-sheet dimension& slit cutting diameter":
                EVABackFrequencyController.text,
            "cutting Edge of Rear EVA & Backsheet on Glass":
                EVACuttingFrequencyController.text,
            "Position of Back EVA & Backsheet on Glass":
                EVAPositionFrequencyController.text,
            "Avaibility of acceptance criteria & WI":
                EVAAvaibilityFrequencyController.text,
          },
          "Remark": EVABacksheetRemarkController.text
        },
        {
          "Stage": "Pre lamination EL &Visual",
          "CheckPoint": {
            "EI Inspection after stringer Number of Stringer":
                PreLaminationEInumberOfStringersController.text,
            "EI Inspection after stringer Number of Created Input text ":
                sample5Controller,
            "Visual inspection of string  Number of Stringer ":
                PreLaminationVisualnumberOfStringersController.text,
            "Visual inspection of string  Number of Created Input text ":
                sample6Controller,
            "Avaibility of acceptance criteria & WI":
                PreLaminationAvaibilityController.text,
          },
          "AcceptanceCriteria": {
            "EI Inspection": PreLaminationEIinspectionCriteriaController.text,
            "Visual inspection":
                PreLaminationVisualinspectionCriteriaController.text,
            "Avaibility of acceptance criteria & WI":
                PreLaminationAvaibilityWIController.text,
          },
          "Frequency": {
            "EI Inspection after stringer":
                PreLaminationEIinspectionFrequencyController.text,
            "Visual inspection of string":
                PreLaminationVisualFrequencyController.text,
            "Avaibility of acceptance criteria & WI":
                PreLaminationAvaibilityFrequencyController.text,
          },
          "Remark": PreLaminationELRemarkController.text
        },
        {
          "Stage": "String Rework station",
          "CheckPoint": {
            "Avaibility of work instruvtion(WI)":
                StringAvaibilityController.text,
            "Cleaning of Rework station/soldering iron sponge":
                StringCleaningController.text,
          },
          "AcceptanceCriteria": {
            "Avaibility of work instruvtion(WI)":
                StringAvaibilityCriteriaController.text,
            "Cleaning of Rework station/soldering iron sponge":
                StringCleaningCriteriaController.text,
          },
          "Frequency": {
            "Avaibility of work instruvtion(WI)":
                StringAvaibilityFrequencyController.text,
            "Cleaning of Rework station/soldering iron sponge":
                StringCleaningFrequencyController.text,
          },
          "Remark": StringReworkRemarkController.text
        },
        {
          "Stage": "Module Rework Station",
          "CheckPoint": {
            "Avaibility of work instruvtion(WI)":
                ModuleAvaibilityController.text,
            "Method of Rework": ModuleMethodCleaningController.text,
            "Handling of Modules": ModuleHandlingController.text,
            "Cleaning of Rework station/soldering iron sponge":
                ModuleCleaningofReworkController.text,
          },
          "AcceptanceCriteria": {
            "Avaibility of work instruvtion(WI)":
                ModuleAvaibilityCriteriaController.text,
            "Method of Rework": ModuleMethodCleaningCriteriaController.text,
            "Handling of Modules": ModuleHandlingCriteriaController.text,
            "Cleaning of Rework station/soldering iron sponge":
                ModuleCleaningofReworkCriteriaController.text,
          },
          "Frequency": {
            "Avaibility of work instruvtion(WI)":
                ModuleAvaibilityFrequencyController.text,
            "Method of Rework": ModuleMethodCleaningFrequencyController.text,
            "Handling of Modules": ModuleHandlingFrequencyController.text,
            "Cleaning of Rework station/soldering iron sponge":
                ModuleCleaningofReworkFrequencyController.text,
          },
          "Remark": ModuleCleaningRemarkController.text
        },
        {
          "Stage": "Laminator",
          "CheckPoint": {
            "Monitoring of Laminator Process parameter":
                LaminatorMonitoringController.text,
            "Adhesive on backsheet of the module":
                LaminatorAdhesiveController.text,
            "Peel Adhesive Test": LaminatorPeelController.text,
            "Gel Content Test": LaminatorGelController.text,
          },
          "AcceptanceCriteria": {
            "Monitoring of Laminator Process parameter":
                LaminatorMonitoringCriteriaController.text,
            "Adhesive on backsheet of the module":
                LaminatorAdhesiveCriteriaController.text,
            "Peel Adhesive Test": LaminatorPeelCriteriaController.text,
            "Gel Content Test": LaminatorGelCriteriaController.text,
          },
          "Frequency": {
            "Monitoring of Laminator Process parameter":
                LaminatorMonitoringFrequencyController.text,
            "Adhesive on backsheet of the module":
                LaminatorAdhesiveFrequencyController.text,
            "Peel Adhesive Test": LaminatorPeelFrequencyController.text,
            "Gel Content Test": LaminatorGelFrequencyController.text,
          },
          "Remark": LaminatorRemarkController.text
        },
      ]
    ];
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site')!;
    FocusScope.of(context).unfocus();

    final url = (site! + "IPQC/AddPreLam");
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
        prelamId = objData['UUID'];

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

  Widget _getFAB() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70),
      child: FloatingActionButton(
        onPressed: () {
          sample1Controller = [];
          for (int i = 0; i < numberOfStringers * 5; i++) {
            sample1Controller.add({
              "cellLoaderVerificationControllers${i + 1}":
                  cellLoaderVerificationControllers[i].text,
            });
          }

          sample2Controller = [];
          for (int i = 0; i < numberOfStringers1 * 5; i++) {
            sample2Controller.add({
              "TabberVisualStringerControllers${i + 1}":
                  TabberVisualStringerControllers[i].text,
            });
          }

          sample3Controller = [];
          for (int i = 0; i < numberOfStringers2 * 5; i++) {
            sample3Controller.add({
              "TabberEIimageofStringerControllers${i + 1}":
                  TabberEIimageofStringerControllers[i].text,
            });
          }

          sample4Controller = [];
          for (int i = 0; i < numberOfStringers4 * 2; i++) {
            sample4Controller.add({
              "TabberVerificationofsilderingControllers${i + 1}":
                  TabberVerificationofsilderingControllers[i].text,
            });
          }

          sample5Controller = [];
          for (int i = 0; i < numberOfStringers5 * 5; i++) {
            sample5Controller.add({
              "PreLaminationEIinspectionrControllers${i + 1}":
                  PreLaminationEIinspectionrControllers[i].text,
            });
          }

          sample6Controller = [];
          for (int i = 0; i < numberOfStringers6 * 5; i++) {
            sample6Controller.add({
              "PreLaminationVisualinspectionrControllers${i + 1}":
                  PreLaminationVisualinspectionrControllers[i].text,
            });
          }
          if (status != 'Pending') {
            setState(() {
              sendStatus = 'Inprogress';
            });
            sendDataToBackend();
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
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: setPage == ''
                      ? Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: [
                            SingleChildScrollView(
                              child: Form(
                                key: _preLamFormKey,
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
                                                "Incoming Production Quality Control",
                                                style: TextStyle(
                                                    fontSize: 27,
                                                    color: AppColors.black,
                                                    fontFamily: appFontFamily,
                                                    fontWeight:
                                                        FontWeight.w700)))),
                                    const Center(
                                        child: Text("(Pre Lam Checklist)",
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
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'GSPL/prelam/IPC/003',
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
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
                                          'Ver.1.0 / 20-08-2023',
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                      ],
                                    ),

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
                                      controller: DayController,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Date",
                                        counterText: '',
                                        fillColor:
                                            Color.fromARGB(255, 215, 243, 207),
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
                                          DayController.text =
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
                                    TextFormField(
                                      controller: shiftController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Shift",
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
                                          return "Please Enter Shift";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),

                                    // ********************************* Line *******************************

                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Line.",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: lineController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Enter Line.",
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
                                            errorText: "Please Enter Line.",
                                          ),
                                        ],
                                      ),
                                    ),

                                    // *  PO Number ***********************

                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Po Number",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),

                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: PoController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Please Po Number",
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
                                            errorText: "Please Po Number",
                                          ),
                                        ],
                                      ),
                                    ),
                                    // ************** step process end *****************

                                    // **************  Glass Loader *****************
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Center(
                                        child: Text("Glass Loader",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 13, 160, 0),
                                                fontFamily: appFontFamily,
                                                fontWeight: FontWeight.w700))),

                                    // **********  step process ***********
                                    const SizedBox(
                                      height: 15,
                                    ),

                                    Text(
                                      "Frequency",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller:
                                          GlassLoaderFreqquency1Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Once a Shift",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Glass Dimension {LengthxWidthxThickness}",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller:
                                          GlassLoaderGlassDimensionController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Enter the Glass Dimension ",
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
                                                "Please Enter Correct data",
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),

                                    Text(
                                      "Acceptance Criteria",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller:
                                          GlassLoaderCriteria1Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Refer Production order & Module Drawing",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    // *** second  221
                                    Divider(
                                      color: Colors.black,
                                      thickness: 2,
                                      height: 20,
                                    ),

                                    Text(
                                      "Frequency",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller:
                                          GlassLoaderFrequency2Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Once a Shift",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Avaibility of WI",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller:
                                          GlassLoaderAvaibilityController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Enter the Avaibility of WI ",
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
                                                "Please Enter Correct Avaibility of WI ",
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),

                                    Text(
                                      "Acceptance Criteria",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller:
                                          GlassLoaderCriteria2Controller,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText:
                                            "Avaibility of WI & Operator should be aware with WI",
                                        counterText: '',
                                      ),
                                      style: AppStyles.textInputTextStyle,
                                      readOnly: true,
                                    ),

                                    // *** Remark
                                    const SizedBox(
                                      height: 15,
                                    ),

                                    Text(
                                      "Remark",
                                      style:
                                          AppStyles.textfieldCaptionTextStyle,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),

                                    TextFormField(
                                      controller: GlassLoaderRemarkController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: AppStyles
                                          .textFieldInputDecoration
                                          .copyWith(
                                        hintText: "Remark ",
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
                                                "Please Enter Correct data",
                                          ),
                                        ],
                                      ),
                                    ),

                                    // *** these data uesed to full code
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
                                              //500
                                              if (status != 'Pending') {
                                                setState(() {
                                                  sendStatus = 'Inprogress';
                                                });
                                                sendDataToBackend();
                                              }
                                              // _glassLoaderFormKey.currentState!.save;
                                              // if (_glassLoaderFormKey.currentState!
                                              //     .validate()) {}

                                              setState(() {
                                                setPage = "glassSide";
                                              });
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
                      : setPage == "glassSide"
                          // GlassSide start
                          ? Stack(
                              alignment: Alignment.center,
                              fit: StackFit.expand,
                              children: [
                                SingleChildScrollView(
                                  child: Form(
                                    key: _preLamFormKey,
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
                                                child: Text(
                                                    "Incoming Production Quality Control",
                                                    style: TextStyle(
                                                        fontSize: 27,
                                                        color: AppColors.black,
                                                        fontFamily:
                                                            appFontFamily,
                                                        fontWeight:
                                                            FontWeight.w700)))),
                                        const Center(
                                            child: Text("(Pre Lam  Checklist)",
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
                                              'GSPL/prelam/IPC/003',
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
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
                                              'Ver.1.0 / 20-08-2023',
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                          ],
                                        ),

                                        // **************  Glass1 Side EVA cutting machine *****************
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Center(
                                            child: Text(
                                                "Glass Side EVA Cutting Machine",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color.fromARGB(
                                                        255, 13, 160, 0),
                                                    fontFamily: appFontFamily,
                                                    fontWeight:
                                                        FontWeight.w700))),
                                        const SizedBox(
                                          height: 15,
                                        ),

                                        Text(
                                          "Frequency",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller:
                                              GlassEVAFrequency1Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Once a Shift",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),

                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "EVA dimension {LengthxWidthxThickness}",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller:
                                              GlassEVADimensionController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Enter the EVA Dimension ",
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
                                                    "Please Enter Correct EVA Dimension",
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 15,
                                        ),

                                        Text(
                                          "Acceptance Criteria",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller:
                                              GlassEVACriteria1Controller,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Refer Production order & Module Drawing",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 2,
                                          height: 20,
                                        ),

                                        Text(
                                          "Frequency",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller:
                                              GlasCuttingFrequencyController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Once a Shift",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),

                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Cutting of Front EVA",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller: GlasCuttingEdgeController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Enter the Cutting  of Front EVA.. ",
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
                                                    "Please Enter Correct Cutting  of Front EVA..",
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 15,
                                        ),

                                        Text(
                                          "Acceptance Criteria",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller:
                                              GlasCuttingCriteriaController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "shoul not be uneven",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 2,
                                          height: 20,
                                        ),

                                        const SizedBox(
                                          height: 15,
                                        ),

                                        Text(
                                          "Frequency",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller:
                                              GlasPositionFrequencyController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Once a Shift",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),

                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Position of front Eva",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller:
                                              GlasPositionFrontController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Enter the Position of front Eva.. ",
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
                                                    "Please Enter Correct Position of front Eva...",
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 15,
                                        ),

                                        Text(
                                          "Acceptance Criteria",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller:
                                              GlasPositionCriteriaController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "shifting of EVA on Glass not allowed",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 2,
                                          height: 20,
                                        ),

                                        Text(
                                          "Frequency",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller:
                                              GlasAvabilityFrequencyController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Once a Shift",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),

                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Avability of Specification & WI",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller:
                                              GlasAvabilitySpecificationController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Enter the Avability of Specification & WI ",
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
                                                    "Please Enter Correct Avability of Specification & WI ",
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 15,
                                        ),

                                        Text(
                                          "Acceptance Criteria",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          controller:
                                              GlasAvabilityCriteriaController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText:
                                                "Avaibility of specification and WI & operator shoud br aware with specification",
                                            counterText: '',
                                          ),
                                          style: AppStyles.textInputTextStyle,
                                          readOnly: true,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),

                                        // *** Remark

                                        Text(
                                          "Remark",
                                          style: AppStyles
                                              .textfieldCaptionTextStyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        TextFormField(
                                          controller: GlasSideRemarkController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: AppStyles
                                              .textFieldInputDecoration
                                              .copyWith(
                                            hintText: "Remark ",
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
                                                    "Please Enter Remark",
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
                                                    sendDataToBackend();
                                                  }

                                                  // _glassSideFormKey
                                                  //     .currentState!.save;
                                                  // if (_glassSideFormKey.currentState!
                                                  //     .validate()) {}
                                                  setState(() {
                                                    setPage = "temperature";
                                                  });
                                                  // createData();
                                                },
                                                label: "Next",
                                                organization: '',
                                              ),
                                        const SizedBox(
                                          height: 10,
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
                          // ***Third Next start

                          : setPage == "temperature"
                              // Temperature start
                              ? Stack(
                                  alignment: Alignment.center,
                                  fit: StackFit.expand,
                                  children: [
                                    SingleChildScrollView(
                                      child: Form(
                                        key: _preLamFormKey,
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
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text(
                                                        "Incoming Production Quality Control",
                                                        style: TextStyle(
                                                            fontSize: 27,
                                                            color:
                                                                AppColors.black,
                                                            fontFamily:
                                                                appFontFamily,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)))),
                                            const Center(
                                                child: Text(
                                                    "(Pre Lam Checklist)",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: AppColors.black,
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
                                                  'GSPL/prelam/IPC/003',
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
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
                                                  'Ver.1.0 / 20-08-2023',
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                              ],
                                            ),

                                            // ************** Temperature & Relative humidity(%RH) monitorin *****************
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const Center(
                                                child: Text(
                                                    "Temperature & Relative Humidity(%RH) Monitoring ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Color.fromARGB(
                                                            255, 13, 160, 0),
                                                        fontFamily:
                                                            appFontFamily,
                                                        fontWeight:
                                                            FontWeight.w700))),
                                            const SizedBox(
                                              height: 15,
                                            ),

                                            Text(
                                              "Frequency",
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller:
                                                  TempShopFrequencyController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText: "Once a Shift",
                                                counterText: '',
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
                                              readOnly: true,
                                            ),

                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Shop floor Temperature condition",
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller:
                                                  TempShopFloorController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Enter the Shop floor Temperature condition",
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
                                                        "Please Enter Correct Shop floor Temperature condition",
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 15,
                                            ),

                                            Text(
                                              "Acceptance Criteria",
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller:
                                                  TempShopCriteriaController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Temprature: 25+/- °C",
                                                counterText: '',
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
                                              readOnly: true,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Divider(
                                              color: Colors.black,
                                              thickness: 2,
                                              height: 20,
                                            ),

                                            Text(
                                              "Frequency",
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller:
                                                  TempRelativeFrequencyController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText: "Once a Shift",
                                                counterText: '',
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
                                              readOnly: true,
                                            ),

                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Relative humadity(%RH) in shop floor",
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller:
                                                  TempRelativeHumidityController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText:
                                                    "Enter the Relative humadity.... ",
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
                                                        "Please Enter Correct Relative humadity....",
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(
                                              height: 15,
                                            ),

                                            Text(
                                              "Acceptance Criteria",
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              controller:
                                                  TempRelativeCriteriaController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText: "Humidity(%RH):<=60%",
                                                counterText: '',
                                              ),
                                              style:
                                                  AppStyles.textInputTextStyle,
                                              readOnly: true,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),

                                            // *** Remark

                                            Text(
                                              "Remark",
                                              style: AppStyles
                                                  .textfieldCaptionTextStyle,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),

                                            TextFormField(
                                              controller:
                                                  TemperatureRemarkController,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: AppStyles
                                                  .textFieldInputDecoration
                                                  .copyWith(
                                                hintText: "Remark ",
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
                                                        "Please Enter Correct data",
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
                                                        sendDataToBackend();
                                                      } //300

                                                      // _temperatureFormKey
                                                      //     .currentState!.save;
                                                      // if (_temperatureFormKey
                                                      //     .currentState!
                                                      //     .validate()) {
                                                      //   //   sendDataToBackend();
                                                      // }
                                                      setState(() {
                                                        setPage =
                                                            "Cell Cutting Machine";
                                                      });
                                                      // createData();
                                                    },
                                                    label: "Next",
                                                    organization: '',
                                                  ),
                                            const SizedBox(
                                              height: 10,
                                            ),

                                            // Back button
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      setPage = 'glassSide';
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
                              // *** Cell Cutting Machine Next start #101

                              : setPage == "Cell Cutting Machine"
                                  // Cell Cutting Machine start
                                  ? Stack(
                                      alignment: Alignment.center,
                                      fit: StackFit.expand,
                                      children: [
                                        SingleChildScrollView(
                                          child: Form(
                                            key: _preLamFormKey,
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
                                                        child: Text(
                                                            "Incoming Production Quality Control",
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
                                                    child: Text(
                                                        "(Pre Lam Checklist)",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                AppColors.black,
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
                                                      'GSPL/prelam/IPC/003',
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
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
                                                      'Ver.1.0 / 20-08-2023',
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                  ],
                                                ),
                                                // **************  Cell Cutting Machine *****************
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                const Center(
                                                    child: Text(
                                                        "Cell Cutting Machine",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Color.fromARGB(
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
                                                  height: 15,
                                                ),

                                                Text(
                                                  "Frequency",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellSizeFrequencyController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Thrice per shift",
                                                    counterText: '',
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: true,
                                                ),

                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Cell Size(Lengthxwidth)",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellSizelengthController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Enter the Cell Size(Lengthxwidth)",
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
                                                            "Please Enter Correct Cell Size(Lengthxwidth)",
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 15,
                                                ),

                                                Text(
                                                  "Acceptance Criteria",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellSizeCriteriaController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Refer Production Order",
                                                    counterText: '',
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: true,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  thickness: 2,
                                                  height: 20,
                                                ),

                                                Text(
                                                  "Frequency",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellManufactureFrequencyController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Thrice per Shift",
                                                    counterText: '',
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: true,
                                                ),

                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Cell Menufacturer & Eff.",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellManufactureEffController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Enter the Cell Menufacturer & Eff.  ",
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
                                                            "Please Enter Correct Cell Menufacturer & Eff.",
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 15,
                                                ),

                                                Text(
                                                  "Acceptance Criteria",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellManufactureCriteriaController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Refer Production Order",
                                                    counterText: '',
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: true,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  thickness: 2,
                                                  height: 20,
                                                ),

                                                Text(
                                                  "Frequency",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellcolorFrequencyController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Thrice per Shift",
                                                    counterText: '',
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: true,
                                                ),

                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Cell Color",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellcolorController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Enter the Cell Color ",
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
                                                            "Please Enter Correct Cell Color",
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 15,
                                                ),

                                                Text(
                                                  "Acceptance Criteria",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellcolorCriteriaController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Proper Segregation should be done as per color mixing not allowed",
                                                    counterText: '',
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: true,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  thickness: 2,
                                                  height: 20,
                                                ),

                                                Text(
                                                  "Frequency",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellAvabilityofFrequencyController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText: "Once per Shift",
                                                    counterText: '',
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: true,
                                                ),

                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Avability of specification & WI.",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellAvabilityofSpecificationController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Enter the Avability of specification & WI.",
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
                                                            "Please Enter Correct Avability of specification & WI.",
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 15,
                                                ),

                                                Text(
                                                  "Acceptance Criteria",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      CellAvabilityofCriteriaController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText:
                                                        "Avaibility of specification and wi & operator should br aware with specification",
                                                    counterText: '',
                                                  ),
                                                  style: AppStyles
                                                      .textInputTextStyle,
                                                  readOnly: true,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),

                                                // *** Remark

                                                Text(
                                                  "Remark",
                                                  style: AppStyles
                                                      .textfieldCaptionTextStyle,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),

                                                TextFormField(
                                                  controller:
                                                      CellCuttingRemarkController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: AppStyles
                                                      .textFieldInputDecoration
                                                      .copyWith(
                                                    hintText: "Remark ",
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
                                                            "Please Enter Correct data",
                                                      ),
                                                    ],
                                                  ),
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
                                                    : AppButton(
                                                        textStyle:
                                                            const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              AppColors.white,
                                                          fontSize: 16,
                                                        ),
                                                        onTap: () {
                                                          AppHelper
                                                              .hideKeyboard(
                                                                  context);
                                                          if (status !=
                                                              'Pending') {
                                                            setState(() {
                                                              sendStatus =
                                                                  'Inprogress';
                                                            });
                                                            sendDataToBackend();
                                                          }
                                                          setState(() {
                                                            setPage =
                                                                "Cell Loading";
                                                          });
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          setPage =
                                                              'temperature';
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

                                  // *** Cell Loading Next start #102
                                  : setPage == "Cell Loading"
                                      // Cell Loading start
                                      ? Stack(
                                          alignment: Alignment.center,
                                          fit: StackFit.expand,
                                          children: [
                                            SingleChildScrollView(
                                              child: Form(
                                                key: _preLamFormKey,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Text(
                                                                "Incoming Production Quality Control",
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
                                                            "(Pre Lam Checklist)",
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
                                                          'GSPL/prelam/IPC/003',
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
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
                                                          'Ver.1.0 / 20-08-2023',
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                      ],
                                                    ),

// **************  Cell Loading *****************
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    const Center(
                                                        child: Text(
                                                            "Cell Loading",
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
                                                      height: 15,
                                                    ),

                                                    Text(
                                                      "Frequency",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingcellFrequencyController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Thrice per shift",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      "Cell Color",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingcellColorController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Enter the Cell Color",
                                                        counterText: '',
                                                        fillColor:
                                                            Color.fromARGB(255,
                                                                215, 243, 207),
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly:
                                                          status == 'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                      validator: MultiValidator(
                                                        [
                                                          RequiredValidator(
                                                            errorText:
                                                                "Please Enter Correct Cell color",
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    Text(
                                                      "Acceptance Criteria",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingcellCriteriaController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Different color of cell loading at a time not allowed ",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Divider(
                                                      color: Colors.black,
                                                      thickness: 2,
                                                      height: 20,
                                                    ),

                                                    Text(
                                                      "Frequency",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingCleanFrequencyController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Once per Shift",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      "Cleanliness of cell Loading Area",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingCleanLinessController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Enter the Cleanliness of cell Loading Area ",
                                                        counterText: '',
                                                        fillColor:
                                                            Color.fromARGB(255,
                                                                215, 243, 207),
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly:
                                                          status == 'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                      validator: MultiValidator(
                                                        [
                                                          RequiredValidator(
                                                            errorText:
                                                                "Please Enter Correct Cleanliness of cell Loading Area",
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    Text(
                                                      "Acceptance Criteria",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingCleanCriteriaController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "no unwanted or waste material should be near cell Loading Area",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Divider(
                                                      color: Colors.black,
                                                      thickness: 2,
                                                      height: 20,
                                                    ),

                                                    Text(
                                                      "Frequency",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingWIFrequencyController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Once per Shift",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      "Cell loading as per WI",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingWIController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Enter the Cell loading as per WI ",
                                                        counterText: '',
                                                        fillColor:
                                                            Color.fromARGB(255,
                                                                215, 243, 207),
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly:
                                                          status == 'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                      validator: MultiValidator(
                                                        [
                                                          RequiredValidator(
                                                            errorText:
                                                                "Please Enter Correct Cell loading as per WI",
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    Text(
                                                      "Acceptance Criteria",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingWICriteriaController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText: "As per WI",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Divider(
                                                      color: Colors.black,
                                                      thickness: 2,
                                                      height: 20,
                                                    ),

                                                    Text(
                                                      "Frequency",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingAvabilityFrequencyController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Once per Shift",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      "Avability of WI.",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingAvabilityController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Enter the Avability WI.",
                                                        counterText: '',
                                                        fillColor:
                                                            Color.fromARGB(255,
                                                                215, 243, 207),
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly:
                                                          status == 'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                      validator: MultiValidator(
                                                        [
                                                          RequiredValidator(
                                                            errorText:
                                                                "Please Enter Correct Avability of  WI.",
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    Text(
                                                      "Acceptance Criteria",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingAvabilityCriteriaController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Avaibility of  wi & operator should br aware with WI",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Divider(
                                                      color: Colors.black,
                                                      thickness: 2,
                                                      height: 20,
                                                    ),

                                                    Text(
                                                      "Frequency",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingVerificationFrequencyController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Once per Shift",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      "Verification of process parameter",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingVerificationController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Enter the Verification of process parameter",
                                                        counterText: '',
                                                        fillColor:
                                                            Color.fromARGB(255,
                                                                215, 243, 207),
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly:
                                                          status == 'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                      validator: MultiValidator(
                                                        [
                                                          RequiredValidator(
                                                            errorText:
                                                                "Please Enter Correct Verification of process parameter",
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    Text(
                                                      "Acceptance Criteria",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingVerificationCriteriaController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "As per machine specification ",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Divider(
                                                      color: Colors.black,
                                                      thickness: 2,
                                                      height: 20,
                                                    ),

                                                    Text(
                                                      "Frequency",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingStringFrequencyController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "5 string/stringer/shift ",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),

                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    // Text(
                                                    //   "String length & cell to cell gap",
                                                    //   style: AppStyles
                                                    //       .textfieldCaptionTextStyle,
                                                    // ),
                                                    // SizedBox(
                                                    //   height: 15,
                                                    // ),
                                                    Text(
                                                      "String length & cell to cell gap",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(height: 5),
                                                    TextFormField(
                                                      controller:
                                                          CellLoadingnumberOfStringerController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLength: 1,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          numberOfStringers =
                                                              int.tryParse(
                                                                      value) ??
                                                                  0;
                                                          addControllers(
                                                              numberOfStringers *
                                                                  5);
                                                        });
                                                      },
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "Enter the number of Stringers",
                                                        fillColor:
                                                            Color.fromARGB(255,
                                                                215, 243, 207),
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly:
                                                          status == 'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                      validator: MultiValidator(
                                                        [
                                                          RequiredValidator(
                                                            errorText:
                                                                "Enter the number of Stringers",
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // SizedBox(height: 20),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          numberOfStringers * 5,
                                                      itemBuilder:
                                                          (context, index) {
                                                        int stringerIndex =
                                                            (index ~/ 5) + 1;
                                                        int textFieldIndex =
                                                            index % 5;
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            if (textFieldIndex ==
                                                                0)
                                                              Text(
                                                                "Stringer $stringerIndex",
                                                                style: AppStyles
                                                                    .textInputTextStyle
                                                                    .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            SizedBox(
                                                                height: 10),
                                                            TextFormField(
                                                              controller:
                                                                  cellLoaderVerificationControllers[
                                                                      index],
                                                              decoration: AppStyles
                                                                  .textFieldInputDecoration
                                                                  .copyWith(
                                                                hintText:
                                                                    "Please Enter stringer data",
                                                                counterText: '',
                                                                fillColor: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        215,
                                                                        243,
                                                                        207),
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                              ),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              readOnly: status ==
                                                                          'Pending' &&
                                                                      designation !=
                                                                          "QC"
                                                                  ? true
                                                                  : false,
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please Enter correcr stringer data';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),

                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    Text(
                                                      "Acceptance Criteria",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          cellLoaderStringCriteriaController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText:
                                                            "refer Production order & module Drawing ",
                                                        counterText: '',
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly: true,
                                                    ),

                                                    // *** Remark
                                                    const SizedBox(
                                                      height: 15,
                                                    ),

                                                    Text(
                                                      "Remark",
                                                      style: AppStyles
                                                          .textfieldCaptionTextStyle,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    TextFormField(
                                                      controller:
                                                          cellLoaderRemarkController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: AppStyles
                                                          .textFieldInputDecoration
                                                          .copyWith(
                                                        hintText: "Remark ",
                                                        counterText: '',
                                                        fillColor:
                                                            Color.fromARGB(255,
                                                                215, 243, 207),
                                                      ),
                                                      style: AppStyles
                                                          .textInputTextStyle,
                                                      readOnly:
                                                          status == 'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                      validator: MultiValidator(
                                                        [
                                                          RequiredValidator(
                                                            errorText:
                                                                "Please Enter Correct data",
                                                          ),
                                                        ],
                                                      ),
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
                                                        : AppButton(
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
                                                              //100

                                                              // _cellLoadingFormKey.currentState!.save;
                                                              // if (_cellLoadingFormKey.currentState!
                                                              //     .validate()) {

                                                              // }
                                                              sample1Controller =
                                                                  [];
                                                              for (int i = 0;
                                                                  i <
                                                                      numberOfStringers *
                                                                          5;
                                                                  i++) {
                                                                sample1Controller
                                                                    .add({
                                                                  "cellLoaderVerificationControllers${i + 1}":
                                                                      cellLoaderVerificationControllers[
                                                                              i]
                                                                          .text,
                                                                });
                                                              }

                                                              if (status !=
                                                                  'Pending') {
                                                                setState(() {
                                                                  sendStatus =
                                                                      'Inprogress';
                                                                });
                                                                sendDataToBackend();
                                                              }
                                                              setState(() {
                                                                setPage =
                                                                    "Tabber & Stringer";
                                                              });
                                                            },
                                                            label: "Next",
                                                            organization: '',
                                                          ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),

                                                    // Back button
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              setPage =
                                                                  'Cell Cutting Machine';
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
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  appFontFamily,
                                                              color: AppColors
                                                                  .greyColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
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
                                      : setPage == "Tabber & Stringer"
                                          // Tabber & Stringer start
                                          ? Stack(
                                              alignment: Alignment.center,
                                              fit: StackFit.expand,
                                              children: [
                                                SingleChildScrollView(
                                                  child: Form(
                                                    key: _preLamFormKey,
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
                                                                AppAssets
                                                                    .imgLogo,
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
                                                                        top:
                                                                            10),
                                                                child: Text(
                                                                    "Incoming Production Quality Control",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            27,
                                                                        color: AppColors
                                                                            .black,
                                                                        fontFamily:
                                                                            appFontFamily,
                                                                        fontWeight:
                                                                            FontWeight.w700)))),
                                                        const Center(
                                                            child: Text(
                                                                "(Pre Lam Checklist)",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
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
                                                              'GSPL/prelam/IPC/003',
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
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
                                                              'Ver.1.0 / 20-08-2023',
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                          ],
                                                        ),
                                                        // ******** Tabber & Stringer *****************
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        const Center(
                                                            child: Text(
                                                                "Tabber & Stringer",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
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

                                                        // **********  start Tabber ***********

                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 2,
                                                          height: 20,
                                                        ),

                                                        Text(
                                                          "Frequency",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              TabberVisualFrequencyController,
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
                                                                "5 string/stringer/shift ",
                                                            counterText: '',
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: true,
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),

                                                        Text(
                                                          "Visual Check after stringer",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(height: 5),
                                                        TextFormField(
                                                          controller:
                                                              TabberVisualnumberOfStringersController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          maxLength: 1,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              numberOfStringers1 =
                                                                  int.tryParse(
                                                                          value) ??
                                                                      0;
                                                              addTabberVisualControllers(
                                                                  numberOfStringers1 *
                                                                      5);
                                                            });
                                                          },
                                                          decoration: AppStyles
                                                              .textFieldInputDecoration
                                                              .copyWith(
                                                            hintText:
                                                                "Enter the number of Stringers",
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    215,
                                                                    243,
                                                                    207),
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: status ==
                                                                      'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                          validator:
                                                              MultiValidator(
                                                            [
                                                              RequiredValidator(
                                                                errorText:
                                                                    "Enter the number of Stringers",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount:
                                                              numberOfStringers1 *
                                                                  5,
                                                          itemBuilder:
                                                              (context, index) {
                                                            int stringerIndex =
                                                                (index ~/ 5) +
                                                                    1;
                                                            int textFieldIndex =
                                                                index % 5;
                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                if (textFieldIndex ==
                                                                    0)
                                                                  Text(
                                                                    "Stringer $stringerIndex",
                                                                    style: AppStyles
                                                                        .textInputTextStyle
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                SizedBox(
                                                                    height: 10),
                                                                TextFormField(
                                                                  controller:
                                                                      TabberVisualStringerControllers[
                                                                          index],
                                                                  decoration: AppStyles
                                                                      .textFieldInputDecoration
                                                                      .copyWith(
                                                                    hintText:
                                                                        "Please Enter stringer data",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please Enter correct stringer data .';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),

                                                        Text(
                                                          "Acceptance Criteria",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              TabberVisualCriteriaController,
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
                                                                "As per pre Lam Visual Criteria ",
                                                            counterText: '',
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: true,
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),

                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 2,
                                                          height: 20,
                                                        ),

                                                        Text(
                                                          "Frequency",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              TabberEIimageFrequencyController,
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
                                                                "5 string/stringer/shift ",
                                                            counterText: '',
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: true,
                                                        ),

                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          "EI image of String",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(height: 5),
                                                        TextFormField(
                                                          controller:
                                                              tabberEIimagenumberOfStringersController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          maxLength: 1,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              numberOfStringers2 =
                                                                  int.tryParse(
                                                                          value) ??
                                                                      0;
                                                              addTabberEImageControllers(
                                                                  numberOfStringers2 *
                                                                      5);
                                                            });
                                                          },
                                                          decoration: AppStyles
                                                              .textFieldInputDecoration
                                                              .copyWith(
                                                            hintText:
                                                                "Enter the number of Stringers",
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    215,
                                                                    243,
                                                                    207),
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: status ==
                                                                      'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                          validator:
                                                              MultiValidator(
                                                            [
                                                              RequiredValidator(
                                                                errorText:
                                                                    "Enter the number of Stringers",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount:
                                                              numberOfStringers2 *
                                                                  5,
                                                          itemBuilder:
                                                              (context, index) {
                                                            int stringerIndex =
                                                                (index ~/ 5) +
                                                                    1;
                                                            int textFieldIndex =
                                                                index % 5;
                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                if (textFieldIndex ==
                                                                    0)
                                                                  Text(
                                                                    "Stringer $stringerIndex",
                                                                    style: AppStyles
                                                                        .textInputTextStyle
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                SizedBox(
                                                                    height: 10),
                                                                TextFormField(
                                                                  controller:
                                                                      TabberEIimageofStringerControllers[
                                                                          index],
                                                                  decoration: AppStyles
                                                                      .textFieldInputDecoration
                                                                      .copyWith(
                                                                    hintText:
                                                                        "Please Enter Stringers",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please Enter stringers.';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),

                                                        const SizedBox(
                                                          height: 2,
                                                        ),

                                                        Text(
                                                          "Acceptance Criteria",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              TabberEIimageCriteriaController,
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
                                                                "As per pre Lam EI Criteria ",
                                                            counterText: '',
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: true,
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),

                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 2,
                                                          height: 20,
                                                        ),

                                                        Text(
                                                          "Frequency",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              TabberVerificationFrequencyController,
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
                                                                "2 string/stringer/shift ",
                                                            counterText: '',
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: true,
                                                        ),

                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          "Verification of sildering peel strength",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(height: 10),
                                                        TextFormField(
                                                          controller:
                                                              TabberVerificationNumberofstringController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          maxLength: 1,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              numberOfStringers4 =
                                                                  int.tryParse(
                                                                          value) ??
                                                                      0;
                                                              addTabberVerificationControllers(
                                                                  numberOfStringers4 *
                                                                      2);
                                                            });
                                                          },
                                                          decoration: AppStyles
                                                              .textFieldInputDecoration
                                                              .copyWith(
                                                            hintText:
                                                                "Enter the number of Stringers",
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    215,
                                                                    243,
                                                                    207),
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: status ==
                                                                      'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                          validator:
                                                              MultiValidator(
                                                            [
                                                              RequiredValidator(
                                                                errorText:
                                                                    "Enter the number of Stringers",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount:
                                                              numberOfStringers4 *
                                                                  2,
                                                          itemBuilder:
                                                              (context, index) {
                                                            int stringerIndex =
                                                                (index ~/ 2) +
                                                                    1;
                                                            int textFieldIndex =
                                                                index % 2;
                                                            return Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                if (textFieldIndex ==
                                                                    0)
                                                                  Text(
                                                                    "Stringer $stringerIndex",
                                                                    style: AppStyles
                                                                        .textInputTextStyle
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                SizedBox(
                                                                    height: 10),
                                                                TextFormField(
                                                                  controller:
                                                                      TabberVerificationofsilderingControllers[
                                                                          index],
                                                                  decoration: AppStyles
                                                                      .textFieldInputDecoration
                                                                      .copyWith(
                                                                    hintText:
                                                                        "Please Enter stringer",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please Enter correct stringer.';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),

                                                        const SizedBox(
                                                          height: 2,
                                                        ),

                                                        Text(
                                                          "Acceptance Criteria",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              TabberVerificationCriteriaController,
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
                                                                ">=0.5N  |  Refer:GSPL/IPQC/GP/001",
                                                            counterText: '',
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: true,
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),

                                                        Divider(
                                                          color: Colors.black,
                                                          thickness: 2,
                                                          height: 20,
                                                        ),

                                                        Text(
                                                          "Frequency",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              TabberAvaibilityFrequencyController,
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
                                                                "Once per Shift",
                                                            counterText: '',
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: true,
                                                        ),

                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          "Avability of specification & WI.",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              TabberAvabilityofSpecificationController,
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
                                                                "Enter the Avability of specification & WI.",
                                                            counterText: '',
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    215,
                                                                    243,
                                                                    207),
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: status ==
                                                                      'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                          validator:
                                                              MultiValidator(
                                                            [
                                                              RequiredValidator(
                                                                errorText:
                                                                    "Please Enter Correct Avability of specification & WI.",
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        const SizedBox(
                                                          height: 15,
                                                        ),

                                                        Text(
                                                          "Acceptance Criteria",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              TabberAvabilityofCriteriaController,
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
                                                                "Avaibility of specification and wi & operator should be aware with specification",
                                                            counterText: '',
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: true,
                                                        ),

                                                        // *** Remark
                                                        const SizedBox(
                                                          height: 15,
                                                        ),

                                                        Text(
                                                          "Remark",
                                                          style: AppStyles
                                                              .textfieldCaptionTextStyle,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),

                                                        TextFormField(
                                                          controller:
                                                              TabberstringerRemarkController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          decoration: AppStyles
                                                              .textFieldInputDecoration
                                                              .copyWith(
                                                            hintText: "Remark ",
                                                            counterText: '',
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    215,
                                                                    243,
                                                                    207),
                                                          ),
                                                          style: AppStyles
                                                              .textInputTextStyle,
                                                          readOnly: status ==
                                                                      'Pending' &&
                                                                  designation !=
                                                                      "QC"
                                                              ? true
                                                              : false,
                                                          validator:
                                                              MultiValidator(
                                                            [
                                                              RequiredValidator(
                                                                errorText:
                                                                    "Please Enter Correct data",
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 10,
                                                                    0, 0)),
                                                        _isLoading
                                                            ? Center(
                                                                child:
                                                                    CircularProgressIndicator())
                                                            : AppButton(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  fontSize: 16,
                                                                ),
                                                                onTap: () {
                                                                  AppHelper
                                                                      .hideKeyboard(
                                                                          context);

                                                                  sample2Controller =
                                                                      [];
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          numberOfStringers1 *
                                                                              5;
                                                                      i++) {
                                                                    sample2Controller
                                                                        .add({
                                                                      "TabberVisualStringerControllers${i + 1}":
                                                                          TabberVisualStringerControllers[i]
                                                                              .text,
                                                                    });
                                                                  }

                                                                  sample3Controller =
                                                                      [];
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          numberOfStringers2 *
                                                                              5;
                                                                      i++) {
                                                                    sample3Controller
                                                                        .add({
                                                                      "TabberEIimageofStringerControllers${i + 1}":
                                                                          TabberEIimageofStringerControllers[i]
                                                                              .text,
                                                                    });
                                                                  }

                                                                  sample4Controller =
                                                                      [];
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          numberOfStringers4 *
                                                                              2;
                                                                      i++) {
                                                                    sample4Controller
                                                                        .add({
                                                                      "TabberVerificationofsilderingControllers${i + 1}":
                                                                          TabberVerificationofsilderingControllers[i]
                                                                              .text,
                                                                    });
                                                                  }
                                                                  if (status !=
                                                                      'Pending') {
                                                                    setState(
                                                                        () {
                                                                      sendStatus =
                                                                          'Inprogress';
                                                                    });
                                                                    sendDataToBackend();
                                                                  }

                                                                  setState(() {
                                                                    setPage =
                                                                        "Auto String Layup";
                                                                  });
                                                                },
                                                                label: "Next",
                                                                organization:
                                                                    '',
                                                              ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),

                                                        // Back button
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  setPage =
                                                                      'Cell Loading';
                                                                });
                                                              },
                                                              child: const Text(
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      appFontFamily,
                                                                  color: AppColors
                                                                      .greyColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
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
                                          : setPage == "Auto String Layup"
                                              // Auto String Layup start
                                              ? Stack(
                                                  alignment: Alignment.center,
                                                  fit: StackFit.expand,
                                                  children: [
                                                    SingleChildScrollView(
                                                      child: Form(
                                                        key: _preLamFormKey,
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
                                                                            top:
                                                                                10),
                                                                    child: Text(
                                                                        "Incoming Production Quality Control",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                27,
                                                                            color: AppColors
                                                                                .black,
                                                                            fontFamily:
                                                                                appFontFamily,
                                                                            fontWeight:
                                                                                FontWeight.w700)))),
                                                            const Center(
                                                                child: Text(
                                                                    "(Pre Lam Checklist)",
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
                                                                  'GSPL/prelam/IPC/003',
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
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
                                                                  'Ver.1.0 / 20-08-2023',
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
                                                                    "Auto String Layup",
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
                                                            // **********  start Tabber ***********
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Divider(
                                                              color:
                                                                  Colors.black,
                                                              thickness: 2,
                                                              height: 20,
                                                            ),

                                                            Text(
                                                              "Frequency",
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  AutoCellFrequencyController,
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
                                                                    "Once per Shift",
                                                                counterText: '',
                                                              ),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              readOnly: true,
                                                            ),

                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              "Cell to cell gap",
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  AutoCellController,
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
                                                                    "Enter the Cell to cell gap.",
                                                                counterText: '',
                                                                fillColor: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        215,
                                                                        243,
                                                                        207),
                                                              ),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              readOnly: status ==
                                                                          'Pending' &&
                                                                      designation !=
                                                                          "QC"
                                                                  ? true
                                                                  : false,
                                                              validator:
                                                                  MultiValidator(
                                                                [
                                                                  RequiredValidator(
                                                                    errorText:
                                                                        "Please Enter Correct Cell to cell gap",
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            const SizedBox(
                                                              height: 15,
                                                            ),

                                                            Text(
                                                              "Acceptance Criteria",
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  AutoCellCriteriaController,
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
                                                                    "None",
                                                                counterText: '',
                                                              ),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              readOnly: true,
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Divider(
                                                              color:
                                                                  Colors.black,
                                                              thickness: 2,
                                                              height: 20,
                                                            ),

                                                            Text(
                                                              "Frequency",
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  AutoStringFrequencyController,
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
                                                                    "Once per Shift",
                                                                counterText: '',
                                                              ),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              readOnly: true,
                                                            ),

                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              "String to String Gap",
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  AutoStringController,
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
                                                                    "Enter the String to String Gap",
                                                                counterText: '',
                                                                fillColor: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        215,
                                                                        243,
                                                                        207),
                                                              ),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              readOnly: status ==
                                                                          'Pending' &&
                                                                      designation !=
                                                                          "QC"
                                                                  ? true
                                                                  : false,
                                                              validator:
                                                                  MultiValidator(
                                                                [
                                                                  RequiredValidator(
                                                                    errorText:
                                                                        "Please Enter Correct String to String Gap",
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            const SizedBox(
                                                              height: 15,
                                                            ),

                                                            Text(
                                                              "Acceptance Criteria",
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  AutoStringCriteriaController,
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
                                                                    "None",
                                                                counterText: '',
                                                              ),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              readOnly: true,
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),

                                                            Divider(
                                                              color:
                                                                  Colors.black,
                                                              thickness: 2,
                                                              height: 20,
                                                            ),

                                                            Text(
                                                              "Frequency",
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  AutoCelledgeFrequencyController,
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
                                                                    "Once per Shift",
                                                                counterText: '',
                                                              ),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              readOnly: true,
                                                            ),

                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              "Cell edge to glass edge(Top, bottom & sides)",
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  AutoCelledController,
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
                                                                    "Enter the Cell edge to glass edge(Top, bottom & sides)",
                                                                counterText: '',
                                                                fillColor: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        215,
                                                                        243,
                                                                        207),
                                                              ),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              readOnly: status ==
                                                                          'Pending' &&
                                                                      designation !=
                                                                          "QC"
                                                                  ? true
                                                                  : false,
                                                              validator:
                                                                  MultiValidator(
                                                                [
                                                                  RequiredValidator(
                                                                    errorText:
                                                                        "Please Enter Correct Cell edge to glass edge(Top, bottom & sides)",
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            const SizedBox(
                                                              height: 15,
                                                            ),

                                                            Text(
                                                              "Acceptance Criteria",
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  AutoCellEdgeCriteriaController,
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
                                                                    "None",
                                                                counterText: '',
                                                              ),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              readOnly: true,
                                                            ),

                                                            // *** Remark
                                                            const SizedBox(
                                                              height: 15,
                                                            ),

                                                            Text(
                                                              "Remark",
                                                              style: AppStyles
                                                                  .textfieldCaptionTextStyle,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),

                                                            TextFormField(
                                                              controller:
                                                                  AutoStringerRemarkController,
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
                                                                    "Remark ",
                                                                counterText: '',
                                                                fillColor: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        215,
                                                                        243,
                                                                        207),
                                                              ),
                                                              style: AppStyles
                                                                  .textInputTextStyle,
                                                              readOnly: status ==
                                                                          'Pending' &&
                                                                      designation !=
                                                                          "QC"
                                                                  ? true
                                                                  : false,
                                                              validator:
                                                                  MultiValidator(
                                                                [
                                                                  RequiredValidator(
                                                                    errorText:
                                                                        "Please Enter Correct data",
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            const SizedBox(
                                                              height: 15,
                                                            ),

                                                            Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0)),
                                                            _isLoading
                                                                ? Center(
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
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                    onTap: () {
                                                                      AppHelper
                                                                          .hideKeyboard(
                                                                              context);
                                                                      if (status !=
                                                                          'Pending') {
                                                                        setState(
                                                                            () {
                                                                          sendStatus =
                                                                              'Inprogress';
                                                                        });
                                                                        sendDataToBackend();
                                                                      }
                                                                      setState(
                                                                          () {
                                                                        setPage =
                                                                            "Auto Bussing & Tapping";
                                                                      });
                                                                    },
                                                                    label:
                                                                        "Next",
                                                                    organization:
                                                                        '',
                                                                  ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            // Back button
                                                            Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      setPage =
                                                                          'Tabber & Stringer';
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
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          appFontFamily,
                                                                      color: AppColors
                                                                          .greyColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
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
                                              : setPage ==
                                                      "Auto Bussing & Tapping"
                                                  // Auto Bussing & Tapping
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      fit: StackFit.expand,
                                                      children: [
                                                        SingleChildScrollView(
                                                          child: Form(
                                                            key: _preLamFormKey,
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
                                                                      Image
                                                                          .asset(
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
                                                                            "Incoming Production Quality Control",
                                                                            style: TextStyle(
                                                                                fontSize: 27,
                                                                                color: AppColors.black,
                                                                                fontFamily: appFontFamily,
                                                                                fontWeight: FontWeight.w700)))),
                                                                const Center(
                                                                    child: Text(
                                                                        "(Pre Lam Checklist)",
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
                                                                      'GSPL/prelam/IPC/003',
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
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
                                                                      'Ver.1.0 / 20-08-2023',
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Center(
                                                                    child: Text(
                                                                        "Auto Bussing & Tapping",
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

                                                                // **********  start Auto Bussing & Tapping ***********

                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Divider(
                                                                  color: Colors
                                                                      .black,
                                                                  thickness: 2,
                                                                  height: 20,
                                                                ),

                                                                Text(
                                                                  "Frequency",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoSolderingFrequencyController,
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
                                                                        "Once per Shift",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),

                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  "Soldering Peel strength between Ribbon to bushbar interconnector",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoSolderingController,
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
                                                                        "Enter the Soldering Peel strength between Ribbon to bushbar interconnector",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      MultiValidator(
                                                                    [
                                                                      RequiredValidator(
                                                                        errorText:
                                                                            "Please Enter Correct Soldering Peel strength between Ribbon to bushbar interconnector",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Text(
                                                                  "Acceptance Criteria",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoSolderingCriteriaController,
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
                                                                        ">=4N | Refer",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),
                                                                const SizedBox(
                                                                  height: 25,
                                                                ),
                                                                Divider(
                                                                  color: Colors
                                                                      .black,
                                                                  thickness: 2,
                                                                  height: 20,
                                                                ),

                                                                Text(
                                                                  "Frequency",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoTerminalFrequencyController,
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
                                                                        "Thrice per Shift",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),

                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  "Terminal busbar to edge of cell",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoTerminalStringController,
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
                                                                        "Enter the Terminal busbar to edge of cell",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      MultiValidator(
                                                                    [
                                                                      RequiredValidator(
                                                                        errorText:
                                                                            "Please Enter Correct Terminal busbar to edge of cell",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Text(
                                                                  "Acceptance Criteria",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoTerminalCriteriaController,
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
                                                                        "As per respective Layup Drawing",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Divider(
                                                                  color: Colors
                                                                      .black,
                                                                  thickness: 2,
                                                                  height: 20,
                                                                ),

                                                                Text(
                                                                  "Frequency",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoSolderingQualityFrequencyController,
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
                                                                        "Thrice per Shift",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),

                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  "soldering quality of Ribbon to busbar",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoSolderingQualityController,
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
                                                                        "Enter the soldering quality of Ribbon to busbar",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      MultiValidator(
                                                                    [
                                                                      RequiredValidator(
                                                                        errorText:
                                                                            "Please Enter Correct soldering quality of Ribbon to busbar",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Text(
                                                                  "Acceptance Criteria",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoSolderingQualityCriteriaController,
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
                                                                        "No Dry Soldering",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Divider(
                                                                  color: Colors
                                                                      .black,
                                                                  thickness: 2,
                                                                  height: 20,
                                                                ),

                                                                Text(
                                                                  "Frequency",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoClearanceFrequencyController,
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
                                                                        "Thrice per Shift",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),

                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  "Clearance between RFID&Logo patch to cell in module",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoClearanceController,
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
                                                                        "Enter the Clearance between RFID&Logo patch to cell in module",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      MultiValidator(
                                                                    [
                                                                      RequiredValidator(
                                                                        errorText:
                                                                            "Please Enter Correct Clearance between RFID&Logo patch to cell in module",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Text(
                                                                  "Acceptance Criteria",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoClearanceCriteriaController,
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
                                                                        "Should not be 2mm-4mm gapfrom the cell to the patch",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Divider(
                                                                  color: Colors
                                                                      .black,
                                                                  thickness: 2,
                                                                  height: 20,
                                                                ),

                                                                Text(
                                                                  "Frequency",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoPositionFrequencyController,
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
                                                                        "Thrice per Shift",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),

                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  "Position verification of RFID& Logo Patch on Module",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoPositionController,
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
                                                                        "Enter the Position verification of RFID& Logo Patch on Module",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      MultiValidator(
                                                                    [
                                                                      RequiredValidator(
                                                                        errorText:
                                                                            "Please Enter Correct Position verification of RFID& Logo Patch on Module",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Text(
                                                                  "Acceptance Criteria",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoPositionCriteriaController,
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
                                                                        "Shiould not be tilt,Busbar should not visible",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Divider(
                                                                  color: Colors
                                                                      .black,
                                                                  thickness: 2,
                                                                  height: 20,
                                                                ),

                                                                Text(
                                                                  "Frequency",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoTopFrequencyController,
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
                                                                        "Thrice per Shift",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),

                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  "Top & Bottom Creepage Distance/Terminal busbar to Edge of Glass",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoTopController,
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
                                                                        "Enter the Top & Bottom Creepage Distance/Terminal busbar to Edge of Glass",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      MultiValidator(
                                                                    [
                                                                      RequiredValidator(
                                                                        errorText:
                                                                            "Please Enter Correct Top & Bottom Creepage Distance/Terminal busbar to Edge of Glass",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Text(
                                                                  "Acceptance Criteria",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoTopCriteriaController,
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
                                                                        "Creepage distance should be 16+-1mm",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Divider(
                                                                  color: Colors
                                                                      .black,
                                                                  thickness: 2,
                                                                  height: 20,
                                                                ),

                                                                Text(
                                                                  "Frequency",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoqualityofFrequencyController,
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
                                                                        "Once per Shift",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),

                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  "Quality of auto taping",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoQualityController,
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
                                                                        "Enter the  Quality of auto taping",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      MultiValidator(
                                                                    [
                                                                      RequiredValidator(
                                                                        errorText:
                                                                            "Please Enter Correct Quality of auto taping",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Text(
                                                                  "Acceptance Criteria",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoQualityCriteriaController,
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
                                                                        "No poor taping,cell shifting,cell breakage",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Divider(
                                                                  color: Colors
                                                                      .black,
                                                                  thickness: 2,
                                                                  height: 20,
                                                                ),

                                                                Text(
                                                                  "Frequency",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoAvaibilityFrequencyController,
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
                                                                        "Once per Shift",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),

                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                  "Avaibility of specificastion & WI",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoAvaibilityController,
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
                                                                        "Enter the Avaibility of specification & WI",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      MultiValidator(
                                                                    [
                                                                      RequiredValidator(
                                                                        errorText:
                                                                            "Please Enter Correct Avaibility of specification & WI",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Text(
                                                                  "Acceptance Criteria",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      AutoAvaibilityCriteriaController,
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
                                                                        "Avaibility of specification & WI & operator should be aware of specification ",
                                                                    counterText:
                                                                        '',
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly:
                                                                      true,
                                                                ),

                                                                // *** Remark
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Text(
                                                                  "Remark",
                                                                  style: AppStyles
                                                                      .textfieldCaptionTextStyle,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),

                                                                TextFormField(
                                                                  controller:
                                                                      AutoBussingRemarkController,
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
                                                                        "Remark ",
                                                                    counterText:
                                                                        '',
                                                                    fillColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                  ),
                                                                  style: AppStyles
                                                                      .textInputTextStyle,
                                                                  readOnly: status ==
                                                                              'Pending' &&
                                                                          designation !=
                                                                              "QC"
                                                                      ? true
                                                                      : false,
                                                                  validator:
                                                                      MultiValidator(
                                                                    [
                                                                      RequiredValidator(
                                                                        errorText:
                                                                            "Please Enter Correct data",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  height: 15,
                                                                ),

                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0)),
                                                                _isLoading
                                                                    ? Center(
                                                                        child:
                                                                            CircularProgressIndicator())
                                                                    : AppButton(
                                                                        textStyle:
                                                                            const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color:
                                                                              AppColors.white,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          AppHelper.hideKeyboard(
                                                                              context);
                                                                          if (status !=
                                                                              'Pending') {
                                                                            setState(() {
                                                                              sendStatus = 'Inprogress';
                                                                            });
                                                                            sendDataToBackend();
                                                                          }
                                                                          setState(
                                                                              () {
                                                                            setPage =
                                                                                "EVA/Backsheet Cutting";
                                                                          });
                                                                        },
                                                                        label:
                                                                            "Next",
                                                                        organization:
                                                                            '',
                                                                      ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                // Back button
                                                                Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          setPage =
                                                                              'Auto String Layup';
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
                                                                                FontWeight.w500,
                                                                            color: AppColors.redColor),
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
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              appFontFamily,
                                                                          color:
                                                                              AppColors.greyColor,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
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
                                                  : setPage ==
                                                          "EVA/Backsheet Cutting"
                                                      // EVA/Backsheet Cutting
                                                      ? Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          fit: StackFit.expand,
                                                          children: [
                                                            SingleChildScrollView(
                                                              child: Form(
                                                                key:
                                                                    _preLamFormKey,
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
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            AppAssets.imgLogo,
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
                                                                            padding:
                                                                                EdgeInsets.only(top: 10),
                                                                            child: Text("Incoming Production Quality Control", style: TextStyle(fontSize: 27, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700)))),
                                                                    const Center(
                                                                        child: Text(
                                                                            "(Pre Lam IPQC Checklist)",
                                                                            style: TextStyle(
                                                                                fontSize: 20,
                                                                                color: AppColors.black,
                                                                                fontFamily: appFontFamily,
                                                                                fontWeight: FontWeight.w700))),
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
                                                                          'GSPL/IPQC/IPC/003',
                                                                          style:
                                                                              AppStyles.textfieldCaptionTextStyle,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
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
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        Text(
                                                                          'Ver.2.0 / 20-03-2024',
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
                                                                            "EVA/Backsheet Cutting",
                                                                            style: TextStyle(
                                                                                fontSize: 20,
                                                                                color: Color.fromARGB(255, 13, 160, 0),
                                                                                fontFamily: appFontFamily,
                                                                                fontWeight: FontWeight.w700))),

                                                                    // ******  start EVA/Backsheet Cutting ***

                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Divider(
                                                                      color: Colors
                                                                          .black,
                                                                      thickness:
                                                                          2,
                                                                      height:
                                                                          20,
                                                                    ),

                                                                    Text(
                                                                      "Frequency",
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVARearFrequencyController,
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
                                                                            "Once per Shift",
                                                                        counterText:
                                                                            '',
                                                                      ),
                                                                      style: AppStyles
                                                                          .textInputTextStyle,
                                                                      readOnly:
                                                                          true,
                                                                    ),

                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Text(
                                                                      "Rear EVA dimension & sift cutting width(mm)",
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVARearController,
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
                                                                            "Enter the  Rear EVA dimension & sift cutting width(mm)",
                                                                        counterText:
                                                                            '',
                                                                        fillColor: Color.fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                      ),
                                                                      style: AppStyles
                                                                          .textInputTextStyle,
                                                                      readOnly: status == 'Pending' &&
                                                                              designation != "QC"
                                                                          ? true
                                                                          : false,
                                                                      validator:
                                                                          MultiValidator(
                                                                        [
                                                                          RequiredValidator(
                                                                            errorText:
                                                                                "Please Enter Correct Rear EVA dimension & sift cutting width(mm)",
                                                                          ),
                                                                        ],
                                                                      ),
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
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVARearCriteriaController,
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
                                                                            "As per Specification GSPL/EVA(IQC)/001 & production order",
                                                                        counterText:
                                                                            '',
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

                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),

                                                                    Divider(
                                                                      color: Colors
                                                                          .black,
                                                                      thickness:
                                                                          2,
                                                                      height:
                                                                          20,
                                                                    ),

                                                                    Text(
                                                                      "Frequency",
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVABackFrequencyController,
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
                                                                            "Once per Shift",
                                                                        counterText:
                                                                            '',
                                                                      ),
                                                                      style: AppStyles
                                                                          .textInputTextStyle,
                                                                      readOnly:
                                                                          true,
                                                                    ),

                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Text(
                                                                      "Back-sheet dimension& slit cutting diameter",
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVABackController,
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
                                                                            "Enter the Back-sheet dimension& slit cutting diameter",
                                                                        counterText:
                                                                            '',
                                                                        fillColor: Color.fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                      ),
                                                                      style: AppStyles
                                                                          .textInputTextStyle,
                                                                      readOnly: status == 'Pending' &&
                                                                              designation != "QC"
                                                                          ? true
                                                                          : false,
                                                                      validator:
                                                                          MultiValidator(
                                                                        [
                                                                          RequiredValidator(
                                                                            errorText:
                                                                                "Please Enter Correct Back-sheet dimension& slit cutting diameter",
                                                                          ),
                                                                        ],
                                                                      ),
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
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVABackCriteriaController,
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
                                                                            "As per Specification GSPL/BS(IQC)/001 & production order",
                                                                        counterText:
                                                                            '',
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

                                                                    Divider(
                                                                      color: Colors
                                                                          .black,
                                                                      thickness:
                                                                          2,
                                                                      height:
                                                                          20,
                                                                    ),

                                                                    Text(
                                                                      "Frequency",
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVACuttingFrequencyController,
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
                                                                            "Once per Shift",
                                                                        counterText:
                                                                            '',
                                                                      ),
                                                                      style: AppStyles
                                                                          .textInputTextStyle,
                                                                      readOnly:
                                                                          true,
                                                                    ),

                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Text(
                                                                      "cutting Edge of Rear EVA & Backsheet on Glass",
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVAcuttingController,
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
                                                                            "Enter the cutting Edge of Rear EVA & Backsheet on Glass",
                                                                        counterText:
                                                                            '',
                                                                        fillColor: Color.fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                      ),
                                                                      style: AppStyles
                                                                          .textInputTextStyle,
                                                                      readOnly: status == 'Pending' &&
                                                                              designation != "QC"
                                                                          ? true
                                                                          : false,
                                                                      validator:
                                                                          MultiValidator(
                                                                        [
                                                                          RequiredValidator(
                                                                            errorText:
                                                                                "Please Enter Correct cutting Edge of Rear EVA & Backsheet on Glass",
                                                                          ),
                                                                        ],
                                                                      ),
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
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVACuttingCriteriaController,
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
                                                                            "Should not be uneven",
                                                                        counterText:
                                                                            '',
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

                                                                    Divider(
                                                                      color: Colors
                                                                          .black,
                                                                      thickness:
                                                                          2,
                                                                      height:
                                                                          20,
                                                                    ),

                                                                    Text(
                                                                      "Frequency",
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVAPositionFrequencyController,
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
                                                                            "Once per Shift",
                                                                        counterText:
                                                                            '',
                                                                      ),
                                                                      style: AppStyles
                                                                          .textInputTextStyle,
                                                                      readOnly:
                                                                          true,
                                                                    ),

                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Text(
                                                                      "Position of Back EVA & Backsheet on Glass",
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVAPositionController,
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
                                                                            "Enter the Position of Back EVA & Backsheet on Glass",
                                                                        counterText:
                                                                            '',
                                                                        fillColor: Color.fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                      ),
                                                                      style: AppStyles
                                                                          .textInputTextStyle,
                                                                      readOnly: status == 'Pending' &&
                                                                              designation != "QC"
                                                                          ? true
                                                                          : false,
                                                                      validator:
                                                                          MultiValidator(
                                                                        [
                                                                          RequiredValidator(
                                                                            errorText:
                                                                                "Please Enter Correct Position of Back EVA & Backsheet on Glass",
                                                                          ),
                                                                        ],
                                                                      ),
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
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVAPositionCriteriaController,
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
                                                                            "Shifting of EVA on Glass not allowed",
                                                                        counterText:
                                                                            '',
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

                                                                    Divider(
                                                                      color: Colors
                                                                          .black,
                                                                      thickness:
                                                                          2,
                                                                      height:
                                                                          20,
                                                                    ),

                                                                    Text(
                                                                      "Frequency",
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVAAvaibilityFrequencyController,
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
                                                                            "Once per Shift",
                                                                        counterText:
                                                                            '',
                                                                      ),
                                                                      style: AppStyles
                                                                          .textInputTextStyle,
                                                                      readOnly:
                                                                          true,
                                                                    ),

                                                                    const SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Text(
                                                                      "Avaibility of specification&wI.",
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVAAvaibilityController,
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
                                                                            "Enter the Avaibility of specification & wI.",
                                                                        counterText:
                                                                            '',
                                                                        fillColor: Color.fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                      ),
                                                                      style: AppStyles
                                                                          .textInputTextStyle,
                                                                      readOnly: status == 'Pending' &&
                                                                              designation != "QC"
                                                                          ? true
                                                                          : false,
                                                                      validator:
                                                                          MultiValidator(
                                                                        [
                                                                          RequiredValidator(
                                                                            errorText:
                                                                                "Please Enter Correct Avaibility of specification&wI.",
                                                                          ),
                                                                        ],
                                                                      ),
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
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    TextFormField(
                                                                      controller:
                                                                          EVAAvaibilityCriteriaController,
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
                                                                            "Avaibility of Specification & WI & operator should be",
                                                                        counterText:
                                                                            '',
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

                                                                    Divider(
                                                                      color: Colors
                                                                          .black,
                                                                      thickness:
                                                                          2,
                                                                      height:
                                                                          20,
                                                                    ),

                                                                    // *** Remark
                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),

                                                                    Text(
                                                                      "Remark",
                                                                      style: AppStyles
                                                                          .textfieldCaptionTextStyle,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),

                                                                    TextFormField(
                                                                      controller:
                                                                          EVABacksheetRemarkController,
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
                                                                            "Remark ",
                                                                        counterText:
                                                                            '',
                                                                        fillColor: Color.fromARGB(
                                                                            255,
                                                                            215,
                                                                            243,
                                                                            207),
                                                                      ),
                                                                      style: AppStyles
                                                                          .textInputTextStyle,
                                                                      readOnly: status == 'Pending' &&
                                                                              designation != "QC"
                                                                          ? true
                                                                          : false,
                                                                      validator:
                                                                          MultiValidator(
                                                                        [
                                                                          RequiredValidator(
                                                                            errorText:
                                                                                "Please Enter Correct data",
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                    const SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),

                                                                    Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0)),
                                                                    _isLoading
                                                                        ? Center(
                                                                            child:
                                                                                CircularProgressIndicator())
                                                                        : AppButton(
                                                                            textStyle:
                                                                                const TextStyle(
                                                                              fontWeight: FontWeight.w700,
                                                                              color: AppColors.white,
                                                                              fontSize: 16,
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              AppHelper.hideKeyboard(context);
                                                                              if (status != 'Pending') {
                                                                                setState(() {
                                                                                  sendStatus = 'Inprogress';
                                                                                });
                                                                                sendDataToBackend();
                                                                              }
                                                                              setState(() {
                                                                                setPage = "Pre Lamination El & Visual inspection";
                                                                              });
                                                                            },
                                                                            label:
                                                                                "Next",
                                                                            organization:
                                                                                '',
                                                                          ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    // Back button
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
                                                                              setPage = 'Auto Bussing & Tapping';
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
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          25,
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          25,
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          const Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "Powered By Gautam Solar Pvt. Ltd.",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: appFontFamily,
                                                                              color: AppColors.greyColor,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
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
                                                      : setPage ==
                                                              "Pre Lamination El & Visual inspection"
                                                          // Pre Lamination El & Visual inspection
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
                                                                        _preLamFormKey,
                                                                    autovalidateMode:
                                                                        AutovalidateMode
                                                                            .onUserInteraction,
                                                                    child:
                                                                        Column(
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
                                                                            child:
                                                                                Padding(padding: EdgeInsets.only(top: 10), child: Text("Incoming Production Quality Control", style: TextStyle(fontSize: 27, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700)))),
                                                                        const Center(
                                                                            child:
                                                                                Text("(Pre Lam IPQC Checklist)", style: TextStyle(fontSize: 20, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
                                                                        const SizedBox(
                                                                          height:
                                                                              35,
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
                                                                              'GSPL/IPQC/IPC/003',
                                                                              style: AppStyles.textfieldCaptionTextStyle,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              8,
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
                                                                              'Ver.2.0 / 20-03-2024',
                                                                              style: AppStyles.textfieldCaptionTextStyle,
                                                                            ),
                                                                          ],
                                                                        ),

                                                                        // **************  "Pre Lamination El & Visual inspection  *****************
                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        const Center(
                                                                            child:
                                                                                Text("Pre Lamination El & Visual Inspection ", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 13, 160, 0), fontFamily: appFontFamily, fontWeight: FontWeight.w700))),

                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Divider(
                                                                          color:
                                                                              Colors.black,
                                                                          thickness:
                                                                              2,
                                                                          height:
                                                                              20,
                                                                        ),

                                                                        Text(
                                                                          "Frequency",
                                                                          style:
                                                                              AppStyles.textfieldCaptionTextStyle,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        TextFormField(
                                                                          controller:
                                                                              PreLaminationEIinspectionFrequencyController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "5 Pieces Per Shift ",
                                                                            counterText:
                                                                                '',
                                                                          ),
                                                                          style:
                                                                              AppStyles.textInputTextStyle,
                                                                          readOnly:
                                                                              true,
                                                                        ),

                                                                        const SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),

                                                                        Text(
                                                                          "EI Inspection",
                                                                          style:
                                                                              AppStyles.textfieldCaptionTextStyle,
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                2),
                                                                        TextFormField(
                                                                          controller:
                                                                              PreLaminationEInumberOfStringersController,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          maxLength:
                                                                              1,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              numberOfStringers5 = int.tryParse(value) ?? 0;
                                                                              addPreLaminationEIControllers(numberOfStringers5 * 5);
                                                                            });
                                                                          },
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "Enter the number of Stringers",
                                                                            fillColor: Color.fromARGB(
                                                                                255,
                                                                                215,
                                                                                243,
                                                                                207),
                                                                          ),
                                                                          style:
                                                                              AppStyles.textInputTextStyle,
                                                                          readOnly: status == 'Pending' && designation != "QC"
                                                                              ? true
                                                                              : false,
                                                                          validator:
                                                                              MultiValidator(
                                                                            [
                                                                              RequiredValidator(
                                                                                errorText: "Enter the number of Stringers",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        ListView
                                                                            .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          itemCount:
                                                                              numberOfStringers5 * 5,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            int stringerIndex =
                                                                                (index ~/ 5) + 1;
                                                                            int textFieldIndex =
                                                                                index % 5;
                                                                            return Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                if (textFieldIndex == 0)
                                                                                  Text(
                                                                                    "Stringer $stringerIndex",
                                                                                    style: AppStyles.textInputTextStyle.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                SizedBox(height: 10),
                                                                                TextFormField(
                                                                                  controller: PreLaminationEIinspectionrControllers[index],
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Please Enter stringer data",
                                                                                    counterText: '',
                                                                                    fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                    contentPadding: EdgeInsets.all(10),
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return 'Please Enter correct string data.';
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),

                                                                        const SizedBox(
                                                                          height:
                                                                              2,
                                                                        ),

                                                                        Text(
                                                                          "Acceptance Criteria",
                                                                          style:
                                                                              AppStyles.textfieldCaptionTextStyle,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        TextFormField(
                                                                          controller:
                                                                              PreLaminationEIinspectionCriteriaController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "EI image should fulfil the EL Acceptance Critoria ",
                                                                            counterText:
                                                                                '',
                                                                          ),
                                                                          style:
                                                                              AppStyles.textInputTextStyle,
                                                                          readOnly:
                                                                              true,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),

                                                                        Divider(
                                                                          color:
                                                                              Colors.black,
                                                                          thickness:
                                                                              2,
                                                                          height:
                                                                              20,
                                                                        ),

                                                                        Text(
                                                                          "Frequency",
                                                                          style:
                                                                              AppStyles.textfieldCaptionTextStyle,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        TextFormField(
                                                                          controller:
                                                                              PreLaminationVisualFrequencyController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "5 Pieces Per Shift ",
                                                                            counterText:
                                                                                '',
                                                                          ),
                                                                          style:
                                                                              AppStyles.textInputTextStyle,
                                                                          readOnly:
                                                                              true,
                                                                        ),

                                                                        const SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),

                                                                        Text(
                                                                          "Visual Inspection",
                                                                          style:
                                                                              AppStyles.textfieldCaptionTextStyle,
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        TextFormField(
                                                                          controller:
                                                                              PreLaminationVisualnumberOfStringersController,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          maxLength:
                                                                              1,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              numberOfStringers6 = int.tryParse(value) ?? 0;
                                                                              addPreLaminationVisualControllers(numberOfStringers6 * 5);
                                                                            });
                                                                          },
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "Enter the number of Stringers",
                                                                            fillColor: Color.fromARGB(
                                                                                255,
                                                                                215,
                                                                                243,
                                                                                207),
                                                                          ),
                                                                          style:
                                                                              AppStyles.textInputTextStyle,
                                                                          readOnly: status == 'Pending' && designation != "QC"
                                                                              ? true
                                                                              : false,
                                                                          validator:
                                                                              MultiValidator(
                                                                            [
                                                                              RequiredValidator(
                                                                                errorText: "Enter the number of Stringers",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        ListView
                                                                            .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          itemCount:
                                                                              numberOfStringers6 * 5,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            int stringerIndex =
                                                                                (index ~/ 5) + 1;
                                                                            int textFieldIndex =
                                                                                index % 5;
                                                                            return Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                if (textFieldIndex == 0)
                                                                                  Text(
                                                                                    "Stringer $stringerIndex",
                                                                                    style: AppStyles.textInputTextStyle.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                SizedBox(height: 10),
                                                                                TextFormField(
                                                                                  controller: PreLaminationVisualinspectionrControllers[index],
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Please Enter stringer",
                                                                                    counterText: '',
                                                                                    fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                    contentPadding: EdgeInsets.all(10),
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                  validator: (value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return 'Please Enter correct Stringer.';
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),

                                                                        const SizedBox(
                                                                          height:
                                                                              2,
                                                                        ),

                                                                        Text(
                                                                          "Acceptance Criteria",
                                                                          style:
                                                                              AppStyles.textfieldCaptionTextStyle,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        TextFormField(
                                                                          controller:
                                                                              PreLaminationVisualinspectionCriteriaController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "Visual image should fulfil the Visual Acceptance Critoria as per GSPL/IPQC/EL/020",
                                                                            counterText:
                                                                                '',
                                                                          ),
                                                                          style:
                                                                              AppStyles.textInputTextStyle,
                                                                          readOnly:
                                                                              true,
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),

                                                                        Divider(
                                                                          color:
                                                                              Colors.black,
                                                                          thickness:
                                                                              2,
                                                                          height:
                                                                              20,
                                                                        ),

                                                                        Text(
                                                                          "Frequency",
                                                                          style:
                                                                              AppStyles.textfieldCaptionTextStyle,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        TextFormField(
                                                                          controller:
                                                                              PreLaminationAvaibilityFrequencyController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "Once per Shift",
                                                                            counterText:
                                                                                '',
                                                                          ),
                                                                          style:
                                                                              AppStyles.textInputTextStyle,
                                                                          readOnly:
                                                                              true,
                                                                        ),

                                                                        const SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                          "Avaibility of acceptance Criteria & wI.",
                                                                          style:
                                                                              AppStyles.textfieldCaptionTextStyle,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        TextFormField(
                                                                          controller:
                                                                              PreLaminationAvaibilityController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "Enter the Avaibility of acceptance Criteria & wI.",
                                                                            counterText:
                                                                                '',
                                                                            fillColor: Color.fromARGB(
                                                                                255,
                                                                                215,
                                                                                243,
                                                                                207),
                                                                          ),
                                                                          style:
                                                                              AppStyles.textInputTextStyle,
                                                                          readOnly: status == 'Pending' && designation != "QC"
                                                                              ? true
                                                                              : false,
                                                                          validator:
                                                                              MultiValidator(
                                                                            [
                                                                              RequiredValidator(
                                                                                errorText: "Please Enter Correct Avaibility of acceptance Criteria & wI.",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),

                                                                        Text(
                                                                          "Acceptance Criteria",
                                                                          style:
                                                                              AppStyles.textfieldCaptionTextStyle,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        TextFormField(
                                                                          controller:
                                                                              PreLaminationAvaibilityWIController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "Avaibility of Acceptance Criteria and operator should be aware of Criteria",
                                                                            counterText:
                                                                                '',
                                                                          ),
                                                                          style:
                                                                              AppStyles.textInputTextStyle,
                                                                          readOnly:
                                                                              true,
                                                                        ),

                                                                        //  *** Remark
                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),

                                                                        Text(
                                                                          "Remark",
                                                                          style:
                                                                              AppStyles.textfieldCaptionTextStyle,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),

                                                                        TextFormField(
                                                                          controller:
                                                                              PreLaminationELRemarkController,
                                                                          keyboardType:
                                                                              TextInputType.text,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          decoration: AppStyles
                                                                              .textFieldInputDecoration
                                                                              .copyWith(
                                                                            hintText:
                                                                                "Remark ",
                                                                            counterText:
                                                                                '',
                                                                            fillColor: Color.fromARGB(
                                                                                255,
                                                                                215,
                                                                                243,
                                                                                207),
                                                                          ),
                                                                          style:
                                                                              AppStyles.textInputTextStyle,
                                                                          readOnly: status == 'Pending' && designation != "QC"
                                                                              ? true
                                                                              : false,
                                                                          validator:
                                                                              MultiValidator(
                                                                            [
                                                                              RequiredValidator(
                                                                                errorText: "Please Enter Correct data",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        const SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        Padding(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                0,
                                                                                10,
                                                                                0,
                                                                                0)),
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

                                                                                  sample5Controller = [];
                                                                                  for (int i = 0; i < numberOfStringers5 * 5; i++) {
                                                                                    sample5Controller.add({
                                                                                      "PreLaminationEIinspectionrControllers${i + 1}": PreLaminationEIinspectionrControllers[i].text,
                                                                                    });
                                                                                  }

                                                                                  sample6Controller = [];
                                                                                  for (int i = 0; i < numberOfStringers6 * 5; i++) {
                                                                                    sample6Controller.add({
                                                                                      "PreLaminationVisualinspectionrControllers${i + 1}": PreLaminationVisualinspectionrControllers[i].text,
                                                                                    });
                                                                                  }
                                                                                  if (status != 'Pending') {
                                                                                    setState(() {
                                                                                      sendStatus = 'Inprogress';
                                                                                    });
                                                                                    sendDataToBackend();
                                                                                  }
                                                                                  setState(() {
                                                                                    setPage = "String Rework Station";
                                                                                  });
                                                                                },
                                                                                label: "Next",
                                                                                organization: '',
                                                                              ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),

                                                                        // Back button
                                                                        Center(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  setPage = 'EVA/Backsheet Cutting';
                                                                                });
                                                                              },
                                                                              child: const Text(
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
                                                          : setPage ==
                                                                  "String Rework Station"
                                                              // String Rework Station start
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
                                                                            _preLamFormKey,
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
                                                                            const Center(child: Padding(padding: EdgeInsets.only(top: 10), child: Text("Incoming Production Quality Control", style: TextStyle(fontSize: 27, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700)))),
                                                                            const Center(child: Text("(Pre Lam IPQC Checklist)", style: TextStyle(fontSize: 20, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
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
                                                                                  'GSPL/IPQC/IPC/003',
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
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
                                                                                  'Ver.2.0 / 20-03-2024',
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                              ],
                                                                            ),

                                                                            // ************** String Rework Station *****************
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            const Center(child: Text("String Rework Station", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 13, 160, 0), fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),

                                                                            Text(
                                                                              "Frequency",
                                                                              style: AppStyles.textfieldCaptionTextStyle,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            TextFormField(
                                                                              controller: StringAvaibilityFrequencyController,
                                                                              keyboardType: TextInputType.text,
                                                                              textInputAction: TextInputAction.next,
                                                                              decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                hintText: "Once a Shift",
                                                                                counterText: '',
                                                                              ),
                                                                              style: AppStyles.textInputTextStyle,
                                                                              readOnly: true,
                                                                            ),

                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Text(
                                                                              "Avaibility of Work instruction(WI)",
                                                                              style: AppStyles.textfieldCaptionTextStyle,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            TextFormField(
                                                                              controller: StringAvaibilityController,
                                                                              keyboardType: TextInputType.text,
                                                                              textInputAction: TextInputAction.next,
                                                                              decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                hintText: "Enter the Avaibility of Work instruction(WI)",
                                                                                counterText: '',
                                                                                fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                              ),
                                                                              style: AppStyles.textInputTextStyle,
                                                                              readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                              validator: MultiValidator(
                                                                                [
                                                                                  RequiredValidator(
                                                                                    errorText: "Please Enter Correct Avaibility of Work instruction(WI)",
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),

                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),

                                                                            Text(
                                                                              "Acceptance Criteria",
                                                                              style: AppStyles.textfieldCaptionTextStyle,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            TextFormField(
                                                                              controller: StringAvaibilityCriteriaController,
                                                                              keyboardType: TextInputType.text,
                                                                              textInputAction: TextInputAction.next,
                                                                              decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                hintText: "WI Should be available at station and operator should be aware of WI",
                                                                                counterText: '',
                                                                              ),
                                                                              style: AppStyles.textInputTextStyle,
                                                                              readOnly: true,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Divider(
                                                                              color: Colors.black,
                                                                              thickness: 2,
                                                                              height: 20,
                                                                            ),

                                                                            Text(
                                                                              "Frequency",
                                                                              style: AppStyles.textfieldCaptionTextStyle,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            TextFormField(
                                                                              controller: StringCleaningFrequencyController,
                                                                              keyboardType: TextInputType.text,
                                                                              textInputAction: TextInputAction.next,
                                                                              decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                hintText: "Once a Shift",
                                                                                counterText: '',
                                                                              ),
                                                                              style: AppStyles.textInputTextStyle,
                                                                              readOnly: true,
                                                                            ),

                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Text(
                                                                              "Cleaning of Rework station/soldering iron sponge",
                                                                              style: AppStyles.textfieldCaptionTextStyle,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            TextFormField(
                                                                              controller: StringCleaningController,
                                                                              keyboardType: TextInputType.text,
                                                                              textInputAction: TextInputAction.next,
                                                                              decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                hintText: "Enter the Cleaning of Rework station/soldering iron sponge",
                                                                                counterText: '',
                                                                                fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                              ),
                                                                              style: AppStyles.textInputTextStyle,
                                                                              readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                              validator: MultiValidator(
                                                                                [
                                                                                  RequiredValidator(
                                                                                    errorText: "Please Enter Correct Cleaning of Rework station/soldering iron sponge",
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),

                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),

                                                                            Text(
                                                                              "Acceptance Criteria",
                                                                              style: AppStyles.textfieldCaptionTextStyle,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            TextFormField(
                                                                              controller: StringCleaningCriteriaController,
                                                                              keyboardType: TextInputType.text,
                                                                              textInputAction: TextInputAction.next,
                                                                              decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                hintText: "Rework Station should be Clean",
                                                                                counterText: '',
                                                                              ),
                                                                              style: AppStyles.textInputTextStyle,
                                                                              readOnly: true,
                                                                            ),

                                                                            // *** Remark
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),

                                                                            Text(
                                                                              "Remark",
                                                                              style: AppStyles.textfieldCaptionTextStyle,
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),

                                                                            TextFormField(
                                                                              controller: StringReworkRemarkController,
                                                                              keyboardType: TextInputType.text,
                                                                              textInputAction: TextInputAction.next,
                                                                              decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                hintText: "Remark ",
                                                                                counterText: '',
                                                                                fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                              ),
                                                                              style: AppStyles.textInputTextStyle,
                                                                              readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                              validator: MultiValidator(
                                                                                [
                                                                                  RequiredValidator(
                                                                                    errorText: "Please Enter Correct data",
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
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
                                                                                      if (status != 'Pending') {
                                                                                        setState(() {
                                                                                          sendStatus = 'Inprogress';
                                                                                        });
                                                                                        sendDataToBackend();
                                                                                      }
                                                                                      setState(() {
                                                                                        setPage = "Module Rework Station";
                                                                                        sendStatus = "Inprogress";
                                                                                      });
                                                                                    },
                                                                                    label: "Next",
                                                                                    organization: '',
                                                                                  ),
                                                                            const SizedBox(
                                                                              height: 10,
                                                                            ),

                                                                            // Back button
                                                                            Center(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      setPage = 'Pre Lamination El & Visual inspection';
                                                                                    });
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
                                                              : setPage ==
                                                                      "Module Rework Station"
                                                                  //   Module Rework Station start
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
                                                                                _preLamFormKey,
                                                                            autovalidateMode:
                                                                                AutovalidateMode.onUserInteraction,
                                                                            child:
                                                                                Column(
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
                                                                                const Center(child: Padding(padding: EdgeInsets.only(top: 10), child: Text("Incoming Production Quality Control", style: TextStyle(fontSize: 27, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700)))),
                                                                                const Center(child: Text("(Pre Lam IPQC Checklist)", style: TextStyle(fontSize: 20, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
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
                                                                                      'GSPL/IPQC/IPC/003',
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
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
                                                                                      'Ver.2.0 / 20-03-2024',
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                  ],
                                                                                ),

                                                                                // ************** Module Rework Station *****************
                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                const Center(child: Text("Module Rework Station", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 13, 160, 0), fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),

                                                                                Text(
                                                                                  "Frequency",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleAvaibilityFrequencyController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Once a Shift",
                                                                                    counterText: '',
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: true,
                                                                                ),

                                                                                const SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                                Text(
                                                                                  "Avaibility of Work instruction(WI)",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleAvaibilityController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Enter the Avaibility of Work instruction(WI)",
                                                                                    counterText: '',
                                                                                    fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                  validator: MultiValidator(
                                                                                    [
                                                                                      RequiredValidator(
                                                                                        errorText: "Please Enter Correct Avaibility of Work instruction(WI)",
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),

                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),

                                                                                Text(
                                                                                  "Acceptance Criteria",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleAvaibilityCriteriaController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "WI Should be available at station and operator should be aware of WI",
                                                                                    counterText: '',
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: true,
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                Divider(
                                                                                  color: Colors.black,
                                                                                  thickness: 2,
                                                                                  height: 20,
                                                                                ),

                                                                                Text(
                                                                                  "Frequency",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleMethodCleaningFrequencyController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Once a Shift",
                                                                                    counterText: '',
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: true,
                                                                                ),

                                                                                const SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                                Text(
                                                                                  "Method of Rework",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleMethodCleaningController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Enter the Method of Rework",
                                                                                    counterText: '',
                                                                                    fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                  validator: MultiValidator(
                                                                                    [
                                                                                      RequiredValidator(
                                                                                        errorText: "Please Enter Correct Method of Rework",
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),

                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),

                                                                                Text(
                                                                                  "Acceptance Criteria",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleMethodCleaningCriteriaController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "As per WI",
                                                                                    counterText: '',
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: true,
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),

                                                                                Divider(
                                                                                  color: Colors.black,
                                                                                  thickness: 2,
                                                                                  height: 20,
                                                                                ),
                                                                                Text(
                                                                                  "Frequency",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleHandlingFrequencyController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Once a Shift",
                                                                                    counterText: '',
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: true,
                                                                                ),

                                                                                const SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                                Text(
                                                                                  "Handling of Modules",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleHandlingController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Enter the Handling of Modules",
                                                                                    counterText: '',
                                                                                    fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                  validator: MultiValidator(
                                                                                    [
                                                                                      RequiredValidator(
                                                                                        errorText: "Please Enter Correct Handling of Modules",
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),

                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),

                                                                                Text(
                                                                                  "Acceptance Criteria",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleHandlingCriteriaController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Operator Should handle the rework module with both the Hands",
                                                                                    counterText: '',
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: true,
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                Divider(
                                                                                  color: Colors.black,
                                                                                  thickness: 2,
                                                                                  height: 20,
                                                                                ),

                                                                                Text(
                                                                                  "Frequency",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleCleaningofReworkFrequencyController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Once a Shift",
                                                                                    counterText: '',
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: true,
                                                                                ),

                                                                                const SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                                Text(
                                                                                  "Cleaning of Rework station/soldering iron sponge",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleCleaningofReworkController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Enter the Cleaning of Rework station/soldering iron sponge",
                                                                                    counterText: '',
                                                                                    fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                  validator: MultiValidator(
                                                                                    [
                                                                                      RequiredValidator(
                                                                                        errorText: "Please Enter Correct Cleaning of Rework station/soldering iron sponge",
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),

                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),

                                                                                Text(
                                                                                  "Acceptance Criteria",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                TextFormField(
                                                                                  controller: ModuleCleaningofReworkCriteriaController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Rework station should be clean",
                                                                                    counterText: '',
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: true,
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),

                                                                                // *** Remark

                                                                                Text(
                                                                                  "Remark",
                                                                                  style: AppStyles.textfieldCaptionTextStyle,
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),

                                                                                TextFormField(
                                                                                  controller: ModuleCleaningRemarkController,
                                                                                  keyboardType: TextInputType.text,
                                                                                  textInputAction: TextInputAction.next,
                                                                                  decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                    hintText: "Remark ",
                                                                                    counterText: '',
                                                                                    fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                  ),
                                                                                  style: AppStyles.textInputTextStyle,
                                                                                  readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                  validator: MultiValidator(
                                                                                    [
                                                                                      RequiredValidator(
                                                                                        errorText: "Please Enter Correct data",
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
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
                                                                                          if (status != 'Pending') {
                                                                                            setState(() {
                                                                                              sendStatus = 'Inprogress';
                                                                                            });
                                                                                            sendDataToBackend();
                                                                                          }
                                                                                          setState(() {
                                                                                            setPage = "Laminator";
                                                                                          });
                                                                                        },
                                                                                        label: "Next",
                                                                                        organization: '',
                                                                                      ),
                                                                                const SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                // Back button

                                                                                Center(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: InkWell(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          setPage = 'String Rework Station';
                                                                                        });
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
                                                                  : setPage ==
                                                                          "Laminator"
                                                                      //   Laminator start
                                                                      ? Stack(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          fit: StackFit
                                                                              .expand,
                                                                          children: [
                                                                            SingleChildScrollView(
                                                                              child: Form(
                                                                                key: _preLamFormKey,
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
                                                                                    const Center(child: Padding(padding: EdgeInsets.only(top: 10), child: Text("Incoming Production Quality Control", style: TextStyle(fontSize: 27, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700)))),
                                                                                    const Center(child: Text("(Pre Lam IPQC Checklist)", style: TextStyle(fontSize: 20, color: AppColors.black, fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
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
                                                                                          'GSPL/IPQC/IPC/003',
                                                                                          style: AppStyles.textfieldCaptionTextStyle,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(
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
                                                                                          'Ver.2.0 / 20-03-2024',
                                                                                          style: AppStyles.textfieldCaptionTextStyle,
                                                                                        ),
                                                                                      ],
                                                                                    ),

                                                                                    // ************** Laminator  *****************
                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),
                                                                                    const Center(child: Text("Laminator", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 13, 160, 0), fontFamily: appFontFamily, fontWeight: FontWeight.w700))),
                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),

                                                                                    Text(
                                                                                      "Frequency",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorMonitoringFrequencyController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "Once a Shift",
                                                                                        counterText: '',
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: true,
                                                                                    ),

                                                                                    const SizedBox(
                                                                                      height: 20,
                                                                                    ),
                                                                                    Text(
                                                                                      "Monitoring of Laminator Process Parameter",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorMonitoringController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "Enter the Monitoring of Laminator Process Parameter",
                                                                                        counterText: '',
                                                                                        fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                      validator: MultiValidator(
                                                                                        [
                                                                                          RequiredValidator(
                                                                                            errorText: "Please Enter Correct Monitoring of Laminator Process Parameter",
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),

                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),

                                                                                    Text(
                                                                                      "Acceptance Criteria",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorMonitoringCriteriaController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "Laminator specification GSPL/IPQC/LM/008 |  GSPL/IPQC/LM/009 |  GSPL/IPQC/LM/010",
                                                                                        counterText: '',
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: true,
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),
                                                                                    Divider(
                                                                                      color: Colors.black,
                                                                                      thickness: 2,
                                                                                      height: 20,
                                                                                    ),

                                                                                    Text(
                                                                                      "Frequency",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorAdhesiveFrequencyController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "Once a Shift",
                                                                                        counterText: '',
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: true,
                                                                                    ),

                                                                                    const SizedBox(
                                                                                      height: 20,
                                                                                    ),
                                                                                    Text(
                                                                                      "Adhesive on backsheet of the module",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorAdhesiveController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "Enter the Adhesive on backsheet of the module",
                                                                                        counterText: '',
                                                                                        fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                      validator: MultiValidator(
                                                                                        [
                                                                                          RequiredValidator(
                                                                                            errorText: "Please Enter Correct Adhesive on backsheet of the module",
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),

                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),

                                                                                    Text(
                                                                                      "Acceptance Criteria",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorAdhesiveCriteriaController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "Teflon should be clean, No EVA residue is allowed ",
                                                                                        counterText: '',
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: true,
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),

                                                                                    Divider(
                                                                                      color: Colors.black,
                                                                                      thickness: 2,
                                                                                      height: 20,
                                                                                    ),
                                                                                    Text(
                                                                                      "Frequency",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorPeelFrequencyController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "All Position | All Laminator Once a Week",
                                                                                        counterText: '',
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: true,
                                                                                    ),

                                                                                    const SizedBox(
                                                                                      height: 20,
                                                                                    ),
                                                                                    Text(
                                                                                      "Peel Adhesive Test",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorPeelController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "Enter the Peel Adhesive Test",
                                                                                        counterText: '',
                                                                                        fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                      validator: MultiValidator(
                                                                                        [
                                                                                          RequiredValidator(
                                                                                            errorText: "Please Enter Correct Peel Adhesive Test",
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),

                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),

                                                                                    Text(
                                                                                      "Acceptance Criteria",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorPeelCriteriaController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "Eva to Glass = 70N/cm EVA to Backsheet >= 80N/cm",
                                                                                        counterText: '',
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: true,
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),
                                                                                    Divider(
                                                                                      color: Colors.black,
                                                                                      thickness: 2,
                                                                                      height: 20,
                                                                                    ),

                                                                                    Text(
                                                                                      "Frequency",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorGelFrequencyController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "All Position | All Laminator once a week ",
                                                                                        counterText: '',
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: true,
                                                                                    ),

                                                                                    const SizedBox(
                                                                                      height: 20,
                                                                                    ),
                                                                                    Text(
                                                                                      "Gel Content Test",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorGelController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "Enter the Gel Content Test",
                                                                                        counterText: '',
                                                                                        fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                      validator: MultiValidator(
                                                                                        [
                                                                                          RequiredValidator(
                                                                                            errorText: "Please Enter Correct Gel Content Test",
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),

                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),

                                                                                    Text(
                                                                                      "Acceptance Criteria",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    TextFormField(
                                                                                      controller: LaminatorGelCriteriaController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "75 to 95% ",
                                                                                        counterText: '',
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: true,
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),

                                                                                    // *** Remark
                                                                                    Text(
                                                                                      "Remark",
                                                                                      style: AppStyles.textfieldCaptionTextStyle,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),

                                                                                    TextFormField(
                                                                                      controller: LaminatorRemarkController,
                                                                                      keyboardType: TextInputType.text,
                                                                                      textInputAction: TextInputAction.next,
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                        hintText: "Remark ",
                                                                                        counterText: '',
                                                                                        fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                      ),
                                                                                      style: AppStyles.textInputTextStyle,
                                                                                      readOnly: status == 'Pending' && designation != "QC" ? true : false,
                                                                                      validator: MultiValidator(
                                                                                        [
                                                                                          RequiredValidator(
                                                                                            errorText: "Please Enter Correct data",
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),
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
                                                                                      decoration: AppStyles.textFieldInputDecoration.copyWith(
                                                                                          hintText: "Please Select Reference Pdf",
                                                                                          fillColor: Color.fromARGB(255, 215, 243, 207),
                                                                                          suffixIcon: IconButton(
                                                                                            onPressed: () async {
                                                                                              if (widget.id != null && widget.id != '' && referencePdfController.text != '') {
                                                                                                UrlLauncher.launch(referencePdfController.text);
                                                                                              } else if (status != 'Pending') {
                                                                                                _pickReferencePDF();
                                                                                              }
                                                                                            },
                                                                                            icon: widget.id != null && widget.id != '' && referencePdfController.text != '' ? const Icon(Icons.download) : const Icon(Icons.upload_file),
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

                                                                                    Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                                                                    _isLoading
                                                                                        ? Center(child: CircularProgressIndicator())
                                                                                        : (widget.id == "" || widget.id == null) || (status == 'Inprogress' && widget.id != null)
                                                                                            ? AppButton(
                                                                                                textStyle: const TextStyle(
                                                                                                  fontWeight: FontWeight.w700,
                                                                                                  color: AppColors.white,
                                                                                                  fontSize: 16,
                                                                                                ),
                                                                                                onTap: () {
                                                                                                  AppHelper.hideKeyboard(context);
                                                                                                  //sendDataToBackend(); //300

                                                                                                  _preLamFormKey.currentState!.save;
                                                                                                  if (_preLamFormKey.currentState!.validate()) {
                                                                                                    setState(() {
                                                                                                      // setPage = "Cell Cutting Machine";
                                                                                                      sendStatus = "Pending";
                                                                                                    });
                                                                                                    sendDataToBackend();
                                                                                                  }
                                                                                                },
                                                                                                label: "Save",
                                                                                                organization: '',
                                                                                              )
                                                                                            : Container(),

                                                                                    const SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                    if (widget.id != "" && widget.id != null && status == 'Pending')
                                                                                      Container(
                                                                                        color: Color.fromARGB(255, 191, 226, 187), // Change the background color to your desired color
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                                          children: [
                                                                                            Divider(),
                                                                                            SizedBox(height: 15),
                                                                                            AppButton(
                                                                                              textStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.white, fontSize: 16),
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

                                                                                    // Back button
                                                                                    Center(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: InkWell(
                                                                                          onTap: () {
                                                                                            setState(() {
                                                                                              setPage = 'Module Rework Station';
                                                                                            });
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
