
import 'package:flutter/material.dart';
import 'package:fwechat/constant/constant.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  ContactsPageState createState() => ContactsPageState();
}

class ContactsPageState extends State<ContactsPage> {

  final List<Person> persons = Constant.persons.values.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通讯录'),
      ),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("${Constant.assetsAvatar}${persons[index].avatar}"),
                    width: 50,
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(persons[index].name),
                  )
                ]),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(persons[index].name),
                    content: Text("个性签名: ${persons[index].slogan}"),
                    actions: [
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}