// =============================================================
// 🟡 进阶题：组合多个 Container 和 SizedBox 做布局
// 目标：用多个 Container 搭出"价格标签"和"按钮样式"两种 UI 元素，
//       并用 SizedBox 控制它们之间的间距。
// 预计用时：15-25 分钟
//
// 本练习涉及的知识点：
//   Container + BoxDecoration —— 制作"胶囊形标签"和"圆角按钮"外观
//   SizedBox —— 在两个组件之间留出固定间距
//   Column / Row —— 上下 / 左右排列多个子组件
//   MainAxisSize —— 控制 Column 是否撑满整屏
//   TextStyle（fontWeight / color / fontSize）—— 精细控制文字样式
//   EdgeInsets.symmetric —— 分别设置水平 / 垂直方向的内边距
//
// 你要完成的小任务（对应下方 TODO-1 ~ TODO-4）：
//   1. 完成"价格标签"：胶囊形、橙色背景、白色加粗文字
//   2. 完成"按钮"外观：主色背景、圆角、内边距、白色加粗文字
//   3. 用 SizedBox 把标题 / 标签 / 按钮之间的间距调舒服（共两处）
//   4. 给 App 换个你喜欢的主题色（ColorScheme.fromSeed）
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
      title: '布局练习',
      theme: ThemeData(
        // TODO-4：把 seedColor 换成你喜欢的颜色（如 Colors.orange、Colors.green、Colors.purple）
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
    // 从主题里取出主色，让按钮背景和主题保持一致
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('布局练习'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // 只占内容高度，不撑满整屏
          children: [
            // 商品标题
            const Text(
              'Flutter 入门课程',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // TODO-3：在这里补一个 SizedBox，给标题和价格标签之间留 12 的间距
            // （提示：const SizedBox(height: 12)）
            ___TODO___,

            // =============================================
            // TODO-1：完成"价格标签"（胶囊形 pill）
            // 要求：橙色背景 + 胶囊形圆角 + 上下 6 / 左右 16 的内边距 + 白色加粗文字
            // 提示：
            //   Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            //     decoration: BoxDecoration(
            //       color: Colors.orange,
            //       borderRadius: BorderRadius.circular(20), // 圆角够大就是"胶囊形"
            //     ),
            //     child: const Text(
            //       '¥ 99',
            //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            //     ),
            //   )
            // =============================================
            ___TODO___,

            // TODO-3：在这里补一个 SizedBox，给标签和按钮之间留 20 的间距
            // （提示：const SizedBox(height: 20)）
            ___TODO___,

            // =============================================
            // TODO-2：完成"按钮"外观（这里先不做点击，只做样式）
            // 要求：主色背景（用上面的 primary）+ 圆角 12 + 上下 14 / 左右 32 的内边距 + 白色加粗文字
            // 提示：
            //   Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            //     decoration: BoxDecoration(
            //       color: primary, // 主色背景
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: const Text(
            //       '立即购买',
            //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            //     ),
            //   )
            // =============================================
            ___TODO___,
          ],
        ),
      ),
    );
  }
}
