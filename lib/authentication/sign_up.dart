import 'package:flutter/material.dart';
import 'package:hafiz_diary/authentication/login_screen.dart';
import 'package:hafiz_diary/services/auth_services.dart';

import '../constants.dart';
import '../widget/TextFormField.dart';
import '../widget/app_text.dart';
import '../widget/common_button.dart';
import 'role_page.dart';

class SignUp extends StatefulWidget {
  final String accountType;
  const SignUp({Key? key, required this.accountType}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  List<String> list = <String>[
    'Staff',
    'Student',
  ];
  String accountType = "Staff";

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AuthServices authServices = AuthServices();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(defPadding),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    // height: 300,
                  ),
                  AppText(
                    text: "Sign Up",
                    fontWeight: FontWeight.bold,
                    clr: primaryColor,
                    size: 22,
                  ),
                  AppText(
                    text: "Sign Up for Hifz Online Diary",
                    clr: Colors.black,
                  ),
                  SizedBox(
                    height: defPadding,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: nameController,
                      lableText: "Name"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: emailController,
                      lableText: "Email"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: phoneController,
                      lableText: "Phone Number"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: passwordController,
                      lableText: "Password"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: confirmPasswordController,
                      lableText: "Confirm Password"),
                  SizedBox(
                    height: defPadding,
                  ),
                  CommonButton(
                    text: "Sign Up",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        authServices.signup(
                            data: {
                              "name": nameController.text,
                              "email": emailController.text,
                              "phone": phoneController.text,
                              "type": widget.accountType == "Staff" ? 1 : 2,
                              "status": false,
                              "remarks": "pending",
                              "img_url": ""
                            },
                            context: context,
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                      }
                    },
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: "Have an account?",
                        clr: Colors.black,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                accountType: widget.accountType,
                                isAdmin: false,
                              ),
                            ),
                          );
                        },
                        child: AppText(
                          text: "Login",
                          clr: primaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
