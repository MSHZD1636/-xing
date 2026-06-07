# -*- coding: utf-8 -*-
"""生成《星语 StarWhisper》鸿蒙移动应用设计报告 .docx"""
from docx import Document
from docx.shared import Pt, RGBColor, Cm
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

doc = Document()

# ---------- 全局样式：正文宋体五号 ----------
normal = doc.styles['Normal']
normal.font.name = 'Times New Roman'
normal.font.size = Pt(10.5)
normal._element.rPr.rFonts.set(qn('w:eastAsia'), '宋体')

def set_run(run, name='宋体', size=10.5, bold=False, color=None):
    run.font.name = 'Times New Roman'
    run._element.rPr.rFonts.set(qn('w:eastAsia'), name)
    run.font.size = Pt(size)
    run.font.bold = bold
    if color:
        run.font.color.rgb = RGBColor(*color)

def heading(text, level=1):
    sizes = {1: 16, 2: 14, 3: 12}
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(10)
    p.paragraph_format.space_after = Pt(6)
    r = p.add_run(text)
    set_run(r, '黑体', sizes.get(level, 12), bold=True, color=(0x1F, 0x1F, 0x4E))
    return p

def body(text, size=10.5, bold=False, align=None, indent=True):
    p = doc.add_paragraph()
    if indent:
        p.paragraph_format.first_line_indent = Pt(21)
    p.paragraph_format.space_after = Pt(4)
    p.paragraph_format.line_spacing = 1.4
    if align:
        p.alignment = align
    r = p.add_run(text)
    set_run(r, size=size, bold=bold)
    return p

def bullet(text, lvl=0):
    p = doc.add_paragraph(style='List Bullet' if lvl == 0 else 'List Bullet 2')
    p.paragraph_format.space_after = Pt(2)
    r = p.add_run(text)
    set_run(r, size=10.5)
    return p

def kv(label, value):
    p = doc.add_paragraph()
    p.paragraph_format.space_after = Pt(3)
    r1 = p.add_run(label)
    set_run(r1, size=10.5, bold=True, color=(0x33, 0x33, 0x66))
    r2 = p.add_run(value)
    set_run(r2, size=10.5)
    return p

def shade_cell(cell, hexcolor):
    tcPr = cell._tc.get_or_add_tcPr()
    shd = OxmlElement('w:shd')
    shd.set(qn('w:val'), 'clear')
    shd.set(qn('w:color'), 'auto')
    shd.set(qn('w:fill'), hexcolor)
    tcPr.append(shd)

def placeholder(label, height_cm=5.0):
    """插入一个用于粘贴用例图/截图的占位框"""
    t = doc.add_table(rows=1, cols=1)
    t.alignment = WD_TABLE_ALIGNMENT.CENTER
    t.style = 'Table Grid'
    cell = t.cell(0, 0)
    shade_cell(cell, 'F2F2F7')
    cell.width = Cm(15)
    tr = t.rows[0]
    tr.height = Cm(height_cm)
    p = cell.paragraphs[0]
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run('【 此处插入：' + label + ' 】')
    set_run(r, size=10.5, bold=True, color=(0x88, 0x88, 0x99))
    p2 = cell.add_paragraph()
    p2.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r2 = p2.add_run('（用例图 / 页面运行截图）')
    set_run(r2, size=9, color=(0xAA, 0xAA, 0xBB))
    doc.add_paragraph().paragraph_format.space_after = Pt(2)

def caption(text):
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run(text)
    set_run(r, size=9, color=(0x66, 0x66, 0x66))
    p.paragraph_format.space_after = Pt(8)

# ========================= 封面 =========================
for _ in range(3):
    doc.add_paragraph()
p = doc.add_paragraph(); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
r = p.add_run('鸿蒙移动应用'); set_run(r, '黑体', 26, bold=True, color=(0x1F, 0x1F, 0x4E))
p = doc.add_paragraph(); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
r = p.add_run('设 计 报 告'); set_run(r, '黑体', 26, bold=True, color=(0x1F, 0x1F, 0x4E))
doc.add_paragraph()
p = doc.add_paragraph(); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
r = p.add_run('—— 星语 StarWhisper · 星座运势 App ——'); set_run(r, '楷体', 15, color=(0x55, 0x33, 0x88))
for _ in range(4):
    doc.add_paragraph()
for label in ['课程名称：移动应用开发技术', '题目名称：星语 StarWhisper 星座运势应用',
              '班　　级：＿＿＿＿＿＿＿＿＿＿', '学　　号：＿＿＿＿＿＿＿＿＿＿',
              '姓　　名：＿＿＿＿＿＿＿＿＿＿', '指导教师：李晓、张登辉',
              '完成日期：2026 年 6 月']:
    pp = doc.add_paragraph(); pp.alignment = WD_ALIGN_PARAGRAPH.CENTER
    rr = pp.add_run(label); set_run(rr, '宋体', 13)
    pp.paragraph_format.space_after = Pt(6)
