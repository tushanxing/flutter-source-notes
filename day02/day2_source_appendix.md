# Day 2 源码对照册（Source Appendix）

> 🤖 **本文件由 `shared/tools/extract_refs.py` 自动生成，不是手写的。**
> 每段代码都是从本机 SDK 磁盘**逐字读出**的：
> `/opt/homebrew/share/flutter/packages/flutter/lib/src/...`（Flutter 3.44.0）
> 左侧 `行号|` 就是磁盘上的真实行号 —— 你可以用 `sed -n '51,59p' <文件>` 自己核对。

**为什么要这份册子**：笔记 `day2_study.md` 里有 **43 处**
`文件:行号` 引用，其中 **18 处只给了行号、没贴代码** —— 看不懂是正常的。
这份册子按文件分组，把每处引用的**真实源码**贴出来，并标注「它是在解释笔记的哪一句话」。

## 怎么用
1. 读笔记遇到 `xxx.dart:123` 看不懂 → 在本册子里 `⌘F` 搜 `xxx.dart:123`（或搜行号 `123`）
2. 看「📍 服务于笔记」那行，回到笔记对应位置
3. 想自己核对：`sed -n '<起>,<止>p' /opt/homebrew/share/flutter/packages/<路径>`

## 目录一览

| # | SDK 文件 | 引用处数 | 笔记里用它讲什么 |
|---|---|---|---|
| 1 | `widgets/container.dart` | 9 | | `Container.build` = 一串嵌套盒子（哪个参数造哪一层） | **Flutter SDK 3.4… |
| 2 | `rendering/box.dart` | 10 | | `BoxConstraints` 的 `deflate` / `enforce` / `loosen` / `w… |
| 3 | `rendering/shifted_box.dart` | 8 | | `RenderPadding.performLayout`（Padding 怎么工作） | **SDK `ren… |
| 4 | `rendering/proxy_box.dart` | 2 | | `RenderConstrainedBox`（SizedBox 的 RenderObject） | **SDK… |
| 5 | `material/card.dart` | 4 | | `Card` 构造函数**没有 width/height** | **SDK `material/card.da… |
| 6 | `widgets/basic.dart` | 8 | | `Center extends Align`（居中的真相） | **SDK `widgets/basic.dar… |
| 7 | `painting/edge_insets.dart` | 1 | - **源码依据**：`painting/edge_insets.dart:390` `class EdgeInsets… |
| 8 | `rendering/debug.dart` | 1 | 1. **`flutter run` 里按 `p`** → 打开 `debugPaintSizeEnabled`（`re… |

---

## 1. `flutter/lib/src/widgets/container.dart`

### `container.dart:246`

```dart
  246| class Container extends StatelessWidget {
```

**📍 服务于笔记：**
- 笔记第 396 行：一句话本质**：一个 **StatelessWidget**（`widgets/container.dart:246`），**自己什么布局都不做**，只按你传的参数**从内到外包一串壳**（§4.2）。

### `container.dart:263-264`

```dart
  263|     double? width,
  264|     double? height,
```

**📍 服务于笔记：**
- 笔记第 363 行：`Container` 有 width/height**（`container.dart:263-264` 附近的字段声明）；

### `container.dart:387-446`

