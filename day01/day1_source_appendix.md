# Day 1 源码对照册（Source Appendix）

> 🤖 **本文件由 `shared/tools/extract_refs.py` 自动生成，不是手写的。**
> 每段代码都是从本机 SDK 磁盘**逐字读出**的：
> `/opt/homebrew/share/flutter/packages/flutter/lib/src/...`（Flutter 3.44.0）
> 左侧 `行号|` 就是磁盘上的真实行号 —— 你可以用 `sed -n '51,59p' <文件>` 自己核对。

**为什么要这份册子**：笔记 `day1_study.md` 里有 **41 处**
`文件:行号` 引用，其中 **21 处只给了行号、没贴代码** —— 看不懂是正常的。
这份册子按文件分组，把每处引用的**真实源码**贴出来，并标注「它是在解释笔记的哪一句话」。

## 怎么用
1. 读笔记遇到 `xxx.dart:123` 看不懂 → 在本册子里 `⌘F` 搜 `xxx.dart:123`（或搜行号 `123`）
2. 看「📍 服务于笔记」那行，回到笔记对应位置
3. 想自己核对：`sed -n '<起>,<止>p' /opt/homebrew/share/flutter/packages/<路径>`

## 目录一览

| # | SDK 文件 | 引用处数 | 笔记里用它讲什么 |
|---|---|---|---|
| 1 | `widgets/binding.dart` | 10 | | `runApp` 到底做了什么（3 行源码） | **Flutter SDK 3.44.0 `widgets/b… |
| 2 | `widgets/framework.dart` | 5 | | `Widget` 是「不可变配置」+ `createElement()` 抽象方法 | **SDK `widge… |
| 3 | `widgets/basic.dart` | 7 | | `Center` 就是 `Align`（alignment 默认 center） | **SDK `widget… |
| 4 | `material/scaffold.dart` | 9 | | `Scaffold` 自带一层 `Material`（Day 7 水波纹画布） | **SDK `materia… |
| 5 | `material/app_bar.dart` | 2 | | `AppBar implements PreferredSizeWidget`（Scaffold 怎么认出它）… |
| 6 | `material/app.dart` | 3 | - **一句话本质**：一个 **StatefulWidget**（`material/app.dart:217` `c… |
| 7 | `rendering/shifted_box.dart` | 1 | Align 对应的 RenderObject 是 `RenderPositionedBox`（`rendering/… |
| 8 | `widgets/text.dart` | 3 | - **一句话本质**：一个 **StatelessWidget**（`widgets/text.dart:497`），… |
| 9 | `rendering/debug.dart` | 1 | - `p` = 给盒子涂色 + 画尺寸箭头（Day 2 起会大量用，开关本体 `rendering/debug.dart… |

---

## 1. `flutter/lib/src/widgets/binding.dart`

### `binding.dart:1883-1886`

```dart
 1883| void runApp(Widget app) {
 1884|   final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
 1885|   _runWidget(binding.wrapWithDefaultView(app), binding, 'runApp');
 1886| }
```

**📍 服务于笔记：**
- 笔记第 26 行：本笔记每处 `widgets/binding.dart:1883` 这类标注，**都紧跟代码块贴出真实源码**（本机 SDK 3.44.0 磁盘逐字读出）。
- 笔记第 11 行：`runApp` 到底做了什么（3 行源码） | **Flutter SDK 3.44.0 `widgets/binding.dart:1883-1886`** | **源码级原理** ⭐⭐ |
- 笔记第 125 行：依据：`widgets/binding.dart:1883-1886`（全文 3 行）+ `:1948-1953`（`_runWidget` 的 `scheduleAttachRootWidget` + `scheduleWarmUpFrame`）。
- 笔记第 192 行：// widgets/binding.dart:1883-1886（runApp 全文 —— 就 3 行！磁盘逐字）
- 笔记第 636 行：✅ **对，而且「未交给 runApp 进行初始化的加载」这个表述抓到本质了**。**L3 补充（源码级）**：`runApp` 只有 3 行（`binding.dart:1883-1886`），关键是 `_runWidget` 里的 `scheduleAttachRootWidget(app)`（挂载根 widget）+ `scheduleWarmUpFrame()`（调度第一帧）（`:1951-1952`）—— **没人调度帧，屏幕…
- 笔记第 605 行：3. **`WidgetsFlutterBinding` / `wrapWithDefaultView` 没展开**：`binding.dart:1884-1885` 两个调用只说了「初始化绑定」「包进默认 View」，**没读它们内部**。今天不需要。

### `binding.dart:1948-1953`

```dart
 1948| void _runWidget(Widget app, WidgetsBinding binding, String debugEntryPoint) {
 1949|   assert(binding.debugCheckZone(debugEntryPoint));
 1950|   binding
 1951|     ..scheduleAttachRootWidget(app)
 1952|     ..scheduleWarmUpFrame();
 1953| }
