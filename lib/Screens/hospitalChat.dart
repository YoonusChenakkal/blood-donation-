import 'package:blood_donation/Models/hospitalModel.dart';
import 'package:blood_donation/Providers/chatsProvider.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:
          true, // Ensures content resizes with the keyboard
      body: SafeArea(
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                width: 98.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black,
                ),
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg',
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    hospital.name,
                    style: TextStyle(
                      fontSize: 15.5.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  titleAlignment: ListTileTitleAlignment.center,
                  subtitle: Text(
                    '3 weeks ago',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.info_outline,
                      size: 21.5.sp,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
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
                        chatProvider.chats
                            .sort((a, b) => a.timestamp.compareTo(b.timestamp));

                        final chat = chatProvider.chats[index];
                        return Padding(
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
                              Container(
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
                                child: Text(chat.content),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 2.2.w),
                width: 92.w,
                height: 6.2.h,
                decoration: BoxDecoration(
                  color: Colors.black,
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
            ],
          ),
        ),
      ),
    );
  }
}
