# Day 2 · 容器与单子布局基础 —— 递进练习

> 对应教材：《Learn Google Flutter Fast: 65 Example Apps》第 17 章「Single-Child Layout Widgets」（单子布局 · 第一部分）

## 📖 先看笔记再动手

- 📕 **学习笔记（深度学习）**：`~/flutter-learning/day2_study.md` —— 含 Container / Padding / SizedBox / Center / Card 详解 + 踩坑记录 + 逻辑像素 vs 物理像素（DPR）
- 📚 **配着书学**：⑧《Flutter 组件详解与实战》第 1 章「基础布局」｜⑦《从零基础到精通》第 4 章「Flutter 组件」｜③《Flutter Essence》的 **Layout Cheat Sheet**

## 本课核心知识点

| 知识点 | 作用 |
|--------|------|
| `Text` | 显示文字，`style` 控制字号、颜色、粗细 |
| `Container` | 万能容器，设置内边距、背景色、圆角、宽高 |
| `Padding` | 给子组件加内边距（等价于 `Container` 的 `padding` 参数） |
| `SizedBox` | 固定尺寸的"空盒子"，最常用于在两个组件之间留间距 |
| `Center` | 让子组件在屏幕上居中（昨天学过，今天继续用） |
| `BoxDecoration` | 给 `Container` 加装饰（背景色、圆角、边框、阴影） |
| `BorderRadius` / `EdgeInsets` | 圆角 / 边距的辅助类 |

## 练习总览

| 练习 | 级别 | 时长 | 形式 | 目标 |
|------|------|------|------|------|
| 练习 1 | 🟢 基础题 | 10-15 分钟 | 填空式 | 用 Container + Padding + Text 搭一张圆角卡片 |
| 练习 2 | 🟡 进阶题 | 15-25 分钟 | 框架补全 | 组合多个 Container 和 SizedBox（价格标签 + 按钮样式） |
| 练习 3 | 🔴 挑战题 | 25-35 分钟 | 自由设计 | 独立搭建"商品卡片" |

## 文件清单

| 文件 | 说明 |
|------|------|
| `exercise1_container_card.dart` | 🟢 基础题起步代码（含 `___TODO___` 占位） |
| `solution1_container_card.dart` | 🟢 基础题参考答案 |
| `exercise2_layout.dart` | 🟡 进阶题起步代码（含 TODO 注释 + 占位） |
| `solution2_layout.dart` | 🟡 进阶题参考答案 |
| `exercise3_product_card.dart` | 🔴 挑战题起步代码（需求 + Widget 清单） |
| `solution3_product_card.dart` | 🔴 挑战题参考答案 |

## 如何运行练习代码

1. 新建一个 Flutter 项目：
   ```bash
   flutter create day2_exercise
   cd day2_exercise
   ```
2. 打开 `lib/main.dart`，把里面默认内容**全部删除**，替换成对应练习文件里的代码。
3. 运行：
   ```bash
   flutter run
   ```

> 提示：可以运行在 Android/iOS 模拟器、真机，或 Chrome（Web）上。

---

## 练习 1：Container 卡片填空（🟢 基础题 · 10-15 分钟）

**文件**：`exercise1_container_card.dart`

**目标**：把代码里的 `___TODO___` 占位符替换成正确的代码，让程序在屏幕中央显示一张"带背景色 + 圆角 + 内边距"的文字卡片。

**完成标准**（全部满足才算完成）：

- [ ] `main()` 里调用了 `runApp(const MyApp())`
- [ ] 根组件返回了 `MaterialApp`，首页是 `HomePage`
- [ ] `body` 用 `Center` 让卡片居中
- [ ] `Container` 设置了 `padding: EdgeInsets.all(24)`
- [ ] 用 `BoxDecoration` 同时设置了背景色和圆角（**不是** `Container` 的 `color` 属性）
- [ ] 卡片内有一段文字（`Text`），有自己的字号和颜色
- [ ] 运行后屏幕中央显示一张圆角卡片，无报错

