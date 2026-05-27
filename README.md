# Flutter 事件处理与通知

> 基于 [《Flutter 实战·第二版》第八章](https://book.flutterchina.club/chapter8/) 的学习复现项目，完整覆盖事件处理、手势识别、通知冒泡等核心机制。

## 环境信息

| 项目 | 版本 |
|------|------|
| Flutter | 3.41.4 |
| Dart | 3.11.1 |
| 支持平台 | Android / iOS / Web / Windows / macOS / Linux |

## 快速开始

```bash
git clone https://github.com/connonfisher/flutter_learning_chapter_8.git
cd flutter_learning_chapter_8
flutter pub get
flutter run
```

## 项目结构

```
lib/
├── main.dart                          # 章节目录导航页
└── chapter8/
    ├── listener.dart                  # 8.1 原始指针事件处理
    ├── gesture.dart                   # 8.2 手势识别
    ├── hit_test.dart                  # 8.3 Flutter事件机制
    ├── gesture_conflict.dart          # 8.4 手势原理与手势冲突
    ├── event_bus.dart                 # 8.5 全局事件总线
    └── notification.dart              # 8.6 通知 Notification
```

每个小节文件均可独立运行（含 `main()` 入口），也可从首页目录导航进入。

---

## 8.1 原始指针事件处理

> 原文链接：[https://book.flutterchina.club/chapter8/listener.html](https://book.flutterchina.club/chapter8/listener.html)

### 功能介绍

| 知识点 | 说明 |
|--------|------|
| `Listener` | 监听原始指针事件（按下/移动/抬起），获取 `localPosition` 坐标 |
| `IgnorePointer` | 阻止子树响应指针事件，**自身也不参与**命中测试 |
| `AbsorbPointer` | 阻止子树响应指针事件，**自身参与**命中测试 |

### 演示效果

| 代码截图 | 运行效果 |
|---------|---------|
| ![代码](assets/演示截图/8.1%20原始指针事件处理-代码.png) | ![运行](assets/演示截图/8.1%20原始指针事件处理-运行效果.png) |

### 核心代码示例

**基础 Listener 监听**

```dart
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
  onPointerDown: (PointerDownEvent event) => setState(() => _event = event),
  onPointerMove: (PointerMoveEvent event) => setState(() => _event = event),
  onPointerUp: (PointerUpEvent event) => setState(() => _event = event),
)
```

**AbsorbPointer — 自身可响应，子树被拦截**

```dart
Listener(
  onPointerDown: (event) => print('父: 响应'),
  child: AbsorbPointer(
    child: Listener(
      onPointerDown: (event) => print('子: 不响应'),
      child: Container(color: Colors.red, width: 140, height: 80),
    ),
  ),
)
```

**IgnorePointer — 自身和子树均不响应**

```dart
Listener(
  onPointerDown: (event) => print('父: 也不响应'),
  child: IgnorePointer(
    child: Listener(
      onPointerDown: (event) => print('子: 不响应'),
      child: Container(color: Colors.orange, width: 140, height: 80),
    ),
  ),
)
```

### 独立运行

```bash
flutter run -t lib/chapter8/listener.dart
```

---

## 8.2 手势识别

> 原文链接：[https://book.flutterchina.club/chapter8/gesture.html](https://book.flutterchina.club/chapter8/gesture.html)

### 功能介绍

| 知识点 | 说明 |
|--------|------|
| 点击/双击/长按 | `onTap` / `onDoubleTap` / `onLongPress` |
| 自由拖动 | `onPanUpdate` 获取 `delta` 位移 |
| 单一方向拖动 | `onVerticalDragUpdate` / `onHorizontalDragUpdate` |
| 缩放 | `onScaleUpdate` 获取 `scale` 倍数 |
| GestureRecognizer | 给 `TextSpan` 添加点击识别器 |

### 演示效果

| 代码截图 | 运行效果 |
|---------|---------|
| ![代码](assets/演示截图/8.2%20手势识别-代码.png) | ![运行](assets/演示截图/8.2%20手势识别-运行效果.png) |

### 核心代码示例

**点击 / 双击 / 长按**

```dart
GestureDetector(
  child: Container(
    alignment: Alignment.center,
    color: Colors.blue,
    width: 200.0,
    height: 100.0,
    child: Text(_operation, style: const TextStyle(color: Colors.white)),
  ),
  onTap: () => updateText('Tap'),
  onDoubleTap: () => updateText('DoubleTap'),
  onLongPress: () => updateText('LongPress'),
)
```

**自由拖动**

```dart
GestureDetector(
  child: const CircleAvatar(child: Text('A')),
  onPanUpdate: (DragUpdateDetails e) {
    setState(() {
      _left += e.delta.dx;
      _top += e.delta.dy;
    });
  },
)
```

**缩放**

```dart
GestureDetector(
  child: Container(width: _width, height: _width * 0.6, color: Colors.teal),
  onScaleUpdate: (ScaleUpdateDetails details) {
    setState(() {
      _width = 200 * details.scale.clamp(0.8, 10.0);
    });
  },
)
```

**TextSpan + GestureRecognizer**

```dart
Text.rich(
  TextSpan(
    children: [
      const TextSpan(text: '你好世界 '),
      TextSpan(
        text: '点我变色',
        style: TextStyle(fontSize: 30.0, color: _toggle ? Colors.blue : Colors.red),
        recognizer: _tapGestureRecognizer..onTap = () => setState(() => _toggle = !_toggle),
      ),
      const TextSpan(text: ' 你好世界'),
    ],
  ),
)
```

### 独立运行

```bash
flutter run -t lib/chapter8/gesture.dart
```

---

## 8.3 Flutter事件机制

> 原文链接：[https://book.flutterchina.club/chapter8/hittest.html](https://book.flutterchina.club/chapter8/hittest.html)

### 功能介绍

| 知识点 | 说明 |
|--------|------|
| `HitTestBehavior.deferToChild` | 命中测试取决于子组件 |
| `HitTestBehavior.opaque` | 始终通过命中测试，`hitTest` 返回 true |
| `HitTestBehavior.translucent` | 始终通过命中测试，可透传到兄弟节点 |
| `WaterMark` 水印 | Stack + IgnorePointer + CustomPaint 实现全屏水印 |

### 演示效果

| 代码截图 | 运行效果 |
|---------|---------|
| ![代码](assets/演示截图/8.3%20Flutter事件机制-代码.png) | ![运行](assets/演示截图/8.3%20Flutter事件机制-运行效果.png) |

### 核心代码示例

**HitTestBehavior 三种模式**

```dart
Listener(
  behavior: HitTestBehavior.deferToChild, // opaque / translucent
  onPointerDown: (_) => print('Listener 收到事件'),
  child: Container(
    height: 60,
    color: Colors.blue.shade100,
    alignment: Alignment.center,
    child: Text('点击测试'),
  ),
)
```

**WaterMark 水印实现**

```dart
Stack(
  children: [
    // 页面内容...
    IgnorePointer(
      child: CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: _WaterMarkPainter(),
      ),
    ),
  ],
)

class _WaterMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(text: 'Flutter 水印',
        style: TextStyle(color: Colors.grey.withValues(alpha: 0.15))),
      textDirection: TextDirection.ltr,
    )..layout();

    for (double y = 0; y < size.height; y += textPainter.height + 40) {
      for (double x = 0; x < size.width; x += textPainter.width + 60) {
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
```

### 独立运行

```bash
flutter run -t lib/chapter8/hit_test.dart
```

---

## 8.4 手势原理与手势冲突

> 原文链接：[https://book.flutterchina.club/chapter8/gesture_conflict.html](https://book.flutterchina.club/chapter8/gesture_conflict.html)

### 功能介绍

| 知识点 | 说明 |
|--------|------|
| 嵌套 GestureDetector 竞争 | 子优先原则，子组件胜出 |
| 水平/垂直方向竞争 | 首次移动位移分量大的方向获胜 |
| Listener 解决冲突 | 跳出 GestureDetector 手势竞技场机制 |
| 自定义 Recognizer | 重写 `rejectGesture` 强制接受手势 |

### 演示效果

| 代码截图 | 运行效果 |
|---------|---------|
| ![代码](assets/演示截图/8.4%20手势原理与手势冲突-代码.png) | ![运行](assets/演示截图/8.4%20手势原理与手势冲突-运行效果.png) |

### 核心代码示例

**嵌套竞争（子组件优先）**

```dart
GestureDetector(
  onTapUp: (_) => print('父未响应'),
  child: Container(width: 200, height: 200, color: Colors.red,
    child: GestureDetector(
      onTapUp: (_) => print('子胜出'),
      child: Container(width: 60, height: 60, color: Colors.grey),
    ),
  ),
)
```

**Listener 解决冲突（父和子都响应）**

```dart
Listener(
  onPointerUp: (_) => print('父: 响应'),
  child: GestureDetector(
    onTap: () => print('子: 也响应'),
    child: Container(width: 60, height: 60, color: Colors.grey),
  ),
)
```

**自定义 Recognizer 解决冲突**

```dart
class CustomTapGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer); // 强制接受
  }
}

RawGestureDetector(
  gestures: {
    CustomTapGestureRecognizer:
        GestureRecognizerFactoryWithHandlers<CustomTapGestureRecognizer>(
      () => CustomTapGestureRecognizer(),
      (detector) { detector.onTap = () => print('父也响应'); },
    ),
  },
  child: GestureDetector(
    onTap: () => print('子响应'),
    child: Container(...),
  ),
)
```

### 独立运行

```bash
flutter run -t lib/chapter8/gesture_conflict.dart
```

---

## 8.5 全局事件总线

> 原文链接：[https://book.flutterchina.club/chapter8/eventbus.html](https://book.flutterchina.club/chapter8/eventbus.html)

### 功能介绍

| 知识点 | 说明 |
|--------|------|
| `EventBus` 单例 | `static` + 工厂构造函数保证全局唯一实例 |
| `on` 订阅 | 注册事件名对应的回调函数 |
| `off` 取消订阅 | 移除指定事件名和回调（注意 dispose 时清理） |
| `emit` 触发 | 反向遍历订阅者列表，防止移除自身导致的错位 |

### 演示效果

| 代码截图 | 运行效果 |
|---------|---------|
| ![代码](assets/演示截图/8.5%20全局事件总线-代码.png) | ![运行](assets/演示截图/8.5%20全局事件总线-运行效果.png) |

### 核心代码示例

**EventBus 实现**

```dart
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
```

**使用示例**

```dart
// 页面A — 订阅
bus.on('login', (arg) => setState(() => _msg = '收到: $arg'));

// 页面B — 触发
bus.emit('login', '用户已登录');

// 页面A dispose 时务必取消订阅
bus.off('login', _onLogin);
```

### 独立运行

```bash
flutter run -t lib/chapter8/event_bus.dart
```

---

## 8.6 通知 Notification

> 原文链接：[https://book.flutterchina.club/chapter8/notification.html](https://book.flutterchina.club/chapter8/notification.html)

### 功能介绍

| 知识点 | 说明 |
|--------|------|
| `NotificationListener` | 监听子树向上冒泡的通知 |
| `ScrollNotification` | Flutter 内置滚动通知（开始/更新/结束/边界） |
| 自定义通知 | 继承 `Notification`，调用 `dispatch(context)` 发送 |
| 阻止冒泡 | `onNotification` 返回 `true` 终止向上传递 |

### 演示效果

| 代码截图 | 运行效果 |
|---------|---------|
| ![代码](assets/演示截图/8.6%20通知%20Notification-代码.png) | ![运行](assets/演示截图/8.6%20通知%20Notification-运行效果.png) |

### 核心代码示例

**监听滚动通知**

```dart
NotificationListener<ScrollNotification>(
  onNotification: (notification) {
    if (notification is ScrollStartNotification) print('开始滚动');
    else if (notification is ScrollUpdateNotification) print('正在滚动');
    else if (notification is ScrollEndNotification) print('滚动停止');
    return false; // 不阻止冒泡
  },
  child: ListView.builder(itemCount: 100, ...),
)
```

**自定义通知 & 发送**

```dart
class MyNotification extends Notification {
  MyNotification(this.msg);
  final String msg;
}

// 在按钮点击时触发
Builder(
  builder: (context) => ElevatedButton(
    onPressed: () => MyNotification('Hi').dispatch(context),
    child: const Text('发送通知'),
  ),
)
```

**嵌套 NotificationListener 与阻止冒泡**

```dart
NotificationListener<MyNotification>(
  onNotification: (n) { print('外层收到: ${n.msg}'); return false; },
  child: NotificationListener<MyNotification>(
    onNotification: (n) { print('内层收到: ${n.msg}'); return true; }, // true = 阻止冒泡
    child: ElevatedButton(...),
  ),
)
```

### 独立运行

```bash
flutter run -t lib/chapter8/notification.dart
```

---