doc.add_page_break()

# ========================= 任务书要求 =========================
heading('引言　作业任务与要求', 1)
body('本设计报告依据《移动应用开发技术 期末综合作业任务书》完成，综合应用移动应用开发技术'
     '课程知识，设计并实现了一款基于 HarmonyOS（鸿蒙）Stage 模型的星座运势主题移动应用'
     '"星语 StarWhisper"。任务书核心要求与本项目达成情况如下：')

req_rows = [
    ('要求项', '任务书要求', '本项目达成情况'),
    ('主题设计', '明确 App 名称、服务对象、功能需求分析、实现意义', '见第一章，主题完整、定位清晰'),
    ('功能模块图', '功能模块图细分到二级功能模块', '见 1.2 节，含 8 个一级、30+ 二级模块'),
    ('页面草图', '为每个功能模块设计页面草图线稿', '见第三章，按模块预留草图位置'),
    ('功能描述表格', '功能模块 / 页面 / 工具包 / 组件 / 完成人', '见第六章功能描述总表'),
    ('页面数量', '每人完成不少于 5 个页面', '共 23 个功能页面，远超要求'),
    ('组件调用', '不少于 15 个组件类型（含布局、组件）', '实际使用 27 种组件类型（见 7.2）'),
    ('工具包导入', '不少于 10 个工具包导入', '导入 7 个系统 Kit、14+ 个系统 API（见 7.1）'),
    ('完整性 / 创新性', 'App 完整、具有创新性', '功能闭环；含粒子动画、雷达图、塔罗翻牌等创新点'),
]
tbl = doc.add_table(rows=0, cols=3); tbl.style = 'Table Grid'; tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
widths = [Cm(2.6), Cm(6.4), Cm(6.4)]
for i, row in enumerate(req_rows):
    cells = tbl.add_row().cells
    for j, txt in enumerate(row):
        cells[j].width = widths[j]
        if i == 0:
            shade_cell(cells[j], 'D9D9F2')
        para = cells[j].paragraphs[0]
        rr = para.add_run(txt)
        set_run(rr, size=10, bold=(i == 0))
caption('表 0-1　任务书要求与达成情况对照')

# ========================= 第一章 主题设计与功能模块图 =========================
heading('第一章　主题设计与功能模块图', 1)

heading('1.1　主题设计', 2)
kv('App 名称：', '星语 StarWhisper（每日一语，星辰指引）')
kv('应用定位：', '一款面向年轻用户的星座运势与心理陪伴类轻应用，纯前端 Mock 数据实现。')

body('（1）服务对象（用户特征与偏好）', bold=True, indent=False)
bullet('年龄层：以 16–35 岁的年轻群体为主，学生与初入职场人群居多；')
bullet('特征：对星座、塔罗、占卜等话题感兴趣，习惯每日查看运势获取心理暗示与情绪价值；')
bullet('偏好：喜欢精致的深色"星空"视觉风格、轻量化的交互、可分享的趣味内容与社交互动；')
bullet('使用场景：晨起 / 通勤 / 睡前等碎片化时间，快速查看当日运势、抽取塔罗、与星友聊天。')

body('（2）功能需求分析', bold=True, indent=False)
bullet('运势查询：提供十二星座每日综合运势及爱情、事业、财运、健康多维度评分；')
bullet('星座科普：星座图鉴、性格 / 爱情 / 职业解析、四象元素分类、星盘知识；')
bullet('趣味互动：星座配对测算、塔罗牌占卜、星座运势日历；')
bullet('社交陪伴：星友匹配并进入一对一聊天；')
bullet('个性化：账号注册登录、设置专属星座、收藏、推送时间、生日查询等。')

body('（3）实现意义', bold=True, indent=False)
body('"星语"以星座文化为切入点，将运势查询、知识科普、趣味占卜与轻社交融为一体，'
     '为用户提供积极的心理暗示与情绪陪伴。项目完整覆盖 HarmonyOS Stage 模型应用开发的'
     '主要技术点（ArkTS/ArkUI 声明式 UI、状态管理、页面路由、Canvas 绘制、动画、'
     '本地持久化等），既是一次完整的工程实践，也具备真实可用的产品形态。')

