# Day 2: 容器与单子布局基础（Container / Padding / SizedBox / Center）— 学习笔记（多书合集 · L3 版）

> ⚠️ 练习改完代码必须 `flutter run -d macos` 重新构建，别双击 build/ 产物（会看到旧版本/黑屏）
>🎯 **L3 目标**：今天学的不只是四个组件 —— **是「约束（Constraints）」这套整个 Flutter 布局的地基**。Day 3（Expanded）、Day 8（Row/Column）、Day 9（ListView）所有布局问题，根都在今天这三句话里。**毕业条件：能用「父给约束 → 子报尺寸 → 父定位置」解释任意一个布局现象。**

---

## 📎 看不懂「文件:行号」？先读这里

本笔记里每处 `rendering/box.dart:200` 这类标注，**都紧跟一个代码块贴出那段真实源码**（本机 SDK 3.44.0 磁盘逐字读出）。

- `200|` 这样的前缀是**磁盘真实行号，不是代码的一部分** —— 只看 `|` 右边。
- 自己核对：
  ```bash
  sed -n '200,212p' /opt/homebrew/share/flutter/packages/flutter/lib/src/rendering/box.dart
  ```
- 全量源码对照册：[`day2_source_appendix.md`](./day2_source_appendix.md)（工具生成）
  ```bash
  python3 /Volumes/external/learning/flutter-learning/shared/tools/extract_refs.py \
          /Volumes/external/learning/flutter/day2_study.md --emit          # 生成对照册 + 校验行号
  python3 /Volumes/external/learning/flutter-learning/shared/tools/verify_inline_code.py \
          /Volumes/external/learning/flutter/day2_study.md                 # 校验内联码逐字一致
  ```

---

## 一、今日阅读

- **主教材**：① 第 17 章「Single-Child Layout Widgets」——「单子」= 一个父组件主要管理**一个直接子组件**
- **今天学**：`Container`、`Padding`、`SizedBox`、`Center`（外加 `Card` 基础、`BoxDecoration`、`EdgeInsets`）
- **延伸**：⑧ 第 1 章基础布局｜⑦ 第 4 章｜③ Layout Cheat Sheet｜⑨ 第 6 章（约束原理）

> **一句话记住今天的主题**：Container 是「万能盒子」，Padding 管盒子里面的间距，SizedBox 管固定尺寸/留白，Center 管居中。**而它们全部都在做同一件事：改约束、报尺寸。**

---

## 二、今天结束前要能口述的 3 句（💎 整个 Flutter 布局的地基）

> 每句都必须能指到**源码行号**。这三句不是「Day 2 的知识」，是**你后面 30 天所有布局问题的总钥匙**。

1. **布局是一个「三步对话」：父给约束（Constraints）→ 子自己决定尺寸（Size）→ 父决定子的位置（Offset）。** 子**永远不能突破**父给的约束（父约束优先级最高）。
   > 依据：`rendering/box.dart:222-228`（`enforce` 用 `clampDouble` 把子的要求**夹进**父的范围）；`rendering/shifted_box.dart:261-267`（RenderPadding 完整走了一遍这三步）。

2. **`Container` 不是「一个盒子」，是一串**：它的 `build` 按你传了哪些参数，**从内到外一层层包**（alignment→Align、padding→Padding、color→ColoredBox、decoration→DecoratedBox、constraints→ConstrainedBox、margin→Padding、transform→Transform）。**一个参数 = 一层壳。**
   > 依据：`widgets/container.dart:387-446`（完整 build，§四-4.2 逐行贴出）。

3. **`Padding` 靠「把约束缩小一圈」实现（deflate），`SizedBox` 靠「把约束夹紧」实现（enforce）** —— 两者都不是「画」出来的，是**改约束**改出来的。
   > 依据：`rendering/box.dart:200-212`（`deflate`：minWidth - horizontal，且用 `math.max(0.0, ...)` 保证不为负）；`:222-228`（`enforce`：clamp 进父约束）；`rendering/shifted_box.dart:261`（`constraints.deflate(padding)` 就是 Padding 的全部秘密）。

---

## 三、术语卡（本日的生词，先定义再用）

> 规矩：**每个新术语必须先给定义**（一句话本质 + 源码依据 + 常见误解）。你以后问「这是什么意思」= 我漏定义，直接说。

### 🃏 术语卡 1：`BoxConstraints`（约束）—— **本日头号术语**

- **一句话本质**：**四个数字** —— `minWidth / maxWidth / minHeight / maxHeight`。父组件用它告诉子组件「你的宽只能在 min~max 之间，高只能在 min~max 之间」。
- **源码依据**：`rendering/box.dart` 里的 `class BoxConstraints`；它的常用构造 `BoxConstraints(minWidth:, maxWidth:, minHeight:, maxHeight:)`（`:206-211` 的 `deflate` 就是这么造的）。
- **两个特殊形态（必须分清）**：
  | 形态 | 长什么样 | 含义 |
  |---|---|---|
  | **紧约束 tight** | `min == max`（如 `200<=w<=200`） | 「你**必须**是这么大」—— 子没有选择权 |
  | **松约束 loose** | `min == 0`（如 `0<=w<=800`） | 「你**最多**这么大，小点随你」—— 子可以自己决定 |
  | **无界 unbounded** | `max == double.infinity` | 「你想多大多大」—— ⚠️ Day 3/9 的一堆报错根源 |
- **常见误解**：
  - ❌「约束是子组件的需求」→ 不，**约束是父组件单方面下达的硬边界**，子不可突破（你周考口述曾持有「内部约束高于外部时按父或子绘制」的错误模型，真相是**父永远赢**）。
  - ❌「我写了 `width: 100` 就一定是 100」→ 不一定，如果父给的 maxWidth 是 94，`enforce` 会把你**夹到 94**（`:225`），而且**静默不报错**（你 Day 8 🔴 实测踩过：写 100 实测 94）。

### 🃏 术语卡 2：逻辑像素 vs 物理像素（DPR）

