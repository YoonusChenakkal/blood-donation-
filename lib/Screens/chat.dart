import 'package:blood_donation/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Chats',
            style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w600),
          ),
        ),
        body: SizedBox(
          height: 100.h,
          width: 100.w,
          child: ListView(
            padding: EdgeInsets.all(12),
            children: [
              SizedBox(
                width: 92.w,
                child: ListTile(
                  tileColor: const Color.fromARGB(255, 248, 248, 248),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg'),
                  ),
                  title: Text(
                    'Marry Hospital',
                    style:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '3 Messages ~15m',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.camera_alt_outlined,
                    // color: Colors.grey,
                  ),
                  onTap: () => Navigator.pushNamed(context, '/userChat'),
                ),
              ),
              SizedBox(
                height: .2.h,
              ),
              SizedBox(
                width: 92.w,
                child: ListTile(
                  tileColor: const Color.fromARGB(255, 248, 248, 248),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.asterdmhealthcare.in/fileadmin/user_upload/MIMS_Kozhikode.jpg'),
                  ),
                  title: Text(
                    'MIMS Hospital',
                    style:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '6 Messages ~10m',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.camera_alt_outlined,
                    // color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: .2.h,
              ),
              SizedBox(
                width: 92.w,
                child: ListTile(
                  tileColor: const Color.fromARGB(255, 248, 248, 248),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.jdmagicbox.com/comp/malappuram/e2/9999px483.x483.230801211004.w1e2/catalogue/dr-p-a-kabeer-almas-hospital-kottakkal-malappuram-general-physician-doctors-GZmbQRJvhi-250.jpg'),
                  ),
                  title: Text(
                    'Almas Hospital',
                    style:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Sent 1 hour ago',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    Icons.camera_alt_outlined,
                    // color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