heading('1.2　功能模块图（细分到二级模块）', 2)
body('应用共划分为 8 个一级功能模块，每个一级模块进一步细分为若干二级功能，结构如下：')
module_tree = [
    ('① 启动与登录模块', ['启动页（粒子动画 / 初始化）', '注册登录（账号密码 / 注册 / 游客）']),
    ('② 首页运势模块', ['今日幸运星座', '星友匹配入口', '十二星座运势总览', '运势详情', '运势排行榜', '搜索', '推送设置']),
    ('③ 星座图鉴模块', ['星座列表图鉴', '星座详情（雷达图）', '四象元素分类', '星盘知识', '生日星座查询']),
    ('④ 星座配对模块', ['配对选择', '配对结果（环形进度 / 分享）']),
    ('⑤ 星友匹配聊天模块', ['星友匹配（用户卡 / 匹配分）', '一对一聊天（气泡 / 自动回复）']),
    ('⑥ 塔罗占卜模块', ['每日塔罗（翻牌 / 随机抽取）', '塔罗解读（牌面 / 三段解读 / 分享）']),
    ('⑦ 星座日历模块', ['月历运势（色点 / 图例）', '当日运势详情（多日切换）']),
    ('⑧ 个人中心模块', ['个人主页', '我的星座设置', '我的收藏']),
]
for m1, subs in module_tree:
    bullet(m1, 0)
    for s in subs:
        bullet(s, 1)
placeholder('应用整体功能模块图（一级 + 二级，可用 ProcessOn / Visio 绘制）', 7.0)
caption('图 1-1　星语 StarWhisper 功能模块图')

# ========================= 第二章 总体架构设计 =========================
heading('第二章　总体架构设计', 1)

heading('2.1　技术架构', 2)
body('应用基于 HarmonyOS Next（API 22，SDK 6.0.2）Stage 模型，使用 ArkTS 语言与 ArkUI '
     '声明式开发范式。整体采用"分层 + 组件化"架构，自上而下分为五层：')
arch_rows = [
    ('层次', '职责', '主要内容'),
    ('Ability 层', '应用入口与生命周期', 'EntryAbility（加载首页面）、EntryBackupAbility（备份）'),
    ('页面层 (pages)', 'UI 展示与交互', '23 个 @Entry 页面，负责布局、事件与路由跳转'),
    ('组件层 (components)', '可复用 UI 组件', 'BottomTabBar、StarRating、FortuneScoreBar、ConstellationCard、RadarChart、TarotCard'),
    ('数据层 (mock)', '业务数据与算法', 'ConstellationData、FortuneData、MatchData、CalendarData、TarotData、UserData'),
    ('模型层 (model)', '数据结构定义', 'Constellation、Fortune、MatchResult、TarotCard、AppUser 等接口'),
    ('工具层 (utils)', '通用工具与持久化', 'Constants（主题常量）、DateUtils（日期）、StorageUtils（Preferences 封装）'),
]
tbl = doc.add_table(rows=0, cols=3); tbl.style = 'Table Grid'; tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
for i, row in enumerate(arch_rows):
    cells = tbl.add_row().cells
    for j, txt in enumerate(row):
        cells[j].width = [Cm(3), Cm(4), Cm(8.4)][j]
        if i == 0:
            shade_cell(cells[j], 'D9D9F2')
        rr = cells[j].paragraphs[0].add_run(txt); set_run(rr, size=9.5, bold=(i == 0))
caption('表 2-1　分层架构职责说明')
placeholder('系统总体架构图（分层架构示意）', 6.0)
caption('图 2-1　总体技术架构图')

heading('2.2　工程目录结构', 2)
body('核心源码位于 entry/src/main 下，目录组织如下（节选）：', indent=False)
code = (
"entry/src/main\n"
"├─ ets\n"
"│  ├─ entryability/      EntryAbility.ets        应用入口 Ability\n"
"│  ├─ entrybackupability/EntryBackupAbility.ets  备份扩展\n"
"│  ├─ pages/             23 个功能页面 (*.ets)\n"
"│  ├─ components/        6 个可复用组件\n"
"│  ├─ model/             5 个数据模型接口\n"
"│  ├─ mock/              6 个 Mock 数据与算法模块\n"
"│  └─ utils/             Constants / DateUtils / StorageUtils\n"
"├─ resources/            media(图标/塔罗牌面) / profile / 字符串等\n"
"└─ module.json5          模块与页面路由配置 (main_pages.json)"
)
pcode = doc.add_paragraph()
rc = pcode.add_run(code)
rc.font.name = 'Consolas'; rc._element.rPr.rFonts.set(qn('w:eastAsia'), '宋体'); rc.font.size = Pt(9)

heading('2.3　数据流与状态管理', 2)
bullet('状态管理：页面内使用 @State 维护可变 UI 状态，自定义组件通过 @Prop 接收父组件参数，'
       '数据变更自动驱动 UI 刷新；')
bullet('数据来源：所有业务数据由 mock 层提供，运势 / 日历采用"（星座id + 日期）哈希"的确定性算法生成，'
       '保证同一星座同一天结果一致且可覆盖任意日期；')
