import 'package:blood_donation/Providers/certificateProvider.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Abcd extends StatelessWidget {
  const Abcd({super.key});

  @override
  Widget build(BuildContext context) {
    final certificateProvider = Provider.of<CertificateProvider>(context);

    return Scaffold(
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: PdfPreview(
          build: (format) async {
            await certificateProvider.generatePdf();
            return await certificateProvider.createPDF();
          },
          allowPrinting: true, // Enable printing option
          allowSharing: true, // Enable sharing option
          loadingWidget:
              const Center(child: CircularProgressIndicator()), // Loader
        ),
      ),
    );
  }
}
