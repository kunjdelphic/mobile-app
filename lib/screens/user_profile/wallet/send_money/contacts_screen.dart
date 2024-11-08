import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];
  String search = '';
  TextEditingController searchController = TextEditingController();
  late Future<List<Contact>> _contactsFuture;

  @override
  void initState() {
    super.initState();

    _contactsFuture = getContacts();
  }

  Future<List<Contact>> getContacts() async {
    var res = await Permission.contacts.request();

    print('---- res is $res');

    if (res.isPermanentlyDenied) {
      errorSnackbar(title: 'Failed', subtitle: 'Permission denied! Please grant the permission to fetch contacts.');
      return [];
    }

    if (res.isDenied) {
      getContacts();
      errorSnackbar(title: 'Failed', subtitle: 'Permission denied! Please grant the permission to fetch contacts.');
      return [];
    }

    if (search.isNotEmpty) {
      try {
        List<Contact> searchContacts = [];
        List<Contact> contactsList = await ContactsService.getContacts(query: "$search", withThumbnails: false);

        print("---======>>> ${contactsList.length}");
        contacts = contactsList.toList();

        print('SEARCHING CONTACT...');
        print("---  CONTACTS: LENGTH ${contacts.length}");

        return contacts;

        // for (var element in contacts) {
        //     print("---  CONTACTS: ${element.toMap()}");
        //   if (element.displayName!
        //         .trim()
        //         .toLowerCase()
        //         .contains(search.trim().toLowerCase())) {
        //       print("--- ADDING CONTACTS ");
        //       searchContacts.add(element);
        //     }
        // }

        // for (var item in contacts) {
        //   print("---  CONTACTS: ${item.toMap()}");
        //   if (item.displayName!
        //       .trim()
        //       .toLowerCase()
        //       .contains(search.trim().toLowerCase())) {
        //     print("--- ADDING CONTACTS ");
        //     searchContacts.add(item);
        //   }
        // }

        return searchContacts;
      } catch (e) {
        print(e);
        return [];
      }
    } else {
      print('this run');
      try {
        List<Contact> contactsList = await ContactsService.getContacts(withThumbnails: false);

        print(contactsList[0].phones == []);
        contacts = contactsList.toList();

        return contacts;
      } catch (e) {
        print('i am $e');
        return [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Contacts",
          style: kBlackLargeStyle,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
              color: kWhite,
              // color: kWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Search is required';
                  }

                  return null;
                },
                onSaved: (val) {
                  search = val!.trim();
                },
                onChanged: (value) {
                  setState(() {
                    search = value.trim().toLowerCase();
                  });
                  _contactsFuture = getContacts();
                },
                controller: searchController,
                enableInteractiveSelection: true,
                style: kBlackMediumStyle,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  helperStyle: kBlackSmallLightMediumStyle,
                  errorStyle: kBlackSmallLightMediumStyle,
                  hintStyle: kBlackSmallLightMediumStyle,
                  hintText: 'Search',
                  labelStyle: kBlackSmallLightMediumStyle,
                  fillColor: Colors.black.withOpacity(0.03),
                  filled: true,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black38,
                  ),
                  suffixIcon: search.isNotEmpty
                      ? GestureDetector(
                          onTap: () => setState(() {
                            search = '';
                            searchController.text = '';

                            setState(() {
                              search = '';
                            });
                            _contactsFuture = getContacts();
                          }),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black38,
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ),
          ),
          const Divider(thickness: 0.30),
          Expanded(
            child: FutureBuilder<List<Contact>>(
              future: _contactsFuture,
              builder: (context, snapshot) {
                print(snapshot.hasData);
                print(snapshot.data?.length);
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.active) {
                  return const Center(
                    child: SizedBox(
                      height: 25,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineScalePulseOut,
                        colors: [
                          kAccentColor,
                        ],
                      ),
                    ),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No contacts found!',
                      style: kBlackMediumStyle,
                    ),
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      dense: true,
                      onTap: () {
                        Get.back(
                          result: snapshot.data![index],
                        );
                      },
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff1B75BB),
                              Color(0xff2B388F),
                            ],
                            begin: Alignment.topCenter,
                            // stops: [
                            //   0.4,
                            //   1,
                            // ],
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            snapshot.data![index].initials(),
                            style: kWhiteMediumStyle,
                          ),
                        ),
                      ),
                      title: Text(
                        '${snapshot.data![index].displayName}',
                        style: kBlackMediumStyle,
                      ),
                      subtitle: Text(
                        snapshot.data![index].phones!.isNotEmpty ? snapshot.data![index].phones!.first.value!.replaceAll('-', '').toString() : '',
                        style: kBlackMediumStyle,
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
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