- **一句话本质**：你代码里写的 `24` 是**逻辑像素（dp）**，屏幕真实点亮的**物理像素** = 24 × DPR（devicePixelRatio，苹果 retina 通常 2.0 ⇒ 48）。
- **为什么要这样**：让**同一个数字在不同分辨率设备上看起来一样大**（否则同样的 `24` 在高清屏上会小一半）。
- **常见误解**：❌「`EdgeInsets.all(24)` 拿尺子量应该是 24 物理点」→ 量出来是 48（DPR 2.0）。**你 Day 2 就为此困惑过**（以为代码有 bug），实测确认：24 逻辑px = 48 物理px，**不是 bug**。
- **实操规矩**：**布局单位默认全是逻辑像素**，讨论尺寸时不要混着说物理像素。

### 🃏 术语卡 3：`EdgeInsets`

- **一句话本质**：描述「四边各留多少」的数据对象（不是 Widget）。三种写法：
  ```dart
  EdgeInsets.all(24)                                  // 四边都 24
  EdgeInsets.symmetric(horizontal: 16, vertical: 8)   // 左右 16、上下 8
  EdgeInsets.only(left: 24, top: 8)                   // 只给某几边，其余 0
  ```
- **源码依据**：`painting/edge_insets.dart:390` `class EdgeInsets extends EdgeInsetsGeometry`；它的 `horizontal` / `vertical` getter 就是 `deflate` 里用的那两个数（`box.dart:202-203`）。

---

## 四、💎 源码机制（今天的主菜）

> 全部按本机 `/opt/homebrew/share/flutter/packages/flutter/lib/src/` Flutter 3.44.0 **磁盘逐字读出**。

### 4.1 `deflate` 与 `enforce` —— Padding 与 SizedBox 的全部秘密

```dart
// rendering/box.dart:199-212（deflate：把约束「缩小一圈」· 磁盘逐字）
 199|   /// Returns new box constraints that are smaller by the given edge dimensions.
 200|   BoxConstraints deflate(EdgeInsetsGeometry edges) {
 201|     assert(debugAssertIsValid());
 202|     final double horizontal = edges.horizontal;      // ← 左右 padding 之和
 203|     final double vertical = edges.vertical;          // ← 上下 padding 之和
 204|     final double deflatedMinWidth = math.max(0.0, minWidth - horizontal);
        //   ↑ ⭐ 为什么套 math.max(0.0, ...)：如果 padding 比 minWidth 还大，
        //     减出来会是负数 —— 负宽度没有意义，框架强制夹到 0（不报错，静默兜底）
 205|     final double deflatedMinHeight = math.max(0.0, minHeight - vertical);
 206|     return BoxConstraints(
 207|       minWidth: deflatedMinWidth,
 208|       maxWidth: math.max(deflatedMinWidth, maxWidth - horizontal),
        //   ↑ ⭐ 再套一层 max：保证 maxWidth 不小于 minWidth（否则约束非法）
 209|       minHeight: deflatedMinHeight,
 210|       maxHeight: math.max(deflatedMinHeight, maxHeight - vertical),
 211|     );
 212|   }
```

```dart
// rendering/box.dart:220-229（enforce：把自己的要求「夹进」父约束 · 磁盘逐字）
 220|   /// Returns new box constraints that respect the given constraints while being
 221|   /// as close as possible to the original constraints.
 222|   BoxConstraints enforce(BoxConstraints constraints) {
 223|     return BoxConstraints(
 224|       minWidth: clampDouble(minWidth, constraints.minWidth, constraints.maxWidth),
 225|       maxWidth: clampDouble(maxWidth, constraints.minWidth, constraints.maxWidth),
        //   ↑ ⭐⭐ 这一行就是「父约束永远赢」的机制本体：
        //     clampDouble(我要的, 父给的下限, 父给的上限)
        //     ⇒ 我要 100、父最多给 94 → 结果 94（静默夹断，不报错！）
 226|       minHeight: clampDouble(minHeight, constraints.minHeight, constraints.maxHeight),
 227|       maxHeight: clampDouble(maxHeight, constraints.minHeight, constraints.maxHeight),
 228|     );
 229|   }
```

```dart
// rendering/box.dart:214-218 + 253-259（loosen 与 widthConstraints · 磁盘逐字）
 214|   /// Returns new box constraints that remove the minimum width and height requirements.
 215|   BoxConstraints loosen() {
 216|     assert(debugAssertIsValid());
 217|     return BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight);
        //   ↑ 把 min 全丢掉（minWidth/minHeight 默认 0.0）⇒ 紧约束变松约束
 218|   }
 253|   /// Returns box constraints with the same width constraints but with
 254|   /// unconstrained height.
 255|   BoxConstraints widthConstraints() => BoxConstraints(minWidth: minWidth, maxWidth: maxWidth);
        //   ↑ ⭐ 只保留宽度约束，高度不管 ⇒ minHeight 默认 0.0、maxHeight 默认 double.infinity（= 无界！）
        //     这就是 Day 3/Day 9「SingleChildScrollView 给孩子无界高」的那一行（Day 9 §2.2 会再见到它）
```

> 🔑 **四个方法一句话总结（背这个，不是背代码）**：
> | 方法 | 干什么 | 谁在用 |
> |---|---|---|
> | `deflate(edges)` | 约束**缩小一圈**（减去 padding） | **Padding** |
> | `enforce(other)` | 把要求**夹进**别人的范围 | **SizedBox / ConstrainedBox** |
> | `loosen()` | 去掉 min（紧→松） | ListTile、Stack 等给孩子松约束时 |
> | `widthConstraints()` | 只留宽、**高变无界** | **SingleChildScrollView**（垂直滚动时） |

### 4.2 `Container.build` —— 「一个参数 = 一层壳」（本日最该读的一段源码）

