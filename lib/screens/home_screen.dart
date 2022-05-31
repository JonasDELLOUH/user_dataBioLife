import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:user_data/services/database.dart';

import '../models/using_data.dart';

class HomeScreen extends StatefulWidget {
  final String memberKey;
 HomeScreen({Key? key, required this.memberKey}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{

  late UsingData usingData;
   String openedTime='';
  late Map<String, dynamic> map;
  DatabaseService databaseService = DatabaseService();


  @override
  void initState(){
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    print("innniiiiitttt");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    print("dispossssseeee");
  }

  late AppLifecycleState _appLifecycleState;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      _appLifecycleState = state;
    });
    if(state == AppLifecycleState.paused) {
      if (kDebugMode) {
        print('AppLifecycleState state: Paused audio playback');
        final deviceInfoPlugin = DeviceInfoPlugin();
        final deviceInfo = await deviceInfoPlugin.deviceInfo;
        map = deviceInfo.toMap();
        usingData = UsingData(DateTime.now().toString(), map, openedTime);
        databaseService.addUsing(widget.memberKey, usingData);
      }
    }
    if(state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print('AppLifecycleState state: Resumed audio playback');
        openedTime = DateTime.now().toString();
      }
    }
    if(state == AppLifecycleState.detached) {
      if (kDebugMode) {
        print('AppLifecycleState state: Detached audio playback');
      }
    }
    if (kDebugMode) {
      print('AppLifecycleState state:  $state');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        key: UniqueKey(),
        child: Center(
          child: CircularParticle(
            // key: UniqueKey(),
            awayRadius: 80,
            numberOfParticles: 200,
            speedOfParticles: 1,
            height: screenHeight,
            width: screenWidth,
            onTapAnimation: true,
            particleColor: Colors.white.withAlpha(150),
            awayAnimationDuration: Duration(milliseconds: 600),
            maxParticleSize: 8,
            isRandSize: true,
            isRandomColor: true,
            randColorList: [
              Colors.red.withAlpha(210),
              Colors.white.withAlpha(210),
              Colors.yellow.withAlpha(210),
              Colors.green.withAlpha(210)
            ],
            awayAnimationCurve: Curves.easeInOutBack,
            enableHover: true,
            hoverColor: Colors.white,
            hoverRadius: 90,
            connectDots: true, //not recommended
          ),
        ),
      ),
    );
  }
}