import 'package:Life_Connect/user side/Providers/certificateProvider.dart';
import 'package:Life_Connect/user%20side/widgets/certificatePreview.dart';
import 'package:Life_Connect/user%20side/widgets/customButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signature/signature.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificatePage extends StatelessWidget {
  const CertificatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final certificateProvider = Provider.of<CertificateProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: Colors.white,
        title: Text('Certificate',
            style: GoogleFonts.aBeeZee(
                fontSize: 23.sp, fontWeight: FontWeight.w600)),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
        
          children: [
            const CertificatePreview(),
            CustomButton(
              width: 50,
              text: certificateProvider.consentDate == null
                  ? 'e-Sign'
                  : 'Download',
              buttonType: ButtonType.Elevated,
              textColor: Colors.white,
              isLoading: certificateProvider.isLoading,
              onPressed: () async {
                if (certificateProvider.consentDate == null) {
                  showSignatureDialogue(context, certificateProvider);
                } else {
                  final certificateUrl = certificateProvider.certificateUrl;
                  if (certificateUrl != null) {
                    // Implement download logic or open URL
                    await launchUrl(Uri.parse(certificateUrl));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void showSignatureDialogue(
      BuildContext context, CertificateProvider certificateProvider) {
    showDialog(
      context: context,
      builder: (c) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Signature(
                  controller: certificateProvider.signatureController,
                  height: 30.h,
                  width: 70.w,
                  backgroundColor:
                      const Color.fromARGB(255, 255, 115, 105).withOpacity(0.2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        certificateProvider.signatureController.clear();
                      },
                      child: const Text(
                        'clear',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final exportController = SignatureController(
                          penStrokeWidth: 2,
                          penColor: Colors.black,
                          exportBackgroundColor: Colors.white,
                          points:
                              certificateProvider.signatureController.points,
                        );

                        final bytes = await exportController.toPngBytes();

                        if (bytes != null) {
                          Navigator.pop(context);
                          certificateProvider.signatureBytes = bytes;
                          await certificateProvider.generatePdf();
                          final message =
                              await certificateProvider.uploadCertificate();

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(message),
                            duration: const Duration(seconds: 2),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please sign before confirming.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'confirm',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