```dart
// widgets/container.dart:387-446（Container.build · 磁盘逐字 · 节选：略去 :413 的 textDirection 实参换行 · 这是「万能盒子」的真相）
 387|   Widget build(BuildContext context) {
 388|     Widget? current = child;                      // ← 从最里面的孩子开始
 389|
 390|     if (child == null && (constraints == null || !constraints!.isTight)) {
 391|       current = LimitedBox(
 392|         maxWidth: 0.0,
 393|         maxHeight: 0.0,
 394|         child: ConstrainedBox(constraints: const BoxConstraints.expand()),
 395|       );
        //   ↑ ⭐ 没有 child 时：包一个「尽量撑满」的盒子（所以空 Container 会占满可用空间）
 396|     } else if (alignment != null) {
 397|       current = Align(alignment: alignment!, child: current);      // ← alignment → Align 层
 398|     }
 399|
 400|     final EdgeInsetsGeometry? effectivePadding = _paddingIncludingDecoration;
 401|     if (effectivePadding != null) {
 402|       current = Padding(padding: effectivePadding, child: current); // ← padding → Padding 层
 403|     }
 404|
 405|     if (color != null) {
 406|       current = ColoredBox(color: color!, isAntiAlias: isAntiAlias, child: current);  // ← color → ColoredBox 层
 407|     }
 408|
 409|     if (clipBehavior != Clip.none) {
 410|       assert(decoration != null);
 411|       current = ClipPath(
 412|         clipper: _DecorationClipper(
 414|           decoration: decoration!,
 415|         ),
 416|         clipBehavior: clipBehavior,
 417|         child: current,
 418|       );                                            // ← clipBehavior → ClipPath 层（按 decoration 形状裁孩子！）
 419|     }
 420|
 421|     if (decoration != null) {
 422|       current = DecoratedBox(decoration: decoration!, child: current);   // ← decoration → DecoratedBox 层
 423|     }
 424|
 425|     if (foregroundDecoration != null) {
 426|       current = DecoratedBox(
 427|         decoration: foregroundDecoration!,
 428|         position: DecorationPosition.foreground,
 429|         child: current,
 430|       );                                            // ← foregroundDecoration → 画在孩子之上的装饰层
 431|     }
 432|
 433|     if (constraints != null) {
 434|       current = ConstrainedBox(constraints: constraints!, child: current);  // ← constraints → ConstrainedBox 层
 435|     }
 436|
 437|     if (margin != null) {
 438|       current = Padding(padding: margin!, child: current);   // ← ⭐ margin 也是 Padding！（只是在最外层）
 439|     }
 440|
 441|     if (transform != null) {
 442|       current = Transform(transform: transform!, alignment: transformAlignment, child: current);
 443|     }
 444|
 445|     return current!;
 446|   }
```

**这段源码回答了 6 个你以前只能「记结论」的问题**：

| 问题 | 源码答案 |
|---|---|
| `Container(color:)` 和 `Container(decoration:)` 能同时写吗？ | **不能**。`:405` 和 `:421` 是两个独立 if，但 Container 构造函数里有 assert 拦（颜色要写就写进 decoration）。**机制上**：color 造 ColoredBox、decoration 造 DecoratedBox，两层都画背景会互相盖 |
| 为什么「背景色 + 圆角」必须放进 `BoxDecoration`？ | 因为 **`borderRadius` 根本不是 Container 的参数**（看 `:387-446` 全文没有它），它属于 `BoxDecoration`。圆角由 `:422` 的 DecoratedBox 画 |
| `Container` 的 `margin` 和 `padding` 有什么本质区别？ | **源码里都是 `Padding`！**（`:402` vs `:438`）区别只在**包的位置**：padding 在内层（`decoration` 之内 ⇒ 背景色覆盖 padding 区），margin 在最外层（`:438`，在 decoration 之外 ⇒ 背景色不覆盖 margin 区） |
| 空的 `Container()` 会怎样？ | 所有参数都 null ⇒ **每个 if 都不成立 ⇒ `:445` 直接 `return child`** ⇒ 它是**透传壳，等于没写**（已实测）。但 `:390-395`：**没有 child 时**会包一个「撑满」的盒子 |
| `clipBehavior` 是干什么的？ | `:409-419` 造一层 `ClipPath`，**按 decoration 的形状裁剪孩子** —— ⚠️ **这条正好回答 Day 6 坑 4**：Container 默认 `clipBehavior: Clip.none`（不裁），所以圆角 Container 里的方图会戳出去；**想要圆角图，要么设 `clipBehavior: Clip.hardEdge`，要么用 ClipRRect** |
| 为什么 Container「什么都能干」？ | 因为它**自己什么都不干**，只是「按参数拼一串专职组件」。**这就是 Flutter 的组合哲学：小组件 + 组合，而不是大组件 + 参数** |

### 4.3 `RenderPadding.performLayout` —— 「三步对话」的完整标本

> 口述句 1 的**最佳教材**：这 15 行源码把「父给约束 → 子报尺寸 → 父定位置」走了一遍。

```dart
// rendering/shifted_box.dart:254-268（RenderPadding.performLayout · 磁盘逐字）
 254|   void performLayout() {
 255|     final BoxConstraints constraints = this.constraints;      // ① 拿到父给我的约束
 256|     final EdgeInsets padding = _resolvedPadding;
 257|     if (child == null) {
 258|       size = constraints.constrain(Size(padding.horizontal, padding.vertical));
 259|       return;                                 // 没孩子：我的尺寸 = padding 本身（再受父约束夹一次）
 260|     }
 261|     final BoxConstraints innerConstraints = constraints.deflate(padding);
        //   ② ⭐ 把父约束「缩小一圈」再给孩子 —— 这就是 Padding 的全部机制（deflate 见 §4.1）
 262|     child!.layout(innerConstraints, parentUsesSize: true);
        //   ③ 让孩子用「缩小后的约束」去布局（孩子自己决定尺寸）
 263|     final childParentData = child!.parentData! as BoxParentData;
 264|     childParentData.offset = Offset(padding.left, padding.top);
        //   ④ ⭐ 父定位置：把孩子往右下方推 (padding.left, padding.top)
 265|     size = constraints.constrain(
 266|       Size(padding.horizontal + child!.size.width, padding.vertical + child!.size.height),
 267|     );
        //   ⑤ 我的尺寸 = 孩子尺寸 + padding 两边 —— 再 constrain 一次（父约束永远赢）
 268|   }
```

