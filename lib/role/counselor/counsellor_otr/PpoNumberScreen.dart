import 'package:flutter/material.dart';
import '../../job_seeker/janadhaarflowpage/janadhaarflowpage_screen.dart';
import '../counsellor_otr/counsellor_otr_screen.dart';

enum UserFlowType1 {
  jobSeeker,
  counselor
}

class PpoNumberScreen extends StatefulWidget {
  final String ssoId;
  final String userID;
  final String displayName;
  final String mobileNo;
  final String type;
  final String subType;
  final UserFlowType1 flowType;

  const PpoNumberScreen({
    Key? key,
    required this.ssoId,
    required this.userID,
    required this.displayName,
    required this.mobileNo,
    required this.type,
    required this.subType,
    required this.flowType,
  }) : super(key: key);

  @override
  _PpoNumberScreenState createState() => _PpoNumberScreenState();
}

class _PpoNumberScreenState extends State<PpoNumberScreen> {
  final TextEditingController _ppoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter PPO Number")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ppoController,
              decoration: InputDecoration(
                labelText: "PPO Number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (_ppoController.text.isNotEmpty) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CounselorOtrScreen(
                  //       ssoId: widget.ssoId,
                  //       userID: widget.userID,
                  //       displayName: widget.displayName,
                  //       mobileNo: widget.mobileNo,
                  //       type: "govt",
                  //       subType: "retired",
                  //       ppoNumber: _ppoController.text, // pass PPO
                  //     ),
                  //   ),
                  // );

                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JanAadhaarFlowPage(
                      ssoId: widget.ssoId,
                      userID: widget.userID,
                      displayName: widget.displayName,
                      mobileNo: widget.mobileNo,
                      type: "govt",
                      subType: "retired",
                      flowType: UserFlowType.counselor, // pass PPO
                    ),
                  ),
                );
                }
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}