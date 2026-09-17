# 📱 Flutter 学习笔记 · 第 1 课「Hello World」— 多书合集 · L3 版

> 课程来源**：①《Learn Google Flutter Fast: 65 Example Apps》ch9｜**学习日期**：2026-08-13（Day 1）｜**L3 升级**：2026-09-16
>**今日目标**：看懂并手写你的第一个 Flutter 程序，理解 Flutter 最底层的几个概念
> **前置知识**：你有 Python/Java/JS 基础，但没有移动端经验 —— 本笔记专门为这个起点设计
> 🎯 **L3 目标**：不止「会写 Hello World」。要能回答：**`runApp` 那一行到底做了什么？为什么说「Widget 不是界面」？`Center` 的源码为什么只有 4 行却能居中？`Scaffold` 除了背景色还白送了什么？**

---

## 📎 看不懂「文件:行号」？先读这里

本笔记每处 `widgets/binding.dart:1883` 这类标注，**都紧跟代码块贴出真实源码**（本机 SDK 3.44.0 磁盘逐字读出）。

- `1883|` 是**磁盘真实行号，不是代码的一部分** —— 只看 `|` 右边。
- 自己核对：
  ```bash
  sed -n '1883,1886p' /opt/homebrew/share/flutter/packages/flutter/lib/src/widgets/binding.dart
  ```
- 全量源码对照册：[`day1_source_appendix.md`](./day1_source_appendix.md)
  ```bash
  python3 /Volumes/external/learning/flutter-learning/shared/tools/extract_refs.py \
          /Volumes/external/learning/flutter/day1_study.md --emit
  python3 /Volumes/external/learning/flutter-learning/shared/tools/verify_inline_code.py \
          /Volumes/external/learning/flutter/day1_study.md
  ```

---

## 一、核心概念定义（先建立正确的第一印象）

### 1. Flutter 是什么？

**Flutter 是 Google 开发的跨平台 UI 框架**。你用 **Dart 语言**写一套代码，就能同时编译成 iOS 应用、Android 应用、网页、桌面程序。核心理念：**「一切皆 Widget」（Everything is a Widget）** —— 界面上你能看到的每一个东西，本质都是一个 Widget。

> 💡 类比：Flutter 就像一套**乐高积木系统**。你不需要为 iOS 造一套零件、为 Android 再造一套，而是用同一批「积木」拼出界面，最后由 Flutter 帮你翻译成各平台能运行的「成品」。

### 2. Widget 是什么？（🃏 术语卡 1 —— **本日头号术语**）

- **一句话本质**：**一段不可变的「界面配置说明书」** —— 描述「界面上某一块长什么样、该怎么显示」的数据对象。**它不是屏幕上的像素。**
- **源码依据**（今天最重要的三行）：

```dart
// widgets/framework.dart:312-314（Widget 类声明 · 磁盘逐字）
 312| abstract class Widget extends DiagnosticableTree {
 313|   /// Initializes [key] for subclasses.
 314|   const Widget({this.key});
        //   ↑ ⭐ 构造函数是 const ⇒ Widget 是【不可变】的配置对象
```

```dart
// widgets/framework.dart:340-349（createElement —— 三棵树的入口 · 磁盘逐字 · 节选：略去 :341 空行）
 340|   /// Inflates this configuration to a concrete instance.
        //   ↑ 中文：「把这份配置『充气』成一个具体实例」
 342|   /// A given widget can be included in the tree zero or more times. In particular
 343|   /// a given widget can be placed in the tree multiple times. Each time a widget
 344|   /// is placed in the tree, it is inflated into an [Element], which means a
 345|   /// widget that is incorporated into the tree multiple times will be inflated
 346|   /// multiple times.
        //   ↑ ⭐ 中文：同一个 Widget 可以被放进树里多次；【每次放进树，都会被 inflate 成一个 Element】
        //     ⇒ 这就是「Widget 是图纸、Element 是照图纸盖的房子」的官方出处
 347|   @protected
 348|   @factory
 349|   Element createElement();      // ← ⭐⭐ 抽象方法：每个 Widget 都必须能造出一个 Element
```

> 🔑 **读懂这三行，你就懂了 Flutter 的世界观**：
> - `const Widget({this.key})` ⇒ Widget **不可变**（配置写完就定死了）；
> - `Element createElement()` ⇒ **每个 Widget 都要「充气」成一个 Element 才能真正进树**；
> - 所以「你写的 Widget」和「屏幕上跑的东西」**根本不是同一个对象**。
>
> ⚠️ **常见误解**：❌「Widget 就是界面上的东西」→ 不。Widget 是**描述**，真正干活的是 Element（管理生命周期）和 RenderObject（布局+绘制）。**三层各干什么、怎么联动，Day 33 系统化讲**（今天只认脸，不深入 —— 见 §八 欠账 1）。

> ⚠️ **另一条关键区分（你周考口述曾持有错误模型）**：约束是**父单方面下达的硬边界**，子不可突破 —— 不存在「内部约束高于外部时按父或子绘制」。今天先记住「Widget 是配置」，Day 2 讲约束时会正式建立这条。

### 3. 声明式 UI vs 命令式 UI

这是 Flutter 和传统开发（Android 原生、iOS 原生、早期 Swing）最根本的区别：

| | 命令式 UI（传统） | 声明式 UI（Flutter） |
|---|---|---|
| **思路** | 告诉程序**「怎么做」**：先拿到按钮对象，再一步步 `button.setText(...)`、`button.setColor(...)` | 告诉程序**「要什么」**：直接声明「界面上应该有一个红色的按钮」，Flutter 负责渲染成那样 |
| **状态变化时** | 手动找到控件，逐个属性去改 | 重建整个 Widget 描述，Flutter 自动对比差异、只更新变化的部分 |
| **类比** | 自己当装修工人，一砖一瓦地改 | 当甲方出图纸，说出你要的效果，施工队照图施工 |

一句话概括本质：**命令式是「改控件」，声明式是「描述界面」**。这个心智模型是理解 Flutter 一切的关键。

> 🔗 **源码印证**：`framework.dart:316-323` 的 `key` 字段文档原话 —— 「如果两个 widget 的 `runtimeType` 和 `key` 相等，新 widget 就**替换**旧的（通过 `Element.update`）；否则旧 element 被移除、新 widget 被 inflate 成新 element 插入树中」。**这就是「Flutter 自动对比差异」的机制出处**（Day 32 Keys 专题会深挖）。

