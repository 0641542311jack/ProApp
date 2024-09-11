import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StarRatingPopup extends StatefulWidget {
  final String bookingId; // Pass the booking ID to identify the booking
  StarRatingPopup({required this.bookingId});

  @override
  _StarRatingPopupState createState() => _StarRatingPopupState();
}

class _StarRatingPopupState extends State<StarRatingPopup> {
  final _firestore = FirebaseFirestore.instance;
  double _rating = 0.0;

  void _submitRating() async {
    await _firestore.collection('ratings').add({
      'bookingId': widget.bookingId, // Save the booking ID
      'rating': _rating,
      'timestamp': FieldValue.serverTimestamp(),
    });
    Navigator.of(context).pop(); // Close the dialog after submitting
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate This Booking'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            itemSize: 40,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          SizedBox(height: 20),
          Text(
            'Rating: $_rating',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitRating,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