**逐步读（这就是要口述的机制）**：
1. `:255` 收到父的约束；
2. `:261` **deflate**：把约束减去 padding ⇒ 孩子可用空间变小；
3. `:262` 孩子在这个更小的约束里布局，**报回自己的 size**；
4. `:264` **父决定孩子的位置** = 往右下推 padding 的量（所以内容「离边远」）；
5. `:265-267` **我自己的 size = 孩子 + padding**，最后再 `constrain` 一次（如果父只给 100 宽、孩子+padding 要 120 ⇒ 我还是 100，**padding 被挤掉**，静默不报错）。

> 🔑 **为什么这段值得背**：所有「单子布局组件」（Padding/SizedBox/Center/ConstrainedBox…）的 `performLayout` 都是这个套路 —— **改约束 → 让孩子布局 → 定孩子位置 → 算自己尺寸**。学会这一段，Day 3/8 的布局源码你都能自己读。

### 4.4 `RenderConstrainedBox` —— SizedBox 的 RenderObject

```dart
// rendering/proxy_box.dart:214-233（RenderConstrainedBox · 磁盘逐字 · 节选）
 214| class RenderConstrainedBox extends RenderProxyBox {
 215|   /// Creates a render box that constrains its child.
 216|   ///
 217|   /// The [additionalConstraints] argument must be valid.
 218|   RenderConstrainedBox({RenderBox? child, required BoxConstraints additionalConstraints})
 219|     : assert(additionalConstraints.debugAssertIsValid()),
 220|       _additionalConstraints = additionalConstraints,
 221|       super(child);
 222|
 223|   /// Additional constraints to apply to [child] during layout.
 224|   BoxConstraints get additionalConstraints => _additionalConstraints;
 225|   BoxConstraints _additionalConstraints;
 226|   set additionalConstraints(BoxConstraints value) {
 227|     assert(value.debugAssertIsValid());
 228|     if (_additionalConstraints == value) {
 229|       return;                                  // ← ⭐ 值没变就直接 return（不触发重新布局）
 230|     }
 231|     _additionalConstraints = value;
 232|     markNeedsLayout();                         // ← ⭐ 值变了才标记「需要重新布局」
 233|   }
```

**SizedBox 的 `width: 100` 是怎么生效的**：
- `SizedBox(width: 100)` → 造一个 `additionalConstraints = BoxConstraints.tightFor(width: 100)`（紧约束：`100<=w<=100`）
- 布局时它把这个约束 **`enforce`** 到父约束上（`box.dart:222-228`）⇒ **父给的上限若小于 100，结果就是父的上限**（口述句 1「父永远赢」）。

```dart
// widgets/basic.dart:2732-2744（SizedBox 的四个构造 · 磁盘逐字 · 节选）
2732| class SizedBox extends SingleChildRenderObjectWidget {
2733|   /// Creates a fixed size box. The [width] and [height] parameters can be null
2734|   /// to indicate that the size of the box should not be constrained in
2735|   /// the corresponding dimension.
        //   ↑ 中文：width/height 传 null = 那个维度「不施加约束」（不是 0！是完全不管）
2736|   const SizedBox({super.key, this.width, this.height, super.child});
2738|   /// Creates a box that will become as large as its parent allows.
2739|   const SizedBox.expand({super.key, super.child})
2740|     : width = double.infinity,               // ← ⭐ expand = 无限大 ⇒ enforce 后 = 父给的最大值
2741|       height = double.infinity;
2743|   /// Creates a box that will become as small as its parent allows.
2744|   const SizedBox.shrink({super.key, super.child}) : width = 0.0, height = 0.0;
```

> 🔑 **三个构造的机制解释（不用背，看懂就行）**：
> - `SizedBox(width: 100)` → 紧约束 100（受父上限夹）
> - `SizedBox.expand()` → `double.infinity` ⇒ `enforce` 时 `clampDouble(inf, min, max)` = **max** ⇒ 「尽量大」
> - `SizedBox.shrink()` → 0.0 ⇒ 但 `enforce` 时会被父的 **min** 夹上去 ⇒ 如果父给紧约束，shrink 也缩不下去

### 4.5 `Card` 为什么没有 `width` / `height`（你周考答错过的点）

```dart
// material/card.dart:73-93（Card 构造函数 · 磁盘逐字 · 节选：略去 :74-79 的 elevated 变体文档注释 —— 数一数，没有 width/height）
  73| class Card extends StatelessWidget {
  80|   const Card({
  81|     super.key,
  82|     this.color,
  83|     this.shadowColor,
  84|     this.surfaceTintColor,
  85|     this.elevation,
  86|     this.shape,
  87|     this.borderOnForeground = true,
  88|     this.margin,
  89|     this.clipBehavior,
  90|     this.child,
  91|     this.semanticContainer = true,
  92|   }) : assert(elevation == null || elevation >= 0.0),
  93|        _variant = _CardVariant.elevated;
```

> ⭐ **对着上面 12 个参数数一遍（当场数过）**：`key / color / shadowColor / surfaceTintColor / elevation / shape / borderOnForeground / margin / clipBehavior / child / semanticContainer`（+ 内部的 `_variant`）—— **没有 `width`，没有 `height`，也没有 `padding`**。
>
> **结论（周考判断题 2 的正确答案）**：
> - **`Card` 没有 width/height** ⇒ 尺寸**靠内容撑开**，或**靠外层给定**（`SizedBox(width: 240, child: Card(...))`）；
> - **`Container` 有 width/height**（`container.dart:263-264` 附近的字段声明）；
> - **`Card` 没有 padding** ⇒ 要给卡片内容留白，必须 `Card(child: Padding(...))`（§六 坑 4）。
>
> 💡 **这解释了你 Day 2 的一个真实现象**：Card 不加任何尺寸时「看起来大小刚好」—— 因为它是 `margin`（默认各边 4）+ 内容撑开的结果。**两张默认 Card 紧挨，视觉间距 = 4 + 4 = 8**（实测过）。

### 4.6 `Center` 就是 `Align`（居中的真相）

```dart
// widgets/basic.dart:2550-2553（Center 的全部源码 —— 只有 4 行！）
2550| class Center extends Align {
2551|   /// Creates a widget that centers its child.
2552|   const Center({super.key, super.widthFactor, super.heightFactor, super.child});
2553| }
```

