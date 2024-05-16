import 'package:QCM/Fqc.dart';
import 'package:QCM/FqcTestList.dart';
import 'package:QCM/Ipqc.dart';
import 'package:QCM/Iqcp.dart';
import 'package:QCM/IqcpTestList.dart';
import 'package:QCM/QualityList.dart';
import 'package:QCM/QualityPage.dart';
import 'package:QCM/QualityReport.dart';
import 'package:QCM/Welcomepage.dart';
import 'package:QCM/components/appbar.dart';
import 'package:QCM/constant/app_color.dart';
import 'package:QCM/constant/app_fonts.dart';
import 'package:QCM/constant/app_styles.dart';
import 'package:QCM/directory.dart';
import 'package:QCM/ipqcTestList.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../BoxCricket.dart';

import '../constant/app_assets.dart';

import '../main.dart';

class PublicDrawer extends StatefulWidget {
  PublicDrawer({Key? key}) : super(key: key);

  @override
  _PublicDrawerState createState() => _PublicDrawerState();
}

class _PublicDrawerState extends State<PublicDrawer> {
  String? firstname,
      designation,
      department,
      lastname,
      personid,
      pic,
      VersionNo,
      ImagePath,
      site,
      businessname,
      clubname,
      organizationName,
      organizationtype,
      vCard,
      userGuideLink;
  bool isAllowedEdit = false,
      menu = true,
      user = false,
      face = false,
      home = false;
  var decodedResult;
  void store() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      designation = prefs.getString('designation');
      department = prefs.getString('department');
      personid = prefs.getString('personid');
      firstname = prefs.getString('firstname');
      lastname = prefs.getString('lastname');
      pic = prefs.getString('pic');
      VersionNo = prefs.getString('versionNo');
      clubname = prefs.getString('clubname');
      businessname = prefs.getString('businessname');
      organizationName = prefs.getString('organizationName');
      organizationtype = prefs.getString('organizationtype');
      site = prefs.getString('site');
      ImagePath = prefs.getString('imagePath');
      vCard = prefs.getString('Vcard');
    });
    // getFromStringmap();
  }

  @override
  void initState() {
    super.initState();
    store();
  }

  adminbuttons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // buttonAttendance(),
        // buttonReport(),
      ],
    );
  }

  Future<bool> redirectto() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                (department == 'IQCP' && designation != 'Super Admin')
                    ? IqcpPage()
                    : (department == 'IPQC' && designation != 'Super Admin')
                        ? IpqcPage()
                        : (department == 'FQC' && designation != 'Super Admin')
                            ? FqcPage()
                            : WelcomePage()),
        (Route<dynamic> route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlack,
      appBar: GautamAppBar(
        organization: "organizationtype",
        isBackRequired: true,
        memberId: personid,
        imgPath: "ImagePath",
        memberPic: pic,
        logo: "logo",
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return (department == 'IQCP' && designation != 'Super Admin')
                ? IqcpPage()
                : (department == 'IPQC' && designation != 'Super Admin')
                    ? IpqcPage()
                    : (department == 'FQC' && designation != 'Super Admin')
                        ? FqcPage()
                        : WelcomePage();
          }));
        },
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),

            //1st row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: tabDashboard('Welcome', AppAssets.home, () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              (department == 'IQCP' &&
                                      designation != 'Super Admin')
                                  ? IqcpPage()
                                  : (department == 'IPQC' &&
                                          designation != 'Super Admin')
                                      ? IpqcPage()
                                      : (department == 'FQC' &&
                                              designation != 'Super Admin')
                                          ? FqcPage()
                                          : (department == 'QUALITY' &&
                                                  designation != 'Super Admin')
                                              ? QualityPage()
                                              : WelcomePage()),
                      (Route<dynamic> route) => false);
                })),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            if ((designation != 'Super Admin' && department == 'IQCP') ||
                (designation == 'Super Admin'))
              SizedBox(
                height: 10,
              ),
            // IQCP
            if ((designation != 'Super Admin' && department == 'IQCP') ||
                (designation == 'Super Admin'))
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: tabDashboard(
                          'IQCP Test List', AppAssets.icApproved, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => IqcpTestList()),
                        (Route<dynamic> route) => false);
                  })),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: tabDashboard('IQCP', AppAssets.IQCP, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => IqcpPage()),
                        (Route<dynamic> route) => false);
                  })),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            if ((designation != 'Super Admin' && department == 'IPQC') ||
                (designation == 'Super Admin'))
              SizedBox(
                height: 10,
              ),

            //IPQC
            if ((designation != 'Super Admin' && department == 'IPQC') ||
                (designation == 'Super Admin'))
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: tabDashboard('IPQC Test List', AppAssets.ipqc, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => IpqcTestList()),
                        (Route<dynamic> route) => false);
                  })),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: tabDashboard('IPQC', AppAssets.ipqc, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => IpqcPage()),
                        (Route<dynamic> route) => false);
                  })),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),

            if ((designation != 'Super Admin' && department == 'FQC') ||
                (designation == 'Super Admin'))
              SizedBox(
                height: 10,
              ),
            // IQCP
            if ((designation != 'Super Admin' && department == 'FQC') ||
                (designation == 'Super Admin'))
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: tabDashboard('FQC Test List', AppAssets.fqc, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => FqcTestList()),
                        (Route<dynamic> route) => false);
                  })),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: tabDashboard('FQC', AppAssets.fqcadd, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => FqcPage()),
                        (Route<dynamic> route) => false);
                  })),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),

            if ((designation != 'Super Admin' && department == 'QUALITY') ||
                (designation == 'Super Admin'))
              SizedBox(
                height: 10,
              ),
            // IQCP
            if ((designation != 'Super Admin' && department == 'QUALITY') ||
                (designation == 'Super Admin'))
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child:
                          tabDashboard('Quality List', AppAssets.quality, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => QualityList()),
                        (Route<dynamic> route) => false);
                  })),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: tabDashboard('QUALITY', AppAssets.qualityadd, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => QualityPage()),
                        (Route<dynamic> route) => false);
                  })),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),

            SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (designation == 'Super Admin')
                  SizedBox(
                    width: 10,
                  ),
                if (designation == 'Super Admin')
                  Expanded(
                      child: tabDashboard(
                          'Quality Reports', AppAssets.imgReportIcon, () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => QualityReport()),
                        (Route<dynamic> route) => false);
                  })),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: tabDashboard('Logout', AppAssets.iclogout, () async {
                  final prefs = await SharedPreferences.getInstance();

                  prefs.remove('site');

                  prefs.remove('personid');
                  prefs.remove('fullname');
                  prefs.remove('department');
                  prefs.remove('pic');

                  prefs.setBool('islogin', false);
                  prefs.remove('designation');
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyApp()),
                      (Route<dynamic> route) => false);
                })),
                SizedBox(
                  width: 10,
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                ('PROD'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: const Text(
                  ('V1.0.20240514.1818'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                )),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          (department == 'IQCP' && designation != 'Super Admin')
                              ? IqcpPage()
                              : (department == 'IPQC' &&
                                      designation != 'Super Admin')
                                  ? IpqcPage()
                                  : (department == 'FQC' &&
                                          designation != 'Super Admin')
                                      ? FqcPage()
                                      : (department == 'QUALITY' &&
                                              designation != 'Super Admin')
                                          ? QualityPage()
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => EmployeeList()));
                  }
                },
                child: Image.asset(
                    user ? AppAssets.imgSelectedPerson : AppAssets.imgPerson,
                    height: 25)),
            const SizedBox(
              width: 8,
            ),
            InkWell(
                onTap: () {
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     builder: (BuildContext context) => Attendance()));
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => PublicDrawer()));
                },
                child: Image.asset(
                    menu ? AppAssets.imgSelectedMenu : AppAssets.imgMenu,
                    height: 25)),
          ],
        ),
      ),
    );
  }

  InkWell buttonDashboard() {
    return InkWell(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => WelcomePage()),
              (Route<dynamic> route) => false);
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Material(
                  shape: RoundedRectangleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: new Image.asset(AppAssets.icDashboard,
                      height: 18.0, width: 18.0, color: AppColors.greyColor),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text("Dashboard", style: AppStyles.drawerMenuTextStyle),
            ]));
  }

  InkWell buttonDirectory() {
    return InkWell(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => EmployeeList()),
              (Route<dynamic> route) => false);
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Material(
                  shape: RoundedRectangleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(AppAssets.icDirectory,
                      height: 18.0, width: 18.0, color: AppColors.greyColor),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text("Directory", style: AppStyles.drawerMenuTextStyle),
            ]));
  }

  Item? selectedUser;
  List<Item> users = <Item>[
    const Item('1-2-1', "images/drawer-p2p.png"),
    const Item('Referral', "images/drawer-referral.png"),
    const Item('TYN', "images/drawer-tyn.png"),
    const Item('Testimonial', "images/drawer-testimonials.png"),
    const Item('Visitor', "images/drawer-visitors.png"),
  ];

  Item1? selectedUser1;
  List<Item1> users1 = <Item1>[
    const Item1('Meeting', "images/drawer-add-meeting.png"),
    const Item1('Training', "images/drawer-training.png"),
  ];

  Item2? selectedUser2;
  List<Item2> users2 = <Item2>[
    const Item2('Activity', "images/drawer-referral.png"),
    const Item2('1-2-1', "images/drawer-p2p.png"),
    const Item2('Referral', "images/drawer-referral.png"),
    const Item2('TYN', "images/drawer-tyn.png"),
    const Item2('Attendance', 'icons/attendance.png'),
  ];
  Item3? selectedUser3;
  List<Item3> users3 = <Item3>[
    const Item3('TYN', "images/drawer-tyn.png"),
    const Item3('Referral', "images/drawer-referral.png"),
    const Item3('1-2-1', "images/drawer-p2p.png"),
    const Item3('Overall', "images/drawer-visitors.png"),
  ];
}

class Item {
  const Item(this.name, this.path);
  final String name;
  final String path;
}

class Item1 {
  const Item1(this.name, this.path);
  final String name;
  final String path;
}

class Item2 {
  const Item2(this.name, this.path);
  final String name;
  final String path;
}

class Item3 {
  const Item3(this.name, this.path);
  final String name;
  final String path;
}

Widget tabDashboard(String title, String img, final Function onPressed) {
  return InkWell(
    onTap: () {
      onPressed();
    },
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 115,
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 50,
                width: 155,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(10)),
                    image: DecorationImage(
                        image: AssetImage(
                          AppAssets.icEllipse,
                        ),
                        fit: BoxFit.fill)),
                // child: Image.asset(
                //   AppAssets.icEllipse,
                //   fit: BoxFit.fill,
                //   height: 50,
                //   width: 155,
                // ),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 15),
                child: Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: appFontFamily,
                        fontSize: 16,
                        color: AppColors.textFieldCaptionColor)),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                  child: Container(
                      height: 36,
                      width: 36,
                      child: Image.asset(
                        img,
                        height: 36,
                        width: 36,
                        //fit: BoxFit.cover,
                      )))
            ],
          )
        ],
      ),
    ),
  );
}
