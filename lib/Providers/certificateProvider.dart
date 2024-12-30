import 'dart:convert';

import 'package:blood_donation/Models/certificateModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:sizer/sizer.dart';

class CertificateProvider with ChangeNotifier {
  Uint8List? pdfDocument;
  SignatureController _signatureController = SignatureController();
  Uint8List? _signatureBytes;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Uint8List? get signatureBytes => _signatureBytes;

  SignatureController get signatureController => _signatureController;

  set signatureController(value) {
    _signatureController = value;
    notifyListeners();
  }

  set signatureBytes(value) {
    _signatureBytes = value;
    notifyListeners();
  }

  Future<void> generatePdf() async {
    pdfDocument = await createPDF();
    notifyListeners();
  }

  postPdf() async {
    _isLoading = true;
    notifyListeners();

    if (pdfDocument == null) {
      return 'No Pdf Found Try Again';
    }

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'Unknown User';

    try {
      final url =
          Uri.parse('https://lifeproject.pythonanywhere.com/donor/consent/');

      final request = http.MultipartRequest('POST', url);

      // Add the PDF file
      request.files.add(http.MultipartFile.fromBytes(
        'certificate', // Field name for the file
        pdfDocument!,
        filename: 'certificate.pdf',
      ));
      request.fields['user'] = username;

      // Send the request
      final response = await request.send();
      if (response.statusCode == 201) {
        return 'Successfully Uploaded';
      } else if (response.statusCode == 400) {
        return 'User Already Have Certitificate';
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      return 'Error posting PDF: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  showPdf() async {
    print('Show Pdf  ntejnlgjluguor');
    _isLoading = true;

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final url = Uri.parse(
        'https://lifeproject.pythonanywhere.com/donor/consents/${username}/');
    try {
      final response = await http.get(url);
      print(response.statusCode);

      if (response.statusCode == 200) {
        notifyListeners();

        final data = jsonDecode(response.body);
        print(data);
      } else {
        throw Exception(
            'Failed to load certificates. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching certificates: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Uint8List> createPDF() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final pdf = Document(title: 'Blood Donation Certificate');

    final pageTheme = await _myPageTheme();
    pdf.addPage(Page(
        pageTheme: pageTheme,
        build: (context) => Stack(children: [
              Center(
                child: Text(username!, style: const TextStyle(fontSize: 50)),
              ),
              Positioned(
                  bottom: 200,
                  left: 170,
                  child: Text(
                      'I pledge here your document is needed right,iot is',
                      style: const TextStyle(fontSize: 27))),
              Positioned(
                  bottom: 120,
                  left: 220,
                  child: Text(
                      intl.DateFormat('dd-MM-yyyy').format(DateTime.now()),
                      style: const TextStyle(fontSize: 27))),
              _signatureBytes != null
                  ? Positioned(
                      bottom: 120,
                      right: 250,
                      child: Image(MemoryImage(_signatureBytes!),
                          height: 10.h, width: 20.w))
                  : Positioned(
                      bottom: 120,
                      right: 250,
                      child: Text('Sign', style: const TextStyle(fontSize: 27)))
            ])));
    return pdf.save();
  }
}

_myPageTheme() async {
  final certificateTemplate = MemoryImage(
      (await rootBundle.load('assets/certificate.png')).buffer.asUint8List());
  return PageTheme(
    // Set the page size to 8.5 x 11 inches (standard certificate size)
    pageFormat: const PdfPageFormat(
        11.9 * PdfPageFormat.inch, 8.5 * PdfPageFormat.inch),

    textDirection: TextDirection.ltr,
    orientation: PageOrientation.landscape, // Landscape orientation
    buildBackground: (context) => FullPage(
        ignoreMargins: true,
        child: Watermark(
            child: Opacity(
                opacity: 1,
                child: Image(
                    alignment: Alignment.center,
                    certificateTemplate,
                    fit: BoxFit.contain)))),
  );
}
