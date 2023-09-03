import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:orange_shopping/screen/login.dart';
import 'package:orange_shopping/assets/apiUrl.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
                  'Registeration',
                  style: TextStyle(
                    color: Color(0xFFE5750E), // Color for the text (229, 117, 14)
                  ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Center( // Wrap the Image widget with Center
              child: Image(
                image: AssetImage('lib/images/logo.png'),
                width: 200, // Set the width to 100 pixels (adjust as needed)
                height: 200, // Set the height to 100 pixels (adjust as needed)
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Sign up',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  labelText: 'Password',
                ),
              ),
            ),
            
            Center(
              child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(90, 50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0), // Adjust the radius as needed
                  ),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Color(0xFFE5750E), // Color for the text (229, 117, 14)
                ),
              ),
              onPressed: () async {
                final String username = nameController.text;
                final String password = passwordController.text;

                try {
                  final response = await http.post(
                    Uri.parse('${apiUrl}register'), // Replace with the correct IP address
                    headers: {'Content-Type': 'application/json'}, // Specify the content type
                    body: json.encode({
                      'username': username,
                      'password': password,
                    })
                  );

                  if (response.statusCode == 200) {

                    // Registration successful, you can navigate to the login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  } else {
                    // Handle registration error
                    print('Registration failed');
                  }
                } catch (error) {
                  print('Error during registration: $error');
                }
              },
            ),

            ),
            Row(
              children: <Widget>[
                const Text('Already have an account?'),
                TextButton(
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      )
                    );
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            
          ],
        ),
      ),
    );
  }
}
