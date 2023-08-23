import 'package:flutter/material.dart';
import 'package:pcari/conf/app_theme.dart';

class UserDetails extends StatefulWidget {
  const UserDetails(id, {super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  init() {}

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage:
                    NetworkImage('https://reqres.in/img/faces/1-image.jpg'),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('test'),
          ],
        ),
      ),
    );
  }
}
