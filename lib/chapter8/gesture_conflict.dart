// 8.4 手势原理与手势冲突
// 功能：演示嵌套 GestureDetector 的手势竞争机制，
//       水平/垂直拖动的方向竞争，
//       Tap 与 Drag 的多手势冲突，
//       以及通过 Listener 和自定义 Recognizer 解决手势冲突。
// 来源：https://book.flutterchina.club/chapter8/gesture_conflict.html

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GestureConflictRoute extends StatefulWidget {
  const GestureConflictRoute({super.key});

  @override
  State<GestureConflictRoute> createState() => _GestureConflictRouteState();
}

class _GestureConflictRouteState extends State<GestureConflictRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('8.4 手势原理与手势冲突')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('1. 嵌套 GestureDetector 竞争'),
          _NestedDemo(),
          const Divider(height: 32),
          _buildSection('2. 水平/垂直方向竞争'),
          _DirectionDemo(),
          const Divider(height: 32),
          _buildSection('3. Listener 解决冲突'),
          _ListenerSolution(),
          const Divider(height: 32),
          _buildSection('4. 自定义 Recognizer 解决冲突'),
          _CustomRecognizerSolution(),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _NestedDemo extends StatefulWidget {
  const _NestedDemo();

  @override
  _NestedDemoState createState() => _NestedDemoState();
}

class _NestedDemoState extends State<_NestedDemo> {
  String _log = '点击灰色区域';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapUp: (_) =>
              setState(() => _log = '❌ 父 GestureDetector 未响应（子优先胜出）'),
          child: Container(
            width: 200,
            height: 200,
            color: Colors.red,
            alignment: Alignment.center,
            child: GestureDetector(
              onTapUp: (_) => setState(() => _log = '✅ 子 GestureDetector 响应'),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey,
                alignment: Alignment.center,
                child: const Text('点我', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(_log, style: const TextStyle(color: Colors.blue)),
      ],
    );
  }
}

class _DirectionDemo extends StatefulWidget {
  const _DirectionDemo();

  @override
  _DirectionDemoState createState() => _DirectionDemoState();
}

class _DirectionDemoState extends State<_DirectionDemo> {
  double _top = 0.0;
  double _left = 0.0;
  String _dir = '拖动 A';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: _top,
            left: _left,
            child: GestureDetector(
              child: const CircleAvatar(child: Text('A')),
              onVerticalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  _top += details.delta.dy;
                  _dir = '垂直方向';
                });
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  _left += details.delta.dx;
                  _dir = '水平方向';
                });
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Text(
              '拖动方向: $_dir',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListenerSolution extends StatefulWidget {
  const _ListenerSolution();

  @override
  _ListenerSolutionState createState() => _ListenerSolutionState();
}

class _ListenerSolutionState extends State<_ListenerSolution> {
  String _log = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Listener(
          onPointerUp: (_) =>
              setState(() => _log = '✅ Listener 父响应 (onPointerUp)'),
          child: Container(
            width: 200,
            height: 100,
            color: Colors.red,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => setState(() => _log = '✅ 子 GestureDetector 也响应'),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey,
                alignment: Alignment.center,
                child: const Text('点我', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(_log, style: const TextStyle(color: Colors.blue)),
      ],
    );
  }
}

class CustomTapGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

class _CustomRecognizerSolution extends StatefulWidget {
  const _CustomRecognizerSolution();

  @override
  _CustomRecognizerState createState() => _CustomRecognizerState();
}

class _CustomRecognizerState extends State<_CustomRecognizerSolution> {
  String _log = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawGestureDetector(
          gestures: {
            CustomTapGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  CustomTapGestureRecognizer
                >(() => CustomTapGestureRecognizer(), (detector) {
                  detector.onTap = () =>
                      setState(() => _log = '✅ 自定义 Recognizer 父也响应');
                }),
          },
          child: Container(
            width: 200,
            height: 100,
            color: Colors.red,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => setState(() => _log = '✅ 子 GestureDetector 响应'),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey,
                alignment: Alignment.center,
                child: const Text('点我', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(_log, style: const TextStyle(color: Colors.blue)),
      ],
    );
  }
}

void main() => runApp(const MaterialApp(home: GestureConflictRoute()));
