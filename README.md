# 学习进度对账表 · Progress Tracker

> 36 个主题日 + 组件打勾清单。每完成一项就 `[x]` 并 commit——这个文件本身就是学习轨迹。
> 状态图例：✅ 完成并实测 ｜ 🔶 学过但有欠账 ｜ ⏳ 进行中 ｜ ⬜ 未开始

## 一、Day 路线总表

### 模块 1 · Flutter 基础（Day 1-4）

| Day  | 主题                                                         | 状态 | 一句话收获                               |
| ---- | ------------------------------------------------------------ | ---- | ---------------------------------------- |
| 1    | Hello World：main / runApp / MaterialApp / Scaffold / AppBar / Center / Text | ✅    | Widget≠界面，已源码验证（见文章 01）     |
| 2    | 容器与单子布局：Container / Padding / SizedBox / Center + Card / BoxDecoration / EdgeInsets | ✅    | 约束的「三步对话」= 后面一切的地基       |
| 3    | 单子布局补充：Expanded / Flexible / SafeArea / SingleChildScrollView | ✅    | 💎 ParentDataWidget 机制已实测            |
| 4    | 手势与定位：GestureDetector / Positioned / Stack + Dart 函数补课 | ✅    | 实测推翻「GD 无 child 点不中」的流传说法 |

### 模块 2 · 基础组件（Day 5-9）

| Day  | 主题                                                         | 状态 | 一句话收获                               |
| ---- | ------------------------------------------------------------ | ---- | ---------------------------------------- |
| 5    | Text 样式深化 + TextSpan 富文本                              | ✅    | Text.build→merge→RichText 全链读通       |
| 6    | Image + Icon（含 FadeInImage 占位图）                        | ✅    | Icon=字符 已源码验证（见文章 02）        |
| 7    | Buttons 全家族 + 禁用态 + styleFrom                          | 🔶    | 按钮渲染链是我当前的薄弱点，复测中       |
| 8    | Column + Row + Flex（主轴/交叉轴/弹性比例）                  | 🔶    | Flex 两遍布局算法讲透了，练习收尾中      |
| 9    | 滚动：ListView / ListTile / GridView（💎 懒加载 Sliver 协议） | ⏳    | 为什么 builder 版只 build 可见项——进行中 |

**节点① 周考（Day 1-7）**：✅ 已完成，错题已整理进复习队列，后续出「补课篇」公开

### 模块 3-9 · 后续路线（Day 10-38）

| Day  | 主题                                                         | 状态 |
| ---- | ------------------------------------------------------------ | ---- |
| 10   | StatefulWidget 两 Class + setState + 生命周期                | ⬜    |
| 11   | Scaffold/AppBar 进阶 + 底部导航                              | ⬜    |
| 12   | Drawer + TabBar（控制器联动）                                | ⬜    |
| 13   | 📝 阶段小考 1（Day 1-12）                                     | ⬜    |
| 14   | Navigator push/pop + 页面传值 ｜ **节点②：Day 8-14 合集考试** | ⬜    |
| 15   | 命名路由 + PageView                                          | ⬜    |
| 16   | Forms 表单 + 校验                                            | ⬜    |
| 17   | Future / async-await 系统化                                  | ⬜    |
| 18   | HTTP + JSON                                                  | ⬜    |
| 19   | FutureBuilder + 加载三态                                     | ⬜    |
| 20   | 本地持久化（SharedPreferences / sqflite）                    | ⬜    |
| 21   | Repository 模式入门                                          | ⬜    |
| 22   | 💎 InheritedWidget（手写 .of）                                | ⬜    |
| 23   | Provider                                                     | ⬜    |
| 24   | Stream / BLoC 入门                                           | ⬜    |
| 25   | 状态 5 方案对照复盘（口述选型）                              | ⬜    |
| 26   | 📝 阶段小考 2（Day 14-25）｜ **节点③**                        | ⬜    |
| 27   | 隐式动画 Animated* 家族                                      | ⬜    |
| 28   | 显式动画 AnimationController / Tween / Curves                | ⬜    |
| 29   | Hero + 页面转场                                              | ⬜    |
| 30   | 杂项 Widget 大全 + mixin                                     | ⬜    |
| 31   | 调试与性能工具链                                             | ⬜    |
| 32   | 💎 Keys / Element / 变更检测                                  | ⬜    |
| 33   | 💎 三棵树系统化（Widget/Element/RenderObject）                | ⬜    |
| 34   | 测试系统化（unit / widget / mockito）                        | ⬜    |
| 35   | 主题 / 颜色系统（清 ARGB + fromSeed 欠账）                   | ⬜    |
| 36   | 工程化入门（分层 / DI）                                      | ⬜    |
| 37   | 发布（Release / 签名 / APK）                                 | ⬜    |
| 38   | 🎓 毕业综合项目（独立从零交付）                               | ⬜    |

