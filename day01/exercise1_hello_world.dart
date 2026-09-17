// =============================================================
// 🟢 基础题：Hello World 填空练习
// 目标：把代码里的 ___TODO___ 占位符替换成正确的代码，
//       让程序成功运行，并在屏幕中央显示 "Hello World"。
// 预计用时：10 分钟
//
// 本练习涉及的核心知识点：
//   main()      —— Dart 程序入口函数
//   runApp()    —— 启动 Flutter 应用
//   MaterialApp —— 应用根组件，提供 Material 设计风格与主题
//   Scaffold    —— 页面骨架，提供背景、AppBar、安全区域适配
//   AppBar      —— 顶部标题栏
//   Center      —— 让子组件在屏幕上居中
//   Text        —— 显示文字
// =============================================================

// TODO-1：导入 Flutter 的 Material 组件库（把 ___TODO___ 换成正确的 import 语句）
___TODO___

// main() 是 Dart 程序的入口函数，Flutter 从这里开始执行
void main() {
  // TODO-2：用 runApp() 启动应用，并把 MyApp 的实例传进去（提示：const MyApp()）
  ___TODO___
}

// MyApp 是应用的根组件（root widget）
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO-3：返回一个 MaterialApp，设置标题，并把首页设为 HomePage
    return ___TODO___(
      title: 'Hello World',    // 这个标题显示在系统任务管理器中
      home: const HomePage(),  // home 指定启动后显示的第一个页面
    );
  }
}

// HomePage 是首页组件，负责显示页面内容
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO-4：用 Scaffold 搭建页面骨架（不能省略，否则会黑屏或布局异常）
    return ___TODO___(
      // TODO-5：顶部标题栏用 AppBar，标题用 Text 显示
      appBar: ___TODO___(
        title: ___TODO___('Hello World'),
      ),
      // TODO-6：body 里先用 Center 让内容居中，再用 Text 显示文字
      body: ___TODO___(
        child: ___TODO___(
          'Hello World',
          style: TextStyle(fontSize: 32), // 字号调大一点，看得更清楚
        ),
      ),
    );
  }
}