bullet('本地持久化：StorageUtils 封装 @ohos.data.preferences，持久化登录态、账号列表、'
       '我的星座、昵称、收藏、塔罗记录、匹配用户、聊天记录等；')
bullet('跨页传参：通过 router 的 params 在页面间传递星座 id、日期、卡牌 id、用户 id 等。')
placeholder('数据流 / 状态管理示意图', 5.0)
caption('图 2-2　数据流与持久化示意图')

heading('2.4　页面跳转总览', 2)
body('应用以"启动页 → 登录页 → 首页"为主线，底部 6 个 Tab（首页 / 图鉴 / 配对 / 塔罗 / 日历 / 我的）'
     '通过 router.replaceUrl 互相切换，二级页面通过 router.pushUrl 进入、router.back 返回。'
     '主要跳转关系如下：')
nav_rows = [
    ('源页面', '触发动作', '目标页面', '跳转方式'),
    ('SplashPage', '2.2s 后按登录态', 'LoginPage / HomePage', 'replaceUrl'),
    ('LoginPage', '登录 / 注册 / 游客', 'HomePage', 'replaceUrl'),
    ('HomePage', '点击星座卡 / 幸运星座', 'FortuneDetailPage', 'pushUrl(id)'),
    ('HomePage', '星友匹配入口卡', 'UserMatchPage', 'pushUrl'),
    ('HomePage', '查看全部 / 搜索', 'AllFortuneListPage / SearchPage', 'pushUrl'),
    ('ConstellationListPage', '点击星座 / 元素 / 星盘', 'ConstellationDetailPage / ElementPage / StarChartPage', 'pushUrl'),
    ('MatchSelectPage', '开始测算', 'MatchResultPage', 'pushUrl(a,b)'),
    ('TarotPage', '查看详细解读', 'TarotDetailPage', 'pushUrl(cardId)'),
    ('CalendarPage', '点击某一天', 'CalendarDetailPage', 'pushUrl(date,id)'),
    ('UserMatchPage', '匹配后进入聊天', 'ChatPage', 'pushUrl(userId)'),
    ('ProfilePage', '菜单 / 设置星座', 'Favorite/Birthday/Notify/StarChart/MyConstellation', 'pushUrl'),
    ('ProfilePage', '退出登录', 'LoginPage', 'clear + replaceUrl'),
]
tbl = doc.add_table(rows=0, cols=4); tbl.style = 'Table Grid'; tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
for i, row in enumerate(nav_rows):
    cells = tbl.add_row().cells
    for j, txt in enumerate(row):
        cells[j].width = [Cm(3.4), Cm(3.6), Cm(5.6), Cm(2.8)][j]
        if i == 0:
            shade_cell(cells[j], 'D9D9F2')
        rr = cells[j].paragraphs[0].add_run(txt); set_run(rr, size=9, bold=(i == 0))
caption('表 2-2　页面跳转关系总览')
placeholder('页面跳转流程图（路由导航图）', 7.0)
caption('图 2-3　页面跳转流程图')

# ========================= 第三章 页面草图 =========================
heading('第三章　模块设计页面草图', 1)
body('为各功能模块设计页面草图线稿，用于指导后续 UI 开发。请在下方各占位处粘贴对应模块的'
     '页面草图（手绘线稿或低保真原型）。')
sketch_modules = ['启动与登录模块', '首页运势模块', '星座图鉴模块', '星座配对模块',
                  '星友匹配聊天模块', '塔罗占卜模块', '星座日历模块', '个人中心模块']
for i, m in enumerate(sketch_modules, 1):
    heading('3.%d　%s 页面草图' % (i, m), 3)
    placeholder('%s 页面草图线稿' % m, 6.0)
    caption('图 3-%d　%s 页面草图' % (i, m))

# ========================= 第四章 各功能模块详细说明 =========================
heading('第四章　各功能模块详细说明（流程 / 逻辑 / 页面跳转）', 1)
body('本章按功能模块逐页说明其作用、核心逻辑、操作流程与页面跳转，并在每个页面后预留'
     '"用例图 / 运行截图"占位框。')

