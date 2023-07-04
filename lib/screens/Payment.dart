import 'dart:convert';

import 'package:dh_course_application/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  String courseId;
  String thumbnail;
  String title;
  int price;
  PaymentScreen(
      {super.key,
      required this.courseId,
      required this.title,
      required this.thumbnail,
      required this.price});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout({String? courseId}) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('authToken');
    final response = await http.post(
      Uri.parse('https://dhcourse-server.vercel.app/api/v1/booking/$courseId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "authorization": 'Bearer $token'
      },
    );

    final responseData = jsonDecode(response.body);
    var paymentId = responseData['order']['id'];
    var options = {
      'key': 'rzp_test_PXZvFNXpJFylGx',
      'amount': widget.price * 100,
      'name': 'CPET Darul Huda',
      'order_id': paymentId,
      'description': 'Payment',
      "notes": {"orderId": paymentId},
      'prefill': {'contact': '9746229547', 'email': 'cpetdarulhuda@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e as String?);
    }
  }

  void _handlePaymentSuccess(
      PaymentSuccessResponse paymentSuccessResponse) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('authToken');
    final response = await http.post(
      Uri.parse(
          'https://dhcourse-server.vercel.app/api/v1/booking/success/booking'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "authorization": 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'course': widget.courseId,
        'razorpay_payment_id': paymentSuccessResponse.paymentId,
        'razorpay_order_id': paymentSuccessResponse.orderId,
        'razorpay_signature': paymentSuccessResponse.signature,
        'price': widget.price,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen()),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {}

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('PaymentScreen',
            style: TextStyle(fontSize: 20.0, color: Color(0xFF545D68))),
      ),
      body: ListView(children: [
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15.0),
                Image.network(widget.thumbnail, fit: BoxFit.cover),
                const SizedBox(height: 20.0),
                Column(
                  children: <Widget>[
                    Text("₹${widget.price}",
                        style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 16, 62, 62))),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color.fromARGB(255, 13, 71, 89)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        InkWell(
            onTap: () {
              openCheckout(courseId: widget.courseId);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Container(
                  width: MediaQuery.of(context).size.width - 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: const Color.fromARGB(255, 21, 90, 68)),
                  child: Center(
                      child: Text('Checkout Now ₹${widget.price}',
                          style: const TextStyle(
                              fontFamily: 'nunito',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)))),
            ))
      ]),
    );
  }
}
