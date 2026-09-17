// =============================================================
// 🔴 挑战题：个人名片（Business Card）
// 目标：从零独立搭建一个"个人名片"页面，综合运用今天学到的 Widget。
// 预计用时：25-35 分钟
//
// 需求（请逐条实现）：
//   1. 页面顶部有 AppBar，标题是"我的名片"
//   2. 用 CircleAvatar 做一个圆形"文字头像"（显示你姓名/昵称的第一个字）
//   3. 显示你的姓名（较大字号、加粗）
//   4. 显示你的职位/头衔（较小字号、灰色）
//   5. 显示一句个人简介（居中文本）
//   6. 用 2-3 行"图标 + 文字"展示联系方式（如电话、邮箱、城市），图标用 Icon + Icons.xxx
//   7. 用 Card 或 Container 给名片加一个圆角卡片背景
//   8. 用 ColorScheme.fromSeed 自定义一个你喜欢的主题色
//
// 可以使用的 Widget 清单（本次练习只需用到这些，不够也可以查官方文档）：
//   MaterialApp / Scaffold / AppBar / Center / Column / Row
//   CircleAvatar / Text / Icon / Card / Container / SizedBox / Padding / ListTile
//
// 常见误区提醒（务必注意）：
//   - CircleAvatar 里用 child 放文字/图标，不要用 Image 塞进 child
//   - Column 里的内容用 SizedBox 控制间距
//   - 每一行"图标+文字"可以直接用 ListTile（leading 放图标，title 放文字）
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
      title: '个人名片',
      // TODO-8：把 seedColor 换成你喜欢的颜色
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BusinessCardPage(),
    );
  }
}

class BusinessCardPage extends StatelessWidget {
  const BusinessCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // =============================================================
    // TODO：在下面完成你的名片页面搭建
    //
    // 参考结构（从上到下）：
    //   Scaffold
    //     ├─ appBar: AppBar(title: Text('我的名片'))
    //     └─ body: Center
    //          └─ Card（圆角卡片，用 shape 设置 borderRadius）
    //               └─ Padding（卡片内边距）
    //                    └─ Column
    //                         ├─ CircleAvatar（文字头像，radius + child: Text(首字)）
    //                         ├─ Text（姓名，大字号加粗）
    //                         ├─ Text（职位，灰色）
    //                         ├─ Text（简介，居中）
    //                         ├─ Divider（分隔线，可选）
    //                         └─ 若干 ListTile（图标 + 文字，展示联系方式）
    // =============================================================
    // 把你的代码写在下面（替换掉 return 后面的占位内容）：
    return const Scaffold(
      body: Center(
        child: Text('在这里开始搭建你的名片吧！'),
      ),
    );
  }
}