```dart
// widgets/basic.dart:2462-2468（Align 的构造函数 · 节选：略去 :2463-2465 的 key/文档 —— 秘密在默认值）
2462| class Align extends SingleChildRenderObjectWidget {
2466|   const Align({
2467|     super.key,
2468|     this.alignment = Alignment.center,      // ← ⭐⭐ 默认值就是 center！
```

> 🔑 **`Center` 一个字都没写，为什么会居中？** 因为它继承 `Align`，而 **`Align` 的 `alignment` 参数默认值就是 `Alignment.center`**（`:2468`）。`Center` 只是「不暴露 alignment 参数的 Align」。
> **所以**：`Center(child: x)` ≡ `Align(alignment: Alignment.center, child: x)`。**想居左/居右/居上，直接用 `Align`**（Center 做不到，它没暴露这个参数）。
> Align 对应的 RenderObject 是 `RenderPositionedBox`（`rendering/shifted_box.dart:397`），它干的事和 §4.3 的 RenderPadding 同套路（改约束 + 定位置）。

---

## 五、核心 Widget 详解

### 5.1 `Container` — 万能容器（= 一串专职组件的组合）

- **一句话本质**：一个 **StatelessWidget**（`widgets/container.dart:246`），**自己什么布局都不做**，只按你传的参数**从内到外包一串壳**（§4.2）。
- **生活化类比**：一个「快递箱」—— 大小（width/height）、箱内泡沫（padding）、外观（decoration）、货怎么摆（alignment）、离别的箱子多远（margin）。
- **关键属性**：

| 属性 | 作用 | 造出哪一层（源码行） |
|---|---|---|
| `width` / `height` | 固定尺寸 | 转成 `constraints` → ConstrainedBox（`:434`） |
| `padding` | 内容↔箱子边缘 | Padding（`:402`），在 decoration **之内** |
| `margin` | 箱子↔外部 | Padding（`:438`），在 decoration **之外** |
| `decoration` | 颜色/圆角/边框/阴影 | DecoratedBox（`:422`） |
| `color` | 背景色（快捷方式） | ColoredBox（`:406`）⚠️ 与 decoration **互斥** |
| `alignment` | 孩子在盒子里摆哪 | Align（`:397`） |
| `clipBehavior` | 按 decoration 形状**裁孩子** | ClipPath（`:411`）← Day 6 圆角图的正解之一 |
| `constraints` | 尺寸范围（min/max） | ConstrainedBox（`:434`） |

- **代码示例**：

```dart
Container(
  padding: const EdgeInsets.all(24),          // 内部内边距 24（逻辑像素）
  decoration: BoxDecoration(                  // 外观（颜色+圆角必须在这，见坑 1）
    color: const Color(0xFFD9078F),           // 玫粉，0xFF = 不透明 + RRGGBB
    borderRadius: BorderRadius.circular(16),  // 圆角 16
  ),
  child: const Text('今天也要加油！', style: TextStyle(fontSize: 24)),
)
```

### 5.2 `Padding` — 内边距（专职版）

- **一句话本质**：一个 `SingleChildRenderObjectWidget`（`widgets/basic.dart:2300`），只做一件事：**把约束 deflate 一圈再给孩子**（§4.3）。
- **和 Container 的关系**：`Container(padding:)` 内层**就是** Padding（`:402`）。有的组件（如 `Card`）**没有 padding 参数**，就得用 `Padding` 包一层。

```dart
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: const Text('有呼吸感的文字'),
)
```

### 5.3 `SizedBox` — 固定尺寸 / 留白

- **一句话本质**：一个 `SingleChildRenderObjectWidget`（`widgets/basic.dart:2732`），给孩子施加**紧约束**（§4.4）。
- **生活化类比**：一段**固定长度的透明隔板** —— 放在两个组件中间把它们隔开。
- **两大用途**：① 固定尺寸 ② **纯留白**（`SizedBox(height: 12)` 不放 child）。

```dart
// ⚠️ 下面用到 Column —— 它是 Day 8 才正式学的组件，这里只是「预告示意」。
//    Day 2 你只需知道「SizedBox(height: 12) 能撑出 12 的垂直空隙」，不用会写 Column。
Column(
  children: [
    const Text('标题'),
    const SizedBox(height: 12),   // ← 标题和下面内容之间留 12 的垂直间距
    Container(...),
  ],
)
```

### 5.4 `Center` — 居中

- **一句话本质**：**就是 `Align` 且 alignment 默认为 center**（§4.6，源码只有 4 行）。
- 要非居中定位 → 用 `Align(alignment: Alignment.topLeft, ...)`（Center 没暴露这个参数）。

### 5.5 `Card` — Material 卡片（Day 2 认脸，Day 3 深入）

- **一句话本质**：一个 **StatelessWidget**（`material/card.dart:73`），自带圆角 + 阴影 + 外边距 4 的 Material 容器；**没有 width/height/padding**（§4.5）。

```dart
Card(
  elevation: 3,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: const BorderSide(color: Colors.grey),  // 边框线用 side，不是 elevation
  ),
  child: Padding(                                 // ← Card 没 padding 参数，必须自己包
    padding: const EdgeInsets.all(16),
    child: const Text('卡片内容'),
  ),
)
```

---

## 六、常见坑（错误写法 vs 正确写法 + **为什么会踩**）

### 坑 1 ❌ 颜色 + 圆角直接写在 Container 上

```dart
// ❌ borderRadius 不是 Container 的参数（§4.2 全文没有它）
Container(color: Colors.pink, borderRadius: BorderRadius.circular(16))
// ✅ 放进 decoration
Container(decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(16)))
```
**为什么会踩**：CSS 直觉里 `border-radius` 和 `background` 是同级属性。**Flutter 里圆角属于「装饰（Decoration）」这个子对象**。
**源码依据**：`container.dart:421-423` —— decoration 才造 DecoratedBox，圆角是 `BoxDecoration` 的字段。

### 坑 2 ❌ `const` 上下文里用 `Colors.grey[600]`