---

## 二、生活化类比（把抽象概念变成画面）

| 抽象概念 | 生活化类比 |
|---|---|
| **Widget** | **乐高积木块**。每一块都有固定形状和用途，可以无限组合。 |
| **Widget 树** | **俄罗斯套娃**，或倒过来的**家族族谱**。最大的套中号、中号套小号……界面就是一层层「嵌套」出来的：`MaterialApp` → `Scaffold` → `Center` → `Text`。 |
| **runApp()** | **「点火/插电」动作**。积木搭好了，不调 `runApp()` 等于拼好的积木瘫在桌上 —— **没通电，屏幕不会亮**。 |
| **MaterialApp** | **「整套房子的地基和物业管理」**：决定整体主题色、字体、页面路由这些全局规则。 |
| **Scaffold** | **「房子的承重骨架」**：预留好天花板（AppBar）、地板（bottomNavigationBar）、墙壁（body）的位置。没有它，家具（文字）没地方摆。 |
| **build() 方法** | **「装配说明图纸」**。Flutter 问「这个组件长啥样？」，你通过 build() 返回一摞 Widget 作为回答。 |
| **StatelessWidget** | **「静物画」**：画好之后永远不变，没有内部状态。 |
| **Widget vs Element**（今天新增） | **图纸 vs 房子**。Widget 是图纸（可以复印很多份、不可改），Element 是照图纸盖出来的房子（真实占着地、有生命周期）。源码 `:344` 的 "inflated into an Element" 就是这个意思。 |

---

## 三、今天结束前要能口述的 3 句

> 每句都必须能指到**源码行号**（导师会追问）。

1. **`runApp` 只有 3 行：初始化绑定 → 把根 widget 包进默认 View → 调度「挂载根 widget + 热身一帧」。** 它干的是「通电」，不是「画画」。
   > 依据：`widgets/binding.dart:1883-1886`（全文 3 行）+ `:1948-1953`（`_runWidget` 的 `scheduleAttachRootWidget` + `scheduleWarmUpFrame`）。

2. **Widget 是「不可变的配置」，不是界面本身 —— 每个 Widget 进树时都会被 `createElement()` 充气成一个 Element。** 所以「我写的 Widget」和「屏幕上跑的东西」不是同一个对象。
   > 依据：`widgets/framework.dart:312-314`（`const Widget({this.key})`）+ `:340-349`（`Element createElement();` 抽象方法 + 官方文档 "Each time a widget is placed in the tree, it is inflated into an Element"）。

3. **`Center` 的源码只有 4 行，它之所以能居中，是因为它继承 `Align` 而 `Align` 的 `alignment` 参数默认值就是 `Alignment.center`。**
   > 依据：`widgets/basic.dart:2550-2553`（Center 全部源码）+ `:2466-2468`（`this.alignment = Alignment.center`）。

---

## 四、关键 Widget / API 逐个讲解

先看**完整可运行代码**，再逐个拆解：

```dart
// 1. 导入 Flutter 的 Material 组件库（几乎所有 App 都要这一行）
import 'package:flutter/material.dart';

// 2. 程序入口：main() 函数，App 从这里开始执行
void main() {
  // 3. runApp()：把根 Widget「插上电」，Flutter 开始渲染
  runApp(const MyApp());
}

// 4. 自定义的根 Widget：继承 StatelessWidget（无状态组件）
class MyApp extends StatelessWidget {
  const MyApp({super.key});          // 构造函数（super.key 见 §六-5.5）

  // 5. build()：返回「这个组件长什么样」
  @override
  Widget build(BuildContext context) {
    // 6. MaterialApp：全局外壳，定义主题和首页
    return MaterialApp(
      title: 'Hello World',      // 应用标题（系统任务切换器里显示，界面上看不到）
      home: Scaffold(            // 7. 首页交给 Scaffold 搭建骨架
        appBar: AppBar(          // 8. 顶部标题栏
          title: const Text('Hello World'),
        ),
        body: const Center(      // 9. 正文区：让内容居中
          child: Text(           // 10. 要显示的文字
            'Hello World!',
          ),
        ),
      ),
    );
  }
}
```

**运行效果**：一个带顶部标题栏、正文区正中央显示 "Hello World!" 的应用。

### 4.1 `main()` —— 程序的入口

Dart 和 C/Java 一样，程序从 `main()` 开始执行，是**整个 App 的起点**。

```dart
void main() {
  // 这里写 App 启动后第一件要做的事
}
```

- `void`：这个函数不返回任何值。
- 你以前写 Java 的 `public static void main(String[] args)`，在 Dart 里就是简洁的 `void main()` —— **不需要类包裹，直接写在文件顶层**。

### 4.2 `runApp()` —— 让界面「亮起来」（💎 今天最该读的 3 行源码）

```dart
// widgets/binding.dart:1883-1886（runApp 全文 —— 就 3 行！磁盘逐字）
 1883| void runApp(Widget app) {
 1884|   final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
        //   ↑ ① 确保「绑定」已初始化（绑定 = Flutter 与底层引擎/系统的总管家）
 1885|   _runWidget(binding.wrapWithDefaultView(app), binding, 'runApp');
        //   ↑ ② 把你的根 widget 包进「默认 View」，再交给 _runWidget
 1886| }
```

```dart
// widgets/binding.dart:1948-1953（_runWidget 全文 · 磁盘逐字）
 1948| void _runWidget(Widget app, WidgetsBinding binding, String debugEntryPoint) {
 1949|   assert(binding.debugCheckZone(debugEntryPoint));
 1950|   binding
 1951|     ..scheduleAttachRootWidget(app)      // ← ⭐ ③ 调度「把根 widget 挂到树上」
 1952|     ..scheduleWarmUpFrame();             // ← ⭐ ④ 调度「热身一帧」⇒ 界面这才亮起来
 1953| }
```

> ⚠️ **注意 `:1950-1952` 的 `..` 是 Dart 的「级联调用」语法**（§六-5.6 有讲）：`binding..A()..B()` = 对同一个 binding 连续调 A 和 B。**这不是 Flutter 特有的东西，是 Dart 语法** —— 第一次见容易懵，特意标出来。

**这 3+5 行源码回答了 4 个问题**：

