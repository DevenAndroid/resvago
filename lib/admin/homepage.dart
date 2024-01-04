import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:resvago/admin/Couponlist_Screen.dart';
import 'package:resvago/admin/Pageslist_screen.dart';
import 'package:resvago/admin/dining_order_list.dart';
import 'package:resvago/admin/loginscreen.dart';
import 'package:resvago/admin/order_list_screen.dart';
import 'package:resvago/admin/setting_screen.dart';
import 'package:resvago/admin/vendor_datalist.dart';
import 'package:resvago/admin/slider_images.dart';
import 'package:resvago/admin/userdata_screen.dart';
import 'package:resvago/components/helper.dart';
import 'customeruser_list.dart';
import 'diningOrders_details_screen.dart';
import 'productcategory_list_screen.dart';
import 'model/deliveryOrder_details_screen.dart';
import 'model/delivery_order_details_modal.dart';
import 'model/dining_order_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late bool isShowingMainData;
  int touchedIndex = -1;
  bool isDropdownOpen = false;

  void toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  Future<int> totalSoldItem() async {
    final item1 = await FirebaseFirestore.instance.collection('order').where("order_status", isEqualTo: "Order Completed").count().get();
    final item2 = await FirebaseFirestore.instance.collection('dining_order').where("order_status", isEqualTo: "Order Completed").count().get();
    return item1.count + item2.count;
  }


  Future<int> totalItem() async {
    final item1 = await FirebaseFirestore.instance
        .collection('order')
        .count()
        .get();
    final item2 = await FirebaseFirestore.instance
        .collection('dining_order')
        .count()
        .get();
    return item1.count + item2.count;
  }

  double totalEarnings = 0;
  Future<double> calculateTotalEarnings() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('dining_order').where("order_status", isEqualTo: "Order Completed").get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      double orderAmount = double.parse(documentSnapshot.data()["total"]);
      totalEarnings += orderAmount;
    }

    return totalEarnings;
  }

  Future<double> calculateTotalEarnings1() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('order').where("order_status", isEqualTo: "Order Completed").get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      double orderAmount = double.parse(documentSnapshot.data()["total"]);
      totalEarnings += orderAmount;
    }

    return totalEarnings;
  }

  Future<void> fetchTotalEarnings() async {
    double earnings = await calculateTotalEarnings();
    double earnings1 = await calculateTotalEarnings();
    setState(() {
      totalEarnings = earnings + earnings1;
      log("dgdfhdfh$totalEarnings");
    });
  }

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    fetchTotalEarnings();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          leading: GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: const Icon(Icons.menu)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hi Admin..',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: CircleAvatar(
                minRadius: 20,
                backgroundImage: AssetImage("assets/images/girl.jpg"),
              ),
            )
          ],
          backgroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
               DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                        minRadius: 35,
                        maxRadius: 40,
                        backgroundImage: AssetImage(
                          'assets/images/girl.jpg',
                        )),
                     Text(
                      FirebaseAuth.instance.currentUser!.email.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('User List'),
                trailing: const Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                ),
                onTap: () {
                  toggleDropdown();
                },
              ),
              if (isDropdownOpen)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('Customers'),
                        onTap: () {
                          Get.to(const CustomeruserListScreen());
                        },
                      ),
                      ListTile(
                        title: const Text('Vendors'),
                        onTap: () {
                          Get.to(const UsersDataScreen());
                        },
                      ),
                    ],
                  ),
                ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.countertops_outlined),
                title: const Text('Coupons List'),
                onTap: () {
                  Get.to(CouponListScreen()); // Closes the drawer
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.food_bank),
                title: const Text('Vendor Category'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VendorDataScreen(
                                collectionReference: FirebaseFirestore.instance.collection("resturent"),
                                key: ValueKey(DateTime.now().millisecondsSinceEpoch),
                              )));
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Product Category'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductCategoryScreen(
                                collectionReference: FirebaseFirestore.instance.collection("menuItemsList"),
                                key: ValueKey(DateTime.now().millisecondsSinceEpoch),
                              )));
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.pages),
                title: const Text('Pages List'),
                onTap: () {
                  Get.to(const PagesListScreen()); // Closes the drawer
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Orders'),
                trailing: const Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                ),
                onTap: () {
                  toggleDropdown();
                },
              ),
              if (isDropdownOpen)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('Delivery'),
                        onTap: () {
                          Get.to(const OrderListScreen());
                        },
                      ),
                      ListTile(
                        title: const Text('Dining'),
                        onTap: () {
                          Get.to(const DiningorderListScreen());
                        },
                      ),
                    ],
                  ),
                ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Get.to(const settingScreen(
                    isEditMode: false,
                  ));
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Image Slider'),
                onTap: () {
                  Get.to(const SliderImagesScreen());
                },
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  Get.back();
                  Get.to(const LogInScreen());
                  // await FirebaseAuth.instance.signOut().then((value) {
                  //   // Get.to(const LogInScreen());
                  //
                  // });
                },
              ),
            ],
          ),
        ),
        body: DefaultTabController(
          length: 2,
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
                  decoration: BoxDecoration(color: const Color(0xff1AB0B0), borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: totalSoldItem(),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                          if (snapshot.hasData) {
                            log(snapshot.data.toString());
                            return Text(
                              (snapshot.data ?? "0").toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                            );
                          }
                          return const Text(
                            "0",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                          );
                        },
                      ),
                      const Text(
                        'Total Sale',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: 160,
                  decoration: BoxDecoration(color: const Color(0xffFF7443), borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: totalItem(),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                          if (snapshot.hasData) {
                            log(snapshot.data.toString());
                            return Text(
                              (snapshot.data ?? "0").toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                            );
                          }
                          return const Text(
                            "0",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                          );
                        },
                      ),
                      const Text(
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
                  decoration: BoxDecoration(color: const Color(0xffF65579), borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\$${totalEarnings.toString()}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                      ),
                      const Text(
                        'Total Profit',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: 160,
                  decoration: BoxDecoration(color: const Color(0xff8676FE), borderRadius: BorderRadius.circular(20)),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${0}',
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
            const TabBar(labelColor: Color(0xFF454B5C), indicatorColor: Color(0xFF3B5998), indicatorWeight: 4, tabs: [
              Tab(
                text: "Dining",
              ),
              Tab(
                text: "Delivery",
              ),
            ]),
            Expanded(
              child: TabBarView(children: [
                StreamBuilder<List<MyDiningOrderModel>>(
                  stream: getOrdersStreamFromFirestore(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<MyDiningOrderModel> diningOrders = snapshot.data ?? [];

                      return diningOrders.isNotEmpty
                          ? ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: diningOrders.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = diningOrders[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => OderDetailsScreen(
                                          myDiningOrderModel: item,
                                        ));
                                  },
                                  child: Container(
                                    height: 100,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            // offset: const Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(11)),
                                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 90,
                                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(item.restaurantInfo!.image),
                                                fit: BoxFit.cover,
                                              ),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(25)),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                item.orderId,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.normal, fontSize: 14, color: Colors.grey),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                item.orderType,
                                                style: const TextStyle(fontSize: 14, color: Color(0xff1A2E33)),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                item.restaurantInfo!.restaurantName,
                                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat("dd-mm-yy").format(DateTime.parse(
                                                  DateTime.fromMillisecondsSinceEpoch(item.time).toLocal().toString())),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal, fontSize: 12, color: Colors.grey),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '\$${item.total}',
                                              style: const TextStyle(fontSize: 17, color: Color(0xff1A2E33)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : const Center(
                              child: Text("Order Not Found"),
                            );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                StreamBuilder<List<MyOrderModel>>(
                  stream: getDeliveryOrdersStreamFromFirestore(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<MyOrderModel> users = snapshot.data ?? [];

                      return users.isNotEmpty
                          ? ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: users.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = users[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => DeliveryOderDetailsScreen(
                                          model: item,
                                        ));
                                  },
                                  child: Container(
                                    height: 100,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            // offset: const Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(11)),
                                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 90,
                                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(item.orderDetails!.restaurantInfo!.image),
                                                fit: BoxFit.cover,
                                              ),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(25)),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                item.orderId,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.normal, fontSize: 14, color: Colors.grey),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                item.orderType,
                                                style: const TextStyle(fontSize: 14, color: Color(0xff1A2E33)),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                item.orderDetails!.restaurantInfo!.restaurantName,
                                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat("dd-mm-yy").format(DateTime.parse(
                                                  DateTime.fromMillisecondsSinceEpoch(item.time).toLocal().toString())),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal, fontSize: 12, color: Colors.grey),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '\$${item.total}',
                                              style: const TextStyle(fontSize: 17, color: Color(0xff1A2E33)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : const Center(
                              child: Text("No User Found"),
                            );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ]),
            )
          ]).appPaddingForScreen,
        ));
  }

  Stream<List<MyDiningOrderModel>> getOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance.collection('dining_order').snapshots().map((querySnapshot) {
      List<MyDiningOrderModel> diningorders = [];
      print(diningorders);
      try {
        for (var doc in querySnapshot.docs) {
          diningorders.add(MyDiningOrderModel.fromJson(doc.data(), doc.id));
        }
      } catch (e) {
        print(e.toString());
        throw Exception(e.toString());
      }
      return diningorders;
    });
  }

  Stream<List<MyOrderModel>> getDeliveryOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance.collection('order').snapshots().map((querySnapshot) {
      List<MyOrderModel> orders = [];
      print(orders);
      try {
        for (var doc in querySnapshot.docs) {
          orders.add(MyOrderModel.fromJson(doc.data(), doc.id));
        }
      } catch (e) {
        print(e.toString());
        throw Exception(e.toString());
      }
      return orders;
    });
  }
}