```dart
// ❌ 编译错：Const variables must be initialized with a constant value
const TextStyle(color: Colors.grey[600])
// ✅ 三选一
const TextStyle(color: Colors.grey)            // 常量本身
const TextStyle(color: Color(0xFF9E9E9E))      // 写死 ARGB
TextStyle(color: Colors.grey.shade600)         // 去掉 const（getter 也是运行时）
```
**为什么会踩**：`Colors.grey` 能进 const，直觉上「加个下标也该能」。但 `[600]` 是**调用 `[]` 运算符 = 运行时方法调用**；`.shade600` 是 **getter = 运行时**。const 要求编译期可求值。
**你 Day 2 踩过、Day 5 又写进笔记 ⇒ 这是你的高频坑，单独记。**

### 坑 3 ❌ 以为 `EdgeInsets.all(24)` 在屏幕上是 24 个物理点

**真相**：24 是**逻辑像素**，物理像素 = 24 × DPR（retina 2.0 ⇒ **48**）。**不是 bug**（术语卡 2）。
**为什么会踩**：拿尺子/截图量像素，忘了 DPR 换算。**规矩：讨论尺寸一律说逻辑像素。**

### 坑 4 ❌ `Card(padding: ...)` → 编译错「No named parameter」

```dart
// ❌ Card 没有 padding 参数（§4.5 数过 12 个参数，没有它）
Card(padding: const EdgeInsets.all(16), child: Text('x'))
// ✅ 自己包一层 Padding
Card(child: Padding(padding: const EdgeInsets.all(16), child: const Text('x')))
```
**为什么会踩**：Container 有 padding，以为 Card 也该有。**Card 是「Material 外观壳」，不管内容留白。**

### 坑 5 ❌ Padding 加错层级（内容还是贴边）

```dart
// ❌ padding 加在内部小容器上 → 只有那个小容器离边远了，整体还是贴边
Card(child: Column(children: [Padding(padding: ..., child: Text('a')), Text('b')]))
// ✅ 「包得越靠外，推开越多」—— 要让全部内容都离卡片边远，Padding 要包住整个 Column
Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Text('a'), Text('b')])))
```
**为什么会踩**：以为 padding 是「全局设置」。**它是组件，作用范围 = 它的 child 子树**（源码 `:261` deflate 只对它的直接孩子生效）。
**⚠️ 这条你 Day 2 实战踩过**（原踩坑记录第 5 条，保留）。

### 坑 6 ❌ 写了 `width: 100` 结果实测 94，以为代码没生效

**真相**：父约束上限只有 94 ⇒ `enforce` 用 `clampDouble` 把你**静默夹到 94**（`box.dart:225`），**不报错**。
**为什么会踩**：以为「我写的数字一定生效」。**父约束永远赢**（口述句 1）。
**你 Day 8 🔴 实测踩过**（最高柱写 100 实测 94，被外层 SizedBox(100)+Padding(3) 夹断）。**今天你终于看到那个 `clampDouble` 了。**

---

## 七、边界对比（近邻概念 A vs B）

### 1. `Container` vs `Padding` vs `SizedBox` vs `DecoratedBox`

| | 能改尺寸 | 能加留白 | 能画背景/圆角 | 本质 |
|---|:---:|:---:|:---:|---|
| `Container` | ✅(width/height/constraints) | ✅(padding/margin) | ✅(color/decoration) | **组合壳**（拼上面几个） |
| `Padding` | ❌ | ✅ | ❌ | 只做 deflate（`:261`） |
| `SizedBox` | ✅ | ✅(空着当隔板) | ❌ | 只做紧约束（enforce） |
| `DecoratedBox` | ❌ | ❌ | ✅ | 只画装饰 |

**判据**：**「我只需要一件事，还是好几件？」** 一件 → 用专职组件（Padding/SizedBox/DecoratedBox，**更轻、语义更清楚**）；好几件 → Container。
**代价**：Container 每多一个参数就多一层壳（§4.2）⇒ **无脑用 Container 会让 widget 树变深**（性能与可读性都差一点）。

### 2. `Container(color:)` vs `Container(decoration: BoxDecoration(color:))`

| | `color:` | `decoration:` |
|---|---|---|
| 造哪一层 | ColoredBox（`:406`） | DecoratedBox（`:422`） |
| 能圆角吗 | ❌ | ✅（borderRadius） |
| 能边框/阴影/渐变吗 | ❌ | ✅ |
| 能同时写吗 | **❌ 互斥**（assert 拦） | — |

**判据**：**只要纯色 → `color:`（更轻）；要圆角/边框/阴影/渐变 → `decoration:`。**

### 3. `padding` vs `margin`（源码里都是 Padding！）

| | `padding` | `margin` |
|---|---|---|
| 源码层 | `:402` 的 Padding | `:438` 的 Padding |
| 位置 | 在 decoration **之内** | 在 decoration **之外** |
| 背景色覆盖它吗 | ✅ 覆盖（留白有底色） | ❌ 不覆盖（留白透明） |

**判据**：**「这块留白要不要有背景色？」** 要 → padding；不要 → margin。**同一个 Padding 组件，只因包的位置不同就有两种语义** —— 这是 §4.2 最漂亮的发现。

### 4. `Center` vs `Align` vs `Container(alignment:)`

| | 能定位到 | 源码 |
|---|---|---|
| `Center` | **只能居中**（没暴露 alignment） | `basic.dart:2550-2553`（继承 Align 默认值） |
| `Align` | 任意 9 个方位 + 自定义 | `basic.dart:2462-2468` |
| `Container(alignment:)` | 任意（内部造 Align，`:397`） | 等价于 Align，但多一层 Container |

**判据**：**只居中 → Center（最短）；要别的方位 → Align；已经因为别的原因用了 Container → 顺手写 alignment。**

### 5. `Card` vs `Container`（你周考判断题 2）

| | `Card` | `Container` |
|---|---|---|
| width/height | **❌ 没有**（`:80-93` 数过） | ✅ 有 |
| padding | **❌ 没有** | ✅ 有 |
| margin | ✅ 有（默认各边 4） | ✅ 有（默认 null） |
| 圆角/阴影 | ✅ **默认自带**（Material 规范） | ❌ 要自己写 decoration |
| 本质 | Material 外观壳 | 万能组合壳 |

