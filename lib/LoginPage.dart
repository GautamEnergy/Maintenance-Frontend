import 'dart:convert';
import 'dart:io';

import 'package:Maintenance/Welcomepage.dart';
import 'package:Maintenance/components/app_button_widget.dart';
import 'package:Maintenance/components/app_loader.dart';
import 'package:Maintenance/constant/app_assets.dart';
import 'package:Maintenance/constant/app_color.dart';
import 'package:Maintenance/constant/app_fonts.dart';
import 'package:Maintenance/constant/app_helper.dart';
import 'package:Maintenance/constant/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  final String? appName;
  LoginPage({this.appName});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();
  // final _otpFormKey = GlobalKey<FormState>();

  List device = [];
  bool otpsend = false, _isLoading = false;
  String? uid, deviceType, designation, department;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  // String path = "http://192.168.0.100:8080/"; //local
  // String path =
  //     "https://fair-gray-gharial-wig.cyclic.app/"; // Maintenance Cyclic Dev

  // String path =
  //     "https://emp56gfc2b.ap-south-1.awsapprunner.com/"; // Maintenance AWS Dev
  // String path =
  //     "https://sore-rose-kingfisher-tutu.cyclic.app/"; // Maintenance App Cyclic Prod

  // String path = "https://xvvmywehv3.ap-south-1.awsapprunner.com/"; // AWS Prod
  String path = "http://srv515471.hstgr.cloud:8080/"; // Hostinger Dev

  // String path = "http://srv515471.hstgr.cloud:9090/"; // Hostinger Prod

  @override
  void initState() {
    super.initState();
  }

  void login(String loginid, String password) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });
    final url = (path + 'Employee/Login');
    var params = {
      "loginid": loginid,
      "password": password,
    };

    var response = await http.post(
      Uri.parse(url),
      body: json.encode(params),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print("Loginnnnnn");
    print(response.statusCode);
    if (response.statusCode == 400) {
      setState(() {
        _isLoading = false;
      });
      var objData = json.decode(response.body);
      print("Passsssss");
      print(objData);
      if (objData['msg'] == "Wrong Password") {
        Toast.show("Password is not valid.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: Colors.red);
      }

      if (objData['msg'] == "Wrong EmployeeId") {
        Toast.show("Login id is not valid.",
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: Colors.red);
      }
    } else if (response.statusCode == 200) {
      var objData = json.decode(response.body);
      setState(() {
        _isLoading = false;
      });

      if (objData['status'] == true) {
        print("KYAYAYYYYYYY");
        print(objData['token']);
        if (mounted) {
          print(prefs.getString('site'));
          setState(() {
            _isLoading = false;
            prefs.setBool('islogin', true);
            prefs.setString('site', path);
            prefs.setString('token', objData['token']);
            prefs.setString('personid', objData['PersonData'][0]['PersonID']);

            prefs.setString(
                'designation', objData['PersonData'][0]['Designation'] ?? '');

            prefs.setString('fullname', objData['PersonData'][0]['Name'] ?? '');
            prefs.setString(
                'department', objData['PersonData'][0]['Department'] ?? '');
            prefs.setString(
                'pic', objData['PersonData'][0]['ProfileImg'] ?? '');
            designation = prefs.getString('designation')!;
            department = prefs.getString('department')!;
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => WelcomePage()));
          });
          print(prefs.getString('site'));
        }
        return;
      }
    } else {
      print("Error");
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
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.white,
          body: _isLoading
              ? AppLoader()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      Form(
                        key: _loginFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // const SizedBox(
                            //   height: 40,
                            // ),
                            Center(
                              child: Image.asset(AppAssets.imgWelcome,
                                  width: 200, height: 200, fit: BoxFit.fill),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Login Id",
                              style: AppStyles.textfieldCaptionTextStyle,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            TextFormField(
                              controller: employeeIdController,
                              minLines: 1,
                              maxLines: null,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: AppStyles.textFieldInputDecoration
                                  .copyWith(
                                      hintText: "Please Enter Login Id",
                                      counterText: '',
                                      contentPadding: EdgeInsets.all(10)),
                              style: AppStyles.textInputTextStyle,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter login id';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Password",
                              style: AppStyles.textfieldCaptionTextStyle,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText:
                                  true, // This property hides the text as it is typed
                              decoration: AppStyles.textFieldInputDecoration
                                  .copyWith(
                                      hintText: "Enter Your Password",
                                      counterText: ''),
                              style: AppStyles.textInputTextStyle,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password!'; // Validation error message
                                }
                                // You can add additional validation logic here if needed
                                return null; // Return null if validation succeeds
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                            AppButton(
                                organization: '',
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                    fontSize: 16),
                                onTap: () {
                                  AppHelper.hideKeyboard(context);
                                  _loginFormKey.currentState!.save();
                                  if (_loginFormKey.currentState!.validate()) {
                                    login(employeeIdController.text,
                                        passwordController.text);
                                  }
                                },
                                label: "Login"),
                            SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                      //Bottom Cognisun Logo
                      Positioned(
                          bottom: 18,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAssets.imgWelcome,
                                height: 60,
                                width: 130,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("Powered By Gautam Solar Pvt Ltd.",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: appFontFamily,
                                      color: AppColors.greyColor,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ))
                    ],
                  ),
                ),
        );
      }),
    );
    // return
  }
}
