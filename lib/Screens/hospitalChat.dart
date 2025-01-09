import 'package:blood_donation/Models/hospitalModel.dart';
import 'package:blood_donation/Providers/chatsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HospitalChat extends StatelessWidget {
  const HospitalChat({super.key});

  @override
  Widget build(BuildContext context) {
    final HospitalModel hospital =
        ModalRoute.of(context)!.settings.arguments as HospitalModel;
    final chatProvider = Provider.of<ChatsProvider>(context);
    TextEditingController tcContent = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      resizeToAvoidBottomInset:
          true, // Ensures content resizes with the keyboard
      appBar: AppBar(
        toolbarHeight: 10.h,
        leading: Padding(
          padding: EdgeInsets.only(left: 6.w),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(
                hospital.image ??
                    'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg',
              ),
            ),
            SizedBox(width: 6.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospital.name,
                  style: GoogleFonts.actor(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '3 weeks ago',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.info_outline,
                size: 21.5.sp,
                color: Colors.amber,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.black,
      ),

      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            // Container(
            //   height: 10.h,
            //   width: 100.w,
            //   decoration: const BoxDecoration(
            //     color: Colors.black,
            //   ),
            //   child: Align(
            //     alignment: AlignmentDirectional.bottomCenter,
            //     child: ListTile(
            //       leading: Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           IconButton(
            //             onPressed: () => Navigator.pop(context),
            //             icon: const Icon(
            //               Icons.arrow_back_ios,
            //               color: Colors.white,
            //             ),
            //           ),
            //           const CircleAvatar(
            //             backgroundImage: NetworkImage(
            //               'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg',
            //             ),
            //           ),
            //         ],
            //       ),
            //       title: Text(
            //         hospital.name,
            //         style: GoogleFonts.actor(
            //             fontSize: 17.sp,
            //             fontWeight: FontWeight.w600,
            //             color: Colors.white),
            //       ),
            //       titleAlignment: ListTileTitleAlignment.center,
            //       subtitle: Text(
            //         '3 weeks ago',
            //         style: TextStyle(
            //           fontSize: 14.sp,
            //           color: Colors.white,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       trailing: IconButton(
            //         onPressed: () {},
            //         icon: Icon(
            //           Icons.info_outline,
            //           size: 21.5.sp,
            //           color: Colors.amber,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: Consumer<ChatsProvider>(
                builder: (context, chatProvider, _) {
                  if (chatProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (chatProvider.errorMessage != null) {
                    return Center(
                      child: Text(
                        chatProvider.errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (chatProvider.chats.isEmpty) {
                    return Center(
                      child: Text(
                        'No Chat Available',
                        style: TextStyle(fontSize: 17.sp),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: chatProvider.chats.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _chatHeaderText();
                      }
                      chatProvider.chats
                          .sort((a, b) => a.timestamp.compareTo(b.timestamp));

                      final chat = chatProvider.chats[index];
                      return Column(
                        children: [
                          Padding(
                            padding: chat.senderType == 'hospital'
                                ? const EdgeInsets.only(left: 15)
                                : const EdgeInsets.only(right: 15),
                            child: Row(
                              mainAxisAlignment: chat.senderType == 'hospital'
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg',
                                  ),
                                ),
                                GestureDetector(
                                  onLongPress: () {},
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 75.w, minWidth: 13.w),
                                    margin: const EdgeInsets.all(4),
                                    padding: const EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                      color: chat.senderType == 'hospital'
                                          ? Colors.red[50]
                                          : Colors.blue[50],
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Text(
                                      chat.content,
                                      style:
                                          GoogleFonts.roboto(fontSize: 15.5.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              width: 100.w,
              color: Colors.black,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                width: 100.w,
                height: 6.2.h,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 56, 56, 56),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: tcContent,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 4.5.w, right: 1.w),
                          hintText: 'Message',
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            color: const Color.fromARGB(255, 224, 224, 224),
                          ),
                          border: InputBorder.none, // To remove border
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final message = await chatProvider.sendMessage(
                            hospital.id, hospital.name, tcContent.text);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(message),
                          duration: const Duration(seconds: 2),
                        ));
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        size: 23.sp,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _chatHeaderText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13.w, vertical: 2.h),
      padding: EdgeInsets.all(14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.amber, Color.fromARGB(255, 255, 215, 97)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 90, 90, 90).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock,
            size: 20.sp,
            color: Colors.white,
          ),
          SizedBox(height: .5.h),
          Text(
            "Your messages are private and secure.",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: .2.h),
          Text(
            "Only you and the recipient can see them.",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 1.h,
          )
        ],
      ),
    );
  }
}
