import 'dart:convert';

import 'package:chips_choice/chips_choice.dart';
import 'package:flexi_chip/flexi_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pcari/conf/app_theme.dart';
import 'package:pcari/dto/userListDto.dart';
import 'package:http/http.dart' as http;
import 'package:pcari/provider/favorite_provider.dart';
import 'package:pcari/screen/user_details.dart';
import 'package:pcari/screen/user_edit.dart';
import 'package:provider/provider.dart';
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

  searchBar() => SearchField<userListDto>(
      onSearchTextChanged: onSearch(),
      controller: searchController,
      searchInputDecoration: InputDecoration(
          hintText: 'Search',
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: ApplicationTheme.primaryColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
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

  init() async {
    print('refresh list');

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
          content: const Text("Are you sure you want to delete this contact?"),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                deleteContact(id, context);
              },
            ),
            TextButton(
              child: const Text(
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

  buildAllListView(FavoriteProvider provider) => ListView.builder(
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
              IconButton(
                  onPressed: () {
                    provider.toggleFavorite(
                        filtercontact.value[index].id.toString());
                  },
                  icon:
                      provider.isExist(filtercontact.value[index].id.toString())
                          ? const Icon(
                              Icons.star,
                              color: ApplicationTheme.yellow,
                            )
                          : const Icon(Icons.star_border))
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

  buildFavListView(FavoriteProvider provider) => ListView.builder(
      itemCount: provider.fav.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var favIndex = int.parse(provider.fav[index]);
        return Slidable(
          endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    editUserDetails(filtercontact.value[favIndex - 1].id);
                  },
                  backgroundColor:
                      ApplicationTheme.primaryColor.withOpacity(0.5),
                  foregroundColor: Colors.yellow,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  onPressed: (context) async {
                    showConfirmDeleteDialog(
                        filtercontact.value[favIndex - 1].id);
                  },
                  backgroundColor:
                      ApplicationTheme.primaryColor.withOpacity(0.5),
                  foregroundColor: Colors.red,
                  icon: Icons.delete,
                ),
              ]),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                  filtercontact.value[favIndex - 1].avatar.toString()),
              backgroundColor: Colors.transparent,
            ),
            contentPadding: const EdgeInsets.all(0),
            title: Row(children: [
              Text(
                  '${filtercontact.value[favIndex - 1].firstName} ${filtercontact.value[favIndex - 1].lastName}'),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {
                    provider.toggleFavorite(
                        filtercontact.value[favIndex - 1].id.toString());
                  },
                  icon: provider.isExist(
                          filtercontact.value[favIndex - 1].id.toString())
                      ? const Icon(
                          Icons.star,
                          color: ApplicationTheme.yellow,
                        )
                      : const Icon(Icons.star_border))
            ]),
            subtitle: Text(filtercontact.value[favIndex - 1].email.toString()),
            trailing: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: ApplicationTheme.primaryColor,
              ),
              onPressed: () {
                getUserDetails(filtercontact.value[favIndex - 1].id);
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
    final provider = Provider.of<FavoriteProvider>(context);
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
        iconTheme: const IconThemeData(
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
              Row(
                children: [
                  ChipsChoice<int>.single(
                    choiceStyle: const FlexiChipStyle(
                      backgroundColor: ApplicationTheme.primaryColor,
                      foregroundColor: Colors.black,
                    ),
                    value: tag,
                    onChanged: (val) => {
                      if (val == 0)
                        {
                          //all
                          setState(() => tag = val),
                          print(
                              'all list total : ${filtercontact.value.length}')
                        }
                      else
                        {
                          //fav
                          setState(() => tag = val),

                          print('show fav list id : ${provider.fav}'),
                          setState(() {
                            filtercontact.value = userlist.value
                                .where((e) => e.id.toString().contains('1'))
                                .toList();
                          }),
                          print(
                              'fav list total : ${filtercontact.value.length}')
                        }
                    },
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: options,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                  ),
                ],
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: tag == 0
                      ? buildAllListView(provider)
                      : buildFavListView(provider))
            ],
          ),
        ),
      ),
    );
  }
}
