import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:twiza/db.dart';
import 'package:twiza/functions/polyBox.dart';
import 'package:twiza/models/MyFiles.dart';
import 'package:twiza/responsive.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatelessWidget {
  User auth;
  MyFiles({Key? key, required this.auth}) : super(key: key);
  GlobalKey<FormState> _formkeyAdd = GlobalKey<FormState>();
  late String category = "";
  late String item = "";
  List<String> categoryList = [
    "ملابس",
    "التعليم",
    "الدم",
    "سيارة الإسعاف",
    "الإمدادات الغذائية",
    "دواء"
  ];

  Widget addNewWidget(context) {
    return Form(
        key: _formkeyAdd,
        child: Container(
            height: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 60.0,
                    padding: EdgeInsets.all(1.0),
                    color: secondaryColor,
                    child: DropdownButtonFormField(
                      alignment: Alignment.center,
                      validator: (value) {
                        if (value == null || value == "فئة") {
                          return "فئة مطلوبة";
                        }
                        return null;
                      },
                      hint: Text(
                        "فئة",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Hacen'),
                      ),
                      // value: wilaya,
                      // isDense: true,
                      onChanged: (value) {
                        category = value.toString();
                      },
                      decoration: InputDecoration(
                        fillColor: secondaryColor,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[200]!, width: .5),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      items: categoryList.map((value) {
                        return DropdownMenuItem<String>(
                          alignment: Alignment.topRight,
                          value: value,
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: secondaryColor),
                  padding: EdgeInsets.all(1.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textDirection: TextDirection.rtl,
                    validator: (input) {
                      if (input!.isEmpty) {
                        return "فارغ";
                      }
                    },
                    onSaved: (input) => item = input!.trim(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      labelText: 'إسم العنصر',
                      labelStyle: TextStyle(fontFamily: 'Hacen'),
                    ),
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            )));
  }

  void addNewFuncion(BuildContext context) {
    final formState = _formkeyAdd.currentState;
    late ProgressDialog pr = ProgressDialog(context,
        isDismissible: true, type: ProgressDialogType.Normal);
    if (formState!.validate()) {
      formState.save();
      try {
        deviceConnectionState().then((state) {
          pr.style(
              message: ' ...حفظ',
              progressWidget: Image.asset('assets/images/ring.gif'),
              textAlign: TextAlign.center);
          pr.show();
          DB().getData(auth.email, "newSubscribers").then((user) {
            DB().setData(
                auth.email,
                "wilaya/${user!.get("wilaya")}/society/${auth.email}/$category",
                {
                  "itmName": item,
                }).then((regst) {
              if (regst) {
                pr.hide();
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop();
                  pr.style(
                      message: 'تم التسجيل بنجاح',
                      progressWidget: Image.asset('assets/images/done.gif'),
                      textAlign: TextAlign.center);
                  pr.show();
                  Future.delayed(const Duration(seconds: 2), () {
                    pr.hide();
                  });
                });
              }
            });
          });
        });
      } catch (e) {
        pr.hide();
        pr.style(
            message: 'خطأ',
            progressWidget: Image.asset('assets/images/error.gif'),
            textAlign: TextAlign.center);
        pr.show();
        Future.delayed(const Duration(seconds: 4), () {
          Navigator.of(context).pop();
          pr.hide();
        });
      }
    }
  }

  Future<bool> deviceConnectionState() async {
    return await InternetConnectionChecker().hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              auth.email.toString(),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                PolyBox(
                    headContext: context,
                    content: addNewWidget(context),
                    title: "إضافة عنصر جديد",
                    btn1Text: "حفظ",
                    btn2Text: "إغلاق",
                    funcBtn1: () => addNewFuncion(context),
                    funcBtn2: (context) => Navigator.of(context).pop()).show();
              },
              icon: Icon(Icons.add),
              label: Text("إضافة جديد"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index]),
    );
  }
}
