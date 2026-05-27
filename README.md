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
# 运行整个项目（从目录页进入）
flutter run

# 或单独运行本节
flutter run -t lib/chapter8/listener.dart
```

---
