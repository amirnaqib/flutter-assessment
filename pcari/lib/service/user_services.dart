import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pcari/dto/userListDto.dart';

class AppService {
  ValueNotifier<List<userListDto>> userlist = ValueNotifier([]);

  // Future<List<userListDto>> getUserList() async {
  //   log('getting userlist..');
  //   var res = await http.get(Uri.parse("http://199.192.25.10/api/recordlist"));

  //   if (res.statusCode == 200) {
  //     List<userListDto> r = json
  //         .decode(res.body)['data']!
  //         .map<userListDto>((x) => userListDto.fromJson(x))
  //         .toList();

  //     return userlist.value = r;
  //   } else {
  //     throw ('Cant Get List');
  //   }
  // }

  getAccountDetails() async {
    log('getting starting amount..');
    var res =
        await http.get(Uri.parse("http://199.192.25.10/api/accountdetails"));
    // var result = response['result'];
    // log(result.toString());
    // log(res.body.toString());

    if (res.statusCode == 200) {
      var response = jsonDecode(res.body)['result'];

      return response[0]['incomeAmt'];
    } else {
      throw ('error');
    }
  }
}

final appService = AppService();
