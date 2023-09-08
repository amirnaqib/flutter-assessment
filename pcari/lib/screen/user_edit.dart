import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pcari/conf/app_theme.dart';
import 'package:pcari/dto/userDetailsDto.dart';
import 'package:http/http.dart' as http;

class UserEdit extends StatefulWidget {
  const UserEdit({super.key, required this.id});
  final int id;

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  userDetailsDto userdetails = userDetailsDto();

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();

  init() async {
    await getUserDetails();
    getUserDetails().then((response) {
      setState(() {
        firstname.text = userdetails.firstName.toString();
        lastname.text = userdetails.lastName.toString();
        email.text = userdetails.email.toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<userDetailsDto> getUserDetails() async {
    var res =
        await http.get(Uri.parse("https://reqres.in/api/users/${widget.id}"));
    if (res.statusCode == 200) {
      setState(() {
        userdetails = userDetailsDto.fromJson(jsonDecode(res.body)['data']);
      });

      return userDetailsDto.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  saveDetails(id) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: ApplicationTheme.primaryColor,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: ApplicationTheme.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Stack(children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage:
                        NetworkImage(userdetails.avatar.toString()),
                    backgroundColor: Colors.transparent,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: ApplicationTheme.primaryColor,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: firstname,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: lastname,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  saveDetails(widget.id);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ApplicationTheme.primaryColor,
                  ),
                  child: const Center(
                      child: Text(
                    'Done',
                    style: TextStyle(color: ApplicationTheme.secondaryColor),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
