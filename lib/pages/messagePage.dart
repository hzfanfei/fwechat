import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fwechat/constant/constant.dart';
import 'package:hive/hive.dart';

import 'chatPage.dart';

class MessagePage extends StatefulWidget {

  const MessagePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {

  final List<Person> persons = Constant.persons.values.toList();
  Map<String, Message>? name2Message;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openBoxes();
    });
  }

  void _openBoxes() async {
    Map<String, Message> name2msg = {};
    for (int i = 0; i < persons.length; i++) {
      final box = await Hive.openBox(persons[i].name);
      final len = box.length;
      if (len > 0) {
        final message = await box.getAt(len - 1) as Message;
        name2msg[persons[i].name] = message;
      }
    }
    setState(() {
      name2Message = name2msg;
      persons.sort((a, b) {
        if (_getPersonTime(a) > _getPersonTime(b)) {
          return 0;
        } else {
          return 1;
        }
      });
    });
  }

  int _getPersonTime(Person person) {
    if (name2Message != null) {
      final timestamp = name2Message?[person.name]?.time;
      if (timestamp != null) {
        return timestamp;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('微信'),
    ),
    body:ListView.builder(
        itemCount: persons.length,
        itemBuilder: (BuildContext context, int index) {
          String? lastMessage = "";
          if (name2Message != null) {
            lastMessage = name2Message?[persons[index].name]?.content;
            lastMessage ??= "";
          }
          DateTime now = DateTime.now();
          String formattedTime = "";
          if (name2Message != null) {
            final timestamp = name2Message?[persons[index].name]?.time;
            if (timestamp != null) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
              if (dateTime.month == now.month && dateTime.day == now.day) {
                formattedTime = "${dateTime.hour}:${dateTime.minute}";
              } else {
                formattedTime = "${dateTime.month}月${dateTime.day}日${dateTime.hour}:${dateTime.minute}";
              }
            }
          }

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/chatPage', arguments: persons[index].name).then((value) {
                _openBoxes();
              });
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                height: 80,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:  const EdgeInsets.fromLTRB(8, 8, 0, 0),
                          child: Center(
                            child: Image(
                              image: AssetImage("${Constant.assetsAvatar}${persons[index].avatar}"),
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container (
                              height: 60,
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(persons[index].name),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 8, 15, 0),
                                      child: Text(lastMessage, overflow: TextOverflow.ellipsis, softWrap: false, maxLines: 1,),
                                    )
                                  ],
                                ),
                              ),
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(formattedTime),
                        )
                      ],
                    ),
                    Expanded(child: Container ()),
                    const Divider(
                      indent: 60,
                    )
                  ],
                )
            ),
          );
        }
    ),
    );
  }
}