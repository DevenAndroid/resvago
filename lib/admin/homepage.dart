import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago/admin/Couponlist_Screen.dart';
import 'package:resvago/admin/Pageslist_screen.dart';
import 'package:resvago/admin/addCustomer_user.dart';
import 'package:resvago/admin/dining_order_list.dart';
import 'package:resvago/admin/loginscreen.dart';
import 'package:resvago/admin/order_list_screen.dart';
import 'package:resvago/admin/setting_screen.dart';
import 'package:resvago/admin/vendor_datalist.dart';
import 'package:resvago/admin/slider_images.dart';
import 'package:resvago/admin/userdata_screen.dart';
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

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
               scaffoldKey.currentState!.openDrawer();
            },
              child: Icon(Icons.menu)),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi Demo Admin..',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              Text(
                'admin@gmail.com',
                style: TextStyle(color: Colors.black, fontSize: 12),
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
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        minRadius: 35,
                        maxRadius: 40,
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
                                collectionReference: FirebaseFirestore.instance
                                    .collection("resturent"),
                                key: ValueKey(
                                    DateTime.now().millisecondsSinceEpoch),
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
                                collectionReference: FirebaseFirestore.instance
                                    .collection("menuItemsList"),
                                key: ValueKey(
                                    DateTime.now().millisecondsSinceEpoch),
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
                  Get.to(const settingScreen(isEditMode: false,));
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
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(const LogInScreen());
                },
              ),
            ],
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: Padding(
            padding: kIsWeb ? const EdgeInsets.only(left: 250,right: 250) : EdgeInsets.zero,
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
                    decoration: BoxDecoration(
                        color: Color(0xff1AB0B0),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${1000}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white),
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
                    decoration: BoxDecoration(
                        color: Color(0xffFF7443),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '120',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white),
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
                    decoration: BoxDecoration(
                        color: Color(0xffF65579),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${500}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white),
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
                    decoration: BoxDecoration(
                        color: Color(0xff8676FE),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${132}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white),
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
              const TabBar(
                  labelColor: Color(0xFF454B5C),
                  indicatorColor: Color(0xFF3B5998),
                  indicatorWeight: 4,
                  tabs: [
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
                            child:
                                CircularProgressIndicator()); // Show a loading indicator while data is being fetched
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<MyDiningOrderModel> diningOrders =
                            snapshot.data ?? [];

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
                                      height: 120,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(11)),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 110,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      item.restaurantInfo!.image),
                                                  fit: BoxFit.cover,
                                                ),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  item.orderId,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  item.orderType,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff1A2E33)),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  item.restaurantInfo!
                                                      .restaurantName,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                DateFormat("dd-mm-yy").format(
                                                    DateTime.parse(DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                                item.time)
                                                        .toLocal()
                                                        .toString())),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '\$${item.total}',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Color(0xff1A2E33)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 10,),
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
                  StreamBuilder<List<MyOrderModel>>(
                    stream: getDeliveryOrdersStreamFromFirestore(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Show a loading indicator while data is being fetched
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
                                      height: 120,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(11)),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 110,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(item
                                                      .orderDetails!
                                                      .restaurantInfo!
                                                      .image),
                                                  fit: BoxFit.cover,
                                                ),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  item.orderId,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  item.orderType,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff1A2E33)),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  item
                                                      .orderDetails!
                                                      .restaurantInfo!
                                                      .restaurantName,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                DateFormat("dd-mm-yy").format(
                                                    DateTime.parse(DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                                item.time)
                                                        .toLocal()
                                                        .toString())),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '\$${item.total}',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Color(0xff1A2E33)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 10,)
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
            ]),
          ),
        ));
  }

  Stream<List<MyDiningOrderModel>> getOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('dining_order')
        .snapshots()
        .map((querySnapshot) {
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
    return FirebaseFirestore.instance
        .collection('order')
        .snapshots()
        .map((querySnapshot) {
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
