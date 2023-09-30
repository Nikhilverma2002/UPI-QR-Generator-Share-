import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(amount: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.amount});

  final String amount;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController amountController = TextEditingController();
  late TextEditingController upiController = TextEditingController();
  double? _lon2g;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Get Payment",
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(
                "Add the upi id details",
                style: GoogleFonts.poppins(
                    fontSize: 17, fontWeight: FontWeight.w500),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: upiController,
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    hintText: "Enter your UPI ID",
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                      child: Image.asset(
                        'assets/image/upi.png',
                        height: 27,
                        width: 27,
                      ),
                    ),
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Add the amount you want",
                style: GoogleFonts.poppins(
                    fontSize: 17, fontWeight: FontWeight.w500),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 10),
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  style: GoogleFonts.poppins(
                      fontSize: 17, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    hintText: "Enter Amount in INR",
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                      child: SvgPicture.asset(
                        'assets/image/money.svg',
                        height: 22,
                        width: 22,
                      ),
                    ),
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left : 20, top : 10, right : 20, bottom : 20),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      /*bool result = await InternetCo nnectionChecker().hasConnection;
                      if(result == true) {
                        print('net on');
                      } else {
                        MotionToast.error(
                            title:  Text("Error",style : GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w500),),
                            description:  Text("net on",style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),)
                        ).show(context);
                      }*/
                      var lon2g =
                          num.tryParse(amountController.text)?.toDouble();
                      if (amountController.text.isNotEmpty &&
                          upiController.text.isNotEmpty) {
                        if (validateUpiID(upiController.text) == true) {
                          setState(() {
                            _lon2g = lon2g;
                          });
                        } else {
                          MotionToast.error(
                              title: Text(
                                "Error",
                                style: GoogleFonts.poppins(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              description: Text(
                                "Please enter a valid UPI",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              )).show(context);
                        }
                      } else {
                        MotionToast.error(
                            title: Text(
                              "Error",
                              style: GoogleFonts.poppins(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            description: Text(
                              "Please fill all the details",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            )).show(context);
                      }
                    },
                    child: Text(
                      "Generate QR",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              if (_lon2g != null)
                // Check if lon2g is not null before displaying the QR code.
                Screenshot(
                  controller: screenshotController,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 30,horizontal: 30),
                    child: UPIPaymentQRCode(
                      upiDetails: UPIDetails(
                        upiID: upiController.text,
                        payeeName: "",
                        amount: _lon2g,
                      ),
                      size: 200,
                      //embeddedImagePath: "assets/image/paytm.png",
                      //embeddedImageSize: const Size(60, 60),
                    ),
                  ),
                ),
              if (_lon2g != null)
              ElevatedButton(
                onPressed: () {
                  screenshotController
                      .capture(delay: Duration(milliseconds: 10))
                      .then((capturedImage) async {

                    // showing the captured widget
                    // through ShowCapturedWidget
                    ShowCapturedWidget(context,
                        capturedImage!,_lon2g,upiController.text);
                  }).catchError((onError) {
                    print(onError);
                  });

                },
                child: Text(
                  "Open and Share",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

Future<void> ShowCapturedWidget(
    BuildContext context, Uint8List capturedImage, double ? amount, String upi) async {
  // Create a temporary directory
  Directory tempDir = await Directory.systemTemp.createTemp();
  String tempFilePath = '${tempDir.path}/temp_image.png';

  // Write the captured image data to a file
  await File(tempFilePath).writeAsBytes(capturedImage);

  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) => Scaffold(
      appBar: AppBar(
        title: Text("Your QR", style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.shareFiles(
                [tempFilePath],
                text: 'Send me the payment of ₹$amount to this QR code which refers to this upi id : $upi for farewell',
              );
            },
          ),
        ],
      ),
      body: Center(
        child: capturedImage != null ? Image.memory(capturedImage) : Container(),
      ),
    ),
  );
}
Object validateUpiID(String value) {
  String pattern = '[a-zA-Z0-9.-_]{2,256}@[a-zA-Z]{2,64}';
  RegExp regExp = RegExp(pattern);
  if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}