**判据**：**要「Material 卡片观感」（圆角+阴影+规范留白）→ Card；要精确控尺寸/自定义外观 → Container。** 尺寸控制上 Card 弱（没 width/height），需要就外面包 SizedBox。

---

## 八、诊断视角（布局不对怎么查）

> 今天的诊断技能是**你后面 30 天最常用的**，务必练熟。

1. **`flutter run` 里按 `p`** → 打开 `debugPaintSizeEnabled`（`rendering/debug.dart:36` `bool debugPaintSizeEnabled = false;`；热键在 `flutter_tools/lib/src/resident_runner.dart` 的 `case 'p'`）。
   **效果**：每个盒子涂色 + 画尺寸箭头 + **padding 区域画出斜纹**（`shifted_box.dart:271-281` 的 `debugPaintSize` → `debugPaintPadding`）。
   ⇒ **一眼看出「padding 到底加在哪一层、多大」** —— 这是诊断坑 5（padding 加错层）的唯一硬办法。
2. **用 `LayoutBuilder` 把约束打印出来**（诊断「为什么我写的 width 不生效」的利器）：
   ```dart
   LayoutBuilder(builder: (context, constraints) {
     debugPrint('父给我的约束 = $constraints');     // 例：BoxConstraints(0.0<=w<=800.0, 0.0<=h<=600.0)
     return Container(width: 100, height: 100, color: Colors.blue);
   })
   ```
   **怎么读**：`0.0<=w<=800.0` = 松约束（宽最多 800，可以更小）；`100.0<=w<=100.0` = 紧约束（必须 100）；`0.0<=h<=Infinity` = **高无界**（⚠️ Day 3/9 的报错根源）。
   **这就是口述句 1 的实操验证**：先看父给了什么，再判断子的要求会不会被 `enforce` 夹掉。
3. **Flutter Inspector（DevTools / 编辑器面板）**：选中组件 → **Layout Explorer** 看每个节点的 constraints 与 size；Widget Tree 面板看 Container 到底被拆成了几层壳（你会亲眼看到 §4.2 那串 Align/Padding/ColoredBox/DecoratedBox）。
4. **`debugDumpRenderTree()`**：控制台打印渲染树。**「Container 到底包了几层」用这个看最清楚。**
5. **`flutter analyze` 查不出什么**：今天所有问题（约束被夹、padding 加错层、逻辑像素误解）**全是运行期布局问题**，analyze 全绿 ≠ 布局对。**必须真跑 `flutter run -d macos` 目检。**

---

## 九、明确欠账（没讲透 / 没验证的）

1. **`BoxDecoration` 只讲了 color/borderRadius**：gradient（渐变）、boxShadow（阴影多光源）、image（背景图）、shape（circle）都没展开。**留 Day 3 / 后续 UI 专题。**
2. **`Transform` / `clipBehavior` 只点到源码存在**（`container.dart:411 / 441`）：矩阵变换、按形状裁剪的机制**没跑探针**。clipBehavior 与 Day 6 圆角图的关系已埋伏笔，**Day 6 会回收**。
3. **`RenderPositionedBox`（Align/Center 的 RenderObject）没读源码**：只在 §4.6 提了名字（`shifted_box.dart:397`）。它的 `performLayout` 和 §4.3 同套路，**但没逐行读** ⇒ 「Center 在有界/无界下自己多大」**未实测**。
4. **`constrain` 与 `enforce` 的差别没细讲**：`:258 / :265` 用的是 `constrain`（夹一个 Size），`:222` 是 `enforce`（夹一组 Constraints）。**今天混着说了「夹」，严格区分留 Day 8。**
5. **`const` 的重建收益没实测**：`identical(const SizedBox(8), const SizedBox(8))` 实测为 **false**（自定义 const 类），**「const 何时让框架跳过重建」未验证到可下结论** ⇒ 留 Day 10（setState/重建边界）用真实重建场景验证。**今天只讲「const 的语法约束」（坑 2），不讲性能收益。**
6. **主题系统（`ColorScheme.fromSeed` / `Theme.of`）刻意不教**：你 Day 2 曾被 seed→primary 的色调派生坑过（改同色系 RGB 几乎不变，误以为没生效）。**今天所有颜色一律直接指定**（`Colors.xxx` / `Color(0xFF...)`），主题留 **Day 35**（那天顺带清你的 ARGB 欠账）。
7. **书原文未逐章 `ov read` 核对**：机制部分全部来自本机 SDK 3.44.0 源码实读（每处贴码、可 `verify_inline_code.py` 校验）；①⑧⑦③⑨ 章节用于**定位与对照**，本次未逐章跑全文。**诚实欠账** —— 书与本笔记冲突时以 SDK 源码为准，并告诉导师去核书。

---

## 十、今日踩坑记录（Day 2 你实际踩过的 · 原样保留 + 补源码解释）

| # | 坑 | 错误写法 | 正确写法 | **源码解释（2026-09-16 补）** |
|---|----|---------|---------|---|
| 1 | 颜色+圆角不能直接写 | `Container(color:.., borderRadius:..)` | 放进 `decoration: BoxDecoration(...)` | `container.dart:421-423`：只有 decoration 造 DecoratedBox，borderRadius 是 BoxDecoration 的字段（§六 坑 1） |
| 2 | 逻辑像素 vs 物理像素 | 以为 `all(24)` = 24 屏幕像素 | 24 = 逻辑像素，屏幕 = 24 × DPR（retina 2.0 → 48） | 术语卡 2；实测确认过，**不是 bug** |
| 3 | const + `Colors.grey[600]` | `const TextStyle(color: Colors.grey[600])` | `Colors.grey` 或 `Color(0xFF...)` | `[600]` 是运行时 `[]` 运算符调用，const 要求编译期可求值（§六 坑 2） |
| 4 | Card 没有 padding 参数 | `Card(padding: ...)` | `Card(child: Padding(...))` | `card.dart:80-93` 的 12 个参数里没有 padding（§4.5 当场数过） |
| 5 | Padding 加错位置 | padding 加在内部小容器上 | 「包得越靠外，推开越多」—— Padding 要包住整个 Column | `shifted_box.dart:261`：deflate 只对自己的直接孩子生效（§六 坑 5） |

