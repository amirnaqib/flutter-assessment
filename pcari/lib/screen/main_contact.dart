import 'dart:convert';

import 'package:chips_choice/chips_choice.dart';
import 'package:flexi_chip/flexi_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pcari/conf/app_theme.dart';
import 'package:pcari/dto/userListDto.dart';
import 'package:http/http.dart' as http;
import 'package:pcari/screen/user_details.dart';

class mainContactScreen extends StatefulWidget {
  const mainContactScreen({super.key});

  @override
  State<mainContactScreen> createState() => _mainContactScreenState();
}

class _mainContactScreenState extends State<mainContactScreen> {
  int tag = 0;
  List<String> options = ['All', 'Favorite'];
  ValueNotifier<List<userListDto>> userlist = ValueNotifier([]);

  Future<List<userListDto>> getUserList() async {
    var res = await http.get(Uri.parse("https://reqres.in/api/users?page=1"));

    if (res.statusCode == 200) {
      List<userListDto> u = json
          .decode(res.body)['data']!
          .map<userListDto>((x) => userListDto.fromJson(x))
          .toList();

      return userlist.value = u;
    } else {
      throw ('Cant Get List');
    }
  }

  chipList() {
    return Row(
      children: [
        ChipsChoice<int>.single(
          choiceStyle: FlexiChipStyle(
            backgroundColor: ApplicationTheme.primaryColor,
            foregroundColor: Colors.black,
          ),
          value: tag,
          onChanged: (val) => setState(() => tag = val),
          choiceItems: C2Choice.listFrom<int, String>(
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
        ),
      ],
    );
  }

  searchBar() {}

  addFavList() {
    print('testing add..');
  }

  init() async {
    await getUserList();
    getUserList().then((response) {
      setState(() {});
    });
  }

  getUserDetails(id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDetails(id)),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addFavList();
        },
        shape: const CircleBorder(),
        backgroundColor: ApplicationTheme.primaryColor,
        child: const Icon(
          Icons.add,
          color: ApplicationTheme.secondaryColor,
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              init();
            },
          )
        ],
        backgroundColor: ApplicationTheme.primaryColor,
        centerTitle: true,
        title: const Text(
          'My Contact',
          style: ApplicationTheme.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // searchBar(),
            chipList(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: userlist.value.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          children: [
                            SlidableAction(
                              onPressed: searchBar(),
                              backgroundColor: ApplicationTheme.primaryColor
                                  .withOpacity(0.5),
                              foregroundColor: Colors.yellow,
                              icon: Icons.edit,
                            ),
                            SlidableAction(
                              onPressed: (context) async {},
                              backgroundColor: ApplicationTheme.primaryColor
                                  .withOpacity(0.5),
                              foregroundColor: Colors.red,
                              icon: Icons.delete,
                            ),
                          ]),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(
                              userlist.value[index].avatar.toString()),
                          backgroundColor: Colors.transparent,
                        ),
                        contentPadding: EdgeInsets.all(0),
                        title: Text(userlist.value[index].firstName.toString() +
                            ' ' +
                            userlist.value[index].lastName.toString()),
                        subtitle: Text(userlist.value[index].email.toString()),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            color: ApplicationTheme.primaryColor,
                          ),
                          onPressed: () {
                            getUserDetails(userlist.value[index].id);
                            // do something
                          },
                        ),
                        onTap: () {},
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
