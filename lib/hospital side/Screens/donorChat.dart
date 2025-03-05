import 'package:Life_Connect/hospital%20side/Models/donorModel.dart';
import 'package:Life_Connect/hospital%20side/Providers/chatsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HospitalDonorChat extends StatelessWidget {
  const HospitalDonorChat({super.key});

  @override
  Widget build(BuildContext context) {
    final DonorModel donor =
        ModalRoute.of(context)!.settings.arguments as DonorModel;
    final chatProvider = Provider.of<HospitalChatsProvider>(context);
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
              backgroundImage: donor.profileImage != null
                  ? NetworkImage(donor.profileImage ?? '')
                  : const AssetImage('assets/man.png'),
            ),
            SizedBox(width: 6.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donor.user,
                  style: GoogleFonts.actor(
                    fontSize: 19.5.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
            Expanded(
              child: Consumer<HospitalChatsProvider>(
                builder: (context, chatProvider, _) {
                  if (chatProvider.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.red,
                    ));
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
                    return Column(
                      children: [
                        _chatHeaderText(),
                        SizedBox(
                          height: 23.h,
                        ),
                        Text(
                          'No Chat Available',
                          style: TextStyle(fontSize: 17.sp),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: chatProvider.chats.length + 1, // Includes header
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Return the header for the first item
                        return _chatHeaderText();
                      }

                      // Adjust index to account for the header
                      final chatIndex = index - 1;

                      // Sort chats once before accessing
                      chatProvider.chats
                          .sort((a, b) => a.timestamp.compareTo(b.timestamp));

                      if (chatIndex < chatProvider.chats.length) {
                        final chat = chatProvider.chats[chatIndex];
                        return Column(
                          children: [
                            Padding(
                              padding: chat.senderType == 'donor'
                                  ? const EdgeInsets.only(left: 15)
                                  : const EdgeInsets.only(right: 15),
                              child: Row(
                                mainAxisAlignment: chat.senderType == 'donor'
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onLongPress: () {
                                      Clipboard.setData(
                                          ClipboardData(text: chat.content));
                                      HapticFeedback.vibrate();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Center(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: const Text(
                                                'Copied',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors
                                              .transparent, // Make the background invisible
                                          elevation: 0, // Remove shadow
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 75.w, minWidth: 13.w),
                                      margin: const EdgeInsets.all(4),
                                      padding: const EdgeInsets.all(9),
                                      decoration: BoxDecoration(
                                        color: chat.senderType == 'donor'
                                            ? Colors.red[50]
                                            : Colors.blue[50],
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: Text(
                                        chat.content,
                                        style: GoogleFonts.roboto(
                                            fontSize: 15.5.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      // Fallback in case of unexpected index
                      return const SizedBox.shrink();
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
                            donor.user, tcContent.text);
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