<details>
<summary>点击展开练习 1 参考答案</summary>

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '卡片练习',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Container 卡片'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24), // 四边内边距 24
          decoration: BoxDecoration(
            color: Color(0xFFE3F2FD),          // 浅蓝色背景
            borderRadius: BorderRadius.circular(16), // 圆角 16
          ),
          child: const Text(
            '今天也要加油！',
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
```

</details>

---

## 练习 2：布局练习（🟡 进阶题 · 15-25 分钟）

**文件**：`exercise2_layout.dart`

**目标**：用多个 `Container` 搭出"价格标签"和"按钮样式"两种 UI 元素，并用 `SizedBox` 控制间距。

**完成标准**：

- [ ] 完成"价格标签"：胶囊形圆角 + 背景色 + 白色加粗文字
- [ ] 完成"按钮"外观：主色背景（`Theme.of(context).colorScheme.primary`）+ 圆角 + 内边距 + 白色加粗文字
- [ ] 标题 / 标签 / 按钮之间用 `SizedBox` 留出间距
- [ ] 用 `ColorScheme.fromSeed` 自定义了主题色
- [ ] 运行后从上到下依次为：标题 → 价格标签 → 按钮，且整体垂直居中

<details>
<summary>点击展开练习 2 参考答案</summary>

```dart
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('布局练习'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // 只占内容高度，不撑满整屏
          children: [
            const Text(
              'Flutter 入门课程',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12), // 标题与标签间距
            // 价格标签：胶囊形 pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20), // 圆角够大就是"胶囊形"
              ),
              child: const Text(
                '¥ 99',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20), // 标签与按钮间距
            // 按钮外观（暂不处理点击）
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                color: primary, // 主色背景
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '立即购买',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

</details>

---

## 练习 3：商品卡片（🔴 挑战题 · 25-35 分钟）

**文件**：`exercise3_product_card.dart`

**目标**：从零独立搭建一张"商品卡片"：商品图占位块 + 标题 + 价格 + 购买按钮（完整需求见文件顶部注释）。

**需求清单**：

1. 页面顶部有 AppBar，标题是"商品卡片"
2. 用 `Container` 做一个"商品图占位块"（背景色 + 居中的图标或文字，高约 160）
3. 显示商品标题（大字号、加粗）
4. 显示价格（主题色、加粗、带 ¥ 符号）
5. 显示一个"购买按钮"（`ElevatedButton` / `TextButton` 或 `Container` 模拟）
6. 整个卡片用 `Card` 或 `Container` 包裹，加圆角和阴影
7. 用 `ColorScheme.fromSeed` 自定义主题色

**完成标准**：

- [ ] 页面能运行，无报错
- [ ] AppBar 标题为"商品卡片"
- [ ] 有"商品图占位块"（背景色 + 图标/文字，不要引用不存在的图片文件）
- [ ] 标题、价格、购买按钮三项齐全
- [ ] 价格用主题色（如 `Theme.of(context).colorScheme.primary`）
- [ ] 有圆角卡片背景
- [ ] 自定义了主题色

<details>
<summary>点击展开练习 3 参考答案</summary>

```dart
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
      debugShowCheckedModeBanner: false, // 隐藏右上角的 DEBUG 标签，让卡片更美观
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
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
    // 从主题里取出主色，用于价格文字和按钮，让配色统一
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('商品卡片'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 300, // 固定卡片宽度，避免在平板上被拉得过宽
          child: Card(
            elevation: 4, // 卡片阴影高度
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // 卡片圆角
            ),
            child: Padding(
              padding: const EdgeInsets.all(16), // 卡片内边距
              child: Column(
                mainAxisSize: MainAxisSize.min, // 只占内容高度
                crossAxisAlignment: CrossAxisAlignment.start, // 内容靠左对齐
                children: [
                  // 商品图占位块：没有真实图片，用背景色 + 居中图标表示
                  Container(
                    height: 160,
                    width: double.infinity, // 占满卡片宽度
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3E0), // 浅橙色背景
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shopping_bag, // 购物袋图标
                        size: 64,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 商品标题
                  const Text(
                    'Flutter 入门课程',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // 价格行：现价 + 划线原价（可选加分项）
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '¥ 199',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primary, // 用主题主色
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '¥ 299',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough, // 划线表示原价
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 购买按钮：占满卡片宽度
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {}, // 点击事件留空，后续章节会学
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary, // 按钮背景：主色
                        foregroundColor: Colors.white, // 按钮文字：白色
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '立即购买',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

</details>

---

## 常见误区速查（先看再写）

1. **`Container` 同时要"背景色 + 圆角"时，不能写 `Container(color: ..., borderRadius: ...)`** → `color` 和圆角不能直接搭配。正确做法是放进 `decoration: BoxDecoration(color: ..., borderRadius: ...)`。
2. **`const` 里不能用 `Colors.grey[600]`** → `grey[600]` 是运行时运算符，不是编译时常量。用 `Colors.grey` 或 `Color(0xFF757575)`。
3. **忘记 `runApp()`** → 屏幕白屏，且不报错。务必 `runApp(const MyApp())`。
4. **缺少 `Scaffold`** → 黑屏或文字贴在屏幕左上角无背景。页面骨架必须用 `Scaffold`。
5. **`SizedBox` 的用法** → 控制间距用 `SizedBox(height: ...)`；控制宽度用 `SizedBox(width: ...)`；要"占满可用宽度"用 `SizedBox(width: double.infinity, ...)`。
