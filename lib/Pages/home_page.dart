// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ruang_temu_apps/Models/aspirasi.dart';
import 'package:ruang_temu_apps/Models/news.dart';
import 'package:ruang_temu_apps/Pages/Features/Edukasi/ruang_edukasi.dart';
import 'package:ruang_temu_apps/StateController/user_controller.dart';
import 'package:ruang_temu_apps/Widgets/aspirasi_card.dart';
import 'package:ruang_temu_apps/Widgets/custom_scroll.dart';
import 'package:ruang_temu_apps/Widgets/navbar.dart';
import 'package:ruang_temu_apps/env.dart';
import 'package:ruang_temu_apps/http_client.dart';
import 'package:ruang_temu_apps/themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String mainCategory = 'main-category';

  List<News> _news = [];
  List<Aspirasi> _aspirasi = [];
  void _firstLoad() async {
    try {
      httpClient.get("$baseAPIUrl/").then((value) async {
        var data = jsonDecode(value.body);
        String _mainCategory = data['main-category'];
        List<News> news = [];
        final res = await httpClient
            .get("$baseAPIUrl/news?page=1&limit=5t&category=$_mainCategory");
        if (res.statusCode == 200) {
          setState(() {
            Map<String, dynamic> m = json.decode(res.body);

            Iterable l = m['data'];
            news.addAll(
                List<News>.from(l.map((model) => News.fromJson(model))));
          });
        } else {
          throw Exception('Failed to load news on first');
        }
        setState(() {
          mainCategory = _mainCategory;
          _news = news;
        });
      });
      // ignore: empty_catches
    } catch (e) {}

    try {
      httpClient.get("$baseAPIUrl/").then((value) async {
        List<Aspirasi> aspirasi = [];
        final response =
            await httpClient.get("$baseAPIUrl/aspirations?page=1&limit=5");

        if (response.statusCode == 200) {
          // print(response.body);
          setState(() {
            Map<String, dynamic> m = json.decode(response.body);

            Iterable l = m['data'];
            aspirasi.addAll(List<Aspirasi>.from(
                l.map((model) => Aspirasi.fromJson(model))));
          });
        } else {
          throw Exception('Failed to load news on first');
        }
        setState(() {
          _aspirasi = aspirasi;
          print(_aspirasi);
        });
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();

    double deviceWidth = MediaQuery.of(context).size.width;
    // double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Navbar(page: 0),
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              child: userController.user.value.avatar == null
                  ? CircleAvatar(
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/images/img_male_avatar.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : CircleAvatar(
                      backgroundImage:
                          NetworkImage('${userController.user.value.avatar}'),
                      backgroundColor: yellowColor,
                    ),
              onTap: () {
                Navigator.pushNamed(context, '/settingsPage');
              },
            ),
            SizedBox(
              width: 10.w,
            ),
            Obx(
              () => SizedBox(
                width: deviceWidth - 90.w,
                child: Text(
                  'Hi, ${userController.user.value.name}',
                  style: heading1MediumTextStyle.copyWith(
                    color: blueColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // ElevatedButton.icon(
            //     onPressed: () {},
            //     icon: const Icon(Icons.help),
            //     label: const Text("Debug")),
          ],
        ),
      ),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: CustomScroll(),
            child: ListView(
              children: [
                const SizedBox(
                  height: 110,
                ),

                //NOTE:Fitur Unggulan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text(
                        'Fitur Unggulan',
                        style: heading2TextStyle.copyWith(
                          color: blueColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 120.h,
                      child: ScrollConfiguration(
                        behavior: CustomScroll(),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            FiturUnggulanCard(
                              id: '/halouny',
                              title: 'Halo UNY!',
                              imgSrc: 'assets/images/img_ill_halouny.png',
                            ),
                            // FiturUnggulanCard(
                            //   id: '/akademik',
                            //   title: 'Ruang\nAkademik',
                            //   imgSrc: 'assets/images/img_ill_akademik.png',
                            // ),
                            FiturUnggulanCard(
                              id: '/aspirasi',
                              title: 'Ruang\nAspirasi',
                              imgSrc: 'assets/images/img_ill_aspirasi.png',
                            ),
                            FiturUnggulanCard(
                              // id: '/info',
                              // id: '/gallery_view',
                              id: '/infoArticle',
                              title: 'Ruang\nInfo',
                              imgSrc: 'assets/images/img_ill_info.png',
                            ),
                            FiturUnggulanCard(
                              id: '/edukasi',
                              title: 'Ruang\nEdukasi',
                              imgSrc: 'assets/images/img_ill_edukasi.png',
                            ),
                            FiturUnggulanCard(
                              // id: '/lapak',
                              id: '/lapakSoon',
                              title: 'Ruang\nLapak',
                              imgSrc: 'assets/images/img_ill_lapak.png',
                            ),
                            FiturUnggulanCard(
                              id: '/survey',
                              title: 'Ruang\nSurvey',
                              imgSrc: 'assets/images/img_ill_survey.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),

                //NOTE:Seputar Kampus
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            mainCategory,
                            style: heading2TextStyle.copyWith(
                              color: blueColor,
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed('/edukasi',
                                      arguments: RuangEdukasiArgs(
                                          defaultCategory: mainCategory));
                                },
                                child: Text(
                                  'Lihat Semua',
                                  style: heading3TextStyle.copyWith(
                                    color: blueColor,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 150.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          ..._news.map((e) => EdukasiCard(
                              contentType: e.contentType,
                              content: e.content,
                              imageSrc: e.image,
                              title: e.title)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),

                //Aspirasi
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Aspirasi',
                            style: heading2TextStyle.copyWith(
                              color: blueColor,
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    '/aspirasiPage',
                                  );
                                },
                                child: Text(
                                  'Lihat Semua',
                                  style: heading3TextStyle.copyWith(
                                    color: blueColor,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 180.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          ..._aspirasi.map(
                            (e) => Container(
                              margin: EdgeInsets.only(right: 24.w),
                              child: AspirasiCard(
                                id: e.id,
                                imgSrc: e.user['avatar'],
                                name: e.user['name'],
                                content: e.message,
                                commentCount: e.aspirationCommentsCount,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                //NOTE:Belanja yuukk
                // Column(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(
                //         left: 20,
                //       ),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'Belanja Yukk',
                //             style: heading2TextStyle.copyWith(
                //               color: blueColor,
                //             ),
                //           ),
                //           Row(
                //             children: [
                //               Text(
                //                 'Lihat Semua',
                //                 style: heading3TextStyle.copyWith(
                //                   color: blueColor,
                //                 ),
                //               ),
                //               const SizedBox(
                //                 width: 20,
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //     const SizedBox(
                //       height: 10,
                //     ),
                //     Container(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 20,
                //       ),
                //       child: GridView.count(
                //         crossAxisCount: 2,
                //         physics: const NeverScrollableScrollPhysics(),
                //         shrinkWrap: true,
                //         childAspectRatio: 8 / 5,
                //         crossAxisSpacing: 20,
                //         mainAxisSpacing: 20,
                //         children: [
                //           ProductCard(
                //             title: 'Jus Sehat',
                //             subtitle: 'Toko Jus',
                //             imgSrc: 'assets/images/img_produk_1.png',
                //           ),
                //           ProductCard(
                //             title: 'Kopi',
                //             subtitle: 'Toko Kopi',
                //             imgSrc: 'assets/images/img_produk_2.png',
                //           ),
                //           ProductCard(
                //             title: 'Daging Domba',
                //             subtitle: 'Jagal Domba',
                //             imgSrc: 'assets/images/img_produk_3.png',
                //           ),
                //           ProductCard(
                //             title: 'Mobil',
                //             subtitle: 'Showroom',
                //             imgSrc: 'assets/images/img_produk_4.png',
                //           ),
                //           ProductCard(
                //             title: 'Pot Hias',
                //             subtitle: 'Petani Bunga',
                //             imgSrc: 'assets/images/img_produk_5.png',
                //           ),
                //           ProductCard(
                //             title: 'Pizza',
                //             subtitle: 'Toko Italy',
                //             imgSrc: 'assets/images/img_produk_6.png',
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(
                //       height: 100.h,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          //NOTE : Expanded Appbar and Searchbar
          ExpandedAppbar(deviceWidth: deviceWidth),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  ProductCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imgSrc,
  }) : super(key: key);
  String title;
  String subtitle;
  String imgSrc;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: blueColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 65.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
              ),
              image: DecorationImage(
                image: AssetImage(imgSrc),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 85.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: heading3TextStyle.copyWith(
                    color: yellowColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: heading4TextStyle.copyWith(
                    color: whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FiturUnggulanCard extends StatelessWidget {
  FiturUnggulanCard({
    Key? key,
    required this.id,
    required this.title,
    required this.imgSrc,
  }) : super(key: key);
  String id;
  String title;
  String imgSrc;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: (() {
            Get.toNamed(id);
          }),
          child: AspectRatio(
            aspectRatio: 0.75,
            child: Container(
              decoration: BoxDecoration(
                color: yellowColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    height: 80.h,
                    child: Hero(
                      tag: imgSrc,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                          image: DecorationImage(
                            alignment: Alignment.bottomCenter,
                            image: AssetImage(imgSrc),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        title,
                        style: heading2TextStyle.copyWith(
                          color: whiteColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20.w,
        ),
      ],
    );
  }
}

class ExpandedAppbar extends StatelessWidget {
  const ExpandedAppbar({
    Key? key,
    required this.deviceWidth,
  }) : super(key: key);

  final double deviceWidth;

  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();

    return Container(
      width: deviceWidth,
      height: 85,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            width: 340.w,
            height: 50,
            decoration: BoxDecoration(
              color: blueColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: _searchController,
              style: heading1MediumTextStyle.copyWith(
                color: whiteColor,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: heading1MediumTextStyle.copyWith(
                  color: whiteColor,
                ),
                hintText: 'Coba "Beasiswa"',
                suffixIcon: GestureDetector(
                  onTap: () {
                    if (_searchController.text.isNotEmpty) {
                      Get.toNamed('/edukasi',
                          arguments: RuangEdukasiArgs(
                              defaultSearch: _searchController.text));
                    } else {
                      Get.snackbar("Error", "Masukkan kata kunci");
                    }
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/icon_search.png'),
                      ),
                    ),
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
