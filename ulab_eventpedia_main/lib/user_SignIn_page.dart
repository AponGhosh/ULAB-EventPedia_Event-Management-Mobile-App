import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'userLoginScreen.dart';
import 'user_SignUp_page.dart';

class JoinAsUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;
        if (user != null) {
          DocumentSnapshot snapshot = await FirebaseFirestore.instance
              .collection('general_users')
              .doc(user.uid)
              .get();

          if (snapshot.exists) {
            Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
            if (userData != null && userData['email'] == email) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserLoginScreen()),
              );
              return;
            }
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid credentials or user not authorized.")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-in error: $e")),
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFB9E5F8),
        appBar: AppBar(
          backgroundColor: Color(0xFFB9E5F8),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(
                    'assets/user_sign_In.png',
                    height: 250,
                    width: 250,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "ULAB EventPedia",
                        style: TextStyle(
                          color: Color(0XFF05707E),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Sign In to continue your journey as a General User with us",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: double.infinity,
                    height: 500,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF46C5FB),
                          Color(0xFFb7dded),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email:",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 350,
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.alternate_email,
                                  color: Color(0XFF05707E),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Password:",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: 350,
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.key_outlined,
                                  color: Color(0XFF05707E),
                                ),
                              ),
                              obscureText: true,
                            ),
                          ),
                          SizedBox(height: 50),
                          Center(
                            child: Container(
                              width: 270,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color(0xFF53bcd4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  signInWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text,
                                    context,
                                  );
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => UserLoginScreen(),
                                  //   ),
                                  // );
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: Text(
                              "Not registered yet?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Container(
                              width: 270,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color(0xFF53bcd4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserSignUpPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Signup",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
