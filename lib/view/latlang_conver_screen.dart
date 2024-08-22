import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LatlangConverScreen extends StatefulWidget {
  const LatlangConverScreen({super.key});

  @override
  State<LatlangConverScreen> createState() => _LatlangConverScreenState();
}

class _LatlangConverScreenState extends State<LatlangConverScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Text(output),

          GestureDetector(
            onTap: () async{
              List<Placemark> placemarks = await placemarkFromCoordinates(52.2165157, 6.9437819);
              var address = placemarks.first;
              setState(() {
                output=address.name.toString() +","+ address.administrativeArea.toString() + ","+address.country.toString() +","+address.street.toString()
                + ","+ address.locality.toString();
              });



            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                width: width,
                height: 50,
                color: Colors.orange,
                child: Text("Convert"),
              ),
            ),
          )

        ],
      ),
    );
  }

  String output='';

  void getLocation () async{
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    output="$position";
    print("hh");
  }
}

// echo "# flutter_map_app" >> README.md
// git init
// git add README.md
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/Shahporan73/flutter_map_app.git
// git push -u origin main