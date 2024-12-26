import 'dart:convert';

import 'package:blood_donation/Models/certificateModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CertificateProvider with ChangeNotifier {
  Uint8List? pdfDocument;
  List<CertificateModel> certificates = [];

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> generatePdf() async {
    certificates.add(CertificateModel(
        username: 'yoonsu',
        certificate: 'jdjsnjlajds',
        CertificateModelDate: 'qeffef',
        isCertificateModelGiven: false));
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
      request.fields['user'] = username!;

      // Send the request
      final response = await request.send();
      if (response.statusCode == 201) {
        return 'Successfully Uploaded';
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

  fetchCertificates() async {
    _isLoading = true;
    notifyListeners();
    final url =
        Uri.parse('https://lifeproject.pythonanywhere.com/donor/consent/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        //certificates.clear();
        final List<dynamic> jsonList = json.decode(response.body);
        certificates =
            jsonList.map((json) => CertificateModel.fromJson(json)).toList();
        notifyListeners();
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
              Positioned(
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
