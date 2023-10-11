import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resvago/admin/Couponlist_Screen.dart';
import 'package:resvago/admin/Pageslist_screen.dart';
import 'package:resvago/admin/resturent_datalist.dart';
import 'package:resvago/admin/userdata_screen.dart';
import 'menuitem_list_screen.dart';

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;
  int touchedIndex = -1;
  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Resvago Admin App',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff3B5998),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff3B5998),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        minRadius: 40,
                        maxRadius: 45,
                        backgroundImage: AssetImage(
                          'assets/images/girl.jpg',
                        )),
                    Text(
                      'Williams Jones',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'williamsjones@gmail.com',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Add User'),
                onTap: () {
                  Get.to(const UsersDataScreen());
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context); // Closes the drawer
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.countertops_outlined),
                title: const Text('Add Coupens'),
                onTap: () {
                  Get.to(const CouponListScreen()); // Closes the drawer
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.food_bank),
                title: const Text('Add Product Category'),
                onTap: () {
                  Get.to(const ResturentDataScreen()); // Closes the drawer
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Add Vendor Category'),
                onTap: () {
                  Get.to(const MenuItemListScreen()); // Closes the drawer
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.pages),
                title: const Text('Add Pages'),
                onTap: () {
                  Get.to(const PagesListScreen()); // Closes the drawer
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 100,
                width: 160,
                decoration: BoxDecoration(color: Color(0xff1AB0B0), borderRadius: BorderRadius.circular(20)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '₹1000',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                    ),
                    Text(
                      'Total Sale',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    )
                  ],
                ),
              ),
              Container(
                height: 100,
                width: 160,
                decoration: BoxDecoration(color: Color(0xffFF7443), borderRadius: BorderRadius.circular(20)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '120',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                    ),
                    Text(
                      'Total Orders  ',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 100,
                width: 160,
                decoration: BoxDecoration(color: Color(0xffF65579), borderRadius: BorderRadius.circular(20)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '₹500',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                    ),
                    Text(
                      'Total Profit',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    )
                  ],
                ),
              ),
              Container(
                height: 100,
                width: 160,
                decoration: BoxDecoration(color: Color(0xff8676FE), borderRadius: BorderRadius.circular(20)),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '₹132',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                    ),
                    Text(
                      'Total Products',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        ])));
  }
}
