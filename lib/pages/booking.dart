import 'package:barberapp/services/database.dart';
import 'package:barberapp/services/shared_pref.dart';
import 'package:flutter/material.dart';

class Booking extends StatefulWidget {
  String service;
  Booking({required this.service});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? name, image, email;

  getthedatafromsharedpref() async {
    name = await SharedpreferenceHelper().getUserName();
    image = await SharedpreferenceHelper().getUserImage();
    email = await SharedpreferenceHelper().getUserEmail();
    setState(() {});
  }

  getontheload() async {
    await getthedatafromsharedpref();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2024),
        lastDate: DateTime(2025));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 4, 37, 72),
      body: Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            SizedBox(
              height: 1,
            ),
            Text(
              "เลือกการจองของคุณ",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "images/bbshop.png",
                  fit: BoxFit.cover,
                )),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.service,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(top: 2, bottom: 2),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 50, 83, 125),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6), // สีของเงา
                      spreadRadius: 5, // การกระจายของเงา
                      blurRadius: 20, // การเบลอของเงา
                      offset: Offset(0, 3), // ตำแหน่งของเงา
                    )
                  ]),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
                    "Set a Date",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.only(top: 2, bottom: 2),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 50, 83, 125),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6), // สีของเงา
                      spreadRadius: 5, // การกระจายของเงา
                      blurRadius: 20, // การเบลอของเงา
                      offset: Offset(0, 3), // ตำแหน่งของเงา
                    )
                  ]),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text(
                    "Set a Time",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Icon(
                          Icons.alarm,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        _selectedTime.format(context),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () async {
                Map<String, dynamic> userBookingmap = {
                  "Service": widget.service,
                  "Date":
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"
                          .toString(),
                  "Time": _selectedTime.format(context).toString(),
                  "Username": name,
                  "Image": image,
                  "Email": email,
                };
                await DatabaseMethods()
                    .addUserBooking(userBookingmap)
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    "บริการจองสำเร็จแล้ว",
                    style: TextStyle(fontSize: 20),
                  )));
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                    color: Color(0xFFfe8f33),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6), // สีของเงา
                        spreadRadius: 5, // การกระจายของเงา
                        blurRadius: 20, // การเบลอของเงา
                        offset: Offset(0, 3), // ตำแหน่งของเงา
                      )
                    ]),
                child: Center(
                  child: Text(
                    "ยืนยัน",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