```dart
  387|   Widget build(BuildContext context) {
  388|     Widget? current = child;
  389| 
  390|     if (child == null && (constraints == null || !constraints!.isTight)) {
  391|       current = LimitedBox(
  392|         maxWidth: 0.0,
  393|         maxHeight: 0.0,
  394|         child: ConstrainedBox(constraints: const BoxConstraints.expand()),
  395|       );
  396|     } else if (alignment != null) {
  397|       current = Align(alignment: alignment!, child: current);
  398|     }
  399| 
  400|     final EdgeInsetsGeometry? effectivePadding = _paddingIncludingDecoration;
  401|     if (effectivePadding != null) {
  402|       current = Padding(padding: effectivePadding, child: current);
  403|     }
  404| 
  405|     if (color != null) {
  406|       current = ColoredBox(color: color!, isAntiAlias: isAntiAlias, child: current);
  407|     }
  408| 
  409|     if (clipBehavior != Clip.none) {
  410|       assert(decoration != null);
  411|       current = ClipPath(
  412|         clipper: _DecorationClipper(
  413|           textDirection: Directionality.maybeOf(context),
  414|           decoration: decoration!,
  415|         ),
  416|         clipBehavior: clipBehavior,
  417|         child: current,
  418|       );
  419|     }
  420| 
  421|     if (decoration != null) {
  422|       current = DecoratedBox(decoration: decoration!, child: current);
  423|     }
  424| 
  425|     if (foregroundDecoration != null) {
  426|       current = DecoratedBox(
  427|         decoration: foregroundDecoration!,
  428|         position: DecorationPosition.foreground,
  429|         child: current,
  430|       );
  431|     }
  432| 
  433|     if (constraints != null) {
  434|       current = ConstrainedBox(constraints: constraints!, child: current);
  435|     }
  436| 
  437|     if (margin != null) {
  438|       current = Padding(padding: margin!, child: current);
  439|     }
  440| 
  441|     if (transform != null) {
  442|       current = Transform(transform: transform!, alignment: transformAlignment, child: current);
  443|     }
  444| 
  445|     return current!;
  446|   }
```

**📍 服务于笔记：**
- 笔记第 702 行：[x] **2. 每个「为什么」能指到源码行号**：全文机制断言均标 `container.dart:387` 等；**0 处「书里说」式断言**。
- 笔记第 12 行：`Container.build` = 一串嵌套盒子（哪个参数造哪一层） | **Flutter SDK 3.44.0 `widgets/container.dart:387-446`** | **源码级原理** ⭐⭐ |
- 笔记第 63 行：依据：`widgets/container.dart:387-446`（完整 build，§四-4.2 逐行贴出）。
- 笔记第 177 行：// widgets/container.dart:387-446（Container.build 全文 · 磁盘逐字 · 这是「万能盒子」的真相）
- 笔记第 623 行：2. **`Transform` / `clipBehavior` 只点到源码存在**（`container.dart:411 / 441`）：矩阵变换、按形状裁剪的机制**没跑探针**。clipBehavior 与 Day 6 圆角图的关系已埋伏笔，**Day 6 会回收**。
- 笔记第 490 行：源码依据**：`container.dart:421-423` —— decoration 才造 DecoratedBox，圆角是 `BoxDecoration` 的字段。
- 笔记第 636 行：1 | 颜色+圆角不能直接写 | `Container(color:.., borderRadius:..)` | 放进 `decoration: BoxDecoration(...)` | `container.dart:421-423`：只有 decoration 造 DecoratedBox，borderRadius 是 BoxDecoration 的字段（§六 坑 1） |

---

## 2. `flutter/lib/src/rendering/box.dart`

### `box.dart:199-259`

