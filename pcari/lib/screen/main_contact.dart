import 'dart:convert';

import 'package:chips_choice/chips_choice.dart';
import 'package:flexi_chip/flexi_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:pcari/conf/app_theme.dart';
import 'package:pcari/dto/userListDto.dart';
import 'package:http/http.dart' as http;
import 'package:pcari/screen/user_details.dart';
import 'package:pcari/screen/user_edit.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mainContactScreen extends StatefulWidget {
  const mainContactScreen({super.key});

  @override
  State<mainContactScreen> createState() => _mainContactScreenState();
}

class _mainContactScreenState extends State<mainContactScreen> {
  int tag = 0;
  List<String> options = ['All', 'Favorite'];
  List<String>? globalfavlist = [];
  ValueNotifier<List<userListDto>> userlist = ValueNotifier([]);
  ValueNotifier<List<userListDto>> filtercontact = ValueNotifier([]);

  TextEditingController searchController = TextEditingController();

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
          choiceStyle: const FlexiChipStyle(
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

  searchBar() => SearchField<userListDto>(
      onSearchTextChanged: onSearch(),
      controller: searchController,
      searchInputDecoration: InputDecoration(
          hintText: 'Search',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: ApplicationTheme.primaryColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: ApplicationTheme.primaryColor,
            ),
          )),
      suggestions: []);

  onSearch() {
    setState(() {
      filtercontact.value = userlist.value
          .where((e) =>
              e.firstName!
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              e.lastName!
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  toggleFav(id) async {
    //set to fav if dont have
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? currentList = prefs.getStringList('favlist');
    if (currentList!.contains(id)) {
      //remove
      currentList.remove(id);
    } else {
      //add
      currentList.add(id);
    }
    await prefs.setStringList('favlist', currentList);
  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? favlist = prefs.getStringList('favlist');
    globalfavlist = favlist;

    await getUserList();
    getUserList().then((response) {
      setState(() {});
    });
  }

  getUserDetails(id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDetails(id: id)),
    );
  }

  editUserDetails(id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserEdit(id: id)),
    );
  }

  deleteContact(id, context) async {
    var res = await http.delete(Uri.parse("https://reqres.in/api/users/$id"));
    if (res.statusCode == 200 || res.statusCode == 204) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Successfuly Deleted!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: ApplicationTheme.successColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Failed To Delete, Try Again!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: ApplicationTheme.failedColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  showConfirmDeleteDialog(id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ApplicationTheme.secondaryColor,
          content: Text("Are you sure you want to delete this contact?"),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                deleteContact(id, context);
              },
            ),
            TextButton(
              child: Text(
                "No",
                style: TextStyle(color: ApplicationTheme.primaryColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future<bool> onFavButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  buildListView() => ListView.builder(
      itemCount: filtercontact.value.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Slidable(
          endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    editUserDetails(filtercontact.value[index].id);
                  },
                  backgroundColor:
                      ApplicationTheme.primaryColor.withOpacity(0.5),
                  foregroundColor: Colors.yellow,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  onPressed: (context) async {
                    showConfirmDeleteDialog(filtercontact.value[index].id);
                  },
                  backgroundColor:
                      ApplicationTheme.primaryColor.withOpacity(0.5),
                  foregroundColor: Colors.red,
                  icon: Icons.delete,
                ),
              ]),
          child: ListTile(
            onLongPress: () {
              toggleFav(filtercontact.value[index].id.toString());
            },
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage:
                  NetworkImage(filtercontact.value[index].avatar.toString()),
              backgroundColor: Colors.transparent,
            ),
            contentPadding: const EdgeInsets.all(0),
            title: Row(children: [
              Text(
                  '${filtercontact.value[index].firstName} ${filtercontact.value[index].lastName}'),
              const SizedBox(
                width: 10,
              ),
              LikeButton(
                onTap: onFavButtonTapped,
                circleColor: CircleColor(
                    start: ApplicationTheme.yellow,
                    end: ApplicationTheme.yellow),
                bubblesColor: BubblesColor(
                  dotPrimaryColor: ApplicationTheme.yellow,
                  dotSecondaryColor: ApplicationTheme.yellow,
                ),
                likeBuilder: (bool isLiked) {
                  return Icon(
                    Icons.star,
                    color: isLiked ? ApplicationTheme.yellow : Colors.grey,
                  );
                },
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.star,
              //     color: ApplicationTheme.yellow,
              //   ),
              // ),
              // Visibility(
              //   visible: globalfavlist!
              //           .contains(filtercontact.value[index].id.toString())
              //       ? true
              //       : false,
              //   child: const Icon(
              //     Icons.star,
              //     color: ApplicationTheme.yellow,
              //   ),
              // ),
            ]),
            subtitle: Text(filtercontact.value[index].email.toString()),
            trailing: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: ApplicationTheme.primaryColor,
              ),
              onPressed: () {
                getUserDetails(filtercontact.value[index].id);
                // do something
              },
            ),
            onTap: () {},
          ),
        );
      });

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              searchBar(),
              chipList(),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: buildListView())
            ],
          ),
        ),
      ),
    );
  }
}
