// 8.3 Flutter事件机制
// 功能：演示 HitTestBehavior 三种模式（deferToChild / opaque / translucent）
//       对事件命中测试的影响，以及通过 Stack + Listener 实现 App 水印效果。
// 来源：https://book.flutterchina.club/chapter8/hittest.html

import 'package:flutter/material.dart';

class HitTestRoute extends StatelessWidget {
  const HitTestRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('8.3 Flutter事件机制')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '1. HitTestBehavior 对比',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildBehaviorDemo('deferToChild', HitTestBehavior.deferToChild,
              '取决于子组件是否通过命中测试'),
          _buildBehaviorDemo('opaque', HitTestBehavior.opaque,
              '始终通过命中测试'),
          _buildBehaviorDemo('translucent', HitTestBehavior.translucent,
              '始终通过命中测试（可透传）'),
          const Divider(height: 32),
          const Text(
            '2. WaterMark 水印效果',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildWaterMarkDemo(),
        ],
      ),
    );
  }

  Widget _buildBehaviorDemo(String name, HitTestBehavior behavior, String desc) {
    final ValueNotifier<String> log = ValueNotifier('未点击');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$name — $desc',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: log,
              builder: (context, value, _) {
                return Listener(
                  behavior: behavior,
                  onPointerDown: (_) => log.value = 'Listener 收到事件',
                  child: Container(
                    height: 60,
                    color: Colors.blue.shade100,
                    alignment: Alignment.center,
                    child: Text(value),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterMarkDemo() {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('可点击按钮'),
                ),
                const SizedBox(height: 12),
                const Text('页面内容区域'),
              ],
            ),
          ),
          IgnorePointer(
            child: CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: _WaterMarkPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaterMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.grey.withValues(alpha: 0.15),
      fontSize: 20,
    );

    final textSpan = TextSpan(text: 'Flutter 水印', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final stepX = textPainter.width + 60;
    final stepY = textPainter.height + 40;

    for (double y = 0; y < size.height; y += stepY) {
      for (double x = 0; x < size.width; x += stepX) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(0.3);
        textPainter.paint(canvas, Offset.zero);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void main() => runApp(const MaterialApp(home: HitTestRoute()));