| 问题 | 源码答案 |
|---|---|
| `runApp` 是「画画」吗？ | **不是**。它只做「初始化 + 挂载 + 调度一帧」，真正画画在后面的帧流程里（layout → paint，Day 2/33） |
| 为什么忘了 `runApp` 就白屏？ | 因为 `MyApp()` 只是**造了一个配置对象**（图纸），没人把它「充气」进树、没人调度帧 ⇒ 屏幕什么都没被要求画（误区 1） |
| 「根 widget」是什么意思？ | `:1885` 的 `wrapWithDefaultView(app)` —— 你的 MyApp 被包进一个 View，成为整棵树的**根** |
| 为什么叫「热身帧」？ | `scheduleWarmUpFrame`（`:1952`）—— 第一帧是「预热」，让树先建起来再画 |

> 🔥 **这是整个 Hello World 的「命门」**：`main()` 里如果忘了调用 `runApp()`，程序能编译通过、也不报错，但**屏幕永远一片空白**。

### 4.3 `MaterialApp` —— 全局外壳

```dart
return MaterialApp(
  title: 'Hello World',     // 应用名，显示在系统任务切换器
  home: Scaffold(...),      // 首页（第一个显示的页面）
);
```

- **一句话本质**：一个 **StatefulWidget**（`material/app.dart:217` `class MaterialApp extends StatefulWidget`），提供遵循 **Material Design** 的全局环境，负责主题、导航、本地化等全局事务。
- **常用参数**：

| 参数 | 作用 |
|---|---|
| `title` | 应用标题（**不是界面上显示的文字**，而是系统级应用名） |
| `home` | 首页 Widget，App 启动后第一个显示的页面 |
| `theme` | 全局主题（颜色、字体等 —— **Day 35 才深入**，今天不碰） |
| `debugShowCheckedModeBanner` | 是否显示右上角 "DEBUG" 标签（默认 true，正式发布前关掉） |

> 💡 新手常疑惑 `title` 为什么界面上看不到 —— 因为 `title` 是给**操作系统**看的（Android 任务列表里的名字），界面上真正显示的文字要靠 `AppBar` 和 `Text` 自己写。
>
> ⭐ **一条 Day 8 会救你一命的知识（提前埋）**：`MaterialApp` **自己不含 Material 层**（也不含 ScaffoldMessenger 之下的 Scaffold）—— 所以在 `MyApp.build` 里直接 `ScaffoldMessenger.of(context)` 会崩「No ScaffoldMessenger widget found」，因为那个 context 在 MaterialApp **之上**，`of()` 只朝树根方向找祖先、不往下看。**记住「context 属于写这段 build 的那个 Widget」。**

### 4.4 `Scaffold` —— 页面骨架（还白送一层 Material）

```dart
Scaffold(
  appBar: AppBar(...),     // 顶部栏（可选）
  body: Center(...),       // 正文主体（核心内容区）
)
```

- **一句话本质**：一个 **StatefulWidget**（`material/scaffold.dart:1686`），搭建页面**标准骨架**，自动处理背景色、安全区域（避开刘海/状态栏）。
- **常用参数**：

| 参数 | 作用 |
|---|---|
| `appBar` | 顶部标题栏（可选） |
| `body` | 页面主要内容区域（最重要） |
| `floatingActionButton` | 右下角悬浮按钮（后面课用） |
| `bottomNavigationBar` | 底部导航栏（Day 11 用） |

**⭐ Scaffold 白送的一层 Material（源码证据，Day 7 水波纹全靠它）**：

```dart
// material/scaffold.dart:3232-3238（Scaffold.build 的核心 · 磁盘逐字 · 节选）
 3232|     return _ScaffoldScope(
 3233|       hasDrawer: hasDrawer,
 3234|       geometryNotifier: _geometryNotifier,
 3235|       child: ScrollNotificationObserver(
 3236|         child: Material(
        //   ↑ ⭐⭐ 就是这一层！Scaffold 内部自己包了一个 Material
 3237|           color: widget.backgroundColor ?? themeData.scaffoldBackgroundColor,
        //   ↑ 背景色从这来（你没给 backgroundColor 就用主题的 scaffoldBackgroundColor）
 3238|           child: Builder(
```

> 🔑 **这一行解释了两件事**：
> 1. **为什么缺 Scaffold 会「黑屏/文字没底色」**（误区 2）—— 背景色是 `:3237` 这个 Material 画的，没有 Scaffold 就没人画背景。
> 2. **为什么按钮的水波纹能画出来**（Day 7）—— InkWell 的水波纹是「画在最近的 Material 上的墨迹」，**Scaffold 就自带一层 Material 当画布**。所以「所有页面都在 MaterialApp→Scaffold 里」不是习惯，是**机制需要**。

> ⚠️ 它和 `MaterialApp` 的关系：`MaterialApp` 管**整个 App** 的全局规则，`Scaffold` 管**单个页面**的布局骨架。**一个 App 只有一个 `MaterialApp`，但可以有多个 `Scaffold`**（每页一个）。

### 4.5 `AppBar` —— 顶部标题栏（为什么 Scaffold 认得它）

```dart
AppBar(
  title: const Text('Hello World'),  // 标题栏中间显示的文字
)
```

- **一句话本质**：页面顶部的应用栏，放标题、返回按钮、操作按钮。

```dart
// material/app_bar.dart:189（类声明 —— 注意 implements 后面那个）
 189| class AppBar extends StatefulWidget implements PreferredSizeWidget {
        //   ↑ ⭐ 它「实现了 PreferredSizeWidget」= 承诺「我知道自己要多高」
```

> 🔑 **为什么这一行重要**：`Scaffold.appBar` 参数的类型是 `PreferredSizeWidget?`，**不是 `AppBar`** —— 所以 Scaffold 不需要知道「你是什么组件」，只需要问「你要多高」（`preferredSize`）。**这就是「Scaffold 怎么知道该给顶部留 56 高」的答案**，也是为什么你可以用自定义组件当 appBar（只要它 implements PreferredSizeWidget）。这是 Flutter「**面向接口而非面向类型**」的第一个例子。
- **关键参数**：`title`（标题 Widget）、`actions`（右侧操作按钮组）、`leading`（左侧自定义组件，默认自动出现返回箭头）。

### 4.6 `Center` —— 居中容器（源码只有 4 行）

