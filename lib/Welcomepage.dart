import 'package:Maintenance/CommonDrawer.dart';

import 'package:Maintenance/components/appbar.dart';
import 'package:Maintenance/constant/app_color.dart';
import 'package:Maintenance/constant/app_fonts.dart';
import 'package:Maintenance/constant/app_styles.dart';
import 'package:Maintenance/directory.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../BoxCricket.dart';
import '../constant/app_assets.dart';
import '../main.dart';
import 'package:shimmer/shimmer.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
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
      menu = false,
      user = false,
      face = false,
      home = true;
  var decodedResult;

  late AnimationController _controller;
  late Animation<double> _animation;

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

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (BuildContext context) => WelcomePage()),
    //     (Route<dynamic> route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlack,
      appBar: GautamAppBar(
        organization: "organizationtype",
        isBackRequired: false,
        memberId: personid,
        imgPath: "ImagePath",
        memberPic: pic,
        logo: "logo",
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EmployeeList();
          }));
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Handle the onTap event here
                        print('Container tapped!');
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _animation.value,
                                child: child,
                              );
                            },
                            child: Container(
                              width: 390.0,
                              height: 250.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/AiBN_Logo.png'), // Replace with your image path
                                  fit: BoxFit.cover,
                                ),
                                // width: 200.0, // Adjust the width as needed
                                // height: 150.0,
                                // border: Border.all(
                                //   color: Color.fromARGB(255, 236, 103, 103),
                                //   width: 3,
                                // ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        5, 10), // changes position of shadow
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            child: Image.asset(
                              AppAssets
                                  .icApproved, // Replace with your logo asset path
                              width:
                                  100.0, // Adjust the size of the logo as needed
                              height: 100.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // SizedBox(
                  //   width: 200.0,
                  //   height: 100.0,
                  //   child: Shimmer.fromColors(
                  //     baseColor: Colors.red,
                  //     highlightColor: Colors.yellow,
                  //     child: Text(
                  //       'Shimmer',
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontSize: 40.0,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Handle the onTap event here
                        print('Container tapped!');
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 390.0,
                            height: 250.0,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 236, 81, 250),
                              border: Border.all(
                                  color: Color.fromARGB(255, 236, 103, 103),
                                  width: 3),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 115, 6, 129)
                                      .withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      5, 10), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            child: Image.asset(
                              AppAssets
                                  .IQCP, // Replace with your logo asset path
                              width:
                                  100.0, // Adjust the size of the logo as needed
                              height: 100.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expanded(
                  //     child: tabDashboard('Machine Maintenance', AppAssets.ipqc,
                  //         () {
                  //   // Navigator.of(context).pushAndRemoveUntil(
                  //   //     MaterialPageRoute(
                  //   //         builder: (BuildContext context) =>
                  //   //             designation != 'Super Admin'
                  //   //                 ? IpqcPage()
                  //   //                 : IpqcTestList()),
                  //   //     (Route<dynamic> route) => false);
                  // })),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  // SizedBox(
                  //   width: 200.0,
                  //   height: 100.0,
                  //   child: Shimmer.fromColors(
                  //     baseColor: Colors.red,
                  //     highlightColor: Colors.yellow,
                  //     child: Text(
                  //       'Shimmer',
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontSize: 40.0,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 218, 132, 240),
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
                      builder: (BuildContext context) => WelcomePage()));
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
                // onTap: () {
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: (BuildContext context) => Attendance()));
                // },
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
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => WelcomePage()),
          //     (Route<dynamic> route) => false);
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
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 15),
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: appFontFamily,
                        fontSize: 16,
                        color: AppColors.textFieldCaptionColor)),
              ),
              const SizedBox(
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
