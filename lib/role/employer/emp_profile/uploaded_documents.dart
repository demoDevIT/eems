import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';

class UploadOrganizationDocuments extends StatefulWidget {
  const UploadOrganizationDocuments({super.key});

  @override
  State<UploadOrganizationDocuments> createState() =>
      _UploadOrganizationDocumentsState();
}

class _UploadOrganizationDocumentsState
    extends State<UploadOrganizationDocuments> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Upload Organization / Company Documents",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ===== PDFs =====
            _label("Uploaded Documents (PDF)"),

            _pdfTile("Company Registration Certificate.pdf"),
            _pdfTile("GST Certificate.pdf"),
            _pdfTile("PAN Card Document.pdf"),

            const SizedBox(height: 20),

            /// ===== Image =====
            _label("Organization Image"),

            _imagePreview(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// ===== Label (SAME AS OTHER PAGES) =====
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 10),
      child: Text(
        text,
        style: Styles.mediumTextStyle(size: 14, color: kBlackColor),
      ),
    );
  }

  /// ===== Static PDF Tile =====
  Widget _pdfTile(String fileName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'https://upload.wikimedia.org/wikipedia/commons/8/87/PDF_file_icon.svg',
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              style: Styles.mediumTextStyle(size: 14, color: kBlackColor),
            ),
          ),
          const Icon(Icons.visibility, size: 18, color: kPrimaryColor),
        ],
      ),
    );
  }

  /// ===== Static Image Preview =====
  Widget _imagePreview() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'https://images.pexels.com/photos/3184292/pexels-photo-3184292.jpeg', // 🔴 static image
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