```dart
Center(
  child: Text('Hello World!'),  // 被居中的子组件
)
```

- **一句话本质**：**就是 `Align`，且 alignment 默认为 center** —— 源码全部：

```dart
// widgets/basic.dart:2550-2553（Center 的全部源码 —— 只有 4 行！磁盘逐字）
2550| class Center extends Align {
2551|   /// Creates a widget that centers its child.
2552|   const Center({super.key, super.widthFactor, super.heightFactor, super.child});
        //   ↑ ⭐ 注意：它【没有】alignment 参数 —— 所以它只能居中，做不到别的方位
2553| }
```

```dart
// widgets/basic.dart:2462-2468（Align 的构造函数 · 节选：略去 :2463-2465 的 key/文档 —— 秘密在默认值）
2462| class Align extends SingleChildRenderObjectWidget {
2466|   const Align({
2467|     super.key,
2468|     this.alignment = Alignment.center,      // ← ⭐⭐ 默认值就是 center！
```

> 🔑 **`Center` 一个字都没写，为什么会居中？** 因为它继承 `Align`，而 **`Align` 的 `alignment` 默认值就是 `Alignment.center`**（`:2468`）。`Center` = 「不暴露 alignment 参数的 Align」。
> **推论**：`Center(child: x)` ≡ `Align(alignment: Alignment.center, child: x)`；**想居左/居右/居上，Center 做不到**（没暴露参数）⇒ 直接用 `Align`。
> Align 对应的 RenderObject 是 `RenderPositionedBox`（`rendering/shifted_box.dart:397`）—— 「真正干活的那层」（Day 2 §4.3 会看到同款套路）。

- 没有 `Center` 时，`Text` 会贴在**左上角** —— 所以它是「让文字出现在屏幕正中」的关键。

### 4.7 `Text` —— 显示文字（它自己不画字）

```dart
Text('Hello World!')
```

- **一句话本质**：一个 **StatelessWidget**（`widgets/text.dart:497`），把「字符串 + 样式」翻译成 `RichText` —— **真正排版画字的是 RichText/RenderParagraph**。

```dart
// widgets/text.dart:780-800（Text.build 造 RichText · 磁盘逐字 · 节选：只留关键 4 行）
 780|       result = RichText(
 781|         textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
        //   ↑ ⭐ 默认对齐是 start（不是 center）；?? 链 = 优先级「你传的 > 默认样式 > start」
 786|         overflow: overflow ?? effectiveTextStyle?.overflow ?? defaultTextStyle.overflow,
 788|         maxLines: maxLines ?? defaultTextStyle.maxLines,
 799|         text: effectiveTextSpan,        // ← 你的字符串被包成 TextSpan 交给它
 800|       );
```

- **关键参数**（**Day 5 会整节展开**，今天认脸）：

| 参数 | 作用 |
|---|---|
| 第一个位置参数 | 要显示的文字内容（字符串）—— `:508` `String this.data` |
| `style` | 文字样式（`TextStyle`），控制字号、颜色、粗细 |
| `textAlign` | 文字对齐方式（⚠️ 默认 **start**，不是 center） |

> 🔑 **今天只需记住一句**：**`Text` 不画字，它把活交给 `RichText`**。这条 Day 5 会完整展开（含 `DefaultTextStyle` 的 merge 机制），Day 6 学 Icon 时你还会发现「Icon 也是造 RichText」—— **同一个套路用三次**。

---

## 五、新手常见误区（错误写法 vs 正确写法）

### 误区 1：忘记 `runApp()` → 白屏

**症状**：编译成功、不报错，但打开 App 屏幕一片空白。

```dart
// ❌ 错误：直接实例化 MyApp，但没交给 runApp
void main() {
  MyApp();   // 这行什么都没做，MyApp 被创建后立刻丢弃
}
// ✅ 正确：把根 Widget 交给 runApp，Flutter 才会渲染
void main() {
  runApp(const MyApp());
}
```

**原理（源码级）**：`MyApp()` 只是「造了一个配置对象」（图纸）；**只有 `runApp` 才会 `scheduleAttachRootWidget` + `scheduleWarmUpFrame`**（`binding.dart:1951-1952`）把图纸充气进树、调度第一帧。没人调度帧 ⇒ 屏幕永远空白。

### 误区 2：缺少 `Scaffold` → 黑屏或文字贴边

**症状**：屏幕黑底，或文字缩在左上角、背景全黑。

```dart
// ❌ 直接让 Center 当 home，没有 Scaffold
MaterialApp(home: Center(child: Text('Hello')))
// ✅ 用 Scaffold 提供页面骨架和背景
MaterialApp(home: Scaffold(body: Center(child: Text('Hello'))))
```

**原理（源码级）**：背景色是 **`scaffold.dart:3236-3237` 那层 Material** 画的（`color: widget.backgroundColor ?? themeData.scaffoldBackgroundColor`）。没有 Scaffold ⇒ 没人画背景 ⇒ 黑底。⚠️ **注意这是「视觉问题」，代码能正常编译运行**（三类错误的第 ③ 类，Day 3 §七 会正式建立分类）。

### 误区 3：`const` 关键字的坑

**症状**：加 `const` 报编译错误 `Const variables must be initialized with a constant value.`

```dart
// ❌ Colors.grey[600] 是「运行时查表」操作，不是常量
const Text('Hello', style: TextStyle(color: Colors.grey[600]))
// ✅ 去掉外层 const，允许运行时求值
Text('Hello', style: TextStyle(color: Colors.grey[600]))
// ✅ 或者改用编译期常量
const Text('Hello', style: TextStyle(color: Colors.grey))
```

**原理**：`const` 要求**编译时就能确定**的值。`Colors.grey` 是一张「色表」（`MaterialColor` 常量对象），`grey[600]` 是**调用它的 `[]` 运算符**（运行时方法调用）⇒ 编译期算不出来。同理 `Colors.blue[200]`、`Colors.grey.shade600`（getter 也是运行时）都不行。

> 🎯 三个 `const` 的经验法则：
> 1. **能加就加**：字面量字符串、`Colors.white` 这类编译期确定的值，加 `const` 能提升性能（Day 1 先照抄模板即可）。
> 2. **报错了就去掉**：凡是带 `[]` 取色或 `.shadeNNN` 的，都不能配 `const`。
> 3. **不用纠结**：去掉 `const` 程序照跑不误，它只是性能优化，不是正确性要求。
> ⚠️ **诚实欠账**：「const 具体省了多少重建」**未实测**（`identical(const SizedBox(8), const SizedBox(8))` 实测为 false）—— 留 Day 10 用真实重建场景验证。**今天别把 const 当性能银弹。**

