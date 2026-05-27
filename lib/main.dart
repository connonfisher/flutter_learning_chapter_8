import 'package:flutter/material.dart';
import 'chapter8/listener.dart';
import 'chapter8/gesture.dart';
import 'chapter8/hit_test.dart';
import 'chapter8/gesture_conflict.dart';
import 'chapter8/event_bus.dart';
import 'chapter8/notification.dart';

void main() {
  runApp(const Chapter8App());
}

class Chapter8App extends StatelessWidget {
  const Chapter8App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 事件处理与通知',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const Chapter8Home(),
    );
  }
}

class Chapter8Home extends StatelessWidget {
  const Chapter8Home({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      _Section(
        title: '8.1 原始指针事件处理',
        keywords: 'Listener · PointerEvent · IgnorePointer · AbsorbPointer',
        builder: (context) => const ListenerRoute(),
      ),
      _Section(
        title: '8.2 手势识别',
        keywords: 'GestureDetector · Drag · Scale · GestureRecognizer',
        builder: (context) => const GestureRoute(),
      ),
      _Section(
        title: '8.3 Flutter事件机制',
        keywords: 'HitTestBehavior · 命中测试 · WaterMark',
        builder: (context) => const HitTestRoute(),
      ),
      _Section(
        title: '8.4 手势原理与手势冲突',
        keywords: '手势竞争 · Recognizer · Listener 解决方案',
        builder: (context) => const GestureConflictRoute(),
      ),
      _Section(
        title: '8.5 全局事件总线',
        keywords: 'EventBus · 订阅者模式 · 跨页面通信',
        builder: (context) => const EventBusRoute(),
      ),
      _Section(
        title: '8.6 通知 Notification',
        keywords: 'NotificationListener · 冒泡 · 自定义通知',
        builder: (context) => const NotificationRoute(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter 事件处理与通知'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final section = sections[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: section.builder),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            section.keywords,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey.shade400),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Section {
  final String title;
  final String keywords;
  final WidgetBuilder builder;

  const _Section({
    required this.title,
    required this.keywords,
    required this.builder,
  });
}
