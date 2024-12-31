import 'package:blood_donation/Providers/chatsProvider.dart';
import 'package:blood_donation/Providers/hospitalProvider.dart';
import 'package:blood_donation/Screens/login.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
      body: Column(
        children: [
          SizedBox(
            height: 5.h,
            width: 80.w,
            child: SearchBar(
              onChanged: (query) =>
                  Provider.of<HospitalProvider>(context, listen: false)
                      .searchhospitals(query),
              backgroundColor: WidgetStatePropertyAll(Colors.red[50]),
              leading: const Icon(Icons.search),
              hintText: 'Search',
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6))),
            ),
          ),
          Expanded(
            child: Consumer<HospitalProvider>(
              builder: (context, donorProvider, _) {
                if (donorProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (donorProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          donorProvider.errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        CustomButton(
                            text: 'Refresh',
                            buttonType: ButtonType.Outlined,
                            onPressed: () => donorProvider.fetchHospitals())
                      ],
                    ),
                  );
                }

                if (donorProvider.hospitals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Chat Available',
                          style: TextStyle(fontSize: 17.sp),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        CustomButton(
                            text: 'Refresh',
                            buttonType: ButtonType.Outlined,
                            onPressed: () => donorProvider.fetchHospitals())
                      ],
                    ),
                  );
                }

                if (donorProvider.filteredhospitals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No chat match your search.",
                          style: TextStyle(fontSize: 17.sp),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        CustomButton(
                            text: 'Refresh',
                            buttonType: ButtonType.Outlined,
                            onPressed: () => donorProvider.fetchHospitals())
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await donorProvider.fetchHospitals();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ListView.builder(
                      itemCount: donorProvider.filteredhospitals.length,
                      itemBuilder: (context, index) {
                        final hospital = donorProvider.filteredhospitals[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 3, left: 8, right: 8),
                          child: ListTile(
                            tileColor: const Color.fromARGB(255, 248, 248, 248),
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg'),
                            ),
                            title: Text(
                              hospital.name,
                              style: TextStyle(
                                  fontSize: 17.sp, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              DateFormat('dd-MM-yyyy')
                                  .format(hospital.createdAt),
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              Provider.of<ChatsProvider>(context, listen: false)
                                  .fetchChats(hospital.id);
                              Navigator.pushNamed(context, '/userChat',
                                  arguments: hospital);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
