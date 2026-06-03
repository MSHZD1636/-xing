# 星语 StarWhisper · 星座运势 App

> 每日一语，星辰指引

基于 **HarmonyOS Next（ArkTS + ArkUI）** 开发的纯前端 Mock 数据星座运势应用。神秘星空风格，沉浸式深紫主题，面向年轻用户提供每日运势、星座图鉴、配对测试、塔罗抽签、星座日历与个人中心等多元功能。

## 技术规格

| 项目 | 内容 |
|------|------|
| 平台 | HarmonyOS Next |
| 语言 | ArkTS + ArkUI（Stage 模型） |
| SDK | 6.0.2(22) |
| 数据 | 纯前端 Mock，确定性算法生成（同一天结果固定） |
| 设备 | Phone |

## 功能模块（20 个页面）

- **首页模块**：启动页（粒子动画）、首页、运势详情、全部运势、搜索、推送设置
- **图鉴 / 配对 / 塔罗**：星座图鉴、星座百科（雷达图）、配对选择、配对结果、元素科普、塔罗抽签（翻牌动画）、塔罗解读
- **日历 / 个人中心**：星座日历、日历详情、个人中心、星座设置、收藏夹、生日查询、星盘知识

## 目录结构

```
entry/src/main/ets/
├── entryability/EntryAbility.ets   # 应用入口
├── pages/                          # 20 个页面
├── components/                     # 6 个公共组件
│   ├── BottomTabBar / ConstellationCard / FortuneScoreBar
│   └── StarRating / RadarChart / TarotCard
├── mock/                           # 5 个 Mock 数据文件
├── model/                          # 4 个数据模型
└── utils/                          # Constants / DateUtils / StorageUtils
```

## 关键实现

| 功能点 | 实现方式 |
|--------|----------|
| 塔罗翻牌动画 | `@ohos.animator` 控制 `rotateY` 0→180°，`Stack` 正反面切换 |
| 启动页粒子 | `animator` 循环帧驱动 `Canvas` 绘制闪烁星点 |
| 雷达图 | `Canvas` 绘制六维属性多边形 |
| 生日→星座识别 | `DateUtils` 日期边界判断 |
| 每日塔罗固定 | `(年 + 月 + 日) % 22` 决定当日牌 |
| 运势 / 配对 | 确定性哈希算法生成，无需后端 |
| 持久化 | `@ohos.data.preferences` 存储星座、收藏、塔罗记录、推送设置 |
| 星空背景 | `LinearGradient` 纯代码渐变，零图片依赖 |

## 运行

使用 DevEco Studio 打开本工程，选择 Phone 模拟器或真机，点击运行即可。项目在**零图片**情况下即可完整演示（图标、塔罗牌、背景均由代码占位生成）。