# 每个模块: (标题, 简介, [ (页面名, 作用, 逻辑流程文本, [跳转]) ])
modules = [
 ("4.1　启动与登录模块", "负责应用启动展示、本地存储初始化与用户身份校验，是进入应用的入口。",
  [
   ("启动页 SplashPage",
    "展示品牌 Logo 与星空粒子动画，并完成初始化与首跳。",
    "进入后 aboutToAppear 初始化 Preferences 并写入默认演示账号；Canvas 生成 60 个粒子，"
    "通过 setInterval 定时重绘实现星点闪烁动画，Logo 使用 animateTo 渐入；2.2 秒后读取登录态，"
    "已登录跳首页、未登录跳登录页。",
    "→ LoginPage / HomePage（replaceUrl）"),
   ("注册登录页 LoginPage",
    "提供账号密码登录与注册，去除了手机验证码方式。",
    "顶部可切换“登录 / 注册”两种模式；登录校验账号密码（内置演示账号 msh / 12345678），"
    "注册校验账号长度、密码长度与两次一致性并写入账号列表后自动登录；另提供游客登录。"
    "成功后写入登录态与用户名并跳转首页。",
    "→ HomePage（replaceUrl）"),
  ]),
 ("4.2　首页运势模块", "应用核心模块，聚合每日运势、幸运星座、社交入口与十二星座总览。",
  [
   ("首页 HomePage",
    "展示日期问候、今日幸运星座轮播、星友匹配入口与十二星座运势宫格。",
    "aboutToAppear 计算当日幸运星座；Swiper 自动轮播幸运星座卡；星友匹配入口卡引导进入匹配；"
    "Grid 渲染 12 星座及其 StarRating 星级；点击任意星座进入运势详情。",
    "→ FortuneDetailPage / UserMatchPage / AllFortuneListPage / SearchPage（pushUrl）"),
   ("运势详情页 FortuneDetailPage",
    "展示单个星座当日综合运势与多维评分。",
    "根据传入星座 id 读取 getFortune，渲染综合星级、爱情/事业/财运/健康评分条、幸运色/数字/方位，"
    "并支持收藏（写入 Preferences）。",
    "← 返回；收藏状态持久化"),
   ("运势排行榜 AllFortuneListPage",
    "展示十二星座当日运势排序榜单。",
    "调用 getAllFortunesSorted 取得排序结果，支持高→低 / 低→高切换；点击条目进入对应详情。",
    "→ FortuneDetailPage（pushUrl）"),
   ("搜索页 SearchPage",
    "支持按名称搜索星座，提供快捷标签与历史。",
    "TextInput 实时过滤星座列表，提供热门标签与搜索历史；点击结果进入星座详情。",
    "→ ConstellationDetailPage（pushUrl）"),
   ("推送设置页 NotificationSettingPage",
    "设置每日运势推送开关与提醒时间。",
    "Toggle 控制开关，TimePicker 选择时间，设置写入 Preferences 持久化。",
    "← 返回；设置持久化"),
  ]),
 ("4.3　星座图鉴模块", "提供星座知识科普，包括图鉴、详情、元素分类、星盘与生日查询。",
  [
   ("星座图鉴页 ConstellationListPage",
    "以卡片宫格形式展示十二星座，并提供元素 / 星盘入口。",
    "Grid 渲染 ConstellationCard；提供进入四象元素页与星盘知识页的快捷入口。",
    "→ ConstellationDetailPage / ElementPage / StarChartPage（pushUrl）"),
   ("星座详情页 ConstellationDetailPage",
    "展示星座基本资料、性格、爱情、职业与能力雷达图。",
    "Tabs 分“基本/性格/爱情/职业”四个标签页；使用 Canvas 绘制六维能力 RadarChart 雷达图。",
    "← 返回"),
   ("四象元素页 ElementPage",
    "按火、水、土、风四象元素归类展示星座。",
    "将十二星座按元素分组，分区块展示对应星座卡片与元素特质说明。",
    "→ ConstellationDetailPage（pushUrl）"),
   ("星盘知识页 StarChartPage",
    "科普太阳、月亮、上升星座等星盘知识。",
    "使用可折叠区块分别介绍太阳 / 月亮 / 上升星座的含义。",
    "← 返回"),
   ("生日查询页 BirthdayQueryPage",
    "根据生日推算所属星座并展示特质。",
    "DatePicker 选择生日，点击查询调用 DateUtils.getConstellationId 推算星座并展示结果卡。",
    "← 返回"),
  ]),
 ("4.4　星座配对模块", "提供两两星座的契合度测算与结果分享。",
  [
   ("配对选择页 MatchSelectPage",
    "选择两个星座并发起配对测算。",
    "两个星座选择器 + 心形动画；点击“开始测算”携带双方 id 跳转结果页；另提供进入星友匹配入口。",
    "→ MatchResultPage / UserMatchPage（pushUrl）"),
   ("配对结果页 MatchResultPage",
    "展示两星座综合契合度与多维评分，可分享。",
    "调用 getMatchResult 计算（元素相生相克加权）契合度，环形进度展示总分，FortuneScoreBar 展示"
    "爱情 / 相处 / 默契等维度；通过 pasteboard 复制分享文案。",
    "← 返回；分享到剪贴板"),
  ]),
 ("4.5　星友匹配聊天模块", "提供用户与用户之间的匹配与一对一聊天（社交创新点）。",
  [
   ("星友匹配页 UserMatchPage",
    "展示可匹配的星友及与本人的契合度，发起匹配。",
    "渲染 10 位 Mock 用户卡片与匹配分（基于星座契合算法）；点击匹配写入已匹配列表并进入聊天对话。",
    "→ ChatPage（pushUrl(userId)）"),
   ("聊天页 ChatPage",
    "与匹配的星友进行一对一气泡聊天。",
    "首次进入对方先打招呼；发送消息后追加气泡并触发模拟自动回复；聊天记录通过 StorageUtils 持久化，"
    "使用 List + Scroller 自动滚动到底部。",
    "← 返回；聊天记录持久化"),
  ]),
 ("4.6　塔罗占卜模块", "提供每日塔罗抽取、翻牌动画与详细解读。",
  [
   ("每日塔罗页 TarotPage",
    "抽取并翻开当日塔罗牌，可再抽一张。",
    "按日期确定当日塔罗牌，TarotCard 组件用 animateTo 实现 3D 翻牌动画；“再抽一张”随机抽取并重建牌面；"
    "支持真实牌面图片（已导入大阿卡那牌面 PNG）。",
    "→ TarotDetailPage（pushUrl(cardId)）"),
   ("塔罗解读页 TarotDetailPage",
    "展示塔罗牌大图、关键词与三段式解读。",
    "根据卡牌 id 展示牌面（图片或渐变占位）、关键词标签与总体 / 爱情 / 事业解读，结合用户星座给出提示；"
    "可通过 pasteboard 分享解读文案。",
    "← 返回；分享到剪贴板"),
  ]),
 ("4.7　星座日历模块", "以月历形式展示运势走势，并可查看任意一天的详情。",
  [
   ("星座日历页 CalendarPage",
    "月历网格展示每日运势等级（色点 + 图例）。",
    "buildMonthCells 生成当月日历格子，每格按运势等级显示不同颜色圆点并附图例；支持上一月 / 下一月切换；"
    "点击任意日期进入当日详情；提供返回首页按钮。",
    "→ CalendarDetailPage（pushUrl(date,id)）；→ HomePage"),
   ("当日运势详情页 CalendarDetailPage",
    "展示选定日期的具体运势详情。",
    "展示综合星级与爱情 / 事业 / 财运 / 健康评分条及运势详解；支持“前一天 / 后一天”切换日期。",
    "← 返回"),
  ]),
 ("4.8　个人中心模块", "用户个性化中心，含资料、星座设置、收藏与退出登录。",
  [
   ("个人中心页 ProfilePage",
    "展示用户资料、今日运势卡与功能菜单。",
    "onPageShow 读取我的星座与昵称；展示今日运势卡与菜单（收藏 / 生日查询 / 推送设置 / 星盘知识）；"
    "退出登录使用 AlertDialog 二次确认，清空页面栈后跳转登录页。",
    "→ MyConstellationPage / FavoritePage 等（pushUrl）；退出 → LoginPage"),
   ("我的星座设置页 MyConstellationPage",
    "设置用户专属星座与昵称。",
    "DatePicker 输入生日自动识别星座，或手动点选；保存后写入 Preferences 并返回。",
    "← 返回；设置持久化"),
   ("我的收藏页 FavoritePage",
    "管理已收藏的星座运势。",
    "读取收藏列表渲染，支持滑动删除（swipeAction）与空状态展示；点击进入对应详情。",
    "→ FortuneDetailPage（pushUrl）"),
  ]),
]

