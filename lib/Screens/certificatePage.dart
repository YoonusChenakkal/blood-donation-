import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as dc;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CertificatePage extends StatelessWidget {
  const CertificatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Certificate',
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 3.h,
              ),
              SizedBox(
                height: 70.h,
                width: 100.w,
                child: PdfPreview(
                  loadingWidget: const CupertinoActivityIndicator(),
                  build: (context) async => await createPDF(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List> createPDF() async {
    final pdf = dc.Document(title: 'Blood Donation Certificate');

    // final logoImage = dc.MemoryImage(
    //     (await rootBundle.load('assets/tec-1.png')).buffer.asUint8List());
    final pageTheme = await _myPageTheme();
    pdf.addPage(dc.Page(
        pageTheme: pageTheme,
        build: (context) => dc.Stack(children: [
              dc.Center(
                child:
                    dc.Text('Yoonus', style: const dc.TextStyle(fontSize: 50)),
              ),
              dc.Positioned(
                  bottom: 200,
                  left: 170,
                  child: dc.Text(
                      'I pledge here your document is needed right,iot is',
                      style: const dc.TextStyle(fontSize: 27))),
              dc.Positioned(
                  bottom: 130,
                  left: 220,
                  child: dc.Text('14/07/22',
                      style: const dc.TextStyle(fontSize: 27))),
              dc.Positioned(
                  bottom: 130,
                  right: 250,
                  child:
                      dc.Text('sihn', style: const dc.TextStyle(fontSize: 27)))
            ])));
    return pdf.save();
  }

  _myPageTheme() async {
    final certificateTemplate = dc.MemoryImage(
        (await rootBundle.load('assets/certificate.png')).buffer.asUint8List());
    return dc.PageTheme(
      // Set the page size to 8.5 x 11 inches (standard certificate size)
      pageFormat: const PdfPageFormat(
          11.9 * PdfPageFormat.inch, 8.5 * PdfPageFormat.inch),

      textDirection: dc.TextDirection.ltr,
      orientation: dc.PageOrientation.landscape, // Landscape orientation
      buildBackground: (context) => dc.FullPage(
          ignoreMargins: true,
          child: dc.Watermark(
              child: dc.Opacity(
                  opacity: 1,
                  child: dc.Image(
                      alignment: dc.Alignment.center,
                      certificateTemplate,
                      fit: dc.BoxFit.contain)))),
    );
  }
}