---

## 十一、今日应掌握清单

- [ ] 能背出**布局三步对话**：父给约束 → 子报尺寸 → 父定位置（口述句 1）
- [ ] 能说出 `Container` 至少 6 个属性，并知道**每个参数造哪一层壳**（§4.2）
- [ ] 记住「背景色+圆角必须放 `BoxDecoration`」（坑 1）
- [ ] 能解释 `deflate`（Padding）与 `enforce`（SizedBox）分别在干什么（口述句 3）
- [ ] 区分 `Padding`（内容↔边缘）与 `SizedBox`（元素↔元素/固定尺寸）
- [ ] 理解「逻辑像素 vs 物理像素（DPR）」
- [ ] 知道 **Card 没有 width/height/padding**（§4.5）
- [ ] 知道 **Center 就是 alignment 默认 center 的 Align**（§4.6）
- [ ] 会用 `Card + Padding` 搭一张卡片
- [ ] **会用两个诊断动作**：按 `p` 看涂色、`LayoutBuilder` 打印约束（§八 1-2）

---

## 十二、学后自查题（先过这关再写练习 · 答案不内嵌）

> 用法：**合上笔记**凭记忆作答，做完发导师批改。答不出 = Day 2 盲区，按〔回看〕补课。
> 参考答案不在本笔记（导师侧：`flutter-learning/shared/solutions/day2/day2_自查题参考答案.md`，作答后解锁）。

**L1/L2 基础**

1. `EdgeInsets` 的三种写法分别是什么？`EdgeInsets.symmetric(horizontal: 16, vertical: 8)` 表示哪几边各多少？〔回看 术语卡 3〕
2. `Container` 的 `padding` 和 `margin` 有什么可见差别？（提示：背景色覆盖哪个）〔回看 §七-3〕
3. 为什么「背景色 + 圆角」必须写进 `BoxDecoration`，不能直接写在 Container 上？〔回看 §六 坑 1〕
4. `Card` 缺哪三个常用参数（Container 有而 Card 没有）？要控制 Card 的宽度该怎么办？〔回看 §4.5、§七-5〕

**💎 L3 深挖（口述机制 + 指得到源码行号；答不全 → 记 weak_points）**

5. **说出「布局三步对话」的三步，并各指一处源码。** 再回答：如果子组件要求的尺寸**超过**父约束的上限，会发生什么？会报错吗？〔回看 §二 口述句 1、§4.1 enforce、§六 坑 6〕
6. **`Container` 是「一个盒子」吗？它的 `build` 做了什么？** 请说出至少 4 个「参数 → 造出哪一层组件」的对应关系（带源码行号）。**空 `Container()`（所有参数 null、有 child）会变成什么？**〔回看 §4.2〕
7. **`Padding` 和 `SizedBox` 分别靠 `BoxConstraints` 的哪个方法工作？这两个方法各做了什么运算？** 为什么 `deflate` 里要套两层 `math.max`？〔回看 §4.1、§4.3〕
8. **`Center` 的源码只有 4 行，它为什么会居中？**（要说出它继承谁、那个默认值在哪一行）。想让孩子居左上角该怎么写？〔回看 §4.6〕

> ✅ 全过 → 开始练习；答不全 → 先补那个点。

---

## 十三、自查清单（按 L3 产出规范逐条打勾）

- [ ] **0. 读原文预检**：机制部分全部来自本机 SDK 3.44.0 **磁盘逐字读出**（`widgets/container.dart`、`rendering/box.dart`、`rendering/shifted_box.dart`、`rendering/proxy_box.dart`、`material/card.dart`、`widgets/basic.dart`）；书章节（①ch17 / ⑧ch1 / ⑦ch4 / ③ / ⑨ch6）本次**未逐章 `ov read`**，仅用于定位对照 → 已在 §九 欠账 7 诚实标注。
- [x] **1. 每个 Widget 有一句话本质**：Container(5.1) / Padding(5.2) / SizedBox(5.3) / Center(5.4) / Card(5.5)。
- [x] **2. 每个「为什么」能指到源码行号**：全文机制断言均标 `container.dart:387` 等；**0 处「书里说」式断言**。
- [x] **3. 有边界对比**：§七 五组（Container/Padding/SizedBox/DecoratedBox、color/decoration、padding/margin、Center/Align、Card/Container）。
- [x] **4. ≥3 个坑且写明「为什么会踩」**：§六 共 6 个坑 + §十 你的 5 条真实踩坑记录（已补源码解释）。
- [x] **5. 有可复跑验证**：§八 5 条诊断动作（按 `p`、LayoutBuilder 打印约束、Inspector、debugDumpRenderTree）；§十三 给了校验命令。
- [x] **6. 有口述验收句（机制级）**：§二 三句，每句标源码行号（这三句是后面 30 天的总钥匙）。
- [x] **7. 无答案泄漏**：§十二 八题只有题干；答案在 `shared/solutions/day2/`。§十 是你的历史踩坑记录（非题目答案）。
- [x] **8. 有学后自查题**：§十二 八题（4 基础 + 4 💎 L3），每题带〔回看〕。
- [x] **9. 贴码铁律（2026-09-16 新增）**：每处 `文件:行号` 都配代码块或落对照册；`extract_refs.py` 0 处假行号；`verify_inline_code.py` 内联码逐字一致；关键源码带中文逐行注释；**计数断言当场数过 —— Card 构造函数 12 个参数（无 width/height/padding）、Container.build 里 8 个「参数→壳」的 if**。

> **超纲自查**：本笔记**未使用** Row/Column 教学（§5.3 那处 Column 已明确标注「Day 8 才学，此处仅示意」）、未使用 Expanded/Flexible（Day 3）、Stack/Positioned（Day 4）、Image/Icon（Day 6）、Buttons（Day 7）、ListView（Day 9）、setState（Day 10）、Theme.of/ColorScheme（Day 35，§九 欠账 6 明确说明为何刻意不教）、Dart 自定义函数（Day 4）。颜色一律直接指定。