```dart
  199|   /// Returns new box constraints that are smaller by the given edge dimensions.
  200|   BoxConstraints deflate(EdgeInsetsGeometry edges) {
  201|     assert(debugAssertIsValid());
  202|     final double horizontal = edges.horizontal;
  203|     final double vertical = edges.vertical;
  204|     final double deflatedMinWidth = math.max(0.0, minWidth - horizontal);
  205|     final double deflatedMinHeight = math.max(0.0, minHeight - vertical);
  206|     return BoxConstraints(
  207|       minWidth: deflatedMinWidth,
  208|       maxWidth: math.max(deflatedMinWidth, maxWidth - horizontal),
  209|       minHeight: deflatedMinHeight,
  210|       maxHeight: math.max(deflatedMinHeight, maxHeight - vertical),
  211|     );
  212|   }
  213| 
  214|   /// Returns new box constraints that remove the minimum width and height requirements.
  215|   BoxConstraints loosen() {
  216|     assert(debugAssertIsValid());
  217|     return BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight);
  218|   }
  219| 
  220|   /// Returns new box constraints that respect the given constraints while being
  221|   /// as close as possible to the original constraints.
  222|   BoxConstraints enforce(BoxConstraints constraints) {
  223|     return BoxConstraints(
  224|       minWidth: clampDouble(minWidth, constraints.minWidth, constraints.maxWidth),
  225|       maxWidth: clampDouble(maxWidth, constraints.minWidth, constraints.maxWidth),
  226|       minHeight: clampDouble(minHeight, constraints.minHeight, constraints.maxHeight),
  227|       maxHeight: clampDouble(maxHeight, constraints.minHeight, constraints.maxHeight),
  228|     );
  229|   }
  230| 
  231|   /// Returns new box constraints with a tight width and/or height as close to
  232|   /// the given width and height as possible while still respecting the original
  233|   /// box constraints.
  234|   BoxConstraints tighten({double? width, double? height}) {
  235|     return BoxConstraints(
  236|       minWidth: width == null ? minWidth : clampDouble(width, minWidth, maxWidth),
  237|       maxWidth: width == null ? maxWidth : clampDouble(width, minWidth, maxWidth),
  238|       minHeight: height == null ? minHeight : clampDouble(height, minHeight, maxHeight),
  239|       maxHeight: height == null ? maxHeight : clampDouble(height, minHeight, maxHeight),
  240|     );
  241|   }
  242| 
  243|   /// A box constraints with the width and height constraints flipped.
  244|   BoxConstraints get flipped {
  245|     return BoxConstraints(
  246|       minWidth: minHeight,
  247|       maxWidth: maxHeight,
  248|       minHeight: minWidth,
  249|       maxHeight: maxWidth,
  250|     );
  251|   }
  252| 
  253|   /// Returns box constraints with the same width constraints but with
  254|   /// unconstrained height.
  255|   BoxConstraints widthConstraints() => BoxConstraints(minWidth: minWidth, maxWidth: maxWidth);
  256| 
  257|   /// Returns box constraints with the same height constraints but with
  258|   /// unconstrained width.
  259|   BoxConstraints heightConstraints() => BoxConstraints(minHeight: minHeight, maxHeight: maxHeight);
```

**📍 服务于笔记：**
- 笔记第 114 行：// rendering/box.dart:199-212（deflate：把约束「缩小一圈」· 磁盘逐字）
- 笔记第 28 行：本笔记里每处 `rendering/box.dart:200` 这类标注，**都紧跟一个代码块贴出那段真实源码**（本机 SDK 3.44.0 磁盘逐字读出）。
- 笔记第 66 行：依据：`rendering/box.dart:200-212`（`deflate`：minWidth - horizontal，且用 `math.max(0.0, ...)` 保证不为负）；`:222-228`（`enforce`：clamp 进父约束）；`rendering/shifted_box.dart:261`（`constraints.deflate(padding)` 就是 Padding 的全部秘密）。
- 笔记第 13 行：`BoxConstraints` 的 `deflate` / `enforce` / `loosen` / `widthConstraints` | **SDK `rendering/box.dart:200-259`** | **源码级原理** ⭐⭐ |
- 笔记第 103 行：源码依据**：`painting/edge_insets.dart:390` `class EdgeInsets extends EdgeInsetsGeometry`；它的 `horizontal` / `vertical` getter 就是 `deflate` 里用的那两个数（`box.dart:202-203`）。
- 笔记第 152 行：// rendering/box.dart:214-218 + 253-259（loosen 与 widthConstraints · 磁盘逐字）
- 笔记第 135 行：// rendering/box.dart:220-229（enforce：把自己的要求「夹进」父约束 · 磁盘逐字）
- 笔记第 60 行：依据：`rendering/box.dart:222-228`（`enforce` 用 `clampDouble` 把子的要求**夹进**父的范围）；`rendering/shifted_box.dart:261-267`（RenderPadding 完整走了一遍这三步）。
- 笔记第 315 行：布局时它把这个约束 **`enforce`** 到父约束上（`box.dart:222-228`）⇒ **父给的上限若小于 100，结果就是父的上限**（口述句 1「父永远赢」）。
- 笔记第 533 行：真相**：父约束上限只有 94 ⇒ `enforce` 用 `clampDouble` 把你**静默夹到 94**（`box.dart:225`），**不报错**。

---

## 3. `flutter/lib/src/rendering/shifted_box.dart`

### `shifted_box.dart:254-268`

