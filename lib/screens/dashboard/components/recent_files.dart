import 'package:twiza/models/RecentFile.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class RecentFiles extends StatelessWidget {
  RecentFiles({Key? key, required this.demoRecentFiles}) : super(key: key);
  final List demoRecentFiles;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
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
              dataTextStyle: TextStyle(fontSize: 13, fontFamily: "hacen"),
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
                (index) => recentFileDataRow(demoRecentFiles[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(RecentFile fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              fileInfo.icon!,
              height: 20,
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(fileInfo.title!),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.quantity!)),
      DataCell(Text(fileInfo.color!)),
      DataCell(Text(fileInfo.size!)),
      DataCell(Text(fileInfo.state!)),
    ],
  );
}
