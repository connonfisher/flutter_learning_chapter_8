// 8.1 原始指针事件处理
// 功能：使用 Listener 组件监听原始触摸事件（按下/移动/抬起），
//       展示 PointerEvent 的 localPosition 属性，
//       以及 IgnorePointer 和 AbsorbPointer 阻止指针事件的区别。
// 来源：https://book.flutterchina.club/chapter8/listener.html

import 'package:flutter/material.dart';

class ListenerRoute extends StatefulWidget {
  const ListenerRoute({super.key});

  @override
  State<ListenerRoute> createState() => _ListenerRouteState();
}

class _ListenerRouteState extends State<ListenerRoute> {
  PointerEvent? _event;
  String _log = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('8.1 原始指针事件处理')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '手指在蓝色区域内移动查看坐标',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Listener(
              child: Container(
                alignment: Alignment.center,
                color: Colors.blue,
                width: 300.0,
                height: 150.0,
                child: Text(
                  '${_event?.localPosition ?? '触摸蓝色区域'}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              onPointerDown: (PointerDownEvent event) =>
                  setState(() => _event = event),
              onPointerMove: (PointerMoveEvent event) =>
                  setState(() => _event = event),
              onPointerUp: (PointerUpEvent event) =>
                  setState(() => _event = event),
            ),
            const SizedBox(height: 24),
            Text(
              'IgnorePointer vs AbsorbPointer',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildAbsorbPointerDemo(), _buildIgnorePointerDemo()],
            ),
            const SizedBox(height: 16),
            Text(
              _log,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsorbPointerDemo() {
    return Column(
      children: [
        const Text(
          'AbsorbPointer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Listener(
          child: AbsorbPointer(
            child: Listener(
              child: Container(
                color: Colors.red,
                width: 140.0,
                height: 80.0,
                alignment: Alignment.center,
                child: const Text(
                  '子(不响应)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPointerDown: (event) =>
                  setState(() => _log = 'AbsorbPointer 子: down'),
            ),
          ),
          onPointerDown: (event) =>
              setState(() => _log = 'AbsorbPointer 父(响应)'),
        ),
      ],
    );
  }

  Widget _buildIgnorePointerDemo() {
    return Column(
      children: [
        const Text(
          'IgnorePointer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Listener(
          child: IgnorePointer(
            child: Listener(
              child: Container(
                color: Colors.orange,
                width: 140.0,
                height: 80.0,
                alignment: Alignment.center,
                child: const Text(
                  '子(不响应)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPointerDown: (event) =>
                  setState(() => _log = 'IgnorePointer 子: down'),
            ),
          ),
          onPointerDown: (event) =>
              setState(() => _log = 'IgnorePointer 父(也不响应)'),
        ),
      ],
    );
  }
}

void main() => runApp(const MaterialApp(home: ListenerRoute()));
