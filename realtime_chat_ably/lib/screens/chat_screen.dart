import 'package:flutter/material.dart';
import 'package:realtime_chat_ably/models/message_model.dart';
import 'package:realtime_chat_ably/config.dart';
import 'package:uuid/uuid.dart';
import 'package:ably_flutter_plugin/ably_flutter_plugin.dart' as ably;

class ChatScreen extends StatefulWidget {
  ChatScreen();

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ably.Realtime realtimeInstance;
  var newMsgFromAbly;
  ably.RealtimeChannel chatChannel;
  var myInputController = TextEditingController();
  var myRandomClientId = '';

  @override
  void initState() {
    super.initState();
    createAblyRealtimeInstance();
  }

  @override
  void dispose() {
    myInputController.dispose();
    super.dispose();
  }

  void createAblyRealtimeInstance() async {
    var uuid = Uuid();
    myRandomClientId = uuid.v4();
    var clientOptions = ably.ClientOptions.fromKey(AblyAPIKey);
    clientOptions.clientId = myRandomClientId;
    try {
      realtimeInstance = ably.Realtime(options: clientOptions);
      print('Ably instantiated');
      chatChannel = realtimeInstance.channels.get('flutter-chat');
      subscribeToChatChannel();
      realtimeInstance.connection
          .on(ably.ConnectionEvent.connected)
          .listen((ably.ConnectionStateChange stateChange) async {
        print('Realtime connection state changed: ${stateChange.event}');
      });
    } catch (error) {
      print('Error creating Ably Realtime Instance: $error');
      rethrow;
    }
  }

  void subscribeToChatChannel() {
    var messageStream = chatChannel.subscribe();
    messageStream.listen((ably.Message message) {
      Message newChatMsg;
      newMsgFromAbly = message.data;
      print("New message arrived ${message.data}");
      var hoursIn12HrFormat = message.timestamp.hour > 12
          ? (message.timestamp.hour - 12)
          : (message.timestamp.hour);
      var timeOfDay = message.timestamp.hour < 12 ? ' AM' : ' PM';
      var msgTime = hoursIn12HrFormat.toString() +
          ":" +
          message.timestamp.minute.toString() +
          timeOfDay;
      if (message.clientId == myRandomClientId) {
        newChatMsg = Message(
          sender: currentUser,
          time: msgTime,
          text: newMsgFromAbly["text"],
          unread: false,
        );
      } else {
        newChatMsg = Message(
          sender: randomChatUser,
          time: msgTime,
          text: newMsgFromAbly["text"],
          unread: false,
        );
      }

      setState(() {
        messages.insert(0, newChatMsg);
      });
    });
  }

  void publishMyMessage() async {
    var myMessage = myInputController.text;
    myInputController.clear();
    chatChannel.publish(name: "chatMsg", data: {
      "sender": "randomChatUser",
      "text": myMessage,
    });
  }

  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: myInputController,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              publishMyMessage();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'Ably Chat',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Message message = messages[index];
                      final bool isMe = message.sender.id == currentUser.id;
                      return _buildMessage(message, isMe);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
