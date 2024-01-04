import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:resvago/components/helper.dart';

import 'model/deliveryOrder_details_screen.dart';
import 'model/delivery_order_details_modal.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            'Delivery Order List',
            style: TextStyle(color: Color(0xff423E5E),fontWeight: FontWeight.bold),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: SvgPicture.asset('assets/images/arrowback.svg')),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                });
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.filter_list,
                  size: 30,
                  color: Color(0xff3B5998),
                ),
              ),
            ),
          ],
        ),
      body: DefaultTabController(
        length: 4,
        child: Column(children: [
          const TabBar(
              labelColor: Color(0xFF454B5C),
              indicatorColor: Color(0xFF3B5998),
              indicatorWeight: 4,
              isScrollable: true,
              tabs: [
                Tab(
                  text: "Active",
                ),
                Tab(
                  text: "Completed",
                ),
                Tab(
                  text: "Due",
                ),
                Tab(
                  text: "Cancelled",
                ),

              ]),
          Expanded(
            child: TabBarView(children: [
              StreamBuilder<List<MyOrderModel>>(
                stream: getOrdersStreamFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
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
                        onTap: (){
                          Get.to(()=> DeliveryOderDetailsScreen(model: item,));
                        },
                        child: Container(
                          height: 120,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(11),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
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
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: Colors.grey),
                                    ),
                                    const SizedBox(height: 3,),
                                     Text(
                                      item.orderType,
                                      style: const TextStyle(
                                          fontSize: 14, color: Color(0xff1A2E33)),
                                    ),
                                    const SizedBox(height: 3,),
                                     Text(
                                      item.orderDetails!.restaurantInfo!.restaurantName,
                                      style:
                                      const TextStyle(fontSize: 12, color: Colors.grey),
                                    )
                                  ],
                                                               ),
                               ),
                              const SizedBox(width: 5,),
                               Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(DateFormat("dd-mm-yy").format(
                                      DateTime.parse(DateTime.fromMillisecondsSinceEpoch(item.time).toLocal().toString())),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(
                                    '\$${item.total}',
                                    style: const TextStyle(
                                        fontSize: 17, color: Color(0xff1A2E33)),
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

              StreamBuilder<List<MyOrderModel>>(
                stream: getCompletedOrdersStreamFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
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
                            onTap: (){
                              Get.to(()=> DeliveryOderDetailsScreen(model: item,));
                            },
                            child: Container(
                              height: 120,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(11),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
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
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: Colors.grey),
                                        ),
                                        const SizedBox(height: 3,),
                                        Text(
                                          item.orderType,
                                          style: const TextStyle(
                                              fontSize: 14, color: Color(0xff1A2E33)),
                                        ),
                                        const SizedBox(height: 3,),
                                        Text(
                                          item.orderDetails!.restaurantInfo!.restaurantName,
                                          style:
                                          const TextStyle(fontSize: 12, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(DateFormat("dd-mm-yy").format(
                                          DateTime.parse(DateTime.fromMillisecondsSinceEpoch(item.time).toLocal().toString())),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(
                                        '\$${item.total}',
                                        style: const TextStyle(
                                            fontSize: 17, color: Color(0xff1A2E33)),
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

              StreamBuilder<List<MyOrderModel>>(
                stream: getDueOrdersStreamFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
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
                            onTap: (){
                              Get.to(()=> DeliveryOderDetailsScreen(model: item,));
                            },
                            child: Container(
                              height: 120,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(11),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
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
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: Colors.grey),
                                        ),
                                        const SizedBox(height: 3,),
                                        Text(
                                          item.orderType,
                                          style: const TextStyle(
                                              fontSize: 14, color: Color(0xff1A2E33)),
                                        ),
                                        const SizedBox(height: 3,),
                                        Text(
                                          item.orderDetails!.restaurantInfo!.restaurantName,
                                          style:
                                          const TextStyle(fontSize: 12, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(DateFormat("dd-mm-yy").format(
                                          DateTime.parse(DateTime.fromMillisecondsSinceEpoch(item.time).toLocal().toString())),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(
                                        '\$${item.total}',
                                        style: const TextStyle(
                                            fontSize: 17, color: Color(0xff1A2E33)),
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

              StreamBuilder<List<MyOrderModel>>(
                stream: getCancelledOrdersStreamFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator()); // Show a loading indicator while data is being fetched
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
                            onTap: (){
                              Get.to(()=> DeliveryOderDetailsScreen(model: item,));
                            },
                            child: Container(
                              height: 120,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(11),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
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
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: Colors.grey),
                                        ),
                                        const SizedBox(height: 3,),
                                        Text(
                                          item.orderType,
                                          style: const TextStyle(
                                              fontSize: 14, color: Color(0xff1A2E33)),
                                        ),
                                        const SizedBox(height: 3,),
                                        Text(
                                          item.orderDetails!.restaurantInfo!.restaurantName,
                                          style:
                                          const TextStyle(fontSize: 12, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(DateFormat("dd-mm-yy").format(
                                          DateTime.parse(DateTime.fromMillisecondsSinceEpoch(item.time).toLocal().toString())),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(
                                        '\$${item.total}',
                                        style: const TextStyle(
                                            fontSize: 17, color: Color(0xff1A2E33)),
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
        ]).appPaddingForScreen
      ));
  }
  Stream<List<MyOrderModel>> getOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('order')
    .where('order_status', isEqualTo: 'Place Order')
        .snapshots()
        .map((querySnapshot) {
      List<MyOrderModel> orders = [];
      print(orders);
      try {
        for (var doc in querySnapshot.docs) {
          orders.add(MyOrderModel.fromJson(doc.data(),doc.id));
        }
      } catch (e) {
        print(e.toString());
        throw Exception(e.toString());
      }
      return orders;
    });
  }
  Stream<List<MyOrderModel>> getCompletedOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('order')
        .where('order_status', isEqualTo: 'Order Completed')
        .snapshots()
        .map((querySnapshot) {
      List<MyOrderModel> orders = [];
      print(orders);
      try {
        for (var doc in querySnapshot.docs) {
          orders.add(MyOrderModel.fromJson(doc.data(),doc.id));
        }
      } catch (e) {
        print(e.toString());
        throw Exception(e.toString());
      }
      return orders;
    });
  }
  Stream<List<MyOrderModel>> getDueOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('order')
        .where('order_status', isEqualTo: 'Order Accepted')
        .snapshots()
        .map((querySnapshot) {
      List<MyOrderModel> orders = [];
      print(orders);
      try {
        for (var doc in querySnapshot.docs) {
          orders.add(MyOrderModel.fromJson(doc.data(),doc.id));
        }
      } catch (e) {
        print(e.toString());
        throw Exception(e.toString());
      }
      return orders;
    });
  }
  Stream<List<MyOrderModel>> getCancelledOrdersStreamFromFirestore() {
    return FirebaseFirestore.instance
        .collection('order')
        .where('order_status', isEqualTo: 'Order Rejected')
        .snapshots()
        .map((querySnapshot) {
      List<MyOrderModel> orders = [];
      print(orders);
      try {
        for (var doc in querySnapshot.docs) {
          orders.add(MyOrderModel.fromJson(doc.data(),doc.id));
        }
      } catch (e) {
        print(e.toString());
        throw Exception(e.toString());
      }
      return orders;
    });
  }
}