```

**📍 服务于笔记：**
- 笔记第 202 行：// widgets/binding.dart:1948-1953（_runWidget 全文 · 磁盘逐字）
- 笔记第 527 行：⭐ **你今天已经见过真实用例**：`binding.dart:1950-1952` 的 `binding..scheduleAttachRootWidget(app)..scheduleWarmUpFrame();` —— 读 SDK 源码时认出它，就不会以为是什么神秘语法。
- 笔记第 387 行：原理（源码级）**：`MyApp()` 只是「造了一个配置对象」（图纸）；**只有 `runApp` 才会 `scheduleAttachRootWidget` + `scheduleWarmUpFrame`**（`binding.dart:1951-1952`）把图纸充气进树、调度第一帧。没人调度帧 ⇒ 屏幕永远空白。

### `binding.dart:1972-1974`

```dart
 1972| void debugDumpApp() {
 1973|   debugPrint(_debugDumpAppString());
 1974| }
```

**📍 服务于笔记：**
- 笔记第 626 行：8. **`debugDumpApp()`**（`widgets/binding.dart:1972-1974`）：控制台打印整棵 Widget 树 —— **今天就能用**，看看你的 Hello World 到底被 inflate 成了多少层（会看到一长串你没写过的组件，那就是 §一-2 说的「充气」结果）。

---

## 2. `flutter/lib/src/widgets/framework.dart`

### `framework.dart:312-349`

```dart
  312| abstract class Widget extends DiagnosticableTree {
  313|   /// Initializes [key] for subclasses.
  314|   const Widget({this.key});
  315| 
  316|   /// Controls how one widget replaces another widget in the tree.
  317|   ///
  318|   /// If the [runtimeType] and [key] properties of the two widgets are
  319|   /// [operator==], respectively, then the new widget replaces the old widget by
  320|   /// updating the underlying element (i.e., by calling [Element.update] with the
  321|   /// new widget). Otherwise, the old element is removed from the tree, the new
  322|   /// widget is inflated into an element, and the new element is inserted into the
  323|   /// tree.
  324|   ///
  325|   /// In addition, using a [GlobalKey] as the widget's [key] allows the element
  326|   /// to be moved around the tree (changing parent) without losing state. When a
  327|   /// new widget is found (its key and type do not match a previous widget in
  328|   /// the same location), but there was a widget with that same global key
  329|   /// elsewhere in the tree in the previous frame, then that widget's element is
  330|   /// moved to the new location.
  331|   ///
  332|   /// Generally, a widget that is the only child of another widget does not need
  333|   /// an explicit key.
  334|   ///
  335|   /// See also:
  336|   ///
  337|   ///  * The discussions at [Key] and [GlobalKey].
  338|   final Key? key;
  339| 
  340|   /// Inflates this configuration to a concrete instance.
  341|   ///
  342|   /// A given widget can be included in the tree zero or more times. In particular
  343|   /// a given widget can be placed in the tree multiple times. Each time a widget
  344|   /// is placed in the tree, it is inflated into an [Element], which means a
  345|   /// widget that is incorporated into the tree multiple times will be inflated
  346|   /// multiple times.
  347|   @protected
  348|   @factory
  349|   Element createElement();
```

**📍 服务于笔记：**
- 笔记第 57 行：// widgets/framework.dart:312-314（Widget 类声明 · 磁盘逐字）
- 笔记第 128 行：依据：`widgets/framework.dart:312-314`（`const Widget({this.key})`）+ `:340-349`（`Element createElement();` 抽象方法 + 官方文档 "Each time a widget is placed in the tree, it is inflated into an Element"）。
- 笔记第 12 行：`Widget` 是「不可变配置」+ `createElement()` 抽象方法 | **SDK `widgets/framework.dart:312-349`** | **源码级原理** ⭐⭐ |
- 笔记第 101 行：🔗 **源码印证**：`framework.dart:316-323` 的 `key` 字段文档原话 —— 「如果两个 widget 的 `runtimeType` 和 `key` 相等，新 widget 就**替换**旧的（通过 `Element.update`）；否则旧 element 被移除、新 widget 被 inflate 成新 element 插入树中」。**这就是「Flutter 自动对比差异」的机制出处**（Day 3…
- 笔记第 65 行：// widgets/framework.dart:340-349（createElement —— 三棵树的入口 · 磁盘逐字 · 节选：略去 :341 空行）

---

## 3. `flutter/lib/src/widgets/basic.dart`

### `basic.dart:2462-2468`

```dart
 2462| class Align extends SingleChildRenderObjectWidget {
 2463|   /// Creates an alignment widget.
 2464|   ///
 2465|   /// The alignment defaults to [Alignment.center].
 2466|   const Align({
 2467|     super.key,
 2468|     this.alignment = Alignment.center,
```

**📍 服务于笔记：**
- 笔记第 706 行：源码 | 4 行（`basic.dart:2550-2553`），继承 Align | `basic.dart:2462`，alignment 默认 center（`:2468`） |
- 笔记第 13 行：`Center` 就是 `Align`（alignment 默认 center） | **SDK `widgets/basic.dart:2462-2468 / 2550-2553`** | 源码级原理 |
- 笔记第 326 行：// widgets/basic.dart:2462-2468（Align 的构造函数 · 节选：略去 :2463-2465 的 key/文档 —— 秘密在默认值）

### `basic.dart:2550-2553`

```dart
 2550| class Center extends Align {
 2551|   /// Creates a widget that centers its child.
 2552|   const Center({super.key, super.widthFactor, super.heightFactor, super.child});
 2553| }
```

**📍 服务于笔记：**
- 笔记第 131 行：依据：`widgets/basic.dart:2550-2553`（Center 全部源码）+ `:2466-2468`（`this.alignment = Alignment.center`）。
- 笔记第 317 行：// widgets/basic.dart:2550-2553（Center 的全部源码 —— 只有 4 行！磁盘逐字）
- 笔记第 657 行：L3 补充**：Center 的源码只有 4 行（`basic.dart:2550-2553`），它继承 `Align` 且 Align 的 `alignment` 默认就是 `Alignment.center`（`:2468`）—— **想居左上角就得改用 `Align`**（Center 没暴露这个参数）。
- 笔记第 706 行：源码 | 4 行（`basic.dart:2550-2553`），继承 Align | `basic.dart:2462`，alignment 默认 center（`:2468`） |

---

## 4. `flutter/lib/src/material/scaffold.dart`

### `scaffold.dart:1686`

```dart
 1686| class Scaffold extends StatefulWidget {
```

**📍 服务于笔记：**
- 笔记第 256 行：一句话本质**：一个 **StatefulWidget**（`material/scaffold.dart:1686`），搭建页面**标准骨架**，自动处理背景色、安全区域（避开刘海/状态栏）。
- 笔记第 699 行：类型 | StatefulWidget（`app.dart:217`） | StatefulWidget（`scaffold.dart:1686`） |

### `scaffold.dart:3232-3238`

```dart
 3232|     return _ScaffoldScope(
 3233|       hasDrawer: hasDrawer,
 3234|       geometryNotifier: _geometryNotifier,
 3235|       child: ScrollNotificationObserver(
 3236|         child: Material(
 3237|           color: widget.backgroundColor ?? themeData.scaffoldBackgroundColor,
 3238|           child: Builder(
```

**📍 服务于笔记：**
- 笔记第 269 行：// material/scaffold.dart:3232-3238（Scaffold.build 的核心 · 磁盘逐字 · 节选）
- 笔记第 14 行：`Scaffold` 自带一层 `Material`（Day 7 水波纹画布） | **SDK `material/scaffold.dart:3236`** | 源码级原理 |
- 笔记第 616 行：2. **黑屏/文字没底色**：查有没有 `Scaffold`（误区 2）—— 背景色来自 `scaffold.dart:3236` 那层 Material。
- 笔记第 698 行：自带 Material 层吗 | **❌ 不含** | ✅ 含（`scaffold.dart:3236`） |
- 笔记第 400 行：原理（源码级）**：背景色是 **`scaffold.dart:3236-3237` 那层 Material** 画的（`color: widget.backgroundColor ?? themeData.scaffoldBackgroundColor`）。没有 Scaffold ⇒ 没人画背景 ⇒ 黑底。⚠️ **注意这是「视觉问题」，代码能正常编译运行**（三类错误的第 ③ 类，Day 3 §七 会正式建立分类）。
- 笔记第 644 行：✅ 三句都对（「一个 App 只有一个 MaterialApp」尤其准）。**L3 补充**：① MaterialApp 是 **StatefulWidget**（`app.dart:217`），管主题/路由/本地化等**全局**事务；② Scaffold「提供背景色」的机制 = 它内部包了一层 **Material**（`scaffold.dart:3236-3237`），**这层 Material 还是 Day 7 按钮水波纹的画布…
- 笔记第 606 行：4. **`Theme` / `themeData.scaffoldBackgroundColor` 刻意不深入**：`scaffold.dart:3237` 出现了主题取值，但**主题系统留 Day 35**（那天顺带清你 Day 2 的 ARGB 欠账）。今天所有颜色一律直接指定。

---

## 5. `flutter/lib/src/material/app_bar.dart`

### `app_bar.dart:189`

```dart
  189| class AppBar extends StatefulWidget implements PreferredSizeWidget {
```

**📍 服务于笔记：**
- 笔记第 15 行：`AppBar implements PreferredSizeWidget`（Scaffold 怎么认出它） | **SDK `material/app_bar.dart:189`** | 源码级原理 |
- 笔记第 298 行：// material/app_bar.dart:189（类声明 —— 注意 implements 后面那个）

---

## 6. `flutter/lib/src/material/app.dart`

### `app.dart:217`

```dart
  217| class MaterialApp extends StatefulWidget {
```

**📍 服务于笔记：**
- 笔记第 233 行：一句话本质**：一个 **StatefulWidget**（`material/app.dart:217` `class MaterialApp extends StatefulWidget`），提供遵循 **Material Design** 的全局环境，负责主题、导航、本地化等全局事务。
- 笔记第 644 行：✅ 三句都对（「一个 App 只有一个 MaterialApp」尤其准）。**L3 补充**：① MaterialApp 是 **StatefulWidget**（`app.dart:217`），管主题/路由/本地化等**全局**事务；② Scaffold「提供背景色」的机制 = 它内部包了一层 **Material**（`scaffold.dart:3236-3237`），**这层 Material 还是 Day 7 按钮水波纹的画布…
- 笔记第 699 行：类型 | StatefulWidget（`app.dart:217`） | StatefulWidget（`scaffold.dart:1686`） |

---

## 7. `flutter/lib/src/rendering/shifted_box.dart`

### `shifted_box.dart:397`

```dart
  397| class RenderPositionedBox extends RenderAligningShiftedBox {
```

**📍 服务于笔记：**
- 笔记第 335 行：Align 对应的 RenderObject 是 `RenderPositionedBox`（`rendering/shifted_box.dart:397`）—— 「真正干活的那层」（Day 2 §4.3 会看到同款套路）。

---

## 8. `flutter/lib/src/widgets/text.dart`

### `text.dart:497`

```dart
  497| class Text extends StatelessWidget {
```

**📍 服务于笔记：**
- 笔记第 345 行：一句话本质**：一个 **StatelessWidget**（`widgets/text.dart:497`），把「字符串 + 样式」翻译成 `RichText` —— **真正排版画字的是 RichText/RenderParagraph**。

### `text.dart:508`

```dart
  508|     String this.data, {
```

**📍 服务于笔记：**
- 笔记第 477 行：对比位置参数：`Text('Hello')` 里的 `'Hello'` 是**位置参数**（必须按顺序、写在最前面）—— 源码 `text.dart:508` `String this.data` 就是位置参数。

### `text.dart:780-800`

```dart
  780|       result = RichText(
  781|         textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
  782|         textDirection:
  783|             textDirection, // RichText uses Directionality.of to obtain a default if this is null.
  784|         locale: locale, // RichText uses Localizations.localeOf to obtain a default if this is null
  785|         softWrap: softWrap ?? defaultTextStyle.softWrap,
  786|         overflow: overflow ?? effectiveTextStyle?.overflow ?? defaultTextStyle.overflow,
  787|         textScaler: textScaler,
  788|         maxLines: maxLines ?? defaultTextStyle.maxLines,
  789|         strutStyle: effectiveStrutStyle,
  790|         textWidthBasis: textWidthBasis ?? defaultTextStyle.textWidthBasis,
  791|         textHeightBehavior:
  792|             textHeightBehavior ??
  793|             defaultTextStyle.textHeightBehavior ??
  794|             DefaultTextHeightBehavior.maybeOf(context),
  795|         selectionColor:
  796|             selectionColor ??
  797|             DefaultSelectionStyle.of(context).selectionColor ??
  798|             DefaultSelectionStyle.defaultColor,
  799|         text: effectiveTextSpan,
  800|       );
```

**📍 服务于笔记：**
- 笔记第 348 行：// widgets/text.dart:780-800（Text.build 造 RichText · 磁盘逐字 · 节选：只留关键 4 行）

---

## 9. `flutter/lib/src/rendering/debug.dart`

### `debug.dart:36`

```dart
   36| bool debugPaintSizeEnabled = false;
```

**📍 服务于笔记：**
- 笔记第 624 行：`p` = 给盒子涂色 + 画尺寸箭头（Day 2 起会大量用，开关本体 `rendering/debug.dart:36`）

---
