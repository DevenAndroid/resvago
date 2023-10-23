import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
 leading: Column(
   children: [
     const Text(
       'Resvago Admin App',
       style: TextStyle(color: Colors.black),
     ),
     const Text(
       'Resvago Admin App',
       style: TextStyle(color: Colors.black),
     ),
   ],
 ),leadingWidth: 200,
          title:
              const Text(
                '',
                style: TextStyle(color: Colors.black),
              ),


          backgroundColor:  Colors.white,
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResturentDataScreen(
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
                title: const Text('Add Vendor Category'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MenuItemListScreen(collectionReference: FirebaseFirestore.instance.collection("vendorCategory"),key: ValueKey(DateTime.now().millisecondsSinceEpoch),)));
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

            const TabBar(
                labelColor: Color(0xFF454B5C),

                indicatorColor: Color(0xFF3B5998),
                indicatorWeight: 4,
                tabs: [
                  Tab(text: "Dining Orders",),
                  Tab(text: "Delivery Orders",),
                ]),
            Expanded(
              child: TabBarView(children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order No.", style: GoogleFonts.poppins(
                                color: const Color(0xFF3B5998),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            const SizedBox(width: 1,),
                            Text("Status", style: GoogleFonts.poppins(
                                color: const Color(0xFF3B5998),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("Earning", style: GoogleFonts.poppins(
                                color: const Color(0xFF3B5998),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,),
                        InkWell(
                          onTap: (){

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("#1234", style: GoogleFonts.poppins(
                                      color: const Color(0xFF454B5C),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),),
                                  Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                      color: const Color(0xFF8C9BB2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11),),
                                ],
                              ),
                              Text("Processing", style: GoogleFonts.poppins(
                                  color: const Color(0xFFFFB26B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                              Text("\$450.00", style: GoogleFonts.poppins(
                                  color: const Color(0xFF454B5C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#1234", style: GoogleFonts.poppins(
                                    color: const Color(0xFF454B5C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),),
                                Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                    color: const Color(0xFF8C9BB2),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),),
                              ],
                            ),
                            Text("Completed", style: GoogleFonts.poppins(
                                color: const Color(0xFF65CD90),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("\$450.00", style: GoogleFonts.poppins(
                                color: const Color(0xFF454B5C),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#1234", style: GoogleFonts.poppins(
                                    color: const Color(0xFF454B5C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),),
                                Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                    color: const Color(0xFF8C9BB2),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),),
                              ],
                            ),
                            Text("Reject", style: GoogleFonts.poppins(
                                color: const Color(0xFFFF557E),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("\$450.00", style: GoogleFonts.poppins(
                                color: const Color(0xFF454B5C),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#1234", style: GoogleFonts.poppins(
                                    color: const Color(0xFF454B5C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),),
                                Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                    color: const Color(0xFF8C9BB2),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),),
                              ],
                            ),
                            Text("Processing", style: GoogleFonts.poppins(
                                color: const Color(0xFFFFB26B),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("\$450.00", style: GoogleFonts.poppins(
                                color: const Color(0xFF454B5C),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#1234", style: GoogleFonts.poppins(
                                    color: const Color(0xFF454B5C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),),
                                Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                    color: const Color(0xFF8C9BB2),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),),
                              ],
                            ),
                            Text("Processing", style: GoogleFonts.poppins(
                                color: const Color(0xFFFFB26B),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("\$450.00", style: GoogleFonts.poppins(
                                color: const Color(0xFF454B5C),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,), Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#1234", style: GoogleFonts.poppins(
                                    color: const Color(0xFF454B5C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),),
                                Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                    color: const Color(0xFF8C9BB2),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),),
                              ],
                            ),
                            Text("Processing", style: GoogleFonts.poppins(
                                color: const Color(0xFFFFB26B),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("\$450.00", style: GoogleFonts.poppins(
                                color: const Color(0xFF454B5C),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 40,),



                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order No.", style: GoogleFonts.poppins(
                                color: const Color(0xFF3B5998),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            const SizedBox(width: 1,),
                            Text("Status", style: GoogleFonts.poppins(
                                color: const Color(0xFF3B5998),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("Earning", style: GoogleFonts.poppins(
                                color: const Color(0xFF3B5998),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,),
                        InkWell(
                          onTap:(){

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("#1234", style: GoogleFonts.poppins(
                                      color: const Color(0xFF454B5C),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),),
                                  Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                      color: const Color(0xFF8C9BB2),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11),),
                                ],
                              ),
                              Text("Processing", style: GoogleFonts.poppins(
                                  color: const Color(0xFFFFB26B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                              Text("\$450.00", style: GoogleFonts.poppins(
                                  color: const Color(0xFF454B5C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#1234", style: GoogleFonts.poppins(
                                    color: const Color(0xFF454B5C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),),
                                Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                    color: const Color(0xFF8C9BB2),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),),
                              ],
                            ),
                            Text("Completed", style: GoogleFonts.poppins(
                                color: const Color(0xFF65CD90),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("\$450.00", style: GoogleFonts.poppins(
                                color: const Color(0xFF454B5C),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#1234", style: GoogleFonts.poppins(
                                    color: const Color(0xFF454B5C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),),
                                Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                    color: const Color(0xFF8C9BB2),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),),
                              ],
                            ),
                            Text("Reject", style: GoogleFonts.poppins(
                                color: const Color(0xFFFF557E),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("\$450.00", style: GoogleFonts.poppins(
                                color: const Color(0xFF454B5C),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#1234", style: GoogleFonts.poppins(
                                    color: const Color(0xFF454B5C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),),
                                Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                    color: const Color(0xFF8C9BB2),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),),
                              ],
                            ),
                            Text("Processing", style: GoogleFonts.poppins(
                                color: const Color(0xFFFFB26B),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("\$450.00", style: GoogleFonts.poppins(
                                color: const Color(0xFF454B5C),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#1234", style: GoogleFonts.poppins(
                                    color: const Color(0xFF454B5C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),),
                                Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                    color: const Color(0xFF8C9BB2),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),),
                              ],
                            ),
                            Text("Processing", style: GoogleFonts.poppins(
                                color: const Color(0xFFFFB26B),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("\$450.00", style: GoogleFonts.poppins(
                                color: const Color(0xFF454B5C),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 10,), Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("#1234", style: GoogleFonts.poppins(
                                    color: const Color(0xFF454B5C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),),
                                Text("2 June, 2021 - 11:57PM", style: GoogleFonts.poppins(
                                    color: const Color(0xFF8C9BB2),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),),
                              ],
                            ),
                            Text("Processing", style: GoogleFonts.poppins(
                                color: const Color(0xFFFFB26B),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                            Text("\$450.00", style: GoogleFonts.poppins(
                                color: const Color(0xFF454B5C),
                                fontWeight: FontWeight.w600,
                                fontSize: 12),),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        const SizedBox(height: 40,),



                      ],
                    ),
                  ),
                ),



              ]),
            )
          ]),
        ));
  }
}
