import 'package:Life_Connect/Providers/chatsProvider.dart';
import 'package:Life_Connect/Providers/hospitalProvider.dart';
import 'package:Life_Connect/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        toolbarHeight: 8.h,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Chats',
          style:
              GoogleFonts.aBeeZee(fontSize: 23.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5.h,
            width: 90.w,
            child: SearchBar(
              onChanged: (query) =>
                  Provider.of<HospitalProvider>(context, listen: false)
                      .searchhospitals(query),
              backgroundColor: const WidgetStatePropertyAll(
                  Color.fromARGB(255, 243, 243, 243)),
              leading: const Icon(Icons.search),
              hintText: 'Search',
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6))),
            ),
          ),
          Expanded(
            child: Consumer<HospitalProvider>(
              builder: (context, hospitalProvider, _) {
                if (hospitalProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (hospitalProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hospitalProvider.errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        CustomButton(
                            text: 'Refresh',
                            buttonType: ButtonType.Outlined,
                            isLoading: hospitalProvider.isLoading,
                            onPressed: () => hospitalProvider.fetchHospitals())
                      ],
                    ),
                  );
                }

                if (hospitalProvider.hospitals.isEmpty) {
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
                            isLoading: hospitalProvider.isLoading,
                            onPressed: () => hospitalProvider.fetchHospitals())
                      ],
                    ),
                  );
                }

                if (hospitalProvider.filteredhospitals.isEmpty) {
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
                            isLoading: hospitalProvider.isLoading,
                            onPressed: () => hospitalProvider.fetchHospitals())
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await hospitalProvider.fetchHospitals();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 2.h),
                    separatorBuilder: (context, index) {
                      return Divider(
                        indent: 21.w,
                        color: const Color.fromARGB(255, 179, 179, 179),
                        thickness: .4,
                        height: 0,
                      );
                    },
                    itemCount: hospitalProvider.filteredhospitals.length,
                    itemBuilder: (context, index) {
                      final hospital =
                          hospitalProvider.filteredhospitals[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: ListTile(
                          tileColor: const Color.fromARGB(255, 255, 255, 255),
                          leading: Container(
                            height: 13.w,
                            width: 13.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: hospital.image != null
                                    ? NetworkImage(
                                        hospital.image!,
                                      )
                                    : const AssetImage(
                                        'assets/hospital.png',
                                      ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            hospital.name,
                            style: GoogleFonts.actor(
                                fontSize: 17.sp, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            DateFormat('dd-MM-yyyy').format(hospital.createdAt),
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w400),
                          ),
                          onTap: () {
                            Provider.of<ChatsProvider>(context, listen: false)
                                .fetchChats(hospital.id);
                            Navigator.pushNamed(context, '/hospitalChat',
                                arguments: hospital);
                          },
                        ),
                      );
                    },
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
