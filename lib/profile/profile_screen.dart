import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/constants.dart';
import 'package:hafiz_diary/widget/TextFormField.dart';
import 'package:hafiz_diary/widget/app_text.dart';
import 'package:hafiz_diary/widget/common_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _img;
  String? url;
  int language = 0;
  String? uId;

  @override
  void initState() {

    super.initState();
    initMethod();
  }

  initMethod() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
 setState(() {
   uId=preferences.getString("currentUserId")!;
 }
 );



    String lang = preferences.getString("lang") ?? "eng";
    language = lang == "ur" ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // Prevent going back to the login screen
      return false;
    },
    child:

      Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.fill)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: defPadding, vertical: defPadding / 2),
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(uId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    nameController.text = snapshot.data!.get("name");
                    emailController.text = snapshot.data!.get("email");
                    phoneController.text = snapshot.data!.get("phone");
                    String imgUrl = snapshot.data!.get("img_url") ?? "";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "Profile",
                              fontWeight: FontWeight.bold,
                              clr: Colors.white,
                              size: 18,
                            ),
                            AppText(
                              text: "Edit your information",
                              clr: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defPadding * 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                imgUrl.isEmpty
                                    ? Stack(
                                  children: [
                                    _img != null
                                        ? CircleAvatar(
                                      radius: 70,
                                      backgroundImage:
                                      FileImage(_img!),
                                    )
                                        : Container(
                                      width: 150,
                                      height: 150,
                                      child: Image.asset(
                                        "assets/images/profile.png",
                                        fit: BoxFit.cover,
                                      ),
                                    )
,

                                    Positioned(
                                      bottom: 0,
                                      left: 110,
                                      child: GestureDetector(
                                        onTap: () async {
                                          XFile? pickedImage =
                                          (await _picker.pickImage(
                                              source: ImageSource
                                                  .gallery));
                                          setState(() async {
                                            _img =
                                                File(pickedImage!.path);
                                            if (_img != null) {
                                              await uploadImage();
                                            }

                                          });
                                        },
                                        child: Container(
                                          height: 60,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: const Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                                    : Stack(
                                  children: [
                                    _img != null
                                        ? CircleAvatar(
                                      radius: 70,
                                      backgroundImage:
                                      FileImage(_img!),
                                    )
                                        : CircleAvatar(
                                      radius: 70,
                                      backgroundImage:
                                      NetworkImage(imgUrl),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 110,
                                      child: GestureDetector(
                                        onTap: () async {
                                          XFile? pickedImage =
                                          (await _picker.pickImage(
                                              source: ImageSource
                                                  .gallery));
                                          setState(() async {
                                            _img =
                                                File(pickedImage!.path);
                                            if (_img != null) {
                                              await uploadImage();
                                            }

                                          });
                                        },
                                        child: Container(
                                          height: 60,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: const Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: defPadding / 2,
                                ),
                                AppText(
                                  text: snapshot.data!.get("name"),
                                  fontWeight: FontWeight.bold,
                                  clr: primaryColor,
                                  size: 18,
                                ),
                                AppText(
                                  text: snapshot.data!.get("type") == 0
                                      ? "Admin"
                                      : snapshot.data!.get("type") == 1
                                      ? "Staff"
                                      : "Parents",
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defPadding,
                        ),
                        Expanded(
                          child: SizedBox(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: defPadding,
                                  ),
                                  CustomTextField(
                                      validation: false,
                                      controller: nameController,
                                      lableText: "Full Name"),
                                  // SizedBox(
                                  //   height: defPadding / 2,
                                  // ),
                                  // CustomTextField(
                                  //     validation: false,
                                  //     controller: controller,
                                  //     lableText: "Madrisa Name"),
                                  SizedBox(
                                    height: defPadding / 2,
                                  ),
                                  IgnorePointer(
                                    ignoring: true,
                                    child: CustomTextField(
                                        validation: false,
                                        controller: emailController,
                                        lableText: "Email"),
                                  ),
                                  SizedBox(
                                    height: defPadding / 2,
                                  ),
                                  CustomTextField(
                                      validation: false,
                                      controller: phoneController,
                                      lableText: "Phone Number"),
                                  // SizedBox(
                                  //   height: defPadding / 2,
                                  // ),
                                  // CustomTextField(
                                  //     validation: false,
                                  //     controller: phoneController,
                                  //     lableText: "Madrisa Code"),
                                  SizedBox(
                                    height: defPadding,
                                  ),
                                  CommonButton(
                                    text: "Save Changes",
                                    onTap: () async {
                                      if (_img != null) {
                                        await uploadImage();
                                      }

                                      String uid = FirebaseAuth.instance.currentUser!.uid;
                                      Map<String, dynamic> userData = {
                                        "name": nameController.text,
                                        "email": emailController.text,
                                        "phone": phoneController.text,
                                      };

                                      if (url !=null) {
                                        userData["img_url"] = url;
                                      }

                                      FirebaseFirestore.instance.collection("users").doc(uid).set(userData, SetOptions(
                                          merge: true)).whenComplete(
                                              () => ScaffoldMessenger.of(
                                              context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Profile has been updated"))));



                                        // FirebaseFirestore.instance
                                        //     .collection("users")
                                        //     .doc(FirebaseAuth
                                        //     .instance.currentUser!.uid)
                                        //     .set(
                                        //     {
                                        //       "img_url": url,
                                        //       "name": nameController.text,
                                        //       "email": emailController.text,
                                        //       "phone": phoneController.text,
                                        //     },
                                        //     SetOptions(
                                        //         merge: true)).whenComplete(
                                        //         () => ScaffoldMessenger.of(
                                        //         context)
                                        //         .showSnackBar(SnackBar(
                                        //         content: Text(
                                        //             "Profile has been updated"))));

                                      setState(() {});
                                    },
                                    color: primaryColor,
                                    textColor: Colors.white,
                                  ),
                                  SizedBox(
                                    height: defPadding,
                                  ),
                                  Row(
                                    children: [
                                      AppText(
                                        text: "Language",
                                        fontWeight: FontWeight.bold,
                                        clr: primaryColor,
                                      ),
                                      SizedBox(
                                        width: defPadding / 2,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border:
                                            Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(
                                                defPadding)),
                                        child: Row(
                                          children: [
                                            InkWell(onTap: () async {
                                              SharedPreferences pref= await SharedPreferences.getInstance();
                                              setState(() {
                                                language=0;
                                                lang='ur';
                                              });
                                              pref.setString("lang", lang);
                                            },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    defPadding / 2),
                                                decoration: BoxDecoration(
                                                  color: language==0?primaryColor:Colors.transparent,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      defPadding),
                                                ),
                                                child: AppText(text: "Urdu"),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                SharedPreferences pref= await SharedPreferences.getInstance();
                                                setState(() {
                                                  language=1;
                                                  lang="en";
                                                });
                                                pref.setString("lang", lang);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    defPadding / 2),
                                                decoration: BoxDecoration(
                                                    color:language==1?primaryColor: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        defPadding)),
                                                child: AppText(text: "English"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: defPadding,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text("No data available"),
                    );
                  }
                }),
          ),
        ),
      ),
    ));
  }

  Future<bool> uploadImage() async {
    bool val = false;
    final _firebaseStorage = FirebaseStorage.instance;
    print("Function STarted");
    print("Function STarted");
    print("Function STarted");
    print("Function STarted");
    print("Function STarted");
    // _firebaseStorage.
    if (_img != null) {
      //Upload to Firebase
      print("Upload STarted");
      print("Upload STarted");
      print("Upload STarted");
      print("Upload STarted");
      print("Upload STarted");
      var snapshot = await _firebaseStorage
          .ref()
          .child('profileImages/${emailController.text}')
          .putFile(_img!)
          .whenComplete(() {
        print("Image Uploaded");
      });
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        url = downloadUrl;
        print("Image URl: $url");
        print("URL Fetched");
        print("URL Fetched");
        print("URL Fetched");
        print("URL Fetched");
        print("URL Fetched");
        val = true;
      });
    } else {
      print('No Image Path Received');
    }
    return val;
  }
}
