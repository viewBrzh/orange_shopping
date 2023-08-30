import 'package:flutter/material.dart';
import 'dart:convert';
import 'sign_up.dart';
import 'package:http/http.dart' as http;
import 'package:orange_shopping/assets/apiUrl.dart';

class ChangePassScreen extends StatefulWidget {
  final int currentUserId;
  const ChangePassScreen({required this.currentUserId});

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  

  Future<void> changePassword(int userId, String oldPassword, String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      // Display an error message if new passwords do not match
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Change Failed'),
            content: Text('New passwords do not match. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final response = await http.post(
      Uri.parse('${apiUrl}changePassword'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId' : userId,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      // Password changed successfully
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Changed'),
            content: Text('Your password has been changed successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Display an error message if the password change fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Change Failed'),
            content: Text('Password change failed. Please check your old password and try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
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
              padding: const EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                controller: oldPasswordController, // Add controller for old password
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  labelText: 'Old Password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: newPasswordController, // Add controller for new password
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  labelText: 'New Password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: confirmPasswordController, // Add controller for confirming new password
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  labelText: 'Confirm New Password',
                ),
              ),
            ),
            SizedBox(height: 16,),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(90, 50)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Change Password',
                  style: TextStyle(
                    color: Color(0xFFE5750E),
                  ),
                ),
                onPressed: () {
                  final String oldPassword = oldPasswordController.text;
                  final String newPassword = newPasswordController.text;
                  final String confirmPassword = confirmPasswordController.text;
                  changePassword(widget.currentUserId ,oldPassword, newPassword, confirmPassword); // Call the changePassword function
                },
              ),
            ),

            Row(
              children: <Widget>[
                const Text('Does not have an account?'),
                TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp(),
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