### 误区 4：把 `title` 当成「界面上显示的文字」

```dart
// ❌ 误以为这样就能在屏幕上看到「我的应用」
MaterialApp(title: '我的应用', home: Scaffold(body: ...))
// ✅ 界面上真正显示的文字，要写在 Text / AppBar 里
MaterialApp(
  title: '我的应用',                                  // 只显示在系统任务切换器
  home: Scaffold(
    appBar: AppBar(title: const Text('我的应用')),     // 这才是界面上看到的标题
    body: const Center(child: Text('Hello World!')),
  ),
)
```

### 误区 5：混淆 `MaterialApp` 和 `Scaffold` 的职责

- **一个 App 只有一个 `MaterialApp`**（在最外层）。
- **一个页面一个 `Scaffold`**（可以有多个）。
- `Scaffold` 永远放在 `MaterialApp` 的 **`home`（或路由页面）里面**，**不是反过来**把 MaterialApp 塞进 Scaffold。
- ⚠️ **另一个同款错误（你 Day 3 犯过）**：把 `Scaffold` 的内容写成 `Scaffold(child: ...)` —— **Scaffold 没有 `child` 参数**，内容要写进 **`body:`**（`appBar` / `body` / `floatingActionButton` 都是具名槽位）。

### 误区 6：`Center` 里写 `children`（复数）

```dart
// ❌ Center 只有 child（单数），写 children 编译错「No named parameter」
Center(children: [Text('a')])
// ✅ 单数 child
Center(child: Text('a'))
```
**为什么会踩**：后面学 Column/Row（Day 8）时它们是 `children`（复数，多子布局）。**记法：单子布局组件用 `child`，多子布局组件用 `children`** —— Center/Padding/SizedBox/Card 都是单子（Day 2-3 学的那批）。

---

## 六、Dart 语法要点（本 App 用到的语法）

### 6.1 入口 `main()` 函数
```dart
void main() {
  // 顶层函数，不需要包在类里
}
```
- 对比 Java 的 `public static void main(String[] args)`，Dart 更简洁。
- `void` 是返回类型，`main` 是函数名，`()` 里没有参数。

### 6.2 命名参数（Named Parameters）
Dart 最影响 Flutter 代码风格的语法。调用函数时参数用 **`名字: 值`** 传递，**顺序可任意调整**：

```dart
AppBar(
  title: const Text('Hello'),   // 用名字 title 传参
)
```
- 好处：函数有十几个可选参数时，不用记顺序、不用传一堆 `null`，只写需要的。
- 对比位置参数：`Text('Hello')` 里的 `'Hello'` 是**位置参数**（必须按顺序、写在最前面）—— 源码 `text.dart:508` `String this.data` 就是位置参数。

> 简单记忆：**位置参数按顺序塞，命名参数挂名字传**。

### 6.3 字符串
```dart
'Hello World!'   // 单引号
"Hello World!"   // 双引号，效果完全一样
```
- Dart 里单引号和双引号**等价**，Flutter 社区习惯用**单引号**。
- 拼接用 `+` 或字符串插值 `'Hello $name'`（Day 5 会讲）。

### 6.4 `const` 常量关键字
```dart
const MyApp();            // 创建一个「编译期常量」实例
const Text('Hello');      // 文字内容固定，可标 const
```
- `const` = **编译时**就完全确定、永不改变；`final` = 运行期只赋值一次（Day 4 系统对比）。
- 第 1 课先记住：**照模板加 `const` 即可，报错就去掉**（误区 3）。

### 6.5 类、继承与 `@override`
```dart
class MyApp extends StatelessWidget {   // MyApp 继承自 StatelessWidget
  @override                              // 标注「重写父类方法」
  Widget build(BuildContext context) {   // 必须实现 build()
    return MaterialApp(...);
  }
}
```
- `extends`：继承，和 Java 一样。
- `StatelessWidget`：**无状态组件** —— 内容不会自己变化（Hello World 是静态的）。
- `build(BuildContext context)`：框架调这个方法拿到你要显示的 Widget；`@override` 表示你在重写父类的 `build`。
- 🃏 **术语卡：`BuildContext context`** —— **一句话本质**：「**当前 Widget 在树里的位置**」的句柄，用它**向上**找祖先（`Xxx.of(context)`）。**常见误解**：❌「context 是全局的 / 属于 MaterialApp 里面的东西」→ 不，**context 属于「写这段 build 的那个 Widget/Element」**，`of()` 只朝树根方向找、不往下看（Day 8 会专门做三层对照实验）。今天只需知道「这是框架传给你的环境信息」。
- `super.key`：把 `key` 参数直接转交给父类构造函数（Dart 3 语法）。`key` 的用途见 §一-3 的源码印证（Day 32 深挖）。

> 📌 与 `StatelessWidget` 对应的是 `StatefulWidget`（有状态组件），界面需要随交互变化时用。**这是 Day 10 的核心**，今天先记住有这两大类。

### 6.6 级联调用 `..`（本 App 未用，但你在 `runApp` 源码里已经见到了）

```dart
// 不用级联：写三行、重复三次变量名
var sb = StringBuffer();
sb.write('Hello');
sb.write(' World');
// 用级联 ..：只写一次变量名，连续调用
var sb = StringBuffer()
  ..write('Hello')
  ..write(' World');
```
- `..` 的作用：**对同一个对象连续调用多个方法，不用反复写对象名**。
- ⭐ **你今天已经见过真实用例**：`binding.dart:1950-1952` 的 `binding..scheduleAttachRootWidget(app)..scheduleWarmUpFrame();` —— 读 SDK 源码时认出它，就不会以为是什么神秘语法。

### 6.7 `import` 导入语句
```dart
import 'package:flutter/material.dart';
```
- 和 Python/Java 的 `import` 类似，引入外部库。
- `package:flutter/material.dart` 是 Flutter 的 Material 组件库，**几乎每个 Flutter 文件第一行都是它**。

---

## 七、项目结构说明

创建一个 Flutter 项目后，最重要的几个文件/目录：

