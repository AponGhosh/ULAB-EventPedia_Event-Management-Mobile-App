import 'package:flutter/material.dart';
import 'PaymentPage.dart';

class RegistrationFormPage extends StatefulWidget {
  final Map<String, dynamic> eventData;

  RegistrationFormPage({required this.eventData});

  @override
  _RegistrationFormPageState createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String?> _formData = {
    'name': '',
    'id': '',
    'email': '',
    'contact': '',
    'department': '',
  };

  void _handleMakePayment() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            eventData: widget.eventData,
            formData: _formData,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFB9E5F8),
        appBar: AppBar(
          title: Text('Register for Event'),
          backgroundColor: Color(0xFFB9E5F8),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(widget.eventData['imageUrl'], height: 200, fit: BoxFit.cover),
                  SizedBox(height: 20),
                  Text('Event: ${widget.eventData['title']}'),
                  Text('Date: ${widget.eventData['date']}'),
                  Text('Fee: ${widget.eventData['fee']}'),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 370,
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        fillColor: Color(0xFFdcf6fc),
                        filled: true,
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSaved: (value) => _formData['name'] = value,
                      validator: (value) => value?.isEmpty == true ? 'Please enter your name' : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 370,
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'ID',
                        fillColor: Color(0xFFdcf6fc),
                        filled: true,
                        prefixIcon: Icon(Icons.badge),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSaved: (value) => _formData['id'] = value,
                      validator: (value) => value?.isEmpty == true ? 'Please enter your ID' : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 370,
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        fillColor: Color(0xFFdcf6fc),
                        filled: true,
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSaved: (value) => _formData['email'] = value,
                      validator: (value) => value?.isEmpty == true ? 'Please enter a valid email' : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 370,
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Contact',
                        fillColor: Color(0xFFdcf6fc),
                        filled: true,
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSaved: (value) => _formData['contact'] = value,
                      validator: (value) => value?.isEmpty == true ? 'Please enter your contact number' : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 370,
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Department',
                        fillColor: Color(0xFFdcf6fc),
                        filled: true,
                        prefixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSaved: (value) => _formData['department'] = value,
                      validator: (value) => value?.isEmpty == true ? 'Please enter your department' : null,
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: _handleMakePayment,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Color(0xFF78D2E6),
                      ),
                      child: Text('Make Payment', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff274560))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
