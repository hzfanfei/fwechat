import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constant.dart';

class MePage extends StatelessWidget {

  final List<String> sections = ['Section 1', 'Section 2'];
  String inputText = "";

  MePage({Key? key}) : super(key: key);

  void saveAPIKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('key', inputText); // 存储字符串
  }

  @override
  Widget build(BuildContext context) {
    return  ListView.separated(
      itemCount: sections.length,
      separatorBuilder: (BuildContext context, int index) => Divider(thickness: 8,),
      itemBuilder: (BuildContext context, int index) {
         if(index == 0) {
           return Container(
             padding: EdgeInsets.all(16),
             height: 150,
             child: Row(
               children: [
                 Image.asset("${Constant.assetsAvatar}me.png", width: 70, height: 70,),
                 Padding(
                   padding: const EdgeInsets.fromLTRB(8, 24, 0, 0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: const [
                       Text("西词", style: TextStyle(
                         fontSize: 18, // 字体大小
                         fontWeight: FontWeight.bold, // 字体粗细
                       ),),
                       Text("微信号:familymrfan"),
                       Text("个性签名:长期接远程办公")
                     ],
                   ),
                 )
               ],
             ),
           );
         } else {
           return Container(
             padding: const EdgeInsets.all(16),
             child: GestureDetector(
               child: Row(
                 children: const [
                   Icon(
                     Icons.settings,
                     size: 24,
                     color: Colors.blue,
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: 8),
                     child: Text("设置 GPT API Key", style: TextStyle(
                       fontSize: 18, // 字体大小
                     )),
                   )
                 ],
               ),
               onTap: () {
                 showDialog(
                   context: context,
                   builder: (BuildContext context) {
                     return AlertDialog(
                       title: const Text("设置 GTP API Key"),
                       content: TextField(
                         onChanged: (value) {
                           inputText = value;
                         },
                         decoration: const InputDecoration(
                           hintText: '这里输入key',
                         ),
                       ),
                       actions: [
                         TextButton(
                           child: const Text('保存'),
                           onPressed: () {
                             Navigator.of(context).pop();
                             saveAPIKey();
                           },
                         ),
                         TextButton(
                           child: const Text('关闭'),
                           onPressed: () {
                             Navigator.of(context).pop();
                           },
                         ),
                       ],
                     );
                   },
                 );
               },
             ),
           );
         }
        },
      );
    }
}