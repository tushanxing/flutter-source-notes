// =============================================================
// 🟡 进阶题：改造 Hello World
// 目标：在 Hello World 基础上做一次"小升级"，掌握更多常用 Widget 和主题定制。
// 预计用时：15-25 分钟
//
// 升级清单（每项对应下方一个 TODO）：
//   1. 把 AppBar 标题改成你自己的 App 名字
//   2. 在页面中央加一个"副标题"文本（较小字号 + 灰色）
//   3. 用 Material 3 的 ColorScheme.fromSeed 自定义主题色
//   4. 在正文上方加一个图标（用 Icon + Icons.xxx）
//
// 新涉及的知识点：
//   Column             —— 把多个子组件从上到下排列
//   MainAxisAlignment  —— 控制 Column 子组件的对齐方式
//   Icon / Icons       —— 显示 Material 图标
//   ColorScheme.fromSeed —— Material 3 主题色定制
// =============================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '改造 Hello World',
      // TODO-3：把 seedColor 换成你喜欢的颜色（例如 Colors.deepPurple、Colors.red）
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true, // Material 3 是 Flutter 3.x 的默认设计风格
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO-1：把下面的 ___TODO___ 换成你自己的 App 名字（例如 '我的学习笔记'）
        title: const Text('___TODO___'),
      ),
      body: Center(
        // Column 把多个内容从上到下排列
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 垂直方向居中
          children: [
            // TODO-4：在下面加一个图标（替换 ___TODO___）
            // 提示：Icon(Icons.favorite, color: Colors.red, size: 48)
            ___TODO___,

            const SizedBox(height: 16), // 图标和标题之间的间距

            const Text(
              'Hello World',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // TODO-2：在下面加一行副标题文本（替换 ___TODO___）
            // 提示：Text('欢迎回来，今天也要加油！',
            //             style: TextStyle(fontSize: 16, color: Colors.grey))
            ___TODO___,
          ],
        ),
      ),
    );
  }
}
