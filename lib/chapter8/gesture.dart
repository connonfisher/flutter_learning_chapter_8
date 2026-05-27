// 8.2 手势识别
// 功能：使用 GestureDetector 识别点击/双击/长按手势，
//       拖动（自由拖动、单一方向拖动）、缩放手势，
//       以及 GestureRecognizer 给 TextSpan 添加点击事件。
// 来源：https://book.flutterchina.club/chapter8/gesture.html

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GestureRoute extends StatefulWidget {
  const GestureRoute({super.key});

  @override
  State<GestureRoute> createState() => _GestureRouteState();
}

class _GestureRouteState extends State<GestureRoute>
    with SingleTickerProviderStateMixin {
  String _operation = '点击/双击/长按蓝色区域';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('8.2 手势识别')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('1. 点击 / 双击 / 长按'),
          _buildTapDemo(),
          const Divider(height: 32),
          _buildSection('2. 拖动'),
          _DragDemo(),
          const Divider(height: 32),
          _buildSection('3. 单一方向拖动'),
          _VerticalDragDemo(),
          const Divider(height: 32),
          _buildSection('4. 缩放'),
          _ScaleDemo(),
          const Divider(height: 32),
          _buildSection('5. GestureRecognizer'),
          _RecognizerDemo(),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTapDemo() {
    return Center(
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          color: Colors.blue,
          width: 200.0,
          height: 100.0,
          child: Text(
            _operation,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: () => updateText('Tap'),
        onDoubleTap: () => updateText('DoubleTap'),
        onLongPress: () => updateText('LongPress'),
      ),
    );
  }

  void updateText(String text) {
    setState(() => _operation = text);
  }
}

class _DragDemo extends StatefulWidget {
  const _DragDemo();

  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<_DragDemo> {
  double _top = 0.0;
  double _left = 0.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: _top,
            left: _left,
            child: GestureDetector(
              child: const CircleAvatar(child: Text('A')),
              onPanDown: (DragDownDetails e) {},
              onPanUpdate: (DragUpdateDetails e) {
                setState(() {
                  _left += e.delta.dx;
                  _top += e.delta.dy;
                });
              },
              onPanEnd: (DragEndDetails e) {},
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDragDemo extends StatefulWidget {
  const _VerticalDragDemo();

  @override
  _VerticalDragState createState() => _VerticalDragState();
}

class _VerticalDragState extends State<_VerticalDragDemo> {
  double _top = 0.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: _top,
            child: GestureDetector(
              child: const CircleAvatar(child: Text('A')),
              onVerticalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  _top += details.delta.dy;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ScaleDemo extends StatefulWidget {
  const _ScaleDemo();

  @override
  _ScaleState createState() => _ScaleState();
}

class _ScaleState extends State<_ScaleDemo> {
  double _width = 200.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Container(
          width: _width,
          height: _width * 0.6,
          color: Colors.teal,
          alignment: Alignment.center,
          child: const Icon(Icons.image, size: 48, color: Colors.white),
        ),
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            _width = 200 * details.scale.clamp(0.8, 10.0);
          });
        },
      ),
    );
  }
}

class _RecognizerDemo extends StatefulWidget {
  const _RecognizerDemo();

  @override
  _RecognizerState createState() => _RecognizerState();
}

class _RecognizerState extends State<_RecognizerDemo> {
  late TapGestureRecognizer _tapGestureRecognizer;
  bool _toggle = false;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer();
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: '你好世界 '),
            TextSpan(
              text: '点我变色',
              style: TextStyle(
                fontSize: 30.0,
                color: _toggle ? Colors.blue : Colors.red,
              ),
              recognizer: _tapGestureRecognizer
                ..onTap = () {
                  setState(() => _toggle = !_toggle);
                },
            ),
            const TextSpan(text: ' 你好世界'),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: GestureRoute()));
