//
// import 'package:flutter/material.dart';
// import '../constants/colors.dart';
//
// class SearchDocument extends SearchDelegate<DocumentModel?> {
//   final List<DocumentModel> docList;
//   // final Widget tableData;
//   Function({required String valueDoc, required String valueDate, required String value, required String contact}) tableData;
//
//   SearchDocument({required this.docList, required this.tableData});
//
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         },
//         icon: Icon(Icons.clear, color: kTextColor1),
//       ),
//     ];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         close(context, null);
//       },
//       icon: Icon(Icons.arrow_back, color: kTextColor1),
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     final List<DocumentModel> allDocs = query.length > 0 ? docList.where(
//       (doc) => doc.docSrNumber!.toLowerCase().contains(
//             query.toLowerCase(),
//           ),
//     ).toList() : docList;
//     return ListView.builder(
//       itemCount: allDocs.length,
//       itemBuilder: (context, ind) {
//         return tableData(valueDoc: allDocs[ind].docSrNumber!,
//             valueDate: allDocs[ind].issueDate!, value: allDocs[ind].docValue!,
//             contact: allDocs[ind].presenterNumber!);
//       },
//     );
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final List<DocumentModel> allDocs = query.length > 0 ? docList.where(
//           (doc) => doc.docSrNumber!.toLowerCase().contains(
//         query.toLowerCase(),
//       ),
//     ).toList() : docList;
//     return ListView.builder(
//       itemCount: allDocs.length,
//       itemBuilder: (context, ind) {
//         return tableData(valueDoc: allDocs[ind].docSrNumber!,
//             valueDate: allDocs[ind].issueDate!, value: allDocs[ind].docValue!,
//             contact: allDocs[ind].presenterNumber!);
//       },
//     );
//   }
// }
