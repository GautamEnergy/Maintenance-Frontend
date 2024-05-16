import 'dart:async';
import 'dart:convert';
import 'package:QCM/AluminiumFrame.dart';
import 'package:QCM/Backsheet.dart';
import 'package:QCM/CommonDrawer.dart';
import 'package:QCM/Encapsulant.dart';
import 'package:QCM/Flux.dart';
import 'package:QCM/Iqcp.dart';
import 'package:QCM/JunctionBox.dart';
import 'package:QCM/Ribbon.dart';
import 'package:QCM/Sealant.dart';
import 'package:QCM/SolarCell.dart';
import 'package:QCM/SolarGlass.dart';
import 'package:QCM/Welcomepage.dart';
import 'package:QCM/components/app_loader.dart';
import 'package:QCM/components/appbar.dart';
import 'package:QCM/constant/app_assets.dart';
import 'package:QCM/constant/app_color.dart';
import 'package:QCM/constant/app_fonts.dart';
import 'package:QCM/constant/app_styles.dart';
import 'package:QCM/Iqcp_list_model.dart';
import 'package:QCM/directory.dart';
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class IqcpTestList extends StatefulWidget {
  IqcpTestList();

  @override
  _IqcpTestListState createState() => _IqcpTestListState();
}

class _IqcpTestListState extends State<IqcpTestList> {
  TextEditingController SearchController = TextEditingController();
  // TextEditingController _paymentModeController = new TextEditingController();

  bool _isLoading = false;
  bool menu = false, user = false, face = false, home = false;
  bool _enabled = false;
  List paymentModeData = [];
  String? personid,
      token,
      vCard,
      firstname,
      lastname,
      pic,
      logo,
      site,
      designation,
      department,
      detail,
      businessname,
      organizationName,
      otherChapterName = '',
      organizationtype,
      _hasBeenPressed1 = 'Pending';

  bool status = false, isAllowedEdit = false;
  var decodedResult;

  Future? userdata;
  late UserModel aUserModel;
  List dropdownList = [];

  @override
  void initState() {
    if (mounted) {
      detail = 'hide';
      store();
    }
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

    userdata = getData();
  }

  Future<List<UserData>?> getData() async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');
    setState(() {
      _isLoading = true;
      // _enabled = true;
    });

    final url = (site! + 'IQCSolarCell/GetIQCTests');

    http.post(
      Uri.parse(url),
      body: jsonEncode(
          <String, String>{"token": token!, "Status": _hasBeenPressed1!}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          // _enabled = false;
          decodedResult = jsonDecode(response.body);
        });
        //  prefs.setString(DBConst.directory, response.body);
      }
    });

    return null;
  }

  void setMemberStatus(id) async {
    final prefs = await SharedPreferences.getInstance();
    site = prefs.getString('site');
    final url = (site!) + 'removeEmployeeById';
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(<String, String>{"personid": id}),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      Toast.show("Employee Removed Successfully",
          duration: Toast.lengthLong,
          gravity: Toast.center,
          backgroundColor: AppColors.primaryColor);

      getData();

      return;
    } else {
      throw Exception('Failed To Fetch Data');
    }
  }

  Future<bool> redirectto() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                department == 'IQCP' && designation != 'Super Admin'
                    ? IqcpPage()
                    : WelcomePage()),
        (Route<dynamic> route) => false);
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
            child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: AppColors.appBackgroundColor,
                appBar: GautamAppBar(
                  organization: "organizationtype",
                  isBackRequired: true,
                  memberId: personid,
                  imgPath: "ImagePath",
                  memberPic: pic,
                  logo: "logo",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return designation != 'Super Admin'
                          ? IqcpPage()
                          : WelcomePage();
                    }));
                  },
                ),
                body: _isLoading
                    ? AppLoader(organization: organizationtype)
                    : RefreshIndicator(
                        color: Colors.white,
                        backgroundColor: AppColors.blueColor,
                        onRefresh: () async {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      IqcpTestList()),
                              (Route<dynamic> route) => false);
                          return Future<void>.delayed(
                              const Duration(seconds: 3));
                        },
                        child: Container(
                          // margin: EdgeInsets.only(bottom: 80),
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: _userData()),
                        ),
                      ),
                bottomNavigationBar: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 245, 203, 19),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        designation != 'Super Admin'
                                            ? IqcpPage()
                                            : WelcomePage()));
                          },
                          child: Image.asset(
                              home
                                  ? AppAssets.icHomeSelected
                                  : AppAssets.icHomeUnSelected,
                              height: 25)),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            if (designation == 'Super Admin') {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EmployeeList()));
                            }
                          },
                          child: Image.asset(
                              user
                                  ? AppAssets.imgSelectedPerson
                                  : AppAssets.imgPerson,
                              height: 25)),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            // Navigator.of(context).pushReplacement(
                            //     MaterialPageRoute(
                            //         builder: (BuildContext context) =>
                            //             Attendance()));
                          },
                          child: Image.asset(
                              face
                                  ? AppAssets.icSearchSelected
                                  : AppAssets.icSearchUnSelected,
                              height: 25)),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PublicDrawer()));
                          },
                          child: Image.asset(
                              menu
                                  ? AppAssets.imgSelectedMenu
                                  : AppAssets.imgMenu,
                              height: 25)),
                    ],
                  ),
                ),
              ),
            )));
  }