---

## 二、Widget 打勾清单（按学习顺序）

> 每个组件要求 = 一句话本质 + 知道关键参数为什么 + 能写 +（💎 项）能讲渲染机制。

### 骨架 / 应用结构

- [x] `runApp` — 把 Widget 挂上 Element 树的入口（Day 1）
- [x] `MaterialApp` — 主题/路由/脚手架的顶层配置（Day 1）
- [x] `Scaffold` — 页面骨架：appBar/body/floatingActionButton…自带 Material（Day 1）
- [x] `AppBar` — implements PreferredSizeWidget（Day 1）
- [ ] `BottomNavigationBar` / `NavigationBar`（Day 11）
- [ ] `Drawer`（Day 12）
- [ ] `TabBar` + `TabBarView`（Day 12）

### 单子布局 / 容器

- [x] `Container` — 一个壳：参数→内部包 Padding/Margin/DecoratedBox…（Day 2）
- [x] `Padding` / `EdgeInsets`（Day 2）
- [x] `SizedBox` — 定尺寸/撑空（Day 2）
- [x] `Center` — 就是 Align 默认值（Day 2）
- [x] `DecoratedBox` / `BoxDecoration` — 圆角/阴影/边框/渐变（Day 2）
- [x] `SafeArea` — Padding + math.max(避开刘海/手势条)（Day 3）
- [ ] `Opacity` / `ClipRRect`（Day 30）
- [ ] `Tooltip`（Day 30）

### 多子布局

- [x] `Column` / `Row` — 都是 Flex 的壳；默认 mainAxisSize.max（Day 8）
- [x] 💎 `Flex` — 主轴/交叉轴/两遍布局算法（Day 8）
- [x] 💎 `Expanded` / `Flexible` — ParentDataWidget<FlexParentData>；Expanded≡Flexible(tight)（Day 3/8）
- [x] `Spacer` — Expanded 的空白特例（Day 8）
- [x] `Stack` — 默认 fit=loose、alignment=左上（Day 4）
- [x] 💎 `Positioned` — ParentDataWidget<StackParentData>，坐标指令不画东西（Day 4）
- [ ] `Wrap`（Day 30）

### 内容展示

- [x] `Text` — build→读 DefaultTextStyle→merge→RichText（Day 1/5）
- [x] `TextSpan` / RichText 富文本混排（Day 5）
- [x] `TextStyle` / copyWith（Day 5）
- [x] `Image` — 三构造殊途同归到 RawImage（Day 6）
- [x] `FadeInImage` — 占位图 + 渐显（Day 6）
- [x] `Icon` — 本质是字符：fromCharCode(codePoint)→TextSpan（Day 6，见文章 02）
- [x] `Card` — 12 参数无 width/height，M3 用表面色代阴影（Day 2/3）

### 滚动 / 💎 懒加载

- [x] `SingleChildScrollView` — 单子+无界约束给孩子 loose（Day 3）
- [x] 💎 `ListView`（builder 版）— SliverChildBuilderDelegate 只 build 可见+cacheExtent（Day 9 ⏳ 待复跑验证）
- [x] `ListTile` — 密排列表行（Day 9 ⏳）
- [x] `GridView`（Day 9 ⏳）
- [ ] 💎 `CustomScrollView` + Sliver 协议（Day 9 机制已讲，动手未做）

### 交互

- [x] 💎 `GestureDetector` — 无 child 默认 translucent 铺满可点（已实测，Day 4）
- [x] `ElevatedButton` / `FilledButton` / `OutlinedButton` / `TextButton`（Day 7 🔶 渲染链欠账待复测）
- [x] `IconButton`（Day 7 🔶）
- [x] `FloatingActionButton`（Day 7 🔶）
- [ ] `Checkbox` / `Radio` / `Switch` / `Slider`（Day 16 前未排→随表单日补）
- [ ] 💎 `InkWell` / 水波纹机制（Day 7 已见源码，L3 复测未过）

### 状态 / 数据 / 导航（未开始）

- [ ] 💎 `StatefulWidget` + State 生命周期（Day 10）
- [ ] 💎 `InheritedWidget` / .of 模式（Day 22）
- [ ] `Provider` / `Consumer`（Day 23）
- [ ] `StreamBuilder`（Day 24）
- [ ] `Navigator` / `Route`（Day 14-15）
- [ ] `PageView`（Day 15）
- [ ] `Form` + `TextFormField`（Day 16）
- [ ] `FutureBuilder`（Day 19）
- [ ] 💎 `Hero`（Day 29）
- [ ] `AnimatedContainer` 等 Animated* 家族（Day 27）

---

*统计口径：勾 = 学过且练习实测通过；🔶 = 学过但有薄弱点待复测；⏳ = 进行中。每周随学习推进更新。*
