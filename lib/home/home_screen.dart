import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wibubarber/home/index.dart';
import 'package:wibubarber/model/schedule_model.dart';
import 'package:wibubarber/schedule/schedule_page.dart';
import 'package:wibubarber/style/style_page.dart';

import '../model/style_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required HomeBloc homeBloc,
    Key? key,
  })  : _homeBloc = homeBloc,
        super(key: key);

  final HomeBloc _homeBloc;

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextStyle whiteText = TextStyle(color: Colors.white, fontSize: 16);
  final f = NumberFormat.currency(locale: "vi", symbol: "K");
  Widget image(StyleModel? model) {
    if (model?.imageURL != null && model?.imageURL != "") {
      return FadeInImage.assetNetwork(
        image: model!.imageURL!,
        placeholder: 'lib/asset/loading-azurlane.gif',
        fit: BoxFit.fill,
      );
    }
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Image.asset(
          "lib/asset/no-photos.png",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: widget._homeBloc,
      builder: (
        BuildContext context,
        HomeState state,
      ) {
        if (state is UnHomeState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ErrorHomeState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(state.errorMessage),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    onPressed: _load,
                    child: Text('reload'),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is InHomeState) {
          if (state.model !=
              ScheduleModel(
                  barberEmail: "",
                  customerEmail: "",
                  date: "",
                  isConfirm: false,
                  time: "",
                  isCancel: false)) {
            String year = state.model!.date.substring(0, 4);
            String mouth = state.model!.date.substring(4, 6);
            String day = state.model!.date.substring(6, 8);
            return RefreshIndicator(
              onRefresh: () async {
                _load();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Wrap(
                      children: [
                        ActionChip(
                          avatar: Icon(FontAwesome5.calendar_check),
                          label: Text("Đặt lịch"),
                          onPressed: () {
                            Navigator.of(context).pushNamed(SchedulePage.routeName);
                          },
                        ),
                        SizedBox(width: 15),
                        ActionChip(
                          label: Text("Bảng giá"),
                          avatar: Icon(FontAwesome5.list_alt),
                          onPressed: () {
                            Navigator.of(context).pushNamed(StylePage.routeName);
                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: MediaQuery.of(context).size.height * 0.65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white70,
                      ),
                      child: Banner(
                        location: BannerLocation.topStart,
                        message: state.model!.isConfirm ? "Đã hoàn thành" : "Chưa hoàn thành",
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  "Lịch hẹn gần đây",
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => QRScreenSchedule(
                                          day: "$year$mouth$day",
                                          userEmail: FirebaseAuth.instance.currentUser!.email!,
                                          time: state.model!.time,
                                          color: state.model!.color ?? "",
                                          style: state.model!.style ?? "",
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(FontAwesome5.qrcode),
                                ),
                                // SizedBox(width: 10),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                SizedBox(width: 10),
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: state.barberName?.avatarURL ??
                                        "https://png2.cleanpng.com/sh/596fdbc47761d72497fc727dd8037788/L0KzQYm3VsA1N5poipH0aYP2gLBuTfNwdaF6jNd7LXnmf7B6TfF3aaVmip9Ac3X1PcH5jBZqdJYyiNd7c3BxPbF8lPxqdpYyTdQ6NXW7SYiAUsY1PGEzUagAM0O2QoS4VcI5OWc3TKcANEa7RnB3jvc=/kisspng-computer-icons-avatar-user-profile-person-outline-5b15e897726440.9653332315281624554686.png",
                                    height: 100,
                                    width: 100,
                                    placeholder: (context, url) =>
                                        Image.asset('lib/asset/loading-azurlane.gif'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    children: [
                                      AutoSizeText(
                                        "Barber: ${state.barberName?.name ?? "Không tên"}",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                      // AutoSizeText(
                                      //   "Email:${state.barberName?.email ?? "Không có"}",
                                      //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      //   maxLines: 1,
                                      // ),
                                      // AutoSizeText(
                                      //   DateFormat('dd/MM/yyyy').format(state.model!.date) + state.model!.time,
                                      //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      // )
                                      SizedBox(height: 20),
                                      AutoSizeText(
                                        "Thời gian: $day/$mouth/$year | ${state.model!.time}",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                "Dịch vụ đã chọn",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Row(
                                children: [
                                  if ((state.style?.styleName ?? "") != "")
                                    Expanded(
                                      child: Column(children: [
                                        AutoSizeText(
                                          state.style!.styleName!,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Card(
                                            semanticContainer: true,
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              side: BorderSide(width: 3, color: Colors.white),
                                            ),
                                            elevation: 4,
                                            child: image(state.style),
                                          ),
                                        ),
                                        Text(
                                          state.style!.styleName ?? "",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Giá: ${f.format(state.style!.stylePrice! / 1000)}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ]),
                                    ),
                                  if ((state.color?.name ?? "") != "")
                                    Expanded(
                                      child: Column(children: [
                                        AutoSizeText(
                                          state.color?.name ?? "",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Card(
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              side: BorderSide(width: 3, color: Colors.white),
                                            ),
                                            elevation: 4,
                                            child: Container(
                                              color: HexColor(state.color?.hex ?? ""),
                                              // width: MediaQuery.of(context).size.width * 0.4,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          state.color?.name ?? "",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Giá: ${f.format((state.color?.price ?? 0) / 1000)}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ]),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Column(
              children: [
                Wrap(
                  children: [
                    ActionChip(
                      avatar: Icon(FontAwesome5.calendar_check),
                      label: Text("Đặt lịch"),
                      onPressed: () {
                        Navigator.of(context).pushNamed(SchedulePage.routeName);
                      },
                    ),
                    SizedBox(width: 15),
                    ActionChip(
                      label: Text("Bảng giá"),
                      avatar: Icon(FontAwesome5.list_alt),
                      onPressed: () {
                        Navigator.of(context).pushNamed(StylePage.routeName);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red.withOpacity(0.6),
                      ),
                      child: Text(
                        "BẠN CHƯA ĐẶT LỊCH HẸN CẮT TÓC NÀO!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _load() {
    widget._homeBloc.add(LoadHomeEvent());
  }
}

class QRScreenSchedule extends StatelessWidget {
  final String userEmail;
  final String day;
  final String time;
  final String color;
  final String style;

  const QRScreenSchedule(
      {super.key,
      required this.day,
      required this.userEmail,
      required this.time,
      required this.color,
      required this.style});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "lib/asset/background/background.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Container(
                color: Colors.white60, child: QrImageView(data: "$userEmail,$day,$time,$color,$style")),
          ),
        ),
      ],
    );
  }
}