// <List<UserData>> List<UserData>
  _userData() {
    return FutureBuilder(
      future: userdata,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          aUserModel = UserModel.fromJson(decodedResult);

          List<UserData> data = aUserModel.data!;

          return _user(aUserModel);
        } else if (snapshot.hasError) {
          return const AppLoader();
        }

        return const AppLoader();
      },
    );
  }

  Widget filter() {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //#1 Inprogress
            InkWell(
                onTap: () {
                  setState(() {
                    _hasBeenPressed1 = 'Inprogress';
                  });
                  userdata = getData();
                },
                child: Text('Inprogress',
                    style: TextStyle(
                        fontFamily: appFontFamily,
                        color: _hasBeenPressed1 == 'Inprogress'
                            ? AppColors.blueColor
                            : AppColors.black,
                        fontWeight: _hasBeenPressed1 == 'Inprogress'
                            ? FontWeight.w700
                            : FontWeight.normal))),

            const Text(
              ' | ',
              style: TextStyle(
                  fontFamily: appFontFamily,
                  color: AppColors.blueColor,
                  fontWeight: FontWeight.w700),
            ),

            //#2 Approved
            InkWell(
              onTap: () {
                setState(() {
                  _hasBeenPressed1 = 'Approved';
                });
                userdata = getData();
              },
              child: Text(
                'Approved',
                style: TextStyle(
                    fontFamily: appFontFamily,
                    color: _hasBeenPressed1 == 'Approved'
                        ? AppColors.blueColor
                        : AppColors.black,
                    fontWeight: _hasBeenPressed1 == 'Approved'
                        ? FontWeight.w700
                        : FontWeight.normal),
              ),
            ),

            const Text(
              ' | ',
              style: TextStyle(
                  fontFamily: appFontFamily,
                  color: AppColors.blueColor,
                  fontWeight: FontWeight.w700),
            ),

            InkWell(
              onTap: () {
                setState(() {
                  _hasBeenPressed1 = 'Pending';
                });
                userdata = getData();
              },
              child: Text(
                'Pending',
                style: TextStyle(
                    fontFamily: appFontFamily,
                    color: _hasBeenPressed1 == 'Pending'
                        ? AppColors.blueColor
                        : AppColors.black,
                    fontWeight: _hasBeenPressed1 == 'Pending'
                        ? FontWeight.w700
                        : FontWeight.normal),
              ),
            ),

            const Text(
              ' | ',
              style: TextStyle(
                  fontFamily: appFontFamily,
                  color: AppColors.blueColor,
                  fontWeight: FontWeight.w700),
            ),

            InkWell(
              onTap: () {
                setState(() {
                  _hasBeenPressed1 = 'Rejected';
                });
                userdata = getData();
              },
              child: Text(
                'Rejected',
                style: TextStyle(
                    fontFamily: appFontFamily,
                    color: _hasBeenPressed1 == 'Rejected'
                        ? AppColors.blueColor
                        : AppColors.black,
                    fontWeight: _hasBeenPressed1 == 'Rejected'
                        ? FontWeight.w700
                        : FontWeight.normal),
              ),
            ),
          ],
        ));
  }

  Column _user(UserModel data) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.only(top: 15, left: 10, right: 10)),
      const Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('IQCP Test List',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: AppColors.blueColor)),
            ],
          )),
      const Padding(padding: EdgeInsets.only(top: 15, left: 10, right: 10)),
      Row(children: <Widget>[
        Container(
          child: Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: SearchController,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: AppStyles.textFieldInputDecoration.copyWith(
                  hintText: "Search IQCP",
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 25,
                    color: AppColors.lightBlackColor,
                  )),
              style: AppStyles.textInputTextStyle,
              onChanged: (value) {
                setState(() {});
              },
            ),
          )),
        ),
      ]),
      Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [filter()],
          )),
      Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  data.data!.length > 1
                      ? '${data.data!.length} Tests'
                      : '${data.data!.length} Test',
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: appFontFamily,
                      fontSize: 15,
                      color: AppColors.greyColor)),
              // if (isAllowedEdit) filter()
            ],
          )),
      Container(
        child: Expanded(
            child: ListView.builder(
                itemCount: data.data!.length,
                itemBuilder: (context, index) {
                  if (SearchController.text.isEmpty) {
                    return Container(
                        child: _tile(
                            data.data![index].solarDetailID ?? '',
                            data.data![index].materialName ?? '',
                            data.data![index].profileImg ?? '',
                            data.data![index].name ?? '',
                            data.data![index].location ?? '',
                            data.data![index].invoiceNo ?? '',
                            data.data![index].employeeID ?? '',
                            data.data![index].supplierName ?? '',
                            data.data![index].qualityCheckDate.toString() ?? '',
                            data.data![index].cOCPdf ?? '',
                            data.data![index].invoicePdf ?? '',
                            data.data![index].excelURL ?? ''));
                  } else if ((data.data![index].name ?? '')
                          .toLowerCase()
                          .contains((SearchController.text).toLowerCase()) ||
                      data.data![index].materialName!
                          .toLowerCase()
                          .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].solarDetailID ?? '',
                            data.data![index].materialName ?? '',
                            data.data![index].profileImg ?? '',
                            data.data![index].name ?? '',
                            data.data![index].location ?? '',
                            data.data![index].invoiceNo ?? '',
                            data.data![index].employeeID ?? '',
                            data.data![index].supplierName ?? '',
                            data.data![index].qualityCheckDate.toString() ?? '',
                            data.data![index].cOCPdf ?? '',
                            data.data![index].invoicePdf ?? '',
                            data.data![index].excelURL ?? ''));
                  } else if (data.data![index].location!
                      .toLowerCase()
                      .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].solarDetailID ?? '',
                            data.data![index].materialName ?? '',
                            data.data![index].profileImg ?? '',
                            data.data![index].name ?? '',
                            data.data![index].location ?? '',
                            data.data![index].invoiceNo ?? '',
                            data.data![index].employeeID ?? '',
                            data.data![index].supplierName ?? '',
                            data.data![index].qualityCheckDate.toString() ?? '',
                            data.data![index].cOCPdf ?? '',
                            data.data![index].invoicePdf ?? '',
                            data.data![index].excelURL ?? ''));
                  } else if (data.data![index].supplierName!
                      .toLowerCase()
                      .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].solarDetailID ?? '',
                            data.data![index].materialName ?? '',
                            data.data![index].profileImg ?? '',
                            data.data![index].name ?? '',
                            data.data![index].location ?? '',
                            data.data![index].invoiceNo ?? '',
                            data.data![index].employeeID ?? '',
                            data.data![index].supplierName ?? '',
                            data.data![index].qualityCheckDate.toString() ?? '',
                            data.data![index].cOCPdf ?? '',
                            data.data![index].invoicePdf ?? '',
                            data.data![index].excelURL ?? ''));
                  } else if ((data.data![index].employeeID!)
                      .toLowerCase()
                      .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].solarDetailID ?? '',
                            data.data![index].materialName ?? '',
                            data.data![index].profileImg ?? '',
                            data.data![index].name ?? '',
                            data.data![index].location ?? '',
                            data.data![index].invoiceNo ?? '',
                            data.data![index].employeeID ?? '',
                            data.data![index].supplierName ?? '',
                            data.data![index].qualityCheckDate.toString() ?? '',
                            data.data![index].cOCPdf ?? '',
                            data.data![index].invoicePdf ?? '',
                            data.data![index].excelURL ?? ''));
                  } else if (data.data![index].solarDetailID!
                      .toLowerCase()
                      .contains((SearchController.text).toLowerCase())) {
                    return Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: _tile(
                            data.data![index].solarDetailID ?? '',
                            data.data![index].materialName ?? '',
                            data.data![index].profileImg ?? '',
                            data.data![index].name ?? '',
                            data.data![index].location ?? '',
                            data.data![index].invoiceNo ?? '',
                            data.data![index].employeeID ?? '',
                            data.data![index].supplierName ?? '',
                            data.data![index].qualityCheckDate.toString() ?? '',
                            data.data![index].cOCPdf ?? '',
                            data.data![index].invoicePdf ?? '',
                            data.data![index].excelURL ?? ''));
                  } else {
                    return Container();
                  }
                })),
      ),
      const SizedBox(
        height: 20,
      )
    ]);
  }

  Widget _tile(
      String id,
      String materialname,
      String profilepic,
      String name,
      String location,
      String invoiceno,
      String employeeid,
      String supplierName,
      String qualityCheckDate,
      String cOCPdf,
      String invoicePdf,
      String excelReport) {
    return InkWell(
      // onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                        child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: CachedNetworkImage(
                        imageUrl: "profilepic",
                        height: 60,
                        width: 60,
                        // planet
                        placeholder: (context, url) {
                          return ClipOval(
                            child: Image.asset(
                              materialname == "Solar Cell"
                                  ? AppAssets.solarcell
                                  : materialname == "Solar Glass"
                                      ? AppAssets.planet
                                      : materialname == "PV Ribbon"
                                          ? AppAssets.icDirectory
                                          : materialname == "Junction Box"
                                              ? AppAssets.imgAttendanceReport
                                              : materialname ==
                                                      "Aluminium Frame"
                                                  ? AppAssets.imgSalaryReport
                                                  : materialname == "Flux"
                                                      ? AppAssets.flux
                                                      : materialname ==
                                                              "Backsheet"
                                                          ? AppAssets
                                                              .imgAttendanceList
                                                          : materialname ==
                                                                  "Sealant/Poating"
                                                              ? AppAssets
                                                                  .Poating
                                                              : AppAssets.eva,
                              height: 60,
                              width: 60,
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return ClipOval(
                            child: Image.asset(
                              materialname == "Solar Cell"
                                  ? AppAssets.solarcell
                                  : materialname == "Solar Glass"
                                      ? AppAssets.planet
                                      : materialname == "PV Ribbon"
                                          ? AppAssets.icDirectory
                                          : materialname == "Junction Box"
                                              ? AppAssets.imgAttendanceReport
                                              : materialname ==
                                                      "Aluminium Frame"
                                                  ? AppAssets.imgSalaryReport
                                                  : materialname == "Flux"
                                                      ? AppAssets.flux
                                                      : materialname ==
                                                              "Backsheet"
                                                          ? AppAssets
                                                              .imgAttendanceList
                                                          : materialname ==
                                                                  "Sealant/Poating"
                                                              ? AppAssets
                                                                  .Poating
                                                              : AppAssets.eva,
                              height: 60,
                              width: 60,
                            ),
                          );
                        },
                      ),
                    )),
                  ),
                  Container(
                    child: Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Name
                        Row(children: <Widget>[
                          Flexible(
                            child: Text(materialname,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: appFontFamily,
                                    fontSize: 16,
                                    color: AppColors.lightBlackColor)),
                          ),
                        ]),

                        Row(children: <Widget>[
                          ClipRRect(
                            child: Image.asset(
                              AppAssets.icLocate,
                              width: 30,
                              height: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(location,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  fontFamily: appFontFamily)),
                          const SizedBox(
                            width: 10,
                          ),
                          ClipRRect(
                            child: Image.asset(
                              AppAssets.icCard,
                              width: 30,
                              height: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(invoiceno,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  fontFamily: appFontFamily)),
                        ]),
                        const SizedBox(
                          height: 5,
                        ),
                        //Occupication
                        Row(children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  255, 95, 245, 8), // Background color
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: Add border radius for rounded corners
                            ),
                            child: Text(
                              employeeid,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Color.fromARGB(
                                    255, 0, 0, 0), // Optional: Set text color
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  255, 104, 3, 236), // Background color
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: Add border radius for rounded corners
                            ),
                            child: Text(
                              "By: $name",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Color.fromARGB(255, 255, 255,
                                    255), // Optional: Set text color
                              ),
                            ),
                          ),
                        ]),

                        const SizedBox(
                          height: 5,
                        ),
                        //Occupication
                        Row(children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255, 0, 0, 0), // Background color
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: Add border radius for rounded corners
                            ),
                            child: Text(
                              DateFormat("dd MMM yyyy").format(
                                  DateTime.parse(qualityCheckDate.toString())),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Color.fromARGB(255, 255, 255,
                                    255), // Optional: Set text color
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255, 4, 68, 243), // Background color
                              borderRadius: BorderRadius.circular(
                                  10), // Optional: Add border radius for rounded corners
                            ),
                            child: Text(
                              supplierName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Color.fromARGB(255, 255, 255,
                                    255), // Optional: Set text color
                              ),
                            ),
                          ),
                        ]),
                        if (_hasBeenPressed1 != 'Inprogress')
                          const SizedBox(
                            height: 5,
                          ),
                        if (_hasBeenPressed1 != 'Inprogress')
                          Row(children: <Widget>[
                            if (invoicePdf != null && invoicePdf != '')
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(
                                      255, 4, 68, 243), // Background color
                                  borderRadius: BorderRadius.circular(
                                      10), // Optional: Add border radius for rounded corners
                                ),
                                child: const Text(
                                  "Invoice :",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Color.fromARGB(255, 255, 255,
                                        255), // Optional: Set text color
                                  ),
                                ),
                              ),
                            if (invoicePdf != null && invoicePdf != '')
                              const SizedBox(
                                width: 5,
                              ),
                            if (invoicePdf != null && invoicePdf != '')
                              GestureDetector(
                                onTap: () {
                                  UrlLauncher.launch(invoicePdf);
                                },
                                child: ClipRRect(
                                  child: Image.asset(
                                    AppAssets.icPdf,
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 20,
                            ),
                            if (cOCPdf != null && cOCPdf != '')
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(
                                      255, 100, 243, 4), // Background color
                                  borderRadius: BorderRadius.circular(
                                      10), // Optional: Add border radius for rounded corners
                                ),
                                child: const Text(
                                  "COC :",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Color.fromARGB(255, 0, 0,
                                        0), // Optional: Set text color
                                  ),
                                ),
                              ),
                            if (cOCPdf != null && cOCPdf != '')
                              const SizedBox(
                                width: 5,
                              ),
                            if (cOCPdf != null && cOCPdf != '')
                              GestureDetector(
                                onTap: () {
                                  UrlLauncher.launch(cOCPdf);
                                },
                                child: ClipRRect(
                                  child: Image.asset(
                                    AppAssets.icPdf,
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                          ]),

                        SizedBox(
                          height: 10,
                        ),

                        if ((_hasBeenPressed1 == 'Approved' ||
                                _hasBeenPressed1 == 'Rejected') &&
                            excelReport != "" &&
                            excelReport != null)
                          Row(children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    255, 172, 69, 141), // Background color
                                borderRadius: BorderRadius.circular(
                                    10), // Optional: Add border radius for rounded corners
                              ),
                              child: const Text(
                                "Excell Report :",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color.fromARGB(255, 255, 255,
                                      255), // Optional: Set text color
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                UrlLauncher.launch(excelReport);
                              },
                              child: ClipRRect(
                                child: Image.asset(
                                  AppAssets.icPdf,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ]),

                        const SizedBox(
                          height: 2,
                        ),
                      ],
                    )),
                  ),
                  if (designation != 'QC' && _hasBeenPressed1 == 'Pending')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) => materialname ==
                                            "Solar Cell"
                                        ? SolarCell(id: id)
                                        : materialname == "Solar Glass"
                                            ? SolarGlass(id: id)
                                            : materialname == "PV Ribbon"
                                                ? Ribbon(id: id)
                                                : materialname == "Junction Box"
                                                    ? JunctionBox(id: id)
                                                    : materialname ==
                                                            "Aluminium Frame"
                                                        ? AluminiumFrame(id: id)
                                                        : materialname == "Flux"
                                                            ? Flux(id: id)
                                                            : materialname ==
                                                                    "Backsheet"
                                                                ? Backsheet(
                                                                    id: id)
                                                                : materialname ==
                                                                        "Sealant/Poating"
                                                                    ? Sealant(
                                                                        id: id)
                                                                    : Encapsulant(
                                                                        id: id)),
                                (Route<dynamic> route) => false);
                          },
                          child: Image.asset(
                            AppAssets.icApproved,
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ],
                    ),
                  if (_hasBeenPressed1 == 'Inprogress' && designation == "QC")
                    //  if (_hasBeenPressed1 == 'Inprogress')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) => materialname ==
                                            "Solar Cell"
                                        ? SolarCell(id: id)
                                        : materialname == "Solar Glass"
                                            ? SolarGlass(id: id)
                                            : materialname == "PV Ribbon"
                                                ? Ribbon(id: id)
                                                : materialname == "Junction Box"
                                                    ? JunctionBox(id: id)
                                                    : materialname ==
                                                            "Aluminium Frame"
                                                        ? AluminiumFrame(id: id)
                                                        : materialname == "Flux"
                                                            ? Flux(id: id)
                                                            : materialname ==
                                                                    "Backsheet"
                                                                ? Backsheet(
                                                                    id: id)
                                                                : materialname ==
                                                                        "Sealant/Poating"
                                                                    ? Sealant(
                                                                        id: id)
                                                                    : Encapsulant(
                                                                        id: id)),
                                (Route<dynamic> route) => false);
                          },
                          child: Image.asset(
                            AppAssets.icMemberEdit,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColors.dividerColor,
              height: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget appBarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 25,
          child: ClipOval(
            child: Image.network(
                "https://st4.depositphotos.com/4329009/19956/v/600/depositphotos_199564354-stock-illustration-creative-vector-illustration-default-avatar.jpg",
                fit: BoxFit.cover,
                height: 50,
                width: 50),
          ),
        ),
        // Image.asset(
        //   AppAssets.icAppLogoHorizontal,
        //   width: 150,
        //   height: 45,
        // )
      ],
    );
  }
}