for mtitle, intro, pages in modules:
    heading(mtitle, 2)
    body(intro)
    for pname, role, logic, nav in pages:
        heading('● ' + pname, 3)
        kv('页面作用：', role)
        kv('逻辑与流程：', logic)
        kv('页面跳转：', nav)
        placeholder('%s 用例图 / 运行截图' % pname, 5.5)
        caption('图　%s 用例图 / 运行截图' % pname)

# ========================= 第五章 公共组件与数据设计 =========================
heading('第五章　公共组件与数据设计', 1)
heading('5.1　可复用组件', 2)
comp_rows = [
    ('组件', '作用', '关键技术'),
    ('BottomTabBar', '底部 6 Tab 导航栏，全局复用', '@Prop currentIndex、router.replaceUrl'),
    ('StarRating', '1–5 星运势星级展示', 'ForEach 渲染星形'),
    ('FortuneScoreBar', '维度评分（标签+进度条+分值）', 'Progress / 自绘进度'),
    ('ConstellationCard', '星座卡片（符号/名称/日期）', '@Prop 传参、点击跳转'),
    ('RadarChart', '六维能力雷达图', 'Canvas + CanvasRenderingContext2D 绘制'),
    ('TarotCard', '塔罗翻牌动画卡', 'animateTo 控制 rotateY 翻转、支持图片牌面'),
]
tbl = doc.add_table(rows=0, cols=3); tbl.style = 'Table Grid'; tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
for i, row in enumerate(comp_rows):
    cells = tbl.add_row().cells
    for j, txt in enumerate(row):
        cells[j].width = [Cm(3.4), Cm(6), Cm(6)][j]
        if i == 0:
            shade_cell(cells[j], 'D9D9F2')
        rr = cells[j].paragraphs[0].add_run(txt); set_run(rr, size=9.5, bold=(i == 0))