```dart
  254|   void performLayout() {
  255|     final BoxConstraints constraints = this.constraints;
  256|     final EdgeInsets padding = _resolvedPadding;
  257|     if (child == null) {
  258|       size = constraints.constrain(Size(padding.horizontal, padding.vertical));
  259|       return;
  260|     }
  261|     final BoxConstraints innerConstraints = constraints.deflate(padding);
  262|     child!.layout(innerConstraints, parentUsesSize: true);
  263|     final childParentData = child!.parentData! as BoxParentData;
  264|     childParentData.offset = Offset(padding.left, padding.top);
  265|     size = constraints.constrain(
  266|       Size(padding.horizontal + child!.size.width, padding.vertical + child!.size.height),
  267|     );
  268|   }
```

**📍 服务于笔记：**
- 笔记第 14 行：`RenderPadding.performLayout`（Padding 怎么工作） | **SDK `rendering/shifted_box.dart:254-268`** | 源码级原理 |
- 笔记第 256 行：// rendering/shifted_box.dart:254-268（RenderPadding.performLayout · 磁盘逐字）
- 笔记第 66 行：依据：`rendering/box.dart:200-212`（`deflate`：minWidth - horizontal，且用 `math.max(0.0, ...)` 保证不为负）；`:222-228`（`enforce`：clamp 进父约束）；`rendering/shifted_box.dart:261`（`constraints.deflate(padding)` 就是 Padding 的全部秘密）。
- 笔记第 640 行：5 | Padding 加错位置 | padding 加在内部小容器上 | 「包得越靠外，推开越多」—— Padding 要包住整个 Column | `shifted_box.dart:261`：deflate 只对自己的直接孩子生效（§六 坑 5） |
- 笔记第 60 行：依据：`rendering/box.dart:222-228`（`enforce` 用 `clampDouble` 把子的要求**夹进**父的范围）；`rendering/shifted_box.dart:261-267`（RenderPadding 完整走了一遍这三步）。

### `shifted_box.dart:271-281`

```dart
  271|   void debugPaintSize(PaintingContext context, Offset offset) {
  272|     super.debugPaintSize(context, offset);
  273|     assert(() {
  274|       final Rect outerRect = offset & size;
  275|       debugPaintPadding(
  276|         context.canvas,
  277|         outerRect,
  278|         child != null ? _resolvedPaddingCache!.deflateRect(outerRect) : null,
  279|       );
  280|       return true;
  281|     }());
```

**📍 服务于笔记：**
- 笔记第 603 行：效果**：每个盒子涂色 + 画尺寸箭头 + **padding 区域画出斜纹**（`shifted_box.dart:271-281` 的 `debugPaintSize` → `debugPaintPadding`）。

### `shifted_box.dart:397`

```dart
  397| class RenderPositionedBox extends RenderAligningShiftedBox {
```

**📍 服务于笔记：**
- 笔记第 388 行：Align 对应的 RenderObject 是 `RenderPositionedBox`（`rendering/shifted_box.dart:397`），它干的事和 §4.3 的 RenderPadding 同套路（改约束 + 定位置）。
- 笔记第 624 行：3. **`RenderPositionedBox`（Align/Center 的 RenderObject）没读源码**：只在 §4.6 提了名字（`shifted_box.dart:397`）。它的 `performLayout` 和 §4.3 同套路，**但没逐行读** ⇒ 「Center 在有界/无界下自己多大」**未实测**。

---

## 4. `flutter/lib/src/rendering/proxy_box.dart`

### `proxy_box.dart:214-233`

```dart
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
  229|       return;
  230|     }
  231|     _additionalConstraints = value;
  232|     markNeedsLayout();
  233|   }
```

**📍 服务于笔记：**
- 笔记第 15 行：`RenderConstrainedBox`（SizedBox 的 RenderObject） | **SDK `rendering/proxy_box.dart:214-233`** | 源码级原理 |
- 笔记第 290 行：// rendering/proxy_box.dart:214-233（RenderConstrainedBox · 磁盘逐字 · 节选）

---

## 5. `flutter/lib/src/material/card.dart`

### `card.dart:73-93`