```
my_app/
├── lib/                 ← ★ 你写代码的地方（核心）
│   └── main.dart        ← 程序入口，Hello World 全在这里
├── pubspec.yaml         ← ★ 项目的「配置清单/购物清单」
├── android/             ← Android 原生工程（一般不用改）
├── ios/                 ← iOS 原生工程（一般不用改）
├── macos/               ← macOS 桌面工程（你跑 flutter run -d macos 用它）
├── test/                ← 单元测试目录
└── analysis_options.yaml← 代码检查规则
```

### 7.1 `lib/main.dart` —— 程序入口文件
- Flutter **约定**：App 启动时自动执行 `lib/main.dart` 里的 `main()`。
- Hello World 的**全部代码都写在 `main.dart`** 里。
- App 变大后会把不同页面拆成 `lib/` 下多个 `.dart` 文件，但**入口永远是 `main.dart`**。
- ⚠️ **你的实操习惯提醒**：改完代码必须 `flutter run -d macos` **重新构建**，别双击 `build/` 目录里的 `.app` 产物（会看到旧构建版本/黑屏）。

### 7.2 `pubspec.yaml` —— 项目配置清单
- Flutter 项目的**核心配置文件**（YAML 格式，类似 Python 的 `requirements.txt` / Node 的 `package.json`）。
- 声明三件事：

| 用途 | 示例 |
|---|---|
| **依赖的第三方包** | 网络请求加 `http`，存数据加 `shared_preferences` |
| **项目元信息** | 项目名、描述、版本号 |
| **静态资源** | 图片、字体等 `assets:` 声明（**Day 6** 图片会用到） |

```yaml
name: my_app
description: 我的第一个 Flutter 应用
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
flutter:
  uses-material-design: true
  # assets:            # Day 6 加载图片时在这里声明
  #   - assets/images/
```

> 💡 今天**不需要改 `pubspec.yaml`**（Hello World 不用第三方包和资源）。但要知道：以后每加一个库、每加一张图，都要回这里登记，改完通常要 `flutter pub get`。

### 7.3 ⚠️ macOS 构建的坑（2026-09-14 实测，你新建项目必踩）

本机 Xcode 27.0 要求 macOS 部署目标 ≥ 12.0，而 `flutter create` 模板仍写 `10.15` ⇒ **新项目一跑 `flutter run -d macos` 就 `BUILD FAILED`**，报错含：
```
The macOS deployment target 'MACOSX_DEPLOYMENT_TARGET' is set to 10.15,
but the range of supported deployment target versions is 12.0 to 27.0.x.
```
**修法**（一条命令，改 `project.pbxproj` 里 3 处）：
```bash
bash /Volumes/external/learning/flutter-learning/shared/tools/fix_macos_deploy_target.sh
```
> 你 Day 1-8 + exam1 的项目都已修过。**新建任何 Flutter 项目后必须跑一次这个脚本** —— 报 "Build process failed" 时先查这条，别怀疑自己的 Dart 代码。

---

## 八、明确欠账（没讲透 / 没验证的）

1. **三棵树（Widget / Element / RenderObject）只认了脸**：今天只讲「Widget 是配置、要 createElement 充气成 Element」，**没讲三层各自职责、怎么联动、mount/inflate 流程**。⇒ **留 Day 33 系统化**（⚠️ 这是你周考口述 Q3 只拿 1.5/7 的重点欠账，Day 33 必须补到能口述）。
2. **帧流程（layout → paint → 光栅化）完全没讲**：`scheduleWarmUpFrame` 之后发生什么、一帧怎么画出来 —— 今天只到「调度一帧」。⇒ Day 2 讲约束三步、Day 33 讲完整管线。
3. **`WidgetsFlutterBinding` / `wrapWithDefaultView` 没展开**：`binding.dart:1884-1885` 两个调用只说了「初始化绑定」「包进默认 View」，**没读它们内部**。今天不需要。
4. **`Theme` / `themeData.scaffoldBackgroundColor` 刻意不深入**：`scaffold.dart:3237` 出现了主题取值，但**主题系统留 Day 35**（那天顺带清你 Day 2 的 ARGB 欠账）。今天所有颜色一律直接指定。
5. **`StatefulWidget` / `setState` 完全没讲**：只说了「有这两大类」。⇒ **Day 10**。
6. **`const` 的性能收益未实测**（误区 3 已标注）⇒ Day 10 用真实重建场景验证。
7. **书原文未逐章 `ov read` 核对**：机制部分全部来自本机 SDK 3.44.0 **磁盘逐字读出**；①ch9 / ⑦ch1-2 / ②ch1 / ⑨ / ⑪ 章节用于定位对照，本次未逐章跑全文。**诚实欠账** —— 书与本笔记冲突时以 SDK 源码为准，并告诉导师去核书。

---

## 九、诊断视角（Hello World 阶段就会用到的排查手段）

1. **白屏**：查 `main()` 里有没有 `runApp(...)`（误区 1）。**编译过 ≠ 会渲染。**
2. **黑屏/文字没底色**：查有没有 `Scaffold`（误区 2）—— 背景色来自 `scaffold.dart:3236` 那层 Material。
3. **文字贴左上角**：漏了 `Center`（§4.6）。
4. **右上角有 "DEBUG" 标签**：正常，`debugShowCheckedModeBanner: false` 可关。
5. **`flutter run` 报 BUILD FAILED（macOS）**：部署目标问题，跑 `fix_macos_deploy_target.sh`（§7.3），**不是你的 Dart 代码错**。
6. **`flutter run` 的常用热键**（今天先认两个）：
   - **`r`** = 热重载（改代码后快速刷新，**保留状态**）
   - **`R`** = 热重启（重建整个 App，**丢状态**）
   - ⚠️ **改了 `main()`、`pubspec.yaml`、或类结构，热重载常常不生效 ⇒ 用 `R` 或直接重跑**。你「看到旧版本」的很多情况就是只按了 `r`。
   - `p` = 给盒子涂色 + 画尺寸箭头（Day 2 起会大量用，开关本体 `rendering/debug.dart:36`）
7. **`flutter analyze`**：查语法/规范问题（误区 3 的 const 错、误区 6 的 children 错它都能抓）。**但查不出白屏/黑屏**（那些是运行期/视觉问题）。
8. **`debugDumpApp()`**（`widgets/binding.dart:1972-1974`）：控制台打印整棵 Widget 树 —— **今天就能用**，看看你的 Hello World 到底被 inflate 成了多少层（会看到一长串你没写过的组件，那就是 §一-2 说的「充气」结果）。

