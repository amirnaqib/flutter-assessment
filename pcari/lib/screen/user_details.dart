import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pcari/conf/app_theme.dart';
import 'package:pcari/dto/userDetailsDto.dart';
import 'package:http/http.dart' as http;

class UserDetails extends StatefulWidget {
  const UserDetails(id, {super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  userDetailsDto userdetails = userDetailsDto();

  init() async {
    await getUserDetails();
    getUserDetails().then((response) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<userDetailsDto> getUserDetails() async {
    var res = await http.get(Uri.parse("https://reqres.in/api/users/2"));
    if (res.statusCode == 200) {
      setState(() {
        userdetails = userDetailsDto.fromJson(jsonDecode(res.body)['data']);
      });

      return userDetailsDto.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
        backgroundColor: ApplicationTheme.primaryColor,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: ApplicationTheme.title,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(userdetails.avatar.toString()),
              backgroundColor: Colors.transparent,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '${userdetails.firstName} ${userdetails.lastName}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            alignment: Alignment.center,
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 50,
                  color: Colors.black,
                ),
                Text(userdetails.email.toString())
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ApplicationTheme.primaryColor,
              ),
              child: const Center(
                  child: Text(
                'Send Email',
                style: TextStyle(color: ApplicationTheme.secondaryColor),
              )),
            ),
          )
        ],
      ),
    );
  }
}
