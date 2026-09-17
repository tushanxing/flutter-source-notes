// =============================================================
// 🔴 挑战题：商品卡片（Product Card）
// 目标：从零独立搭建一张"商品卡片"：商品图占位块 + 标题 + 价格 + 购买按钮。
// 预计用时：25-35 分钟
//
// 需求（请逐条实现）：
//   1. 页面顶部有 AppBar，标题是"商品卡片"
//   2. 用 Container 做一个"商品图占位块"（没有真实图片，用背景色 + 居中的图标或文字表示）
//   3. 显示商品标题（大字号、加粗）
//   4. 显示价格（用主题色、加粗、带 ¥ 符号）
//   5. 显示一个"购买按钮"（可用 ElevatedButton / TextButton，也可以用 Container 模拟）
//   6. 整个卡片用 Container 或 Card 包裹，加圆角和阴影
//   7. 用 ColorScheme.fromSeed 自定义一个你喜欢的主题色
//
// 可以使用的 Widget 清单（本次练习只需用到这些，不够也可以查官方文档）：
//   MaterialApp / Scaffold / AppBar / Center / Column / Row
//   Container / Padding / SizedBox / Text / Icon / Card
//   ElevatedButton / TextButton（按钮）
//   BoxDecoration / BorderRadius / EdgeInsets
//
// 常见误区提醒（务必注意）：
//   - Container 同时要"背景色 + 圆角"时，必须放进 BoxDecoration，
//     不能写 Container(color: ..., borderRadius: ...)
//   - Column 里的内容用 SizedBox 控制间距
//   - const 上下文里不能用 Colors.grey[600]（运行时运算符），用 Colors.grey 或 Color(0xFF...)
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
      title: '商品卡片',
      // TODO：把 seedColor 换成你喜欢的颜色
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProductCardPage(),
    );
  }
}

class ProductCardPage extends StatelessWidget {
  const ProductCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // =============================================================
    // TODO：在下面完成你的商品卡片
    //
    // 参考结构（从上到下）：
    //   Scaffold
    //     ├─ appBar: AppBar(title: Text('商品卡片'))
    //     └─ body: Center
    //          └─ Card（圆角卡片，shape 设置 borderRadius）
    //               └─ Padding（卡片内边距）
    //                    └─ Column
    //                         ├─ Container（商品图占位块：背景色 + 居中图标/文字，高约 160）
    //                         ├─ Text（商品标题，大字号加粗）
    //                         ├─ Text（价格：主题色加粗，带 ¥）
    //                         └─ 按钮（购买按钮）
    // =============================================================
    // 把你的代码写在下面（替换掉 return 后面的占位内容）：
    return const Scaffold(
      body: Center(
        child: Text('在这里开始搭建你的商品卡片吧！'),
      ),
    );
  }
}