caption('表 5-1　可复用组件说明')

heading('5.2　数据模型与 Mock 算法', 2)
bullet('数据模型(model)：Constellation（星座信息+雷达值）、Fortune（每日运势）、'
       'MatchResult（配对结果）、TarotCard（塔罗牌）、AppUser/ChatMessage（用户与消息）；')
bullet('运势算法(FortuneData)：以"星座id + 日期字符串"哈希为种子，确定性生成综合及多维评分，'
       '综合分经优化后均匀分布于 2–5 星，保证各星座运势多样；')
bullet('配对算法(MatchData)：基于四象元素相生相克关系加权计算契合度；')
bullet('塔罗算法(TarotData)：按日期确定当日牌、支持随机抽取，含 22 张大阿卡那与权杖牌组；')
bullet('日历数据(CalendarData)：复用运势算法生成整月每日运势等级；')
bullet('用户数据(UserData)：内置 10 位星友及自动回复语料。')

# ========================= 第六章 功能描述总表 =========================
heading('第六章　功能描述（表格）', 1)
body('下表按功能模块汇总各页面所调用的工具包与主要组件，"完成人"列供小组分工填写。')
func_rows = [
 ('功能模块', '页面（*.ets）', '工具包 / 导入', '主要组件', '完成人'),
 ('启动与登录', 'SplashPage、LoginPage',
  '@kit.ArkUI(router/promptAction)、@kit.AbilityKit(common)、@kit.PerformanceAnalysisKit(hilog)、@ohos.data.preferences、Constants、StorageUtils',
  'Stack、Column、Canvas、Text、TextInput、Button', ''),
 ('首页运势', 'HomePage、FortuneDetailPage、AllFortuneListPage、SearchPage、NotificationSettingPage',
  '@kit.ArkUI(router/promptAction)、DateUtils、StorageUtils、FortuneData、ConstellationData、StarRating、FortuneScoreBar',
  'Column、Row、Grid、Swiper、List、Scroll、Text、Button、TextInput、Toggle、TimePicker、Blank', ''),
 ('星座图鉴', 'ConstellationListPage、ConstellationDetailPage、ElementPage、StarChartPage、BirthdayQueryPage',
  '@kit.ArkUI(router)、ConstellationData、RadarChart、ConstellationCard、DateUtils',
  'Grid、Tabs、TabContent、Canvas、Column、Row、DatePicker、Divider、Text', ''),
 ('星座配对', 'MatchSelectPage、MatchResultPage',
  '@kit.ArkUI(router)、@kit.BasicServicesKit(pasteboard)、MatchData、FortuneScoreBar、StorageUtils',
  'Column、Row、Progress、Circle、Button、Text、Blank', ''),
 ('星友匹配聊天', 'UserMatchPage、ChatPage',
  '@kit.ArkUI(router)、UserData、MatchData、StorageUtils、AppUser',
  'List、ListItem、Scroll、TextInput、Button、Stack、Circle、Text', ''),
 ('塔罗占卜', 'TarotPage、TarotDetailPage',
  '@kit.ArkUI(router/promptAction)、@kit.BasicServicesKit(pasteboard)、TarotData、TarotCard、DateUtils、StorageUtils',
  'Stack、Image、Flex、Column、Button、Text、ForEach', ''),
 ('星座日历', 'CalendarPage、CalendarDetailPage',
  '@kit.ArkUI(router)、CalendarData、FortuneData、DateUtils、StorageUtils、StarRating、FortuneScoreBar、BottomTabBar',
  'Grid、GridItem、Column、Row、Scroll、Text、Button', ''),
 ('个人中心', 'ProfilePage、MyConstellationPage、FavoritePage',
  '@kit.ArkUI(router/promptAction)、@kit.PerformanceAnalysisKit(hilog)、StorageUtils、DateUtils、ConstellationData、StarRating、BottomTabBar',
  'List、ListItem、DatePicker、Grid、AlertDialog、Button、Text、Circle', ''),
 ('公共组件', 'components/*.ets（6 个）',
  'Constants、各 model 接口、@kit.ArkUI',
  'Canvas、Progress、ForEach、Column、Row、Text（被各页面复用）', ''),
]
tbl = doc.add_table(rows=0, cols=5); tbl.style = 'Table Grid'; tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
fw = [Cm(2.2), Cm(4.0), Cm(5.2), Cm(3.8), Cm(1.6)]
for i, row in enumerate(func_rows):
    cells = tbl.add_row().cells
    for j, txt in enumerate(row):
        cells[j].width = fw[j]
        if i == 0:
            shade_cell(cells[j], 'D9D9F2')
        rr = cells[j].paragraphs[0].add_run(txt); set_run(rr, size=8.5, bold=(i == 0))
