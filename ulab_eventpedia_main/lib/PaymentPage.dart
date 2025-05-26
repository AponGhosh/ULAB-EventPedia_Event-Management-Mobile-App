import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_Registrations_Provider.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final Map<String, String?> formData;

  PaymentPage({required this.eventData, required this.formData});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;

  void _handlePaymentMethodChange(String? method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  Future<void> _submitRegistration() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please choose a payment method')),
      );
      return;
    }

    final registrationData = {
      ...widget.formData,
      'eventID': widget.eventData['docID'],
      'eventTitle': widget.eventData['title'],
      'eventDate': widget.eventData['date'],
      'eventFee': widget.eventData['fee'],
      'eventImage': widget.eventData['imageUrl'],
      'paymentMethod': _selectedPaymentMethod,
    };

    // Add the registration to the Firestore database
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventData['docID'])
        .collection('registrations')
        .add(registrationData);

    // Add the registration to the provider for notifications
    Provider.of<UserRegistrationsProvider>(context, listen: false).addRegistration(registrationData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration submitted successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for ${widget.eventData['title']}'),
        backgroundColor: Color(0xFFB9E5F8),
      ),
      backgroundColor: Color(0xFFB9E5F8),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(widget.eventData['imageUrl'], height: 200, fit: BoxFit.cover),
            ),
            SizedBox(height: 20),
            Text('Event: ${widget.eventData['title']}'),
            Text('Date: ${widget.eventData['date']}'),
            Text('Fee: ${widget.eventData['fee']}'),
            SizedBox(height: 20),
            Text('Choose payment method:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            ListTile(
              title: Text('Card', style: TextStyle(fontSize: 20)),
              leading: Image.asset('assets/card.png', width: 32, height: 32),
              trailing: Radio(
                value: 'cash',
                groupValue: _selectedPaymentMethod,
                onChanged: _handlePaymentMethodChange,
              ),
            ),
            ListTile(
              title: Text('bKash', style: TextStyle(fontSize: 20)),
              leading: Image.asset('assets/bkash.png', width: 32, height: 32),
              trailing: Radio(
                value: 'bkash',
                groupValue: _selectedPaymentMethod,
                onChanged: _handlePaymentMethodChange,
              ),
            ),
            ListTile(
              title: Text('Nagad', style: TextStyle(fontSize: 20)),
              leading: Image.asset('assets/nogod.png', width: 32, height: 32),
              trailing: Radio(
                value: 'nagad',
                groupValue: _selectedPaymentMethod,
                onChanged: _handlePaymentMethodChange,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitRegistration,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Color(0xFF78D2E6),
                ),
                child: Text('Submit', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xff274560))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
