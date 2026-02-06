import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';

import 'provider/uploaded_documents_provider.dart';

class UploadOrganizationDocuments extends StatefulWidget {
  const UploadOrganizationDocuments({super.key});

  @override
  State<UploadOrganizationDocuments> createState() =>
      _UploadOrganizationDocumentsState();
}

class _UploadOrganizationDocumentsState
    extends State<UploadOrganizationDocuments> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
      Provider.of<UploadedDocumentsProvider>(context, listen: false);

      final data = provider.userModel;
      debugPrint("userModel => $data");

      provider.loadUploadedDocuments(
        userId: "8442", // 🔴 dynamic later
      );
    });
  }


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
        body: Consumer<UploadedDocumentsProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// ===== PDFs =====
                    _label("Uploaded Documents (PDF)"),

                    ...provider.pdfUrls.map(
                          (url) =>
                          _pdfTile(
                            url
                                .split("/")
                                .last,
                            onTap: () => provider.downloadAndOpenPdf(url),
                          ),
                    ),

                    const SizedBox(height: 20),

                    /// ===== Image =====
                    _label("Organization Image"),

                    if (provider.imageUrl != null)
                      _imagePreview(provider.imageUrl!)
                    else
                      const Text("No image uploaded"),

                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
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
  Widget _pdfTile(String fileName, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.picture_as_pdf,
                color: Colors.red, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                fileName,
                style: Styles.mediumTextStyle(size: 14, color: kBlackColor),
              ),
            ),
            const Icon(Icons.download, size: 18, color: kPrimaryColor),
          ],
        ),
      ),
    );
  }


  /// ===== Static Image Preview =====
  Widget _imagePreview(String imageUrl) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.broken_image)),
        ),
      ),
    );
  }

}