caption('表 6-1　功能描述总表（功能模块 / 页面 / 工具包 / 组件 / 完成人）')

# ========================= 第七章 技术指标达成 =========================
heading('第七章　技术指标达成情况', 1)
heading('7.1　工具包（系统 Kit / API）导入清单', 2)
body('项目共导入 7 个系统 Kit、14+ 个系统 API，满足"不少于 10 个工具包导入"的要求：')
kit_rows = [
    ('序号', '系统 Kit', '导入的 API', '用途'),
    ('1', '@kit.ArkUI', 'router', '页面路由跳转'),
    ('2', '@kit.ArkUI', 'promptAction', 'Toast 轻提示'),
    ('3', '@kit.ArkUI', 'window', '窗口 / 沉浸式设置'),
    ('4', '@kit.ArkData', 'preferences', '本地键值持久化'),
    ('5', '@kit.AbilityKit', 'common / UIAbility / Want', 'Ability 上下文与生命周期'),
    ('6', '@kit.AbilityKit', 'AbilityConstant / ConfigurationConstant', '启动参数与配置常量'),
    ('7', '@kit.PerformanceAnalysisKit', 'hilog', '日志打印'),
    ('8', '@kit.BasicServicesKit', 'pasteboard', '剪贴板（分享）'),
    ('9', '@kit.LocalizationKit', 'intl', '日期本地化格式化'),
    ('10', '@kit.CoreFileKit', 'BackupExtensionAbility / BundleVersion', '数据备份扩展'),
]
tbl = doc.add_table(rows=0, cols=4); tbl.style = 'Table Grid'; tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
for i, row in enumerate(kit_rows):
    cells = tbl.add_row().cells
    for j, txt in enumerate(row):
        cells[j].width = [Cm(1.4), Cm(5), Cm(5.5), Cm(4.5)][j]
        if i == 0:
            shade_cell(cells[j], 'D9D9F2')
        rr = cells[j].paragraphs[0].add_run(txt); set_run(rr, size=9, bold=(i == 0))
caption('表 7-1　系统工具包（Kit/API）导入清单')

heading('7.2　组件类型清单（27 种，≥15）', 2)
body('项目共使用 27 种 ArkUI 组件类型（含布局容器与基础组件），满足"不少于 15 个组件类型"的要求：')
comps = ('Column、Row、Stack、Flex、Grid、GridItem、List、ListItem、Scroll、Swiper、Tabs、TabContent、'
         'Text、Button、Image、TextInput、Toggle、Divider、Blank、Circle、Canvas、DatePicker、TimePicker、'
         'Progress、Checkbox、Select、AlertDialog')
body(comps)

heading('7.3　页面数量', 2)
body('应用共实现 23 个功能页面（另含 2 个 Ability），远超"每人不少于 5 个页面"的要求；'
     '具体清单见第四章及第六章功能描述总表。')

# ========================= 第八章 创新点与总结 =========================
heading('第八章　创新点与总结', 1)
heading('8.1　创新点', 2)
bullet('星空粒子启动动画：Canvas + setInterval 实现星点闪烁与 Logo 渐入；')
bullet('六维能力雷达图：Canvas 自绘星座能力雷达图，可视化星座特质；')
bullet('塔罗 3D 翻牌：animateTo 控制 rotateY 实现翻牌动画，并支持真实牌面图片；')
bullet('确定性运势算法：哈希种子保证"同星座同日期"结果稳定且分布多样；')
bullet('星友匹配 + 聊天：用户间契合度匹配与一对一持久化聊天，增强社交属性；')
bullet('运势日历：以色点直观呈现整月运势走势并可下钻到每日详情；')
bullet('统一深色"星空"视觉与全局渐变主题，体验沉浸一致。')

heading('8.2　总结', 2)
body('本项目完整实现了一款基于 HarmonyOS Stage 模型的星座运势应用，覆盖运势、科普、占卜、'
     '配对、社交与个性化六大方向，技术上充分运用了 ArkTS/ArkUI 声明式 UI、状态管理、页面路由、'
     'Canvas 绘制、属性动画与 Preferences 持久化等知识点，页面、组件与工具包数量均满足并超出'
     '任务书要求，功能闭环、结构清晰、具有较强的完整性与创新性。')

placeholder('小组心得体会（可在此处填写）', 4.0)

doc.save('/home/user/-xing/docs/星语StarWhisper设计报告.docx')
print('saved')