```dart
   73| class Card extends StatelessWidget {
   74|   /// Creates an elevated variant of Card.
   75|   ///
   76|   /// Elevated cards have a drop shadow, providing more separation from the
   77|   /// background than filled cards, but less than outlined cards.
   78|   ///
   79|   /// The [elevation] must be null or non-negative.
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

**📍 服务于笔记：**
- 笔记第 461 行：一句话本质**：一个 **StatelessWidget**（`material/card.dart:73`），自带圆角 + 阴影 + 外边距 4 的 Material 容器；**没有 width/height/padding**（§4.5）。
- 笔记第 16 行：`Card` 构造函数**没有 width/height** | **SDK `material/card.dart:73-93`** | 源码级原理（你周考答错过的点） |
- 笔记第 341 行：// material/card.dart:73-93（Card 构造函数全文 · 磁盘逐字 —— 数一数，没有 width/height）
- 笔记第 639 行：4 | Card 没有 padding 参数 | `Card(padding: ...)` | `Card(child: Padding(...))` | `card.dart:80-93` 的 12 个参数里没有 padding（§4.5 当场数过） |

---

## 6. `flutter/lib/src/widgets/basic.dart`

### `basic.dart:2300`

```dart
 2300| class Padding extends SingleChildRenderObjectWidget {
```

**📍 服务于笔记：**
- 笔记第 426 行：一句话本质**：一个 `SingleChildRenderObjectWidget`（`widgets/basic.dart:2300`），只做一件事：**把约束 deflate 一圈再给孩子**（§4.3）。

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
- 笔记第 17 行：`Center extends Align`（居中的真相） | **SDK `widgets/basic.dart:2462-2468 / 2550-2553`** | 源码级原理 |
- 笔记第 379 行：// widgets/basic.dart:2462-2468（Align 的构造函数 —— 秘密在默认值）
- 笔记第 579 行：`Align` | 任意 9 个方位 + 自定义 | `basic.dart:2462-2468` |

### `basic.dart:2550-2553`

```dart
 2550| class Center extends Align {
 2551|   /// Creates a widget that centers its child.
 2552|   const Center({super.key, super.widthFactor, super.heightFactor, super.child});
 2553| }
```

**📍 服务于笔记：**
- 笔记第 371 行：// widgets/basic.dart:2550-2553（Center 的全部源码 —— 只有 4 行！）
- 笔记第 578 行：`Center` | **只能居中**（没暴露 alignment） | `basic.dart:2550-2553`（继承 Align 默认值） |

### `basic.dart:2732-2744`

```dart
 2732| class SizedBox extends SingleChildRenderObjectWidget {
 2733|   /// Creates a fixed size box. The [width] and [height] parameters can be null
 2734|   /// to indicate that the size of the box should not be constrained in
 2735|   /// the corresponding dimension.
 2736|   const SizedBox({super.key, this.width, this.height, super.child});
 2737| 
 2738|   /// Creates a box that will become as large as its parent allows.
 2739|   const SizedBox.expand({super.key, super.child})
 2740|     : width = double.infinity,
 2741|       height = double.infinity;
 2742| 
 2743|   /// Creates a box that will become as small as its parent allows.
 2744|   const SizedBox.shrink({super.key, super.child}) : width = 0.0, height = 0.0;
```

**📍 服务于笔记：**
- 笔记第 438 行：一句话本质**：一个 `SingleChildRenderObjectWidget`（`widgets/basic.dart:2732`），给孩子施加**紧约束**（§4.4）。
- 笔记第 318 行：// widgets/basic.dart:2732-2744（SizedBox 的四个构造 · 磁盘逐字 · 节选）

---

## 7. `flutter/lib/src/painting/edge_insets.dart`

### `edge_insets.dart:390`

```dart
  390| class EdgeInsets extends EdgeInsetsGeometry {
```

**📍 服务于笔记：**
- 笔记第 103 行：源码依据**：`painting/edge_insets.dart:390` `class EdgeInsets extends EdgeInsetsGeometry`；它的 `horizontal` / `vertical` getter 就是 `deflate` 里用的那两个数（`box.dart:202-203`）。

---

## 8. `flutter/lib/src/rendering/debug.dart`

### `debug.dart:36`

```dart
   36| bool debugPaintSizeEnabled = false;
```

**📍 服务于笔记：**
- 笔记第 602 行：1. **`flutter run` 里按 `p`** → 打开 `debugPaintSizeEnabled`（`rendering/debug.dart:36` `bool debugPaintSizeEnabled = false;`；热键在 `flutter_tools/lib/src/resident_runner.dart` 的 `case 'p'`）。

---
