import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/adduser_screen.dart';
import 'package:resvago/admin/user_model.dart';
import '../components/my_button.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({Key? key}) : super(key: key);

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            MyButton(
              onTap: () {
                Get.to(const AddUserScreen());
              },
              text: 'Add User',
            ),

            FutureBuilder(
              future: getUsersFromFirestore(), builder: (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){

                    final item = snapshot.data![index];
                  return ListTile(
                    title: Text(item.name.toString()),
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    subtitle: Text(item.phoneNumber),
                    trailing: PopupMenuButton<int>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        color: Colors.white,
                        itemBuilder: (context) {
                          return [
                                  PopupMenuItem(
                                    value: 1,
                                    onTap: () {
                                    },
                                    child: const Text(
                                      "Edit"
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    onTap: () {
                                    },
                                    child: const Text(
                                      "Delete"
                                    ),
                                  ),
                             PopupMenuItem(
                                value: 1,
                                onTap: () {
                                },
                                child: const Text(
                                 "Deactivate"
                                ),
                              ),
                          ];
                        }));
                });
              }
              return const CircularProgressIndicator();
            },

            )
          ],
        ),
      ),
    );
  }
}

Future<List<UserData>> getUsersFromFirestore() async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('users').get();

  List<UserData> users = [];

  querySnapshot.docs.forEach((doc) {
    users.add(UserData(
      name: doc['name'],
      email: doc['email'],
      password: doc['password'],
      phoneNumber: doc['phonenumber'],
    ));
  });

  return users;
}