---

## 十、今日自测（你 2026-08-13 已作答 · 原文保留 + 导师批改）

1. `main()` 里少了 `runApp()` 会发生什么？为什么？

   > 会无法起动，要有runApp()才会启动，说白了， 就是页面只是一个静态的函数，未交给runApp进行初始化的加载

   ✅ **对，而且「未交给 runApp 进行初始化的加载」这个表述抓到本质了**。**L3 补充（源码级）**：`runApp` 只有 3 行（`binding.dart:1883-1886`），关键是 `_runWidget` 里的 `scheduleAttachRootWidget(app)`（挂载根 widget）+ `scheduleWarmUpFrame()`（调度第一帧）（`:1951-1952`）—— **没人调度帧，屏幕就永远空白**。而 `MyApp()` 只是造了个配置对象（图纸），没被「充气」进树。

2. `MaterialApp` 和 `Scaffold` 各管什么？一个 App 里有几个 `MaterialApp`？

   > materialapp是指我这个项目，要使用什么风格
   > scaffold则是在home下提供背景色
   > 一个app里面只有一个materalapp

   ✅ 三句都对（「一个 App 只有一个 MaterialApp」尤其准）。**L3 补充**：① MaterialApp 是 **StatefulWidget**（`app.dart:217`），管主题/路由/本地化等**全局**事务；② Scaffold「提供背景色」的机制 = 它内部包了一层 **Material**（`scaffold.dart:3236-3237`），**这层 Material 还是 Day 7 按钮水波纹的画布** —— 所以 Scaffold 白送的不只是背景色；③ ⚠️ 但 **MaterialApp 自己不含 Material/Scaffold**，所以在 `MyApp.build` 里调 `ScaffoldMessenger.of(context)` 会崩（Day 8 你实战踩过）。

3. 为什么 `Colors.grey[600]` 不能放进 `const` 里？

   > 因为colors.grey是计算值，而const是确定的值

   ✅ 方向对。**精确化**：`Colors.grey` 本身**是常量**（`MaterialColor` 常量对象），问题在 **`[600]` 是调用它的 `[]` 运算符 = 运行时方法调用** ⇒ 编译期算不出值。同理 `.shade600`（getter）也不行。→ §五 误区 3。**这条你 Day 2、Day 5 又各踩一次，是高频坑。**

4. 想让文字显示在屏幕正中央，需要哪个 Widget 包着 `Text`？

   > 要用center进行包裹，center下面装childen然后在装text

   ✅ 组件对（Center）。**两处要纠正**：① 参数名是 **`child`（单数）**，不是 `children` —— Center 是单子布局组件（写 `children` 会编译错「No named parameter」，误区 6）；② 正确写法 `Center(child: Text('...'))`。
   **L3 补充**：Center 的源码只有 4 行（`basic.dart:2550-2553`），它继承 `Align` 且 Align 的 `alignment` 默认就是 `Alignment.center`（`:2468`）—— **想居左上角就得改用 `Align`**（Center 没暴露这个参数）。

5. 你写的 Dart 代码放在哪个目录、哪个文件里？

   > 放在lib里面，测试放在test文件夹里面，an开头是语法检测配置，pub则是项目管理配置，其他的就是各大平台的一些配置

   ✅ **全对**，而且能说出 `analysis_options.yaml` 和 `pubspec.yaml` 各自的角色，说明项目结构真看懂了。补一条：**入口永远是 `lib/main.dart`**（Flutter 的约定）。

---

## 十一、学后自查题（先过这关再写练习 · 答案不内嵌）

> 用法：**合上笔记**凭记忆作答，做完发导师批改。💎 题要求指到源码行号。
> 参考答案不在本笔记（导师侧：`flutter-learning/shared/solutions/day1/day1_自查题参考答案.md`，作答后解锁）。

**L1/L2 基础**

1. 一个最小可运行的 Flutter App 需要哪几层组件？从外到内按顺序写出来。〔回看 §四 完整代码〕
2. `MaterialApp` 的 `title` 和 `AppBar` 的 `title` 有什么区别？各自显示在哪？〔回看 §4.3、误区 4〕
3. `Center` 的参数是 `child` 还是 `children`？为什么？〔回看 误区 6〕
4. `flutter run` 里 `r` 和 `R` 分别是什么？改完代码看到「还是旧界面」该怎么办？〔回看 §九-6〕

**💎 L3 深挖（口述机制 + 指得到源码行号；答不全 → 记 weak_points）**

5. **`runApp(const MyApp())` 这一行，框架内部做了哪几件事？**（要说出至少 3 步 + 源码文件:行号）**为什么忘了它屏幕就白屏、但编译不报错？**〔回看 §4.2、误区 1〕
6. **为什么说「Widget 不是界面」？** 请给出源码依据（Widget 的构造函数有什么特征？那个抽象方法叫什么、返回什么类型？）。官方文档用哪个动词描述「Widget 进树」的过程？〔回看 §一-2 术语卡 1〕
7. **`Center` 的源码一共几行？它为什么能居中？**（要说出它继承谁、那个默认值在哪一行、以及「想居左上角该怎么办」）〔回看 §4.6〕
8. **`Scaffold` 除了背景色，还白送了什么一层？源码在哪一行？这一层在 Day 7 会变成什么的关键？** 再回答：`AppBar` 是靠实现哪个接口让 Scaffold 认出「我是顶部栏、给我留高度」的？〔回看 §4.4、§4.5〕

> ✅ 全过 → 开始练习；答不全 → 先补那个点。

---

## 十二、边界对比（近邻概念 A vs B）

### 1. `MaterialApp` vs `Scaffold`

| | MaterialApp | Scaffold |
|---|---|---|
| 管什么 | **整个 App** 的全局规则（主题/路由/本地化） | **单个页面**的骨架（appBar/body/drawer 槽位） |
| 数量 | **一个 App 只有一个** | 每页一个（可多个） |
| 自带 Material 层吗 | **❌ 不含** | ✅ 含（`scaffold.dart:3236`） |
| 类型 | StatefulWidget（`app.dart:217`） | StatefulWidget（`scaffold.dart:1686`） |
| 层级 | 外层 | 必须在 MaterialApp 的 home/路由**里面** |

