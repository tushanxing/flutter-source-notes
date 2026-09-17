# Day 1 · Hello World —— 递进练习

> 对应教材：《Learn Google Flutter Fast: 65 Example Apps》第 1 个 Example App「Hello World」

## 本课核心知识点

| 知识点 | 作用 |
|--------|------|
| `main()` | Dart 程序入口函数，Flutter 从这里开始执行 |
| `runApp()` | 启动 Flutter 应用，把根组件挂到屏幕上 |
| `MaterialApp` | 应用根组件，提供 Material 设计风格与主题 |
| `Scaffold` | 页面骨架，提供背景色、AppBar、安全区域适配 |
| `AppBar` | 顶部标题栏 |
| `Center` | 让子组件在屏幕上居中 |
| `Text` | 显示文字 |

## 练习总览

| 练习 | 级别 | 时长 | 形式 | 目标 |
|------|------|------|------|------|
| 练习 1 | 🟢 基础题 | 10 分钟 | 填空式 | 补全 Hello World 骨架 |
| 练习 2 | 🟡 进阶题 | 15-25 分钟 | 框架补全 | 改造 Hello World |
| 练习 3 | 🔴 挑战题 | 25-35 分钟 | 自由设计 | 独立搭建个人名片 |

## 文件清单

| 文件 | 说明 |
|------|------|
| `exercise1_hello_world.dart` | 🟢 基础题起步代码（含 `___TODO___` 占位） |
| `solution1_hello_world.dart` | 🟢 基础题参考答案 |
| `exercise2_titled_app.dart` | 🟡 进阶题起步代码（含 TODO 注释） |
| `solution2_titled_app.dart` | 🟡 进阶题参考答案 |
| `exercise3_business_card.dart` | 🔴 挑战题起步代码（需求 + Widget 清单） |
| `solution3_business_card.dart` | 🔴 挑战题参考答案 |

## 如何运行练习代码

1. 新建一个 Flutter 项目：
   ```bash
   flutter create day1_exercise
   cd day1_exercise
   ```
2. 打开 `lib/main.dart`，把里面默认内容**全部删除**，替换成对应练习文件里的代码。
3. 运行：
   ```bash
   flutter run
   ```

> 提示：可以运行在 Android/iOS 模拟器、真机，或 Chrome（Web）上。

---

## 练习 1：Hello World 填空（🟢 基础题 · 10 分钟）

**文件**：`exercise1_hello_world.dart`

**目标**：把代码里的 `___TODO___` 占位符替换成正确的代码，让程序显示 "Hello World"。

**完成标准**（全部满足才算完成）：

- [ ] `main()` 里调用了 `runApp()`
- [ ] 根组件返回了 `MaterialApp`
- [ ] 页面用 `Scaffold` 包裹
- [ ] `AppBar` 标题显示 "Hello World"
- [ ] `body` 里用 `Center` + `Text` 让文字居中显示
- [ ] 运行后屏幕中央显示 "Hello World"，无报错

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
      title: 'Hello World',
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
        title: const Text('Hello World'),
      ),
      body: const Center(
        child: Text(
          'Hello World',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
```

</details>

---

## 练习 2：改造 Hello World（🟡 进阶题 · 15-25 分钟）

**文件**：`exercise2_titled_app.dart`

**目标**：在 Hello World 基础上完成 4 项升级：改标题、加副标题、加图标、自定义 Material 3 主题色。

**完成标准**：

- [ ] AppBar 标题改成了自己的 App 名字
- [ ] 正文下方加了一行副标题文本（较小字号 + 灰色）
- [ ] 正文上方加了一个图标（`Icon` + `Icons.xxx`）
- [ ] 用 `ColorScheme.fromSeed` 自定义了主题色
- [ ] 运行后整体布局从上到下依次为：图标 → 标题 → 副标题，且垂直居中

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
      title: '我的学习笔记',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的学习笔记'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.favorite, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              'Hello World',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '欢迎回来，今天也要加油！',
              style: TextStyle(fontSize: 16, color: Colors.grey),
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

## 练习 3：个人名片（🔴 挑战题 · 25-35 分钟）

**文件**：`exercise3_business_card.dart`

**目标**：从零独立搭建一个"个人名片"页面，综合运用今天学到的 Widget（完整需求见文件顶部注释）。

**需求清单**：

1. 页面顶部有 AppBar，标题是"我的名片"
2. 用 `CircleAvatar` 做一个圆形"文字头像"（显示姓名首字）
3. 显示姓名（大字号、加粗）
4. 显示职位/头衔（小字号、灰色）
5. 显示一句个人简介（居中文本）
6. 用 2-3 行"图标 + 文字"展示联系方式（电话、邮箱、城市）
7. 用 `Card` 或 `Container` 加圆角卡片背景
8. 用 `ColorScheme.fromSeed` 自定义主题色

**完成标准**：

- [ ] 页面能运行，无报错
- [ ] AppBar 标题为"我的名片"
- [ ] 有圆形文字头像（`CircleAvatar` + `child: Text(首字)`，**不要**用 `Image` 塞 `child`）
- [ ] 姓名、职位、简介三项齐全
- [ ] 至少 2 行"图标 + 文字"联系方式
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
      title: '个人名片',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
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
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的名片'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: primary,
                  child: const Text(
                    '张',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '张三',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Flutter 开发者',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  '热爱用代码创造美好体验，正在学习 Flutter。',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 8),
                const ListTile(
                  leading: Icon(Icons.phone, color: Colors.indigo),
                  title: Text('138-0000-0000'),
                  dense: true,
                ),
                const ListTile(
                  leading: Icon(Icons.email, color: Colors.indigo),
                  title: Text('zhangsan@example.com'),
                  dense: true,
                ),
                const ListTile(
                  leading: Icon(Icons.location_on, color: Colors.indigo),
                  title: Text('中国 · 北京'),
                  dense: true,
                ),
              ],
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

1. **忘记 `runApp()`** → 屏幕白屏，且不报错。务必 `runApp(const MyApp())`。
2. **缺少 `Scaffold`** → 黑屏或文字贴在屏幕左上角无背景。页面骨架必须用 `Scaffold`。
3. **`const` 里不能用 `Colors.grey[600]`** → 这是运行时运算符，不是编译时常量。用 `Colors.grey` 或 `Color(0xFF757575)`。
4. **`CircleAvatar` 用错 `child`** → 图片用 `backgroundImage`，文字/图标用 `child`。文字头像直接用 `child: Text(首字)` 最省事。
