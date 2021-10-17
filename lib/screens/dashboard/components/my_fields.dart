import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:twiza/db.dart';
import 'package:twiza/functions/polyBox.dart';
import 'package:twiza/loginUI2.dart';
import 'package:twiza/models/MyFiles.dart';
import 'package:twiza/models/RecentFile.dart';
import 'package:twiza/nav.dart';
import 'package:twiza/responsive.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:twiza/screens/dashboard/components/recent_files.dart';
import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatefulWidget {
  User auth;
  MyFiles({Key? key, required this.auth}) : super(key: key);
  _MyFilesState createState() => new _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  GlobalKey<FormState> _formkeyAdd = GlobalKey<FormState>();
  late String category = "";
  late String item = "";
  late DocumentSnapshot user;
  final List<String> categoryList = [
    "ملابس",
    "التعليم",
    "الدم",
    "سيارة الإسعاف",
    "الإمدادات الغذائية",
    "دواء",
  ];
  late ProgressDialog pr = ProgressDialog(context,
      isDismissible: true, type: ProgressDialogType.Normal);
  late List<List<String>> categoryDataDoc = [];
  late List categoryDataDocField = [];
  late List<CloudStorageInfo> categoryData = [];
  late List demoRecentFiles = [];
  late List categoryRef = [];
  final List colors = [
    Colors.purple,
    Color(0xFFFFA113),
    Colors.red,
    Color(0xFF007EE5),
    Color(0xFF007EE5),
    Colors.teal,
    Colors.green
  ];
  final List categoryIcons = [
    "clothes",
    "education",
    "blood",
    "ambulance",
    "food",
    "pharmacy"
  ];
  late int percentage = 0;
  @override
  void initState() {
    super.initState();
    userProfile().whenComplete(() {
      wilayaDB();
    });
  }

  initDB() {}

  Future userProfile() async {
    return await DB()
        .getData(widget.auth.email, "newSubscribers")
        .then((value) {
      setState(() {
        user = value!;
      });
    });
  }

  wilayaDB() {
    categoryList.forEach((category) {
      DB()
          .getDatagroup(
        "wilaya/${user.data()!["wilaya"]}/society/${widget.auth.email}/$category",
      )
          .then((data) {
        setState(() {
          if (data!.docs.map((e) => e.data()).toList().isNotEmpty) {
            categoryDataDoc.add(data.docs.map((e) => e.id).toList());
            categoryDataDocField.add(data.docs.map((e) => [e.data()]).toList());
            percentage = (categoryDataDoc.length * 100 / 20).ceil();
            categoryRef.add(category);
            categoryData.add(
              CloudStorageInfo(
                title: category,
                numOfFiles: categoryDataDocField.isEmpty
                    ? 0
                    : categoryDataDoc[categoryList.indexOf(category)].length,
                svgSrc:
                    "assets/icons/${categoryIcons[categoryList.indexOf(category)]}.svg",
                totalStorage: categoryDataDocField.isEmpty
                    ? "0"
                    : "${categoryDataDoc[categoryList.indexOf(category)].length}",
                color: colors[categoryList.indexOf(category)],
                percentage: percentage,
              ),
            );
            categoryDataDoc.forEach((docs) {
              docs.forEach((doc) {
                print("-" * 100);
                print(doc);
                print("-" * 100);
                demoRecentFiles.add(
                  RecentFile(
                    icon:
                        "assets/icons/${categoryIcons[categoryList.indexOf(category)]}.svg",
                    title: doc.toString(),
                    color: categoryDataDocField[categoryList.indexOf(category)]
                        [docs.indexOf(doc)][docs.indexOf(doc)]["color"],
                    quantity:
                        categoryDataDocField[categoryList.indexOf(category)]
                            [docs.indexOf(doc)][docs.indexOf(doc)]["quantity"],
                    state: categoryDataDocField[categoryList.indexOf(category)]
                        [docs.indexOf(doc)][docs.indexOf(doc)]["stat"],
                    size: categoryDataDocField[categoryList.indexOf(category)]
                        [docs.indexOf(doc)][docs.indexOf(doc)]["size"],
                  ),
                );
              });
            });
          }
        });
      }).whenComplete(() {
        if (categoryData.length <= 6 && categoryRef.indexOf(category) == -1) {
          categoryData.add(
            CloudStorageInfo(
              title: category,
              numOfFiles: 0,
              svgSrc:
                  "assets/icons/${categoryIcons[categoryList.indexOf(category)]}.svg",
              totalStorage: "0",
              color: colors[categoryList.indexOf(category)],
              percentage: 0,
            ),
          );
        }
      });
    });
  }

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
    if (formState!.validate()) {
      formState.save();
      try {
        deviceConnectionState().then((state) {
          pr.style(
              message: ' ...حفظ',
              progressWidget: Image.asset('assets/images/ring.gif'),
              textAlign: TextAlign.center);
          pr.show();
          DB().setData(
              item,
              "wilaya/${user.data()!["wilaya"]}/society/${widget.auth.email}/$category",
              {
                "color": "اسود",
                "stat": "مستعمل",
                "size": 52,
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
    // print("*" * 100);
    // print(categoryDataDocField.isEmpty
    //     ? "null"
    //     : categoryDataDocField[0][0][0]["color"]);
    // print("*" * 100);
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.auth.email.toString(),
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
        categoryDataDoc.isEmpty
            ? Center(
                child: Container(
                    width: 50.0,
                    height: 50.0,
                    child: Image.asset('assets/images/ring.gif')))
            // : Responsive(
            // mobile
            : Column(
                children: [
                  FileInfoCardGridView(
                    percentage: percentage,
                    crossAxisCount: _size.width < 650 ? 2 : 4,
                    childAspectRatio:
                        _size.width < 650 && _size.width > 350 ? 1.3 : 1,
                    demoMyFiles: categoryData,
                    detailIcon: () {
                      PolyBox(
                          headContext: context,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Recent Files",
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: DataTable2(
                                  columnSpacing: 1.0,
                                  horizontalMargin: 1.0,
                                  minWidth: 420,
                                  dataTextStyle: TextStyle(
                                      fontSize: 13, fontFamily: "hacen"),
                                  columns: [
                                    DataColumn(
                                      label: Text("إسم العنصر"),
                                    ),
                                    DataColumn(
                                      label: Text("الكمية"),
                                    ),
                                    DataColumn(
                                      label: Text("اللون"),
                                    ),
                                    DataColumn(
                                      label: Text("الحجم"),
                                    ),
                                    DataColumn(
                                      label: Text("الحالة"),
                                    ),
                                  ],
                                  rows: List.generate(
                                    demoRecentFiles.length,
                                    (index) => recentFileDataRow(
                                        demoRecentFiles[index]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: "إضافة عنصر جديد",
                          btn1Text: "",
                          btn2Text: "إغلاق",
                          funcBtn1: () => {},
                          funcBtn2: (context) =>
                              Navigator.of(context).pop()).show();
                      //  Nav().nav(
                      //   RecentFiles(demoRecentFiles: demoRecentFiles), context)
                    },
                  ),
                ],
              )
        // tablet: FileInfoCardGridView(
        //   percentage: percentage,
        //   demoMyFiles: categoryData,
        //   detailIcon: () => Nav().nav(
        //       RecentFiles(demoRecentFiles: demoRecentFiles), context),
        // ),
        // desktop: FileInfoCardGridView(
        //   percentage: percentage,
        //   demoMyFiles: categoryData,
        //   childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
        //   detailIcon: () => Nav().nav(
        //       RecentFiles(demoRecentFiles: demoRecentFiles), context),
        // ),
        // ),
      ],
    );
  }
}

//
class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView(
      {Key? key,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1,
      required this.percentage,
      required this.demoMyFiles,
      required this.detailIcon()})
      : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final int percentage;
  final List<CloudStorageInfo> demoMyFiles;
  final Function detailIcon;
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
        itemBuilder: (context, index) => FileInfoCard(
              info: demoMyFiles[index],
              percentage: percentage,
              detailIcon: () => detailIcon(),
            ));
  }
}
