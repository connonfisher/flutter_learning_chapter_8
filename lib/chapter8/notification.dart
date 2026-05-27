// 8.6 通知 Notification
// 功能：使用 NotificationListener 监听 ScrollNotification 滚动通知，
//       自定义 MyNotification 并演示 dispatch 向上冒泡，
//       以及通过 onNotification 返回 true 阻止冒泡。
// 来源：https://book.flutterchina.club/chapter8/notification.html

import 'package:flutter/material.dart';

class NotificationRoute extends StatefulWidget {
  const NotificationRoute({super.key});

  @override
  State<NotificationRoute> createState() => _NotificationRouteState();
}

class _NotificationRouteState extends State<NotificationRoute> {
  String _scrollMsg = '滚动状态';
  String _customMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('8.6 通知 Notification')),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 8),
                Expanded(child: Text('$_scrollMsg\n$_customMsg',
                    style: const TextStyle(fontSize: 13))),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<MyNotification>(
              onNotification: (notification) {
                setState(() {
                  _customMsg = '收到 MyNotification: ${notification.msg}';
                });
                return false;
              },
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    '1. 滚动通知监听',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    flex: 2,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        setState(() {
                          if (notification is ScrollStartNotification) {
                            _scrollMsg = '开始滚动';
                          } else if (notification is ScrollUpdateNotification) {
                            _scrollMsg = '正在滚动...';
                          } else if (notification is ScrollEndNotification) {
                            _scrollMsg = '滚动停止';
                          } else if (notification is OverscrollNotification) {
                            _scrollMsg = '滚动到边界';
                          }
                        });
                        return false;
                      },
                      child: ListView.builder(
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('项目 $index'),
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(),
                  const Text(
                    '2. 自定义通知 & 冒泡控制',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  NotificationListener<MyNotification>(
                    onNotification: (notification) {
                      debugPrint('内层收到: ${notification.msg}');
                      return false;
                    },
                    child: Builder(
                      builder: (context) {
                        return ElevatedButton(
                          onPressed: () =>
                              MyNotification('Hi').dispatch(context),
                          child: const Text('发送通知'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '内层 return false → 继续冒泡，外层也能收到',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyNotification extends Notification {
  MyNotification(this.msg);
  final String msg;
}

void main() => runApp(const MaterialApp(home: NotificationRoute()));
