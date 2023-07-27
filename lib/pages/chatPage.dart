
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fwechat/constant/constant.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {

  const ChatPage({Key? key}) : super(key: key);

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {

  String chatName = "";

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatName = ModalRoute.of(context)!.settings.arguments as String;
      loadMessage();
    });
  }

  List<Message> messages = [];

  final TextEditingController _textEditingController = TextEditingController();

  int currentTime() {
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch;
  }

  void _sendMessage() {
    setState(() {
      String messageText = _textEditingController.text;
      if (messageText.isNotEmpty) {
        messages.add(Message(content: messageText, isMe: true, time: currentTime()));
        final loadMsg = Message(content: "$chatName正在输入...", isMe: false, time: currentTime());
        loadMsg.tmpId = const Uuid().v1();
        messages.add(loadMsg);
        _gptRequest(loadMsg.tmpId);
        _textEditingController.clear();
        _saveMessage();
      }
    });
  }

  String _lastQuestion() {
    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages[i].isMe) {
        return messages[i].content;
      }
    }
    return "";
  }

  void _gptRequest(String tmpId) async {
    String lastQuestion = _lastQuestion();
    if (lastQuestion == "") {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? key = prefs.getString('key');
    if (key == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('未设置API KEY，无法回答问题'),
            content: const Text('需要到【我->设置 GPT API KEY】'),
            actions: <Widget>[
              TextButton(
                child: const Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return ;
    }
    try {
      Dio dio = Dio();
      Options options = Options(
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/json',
        },
      );
      List<Map<String, String>> msgs = [];
      for (int i = 0; i < messages.length; i++) {
        final msg = messages[i];
        if (msg.isMe) {
          msgs.add({ "role":"user", "content":msg.content });
        } else if (msg.tmpId == "") {
          msgs.add({ "role":"assistant", "content":msg.content });
        }
      }
      Response response = await dio.post('https://api.op-enai.com/v1/chat/completions', data: {
        'model': 'gpt-3.5-turbo-16k',
        'messages': msgs,
        'temperature': 0,
        'max_tokens':300,
        'top_p':1,
        'frequency_penalty':0.0,
        'presence_penalty':0.0
      }, options: options);
      final answer = response.data['choices'][0]['message']['content'];
      setState(() {
        // replace
        for (int i = messages.length - 1; i >= 0; i--) {
          if (messages[i].tmpId == tmpId) {
            messages[i].content = answer;
            messages[i].tmpId = "";
          }
        }
        _saveMessage();
      });
    } catch (e) {
      print(e);
    }
  }

  void _saveMessage() async {
    final box = await Hive.openBox(chatName);
    await box.clear();
    for (int i = 0; i < messages.length; i++) {
      if (messages[i].tmpId != "") continue;
      await box.add(messages[i]);
    }
    Future.delayed(const Duration(milliseconds: 10), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void loadMessage() async {
    final box = await Hive.openBox(chatName);
    List<Message> msg = [];
    for (var i = 0; i < box.length; i++) {
      final message = await box.getAt(i) as Message;
      msg.add(message);
    }
    setState(() {
      messages = msg;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void deleteMessage() async {
    final box = await Hive.openBox(chatName);
    box.clear();
    setState(() {
      messages = [];
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(chatName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('删除聊天'),
                    content: Text('确定要删除和$chatName聊天记录么'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('取消'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('确认'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          deleteMessage();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blueGrey,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  Message message = messages[index];
                  return Container(
                    margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!message.isMe) Image(
                              image: AssetImage(Constant.assetsAvatar + Constant.persons[chatName]!.avatar),
                            width: 50,
                            height: 50,
                          ),
                          Expanded(
                            child: Align(
                              alignment: message.isMe?Alignment.topRight:Alignment.topLeft,
                              child:Container(
                                margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: message.isMe ? Colors.lightGreen : Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Text(
                                  message.content,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (message.isMe) const Image(
                            image: AssetImage("${Constant.assetsAvatar}me.png"),
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 28),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: '点击发送消息...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

@HiveType(typeId: 0)
class Message extends HiveObject {
  @HiveField(0)
  String content;
  
  @HiveField(1)
  final bool isMe;

  @HiveField(2)
  final int time;

  @HiveField(3)
  String tmpId = "";

  Message({required this.content, required this.isMe, required this.time});
}

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 0;

  @override
  Message read(BinaryReader reader) {
    final content = reader.readString();
    final isMe = reader.readBool();
    final time = reader.readInt();
    return Message(content: content, isMe: isMe, time: time);
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer.writeString(obj.content);
    writer.writeBool(obj.isMe);
    writer.writeInt(obj.time);
  }
}