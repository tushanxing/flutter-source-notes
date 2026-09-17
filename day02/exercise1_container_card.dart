// =============================================================
// 🟢 基础题：用 Container + Padding + Text 搭建一张卡片
// 目标：把代码里的 ___TODO___ 占位符替换成正确的代码，
//       让程序在屏幕中央显示一张"带背景色 + 圆角 + 内边距"的文字卡片。
// 预计用时：10-15 分钟
//
// 本练习涉及的核心知识点（今天的新内容）：
//   Container     —— 万能容器，可设置内边距、背景色、圆角、宽高等
//   Padding       —— 专门给子组件加内边距的组件（等价于 Container 的 padding 参数）
//   Text          —— 显示文字（style 控制字号、颜色、粗细）
//   BoxDecoration —— 给 Container 加"装饰"（背景色、圆角、边框、阴影）
//   BorderRadius  —— 设置圆角大小
//   EdgeInsets    —— 描述上下左右的距离（.all(24) 表示四边都是 24）
//   Center        —— 让子组件在屏幕居中（昨天学过，今天继续用）
//
// ⚠️ 重要提示（今天最容易踩的坑）：
//   Container 要同时设置"背景色 + 圆角"时，不能写成
//   Container(color: ..., borderRadius: ...)，因为 color 和 borderRadius
//   不能直接搭配。正确做法是把两者都放进：
//   decoration: BoxDecoration(color: ..., borderRadius: ...)
// =============================================================

// TODO-1：导入 Flutter 的 Material 组件库（把 ___TODO___ 换成 import 语句）
___TODO___

// main() 是 Dart 程序的入口函数，Flutter 从这里开始执行
void main() {
  // TODO-2：用 runApp() 启动应用（提示：runApp(const MyApp())）
  ___TODO___
}

// MyApp 是应用根组件（root widget）
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO-3：返回一个 MaterialApp，设置标题，并把首页设为 HomePage
    return ___TODO___(
      title: '卡片练习',
      home: const HomePage(), // home 指定启动后显示的第一个页面
    );
  }
}

// HomePage 是首页组件
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Container 卡片'),
      ),
      // TODO-4：body 用 Center 让卡片在屏幕居中（把 ___TODO___ 换成 Center）
      body: ___TODO___(
        child: Container(
          // TODO-5：给卡片设置内边距 24（提示：const EdgeInsets.all(24)）
          padding: ___TODO___,

          // TODO-6：用 BoxDecoration 给卡片设置"背景色 + 圆角"
          //   提示：
          //   decoration: BoxDecoration(
          //     color: Color(0xFFE3F2FD),                // 浅蓝色背景
          //     borderRadius: BorderRadius.circular(16), // 圆角 16
          //   )
          ___TODO___,

          // 卡片里的文字内容
          child: const Text(
            // TODO-7：把 ___TODO___ 换成一句你想显示的话（例如 '今天也要加油！'）
            '___TODO___',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0), // 深蓝色文字
            ),
          ),
        ),
      ),
    );
  }
}
