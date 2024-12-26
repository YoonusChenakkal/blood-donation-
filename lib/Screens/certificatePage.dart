import 'package:blood_donation/Providers/certificateProvider.dart';
import 'package:blood_donation/widgets/certificatePreview.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CertificatePage extends StatelessWidget {
  const CertificatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final certificateProvider =
        Provider.of<CertificateProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Certificate',
          style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 9.h,
      ),
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            const CertificatePreview(),
            CustomButton(
              text: 'Generate',
              buttonType: ButtonType.Elevated,
              onPressed: () async {
                await certificateProvider.generatePdf();
                final message = await certificateProvider.postPdf();

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                  duration: const Duration(seconds: 2),
                ));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'History',
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 132, 132, 132)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: certificateProvider.fetchCertificates(),
                builder: (context, snapshot) {
                  if (certificateProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final certificates = certificateProvider.certificates;
                  if (certificates.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No certificates found.",
                            style: TextStyle(fontSize: 17.sp),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CustomButton(
                              width: 40,
                              text: 'Refresh',
                              buttonType: ButtonType.Outlined,
                              onPressed: () =>
                                  certificateProvider.fetchCertificates())
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: certificates.length,
                    itemBuilder: (context, index) {
                      final certificate = certificates[index];
                      return ListTile(
                        title: Text(certificate.username),
                        subtitle: Text(certificate.certificate),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.download,
                            color: Colors.red,
                            size: 22.sp,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
