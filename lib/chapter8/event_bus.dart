// 8.5 全局事件总线
// 功能：实现一个基于订阅者模式的全局 EventBus（单例），
//       支持事件订阅(on)、取消订阅(off)和触发(emit)，
//       并演示跨组件/页面的状态共享。
// 来源：https://book.flutterchina.club/chapter8/eventbus.html

import 'package:flutter/material.dart';

typedef EventCallback = void Function(dynamic arg);

class EventBus {
  EventBus._internal();

  static final EventBus _singleton = EventBus._internal();

  factory EventBus() => _singleton;

  final Map<Object, List<EventCallback>?> _emap = {};

  void on(Object eventName, EventCallback f) {
    _emap[eventName] ??= <EventCallback>[];
    _emap[eventName]!.add(f);
  }

  void off(Object eventName, [EventCallback? f]) {
    final list = _emap[eventName];
    if (list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  void emit(Object eventName, [dynamic arg]) {
    final list = _emap[eventName];
    if (list == null) return;
    for (var i = list.length - 1; i >= 0; i--) {
      list[i](arg);
    }
  }
}

final bus = EventBus();

class EventBusRoute extends StatefulWidget {
  const EventBusRoute({super.key});

  @override
  State<EventBusRoute> createState() => _EventBusRouteState();
}

class _EventBusRouteState extends State<EventBusRoute> {
  String _msg = '等待消息...';

  @override
  void initState() {
    super.initState();
    bus.on('login', _onLogin);
  }

  void _onLogin(dynamic arg) {
    setState(() {
      _msg = '收到登录事件: ${arg ?? '无参数'}';
    });
  }

  @override
  void dispose() {
    bus.off('login', _onLogin);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('8.5 全局事件总线')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_active, size: 48, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              _msg,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => bus.emit('login', '用户已登录 (${DateTime.now().second}s)'),
              icon: const Icon(Icons.send),
              label: const Text('触发 login 事件'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => setState(() => _msg = '等待消息...'),
              child: const Text('清空消息'),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🛠 跨页面通信场景：',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('• 页面A: bus.on("login", callback) 订阅'),
                  Text('• 页面B: bus.emit("login", userInfo) 触发'),
                  Text('• 页面A 自动收到通知并更新状态'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: EventBusRoute()));