### 2. `Center` vs `Align`

| | Center | Align |
|---|---|---|
| 源码 | 4 行（`basic.dart:2550-2553`），继承 Align | `basic.dart:2462`，alignment 默认 center（`:2468`） |
| 能定位到 | **只能居中**（没暴露 alignment） | 任意方位（9 个预设 + 自定义） |
| 何时用 | 只居中（最短写法） | 要别的方位 |

### 3. `StatelessWidget` vs `StatefulWidget`（今天只认脸，Day 10 正式学）

| | StatelessWidget | StatefulWidget |
|---|---|---|
| 内容会变吗 | **不会**（静物画） | 会（有内部状态） |
| 今天用到的 | `MyApp`（你自己写的） | `MaterialApp` / `Scaffold` / `AppBar`（框架的） |
| 何时用 | 纯展示、配置不变 | 需要随交互变化（计数器、表单） |

> ⭐ **有意思的观察**：你写的 `MyApp` 是 Stateless，但它 return 的 `MaterialApp`/`Scaffold`/`AppBar` **都是 StatefulWidget** —— **「我用的组件有状态」和「我自己写的组件有状态」是两回事**。今天不需要理解为什么它们是 Stateful，Day 10 会讲。

### 4. `Text` vs `RichText`（今天只认脸，Day 5 展开）

| | Text | RichText |
|---|---|---|
| 是什么 | 语法糖（StatelessWidget） | **真正干活的**（MultiChildRenderObjectWidget） |
| 会 merge 默认样式吗 | ✅ 会 | ❌ 不会 |
| 何时用 | 99% 场景 | 几乎不直接用 |

---

## 十三、一句话总结 + 资源任务卡

**今日核心一句话**：Flutter 用 Dart 写「声明式」的 Widget 树，`main()` 里调用 `runApp()` 启动（3 行源码：初始化绑定 → 包 View → 挂载根 widget + 调度热身帧），`MaterialApp` 提供全局环境，`Scaffold` 搭建页面骨架（**还白送一层 Material**），`AppBar` / `Center` / `Text` 组成具体界面 —— **而这一切都只是「配置」，真正进树的是 `createElement()` 充气出来的 Element。**

**资源任务卡**：
- [ ] 跑通 Hello World，然后按 `p` 看盒子涂色（认识「你写的 4 层，实际渲染出几十层」）
- [ ] 在 `main()` 里加一行 `debugDumpApp();`（放在 `runApp` 之后），**亲眼看你的 Widget 被 inflate 成了什么** —— 这是 §一-2「Widget 是图纸、Element 是房子」的第一次实证
- [ ] **新增（今天的 L3 动作）**：跑这两条命令，验证「笔记贴的码 == 磁盘的码」
  ```bash
  python3 /Volumes/external/learning/flutter-learning/shared/tools/verify_inline_code.py \
          /Volumes/external/learning/flutter/day1_study.md
  sed -n '1883,1886p' /opt/homebrew/share/flutter/packages/flutter/lib/src/widgets/binding.dart
  ```
  **目的**：亲眼看到 `runApp` 只有 3 行 —— L3「能读 SDK 源码验证」的第一次实操。

---

## 十四、自查清单（按 L3 产出规范逐条打勾）

- [ ] **0. 读原文预检**：机制部分全部来自本机 SDK 3.44.0 **磁盘逐字读出**（`widgets/binding.dart`、`widgets/framework.dart`、`widgets/basic.dart`、`widgets/text.dart`、`material/app.dart`、`material/scaffold.dart`、`material/app_bar.dart`、`rendering/shifted_box.dart`）；书章节（①ch9 / ⑦ch1-2 / ②ch1 / ⑨ / ⑪）本次**未逐章 `ov read`** → §八 欠账 7 已诚实标注。
- [x] **1. 每个 Widget 有一句话本质**：Widget(§一-2 术语卡) / runApp(4.2) / MaterialApp(4.3) / Scaffold(4.4) / AppBar(4.5) / Center(4.6) / Text(4.7)。
- [x] **2. 每个「为什么」能指到源码行号**：全文机制断言均标行号；**0 处「书里说」式断言**。
- [x] **3. 有边界对比**：§十二 四组（MaterialApp/Scaffold、Center/Align、Stateless/Stateful、Text/RichText）。
- [x] **4. ≥3 个坑且写明「为什么会踩」**：§五 共 6 个误区。
- [x] **5. 有可复跑验证**：§九 8 条诊断动作（含 `r`/`R`/`p` 热键、`debugDumpApp`）；§十三 资源任务卡给了可跑命令。
- [x] **6. 有口述验收句（机制级）**：§三 三句，每句标源码行号。
- [x] **7. 无答案泄漏**：§十一 八题只有题干；答案在 `shared/solutions/day1/`。§十 是你已提交批改的历史答案。
- [x] **8. 有学后自查题**：§十一 八题（4 基础 + 4 💎 L3），每题带〔回看〕。
- [x] **9. 贴码铁律（2026-09-16 新增）**：每处 `文件:行号` 都配代码块或落对照册；`extract_refs.py` 0 处假行号；`verify_inline_code.py` 内联码逐字一致；关键源码带中文逐行注释；计数断言当场数过（runApp 函数体 **3 行**、Center **4 行**、MaterialApp/Scaffold 均为 StatefulWidget）。

> **超纲自查**：本笔记未教 Container/Padding/SizedBox（Day 2）、Card/Expanded/SafeArea/SCSV（Day 3）、GestureDetector/Stack/Positioned（Day 4）、Text 样式深化/TextSpan（Day 5，§4.7 明确标注「Day 5 整节展开」）、Image/Icon（Day 6）、Buttons（Day 7）、Row/Column（Day 8）、ListView（Day 9）、setState/StatefulWidget 生命周期（Day 10，只认脸）、Theme/ColorScheme（Day 35，§八 欠账 4 说明为何刻意不深入）、三棵树系统化（Day 33，§八 欠账 1）。代码示例无自定义函数/箭头函数（Day 4 才补）。颜色一律直接指定。

---

*笔记完 · 下一课：Day 2「容器与单子布局基础」（Container / Padding / SizedBox / Center + **约束三步对话** —— 整个 Flutter 布局的地基）。*
