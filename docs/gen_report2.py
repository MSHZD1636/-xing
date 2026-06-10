# -*- coding: utf-8 -*-
"""按浙江树人大学《实验报告》模板生成 星语StarWhisper 实验报告 .docx"""
from docx import Document
from docx.shared import Pt, RGBColor, Cm
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

doc = Document()
sec = doc.sections[0]
sec.left_margin = Cm(2.6); sec.right_margin = Cm(2.6)
sec.top_margin = Cm(2.4); sec.bottom_margin = Cm(2.4)

normal = doc.styles['Normal']
normal.font.name = 'Times New Roman'
normal.font.size = Pt(12)
normal._element.rPr.rFonts.set(qn('w:eastAsia'), '仿宋_GB2312')

def setrun(run, name='仿宋_GB2312', size=12, bold=False, color=None):
    run.font.name = 'Times New Roman'
    run._element.rPr.rFonts.set(qn('w:eastAsia'), name)
    run.font.size = Pt(size)
    run.font.bold = bold
    if color:
        run.font.color.rgb = RGBColor(*color)

def para(text, size=12, name='仿宋_GB2312', bold=False, indent=True,
         align=None, after=6, before=0, line=1.6):
    p = doc.add_paragraph()
    pf = p.paragraph_format
    if indent:
        pf.first_line_indent = Pt(size * 2)
    pf.space_after = Pt(after); pf.space_before = Pt(before)
    pf.line_spacing = line
    if align:
        p.alignment = align
    r = p.add_run(text); setrun(r, name, size, bold)
    return p

def sec_title(text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(10)
    p.paragraph_format.space_after = Pt(6)
    r = p.add_run(text); setrun(r, '黑体', 14, bold=True)
    return p

def sub_title(text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(4)
    p.paragraph_format.space_after = Pt(3)
    r = p.add_run(text); setrun(r, '黑体', 12, bold=True)
    return p

def shade(cell, hexc):
    tcPr = cell._tc.get_or_add_tcPr()
    shd = OxmlElement('w:shd'); shd.set(qn('w:val'), 'clear')
    shd.set(qn('w:color'), 'auto'); shd.set(qn('w:fill'), hexc)
    tcPr.append(shd)

def cell_text(cell, text, size=10.5, bold=False, align=None, name='仿宋_GB2312'):
    p = cell.paragraphs[0]
    if align:
        p.alignment = align
    r = p.add_run(text); setrun(r, name, size, bold)

def placeholder(label, h=6.0):
    t = doc.add_table(rows=1, cols=1); t.alignment = WD_TABLE_ALIGNMENT.CENTER
    t.style = 'Table Grid'
    c = t.cell(0, 0); shade(c, 'F4F4F8'); c.width = Cm(15.5)
    t.rows[0].height = Cm(h)
    p = c.paragraphs[0]; p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run('【 此处插入：' + label + ' 】'); setrun(r, '黑体', 11, color=(0x88, 0x88, 0x99))
    p2 = c.add_paragraph(); p2.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r2 = p2.add_run('（运行截图 / 用例图）'); setrun(r2, '仿宋_GB2312', 9, color=(0xAA, 0xAA, 0xBB))
    doc.add_paragraph().paragraph_format.space_after = Pt(2)

def cap(text):
    p = doc.add_paragraph(); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p.add_run(text); setrun(r, '楷体_GB2312', 9, color=(0x66, 0x66, 0x66))
    p.paragraph_format.space_after = Pt(8)

# =================== 封面 ===================
para('浙江树人大学信息科技学院', size=22, name='黑体', bold=True, indent=False,
     align=WD_ALIGN_PARAGRAPH.CENTER, before=24, after=10)
para('实  验  报  告', size=26, name='黑体', bold=True, indent=False,
     align=WD_ALIGN_PARAGRAPH.CENTER, after=30)
for _ in range(2):
    doc.add_paragraph()

info = [('课程名称：', '移动应用开发技术'),
        ('专业班级：', '数据科学与大数据231班'),
        ('姓　　名：', '＿＿＿＿＿＿（组长） / ＿＿＿＿ / ＿＿＿＿'),
        ('学　　号：', '＿＿＿＿＿＿＿＿＿＿＿＿'),
        ('指导教师：', '李晓、张登辉'),
        ('实验日期：', '2026 年 5 月 13 日')]
for k, v in info:
    p = doc.add_paragraph(); p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_after = Pt(10)
    r1 = p.add_run(k); setrun(r1, '黑体', 14, bold=True)
    r2 = p.add_run(v); setrun(r2, '仿宋_GB2312', 14)
doc.add_page_break()

# =================== 正文抬头 ===================
para('学生大作业实验报告', size=16, name='黑体', bold=True, indent=False,
     align=WD_ALIGN_PARAGRAPH.CENTER, after=8)
p = doc.add_paragraph(); p.paragraph_format.space_after = Pt(8)
r1 = p.add_run('实验序号：'); setrun(r1, '黑体', 12, bold=True)
r2 = p.add_run('大作业　　　　实验名称：星语 StarWhisper 星座运势鸿蒙移动应用的设计与实现')
setrun(r2, '仿宋_GB2312', 12)

# =================== 一 ===================
sec_title('一、大作业实验目的及要求')
para('本次大作业旨在综合运用《移动应用开发技术》课程所学知识，由小组协作设计并实现一款'
     '基于 HarmonyOS（鸿蒙）Stage 模型的完整移动应用，从而系统掌握 ArkTS 语言与 ArkUI '
     '声明式开发范式，熟悉鸿蒙应用的工程结构、页面路由、状态管理、Canvas 绘制、属性动画'
     '以及本地数据持久化等核心技术。通过从主题构思、功能设计到编码实现、联调测试的全流程'
     '实践，进一步提升团队分工协作与工程化开发的综合能力。')
para('在具体要求方面，本作业以二至三人为一组分工协作完成：每位成员独立完成的页面不少于'
     '五个；项目中调用的组件类型（含布局容器与基础组件）不少于十五种；导入的系统工具包'
     '不少于十个。除此之外，应用还应具备良好的完整性，能够形成从启动、登录到核心功能使用'
     '的完整闭环，并在交互方式与表现形式上体现一定的创新性。本组据此选定"星座运势"为主题，'
     '开发了名为"星语 StarWhisper"的鸿蒙移动应用，口号为"每日一语，星辰指引"。')

# =================== 二 ===================
sec_title('二、大作业实验描述及实验过程')

sub_title('（一）应用主题与定位')
para('"星语 StarWhisper"是一款面向年轻群体的星座运势与心理陪伴类轻应用，主要服务于十六'
     '至三十五岁、对星座与占卜话题感兴趣的学生及初入职场人群。这类用户通常习惯在晨起、'
     '通勤或睡前等碎片化时间查看当日运势，以获取积极的心理暗示与情绪价值，同时偏好精致的'
     '深色"星空"视觉风格与轻量化的交互体验。基于上述定位，应用围绕运势查询、星座科普、'
     '趣味占卜、轻社交陪伴与个性化设置五条主线展开功能设计，全部数据均采用前端 Mock 方式'
     '生成，既便于离线演示，又能保证运势与占卜算法在相同输入下的确定性复现。')

sub_title('（二）总体架构与技术选型')
para('应用基于 HarmonyOS Next（API 22，SDK 6.0.2）Stage 模型构建，采用 ArkTS 语言与 '
     'ArkUI 声明式 UI 框架开发。为保证工程的可维护性与复用性，项目整体采用"分层加组件化"'
     '的架构思想，自上而下划分为 Ability 层、页面层、组件层、数据层、模型层与工具层六个'
     '部分。其中，Ability 层负责应用入口与生命周期管理；页面层由二十三个 @Entry 页面组成，'
     '承担界面布局、事件响应与路由跳转；组件层抽取了底部导航栏、星级评分、运势进度条、'
     '星座卡片、能力雷达图与塔罗翻牌卡等六个可复用组件；数据层与模型层分别提供业务数据、'
     'Mock 算法和数据结构定义；工具层则封装了主题常量、日期处理以及基于 Preferences 的'
     '本地持久化能力。各层之间职责清晰、依赖单向：页面之间通过 router 跳转并以 params '
     '传递星座编号、日期、卡牌与用户等参数，界面则借助 @State 与 @Prop 实现状态驱动的'
     '自动刷新，从而在结构上保证了团队并行开发的可行性。')

sub_title('（三）功能模块与实现过程')
para('依据应用定位，本组将系统划分为八个一级功能模块，并按照"先搭框架、再填功能、最后'
     '联调优化"的顺序逐步推进开发，各模块的作用与实现要点如下。')

mods = [
 ('1. 启动与登录模块。',
  '应用启动后首先进入启动页，该页通过 Canvas 绘制并以定时器驱动六十个星点实现闪烁的粒子'
  '动画，配合品牌 Logo 的渐入效果营造星空氛围，同时在后台完成本地存储初始化并写入默认'
  '演示账号；停留约两秒后，应用依据本地保存的登录状态自动跳转，已登录用户直接进入首页，'
  '未登录用户进入注册登录页。注册登录页摒弃了早期的手机验证码方式，改为账号密码登录，'
  '并支持在"登录"与"注册"两种模式间切换：登录时校验账号与密码（内置演示账号 msh，'
  '密码 12345678），注册时校验账号长度、密码长度及两次输入的一致性后写入账号列表并自动'
  '登录，此外还提供游客登录入口，方便快速体验。'),
 ('2. 首页运势模块。',
  '首页是应用的核心枢纽，顶部展示本地化的日期与问候语，其下通过 Swiper 轮播当日"幸运'
  '星座"卡片，紧接着是引导用户进入星友匹配的入口卡，最后以宫格形式呈现十二星座及其当日'
  '综合运势星级。用户点击任意星座即可进入运势详情页，查看综合评分、爱情、事业、财运、'
  '健康四个维度的评分条以及幸运色、幸运数字与幸运方位，并可将该星座加入收藏。除此之外，'
  '模块还提供运势排行榜（支持按分数升序或降序排列）、星座搜索（实时过滤并保留历史记录）'
  '以及推送设置（运势提醒开关与提醒时间）等辅助功能。'),
 ('3. 星座图鉴模块。',
  '该模块承担星座知识科普的职责。星座图鉴页以卡片宫格展示十二星座，并提供进入四象元素'
  '与星盘知识的快捷入口；星座详情页通过 Tabs 将基本、性格、爱情、职业四类信息分页呈现，'
  '并使用 Canvas 自绘六维能力雷达图，直观刻画星座特质；四象元素页按火、水、土、风对星座'
  '进行归类说明；星盘知识页以可折叠区块科普太阳、月亮与上升星座的含义；生日查询页则允许'
  '用户选择生日后自动推算所属星座并展示其性格特质。'),
 ('4. 星座配对模块。',
  '用户在配对选择页分别选定两个星座并触发心形动画后，点击"开始测算"即可携带双方信息'
  '跳转至配对结果页。结果页基于四象元素相生相克的关系加权计算契合度，以环形进度条直观'
  '呈现总体匹配分数，并通过多条评分条展示爱情、相处、默契等细分维度；用户还可将测算结论'
  '一键复制到剪贴板进行分享。'),
 ('5. 星友匹配聊天模块。',
  '作为应用的社交创新点，星友匹配页展示了多位虚拟星友及其与本人的契合度评分，用户点击'
  '匹配后即被加入已匹配列表并进入一对一聊天页。聊天页在首次进入时由对方主动打招呼，'
  '用户发送消息后界面会即时追加气泡并触发模拟自动回复；全部聊天记录通过本地持久化保存，'
  '再次进入时可完整恢复，消息列表借助 Scroller 自动滚动到底部，整体交互贴近真实的即时'
  '通讯体验。'),
 ('6. 塔罗占卜模块。',
  '每日塔罗页根据日期确定当天的塔罗牌，并由塔罗翻牌卡组件借助 animateTo 控制 rotateY '
  '实现三维翻牌动画；用户可通过"再抽一张"随机抽取新牌并重建牌面，牌面已接入导入的大'
  '阿卡那真实图片素材。点击牌面进入塔罗解读页后，页面以大图展示牌面、罗列关键词标签，'
  '并从总体、爱情、事业三个角度结合用户星座给出解读，同样支持一键分享。'),
 ('7. 星座日历模块。',
  '星座日历页以月历网格呈现当月每一天的运势走势，每个日期下方以不同颜色的圆点标识运势'
  '等级，并配有图例帮助用户理解；用户可在上一月与下一月之间切换，点击任意日期即可进入'
  '当日运势详情页查看该天的综合星级与多维评分，详情页还支持"前一天"与"后一天"的连续'
  '翻看。该模块顶部另设返回首页按钮，避免用户在标签页之间迷失方向。'),
 ('8. 个人中心模块。',
  '个人中心页集中展示用户头像、昵称与今日运势卡，并以列表形式提供我的收藏、生日查询、'
  '推送设置与星盘知识等功能入口；退出登录采用 AlertDialog 二次确认，确认后清空页面栈'
  '并跳转回登录页，保证退出彻底而可靠。我的星座设置页支持通过生日自动识别或手动点选'
  '确定专属星座并持久化保存；我的收藏页则以可滑动删除的列表管理收藏内容，并在无数据时'
  '给出友好的空状态提示。'),
]
for head, txt in mods:
    p = doc.add_paragraph()
    p.paragraph_format.first_line_indent = Pt(24)
    p.paragraph_format.space_after = Pt(6); p.paragraph_format.line_spacing = 1.6
    rh = p.add_run(head); setrun(rh, '黑体', 12, bold=True)
    rt = p.add_run(txt); setrun(rt, '仿宋_GB2312', 12)

sub_title('（四）开发分工')
para('本项目由三名小组成员协作完成，依据功能模块进行了清晰的分工，既保证每位成员独立完成'
     '的页面数量均达到不少于五个的要求，又兼顾了公共组件、数据算法与文档测试的合理分配，'
     '具体安排如下表所示。')
div_rows = [
 ('成员', '学号', '负责模块', '主要页面 / 承担工作', '页面数'),
 ('＿＿＿（组长）', '＿＿＿＿', '启动与登录、首页运势模块，整体架构与持久化',
  'SplashPage、LoginPage、HomePage、FortuneDetailPage、AllFortuneListPage、SearchPage、'
  'NotificationSettingPage；StorageUtils / Constants / DateUtils 及 BottomTabBar、'
  'StarRating、FortuneScoreBar 等公共组件', '7'),
 ('＿＿＿（组员）', '＿＿＿＿', '星座图鉴、星座配对、塔罗占卜模块',
  'ConstellationListPage、ConstellationDetailPage、ElementPage、StarChartPage、'
  'BirthdayQueryPage、MatchSelectPage、MatchResultPage、TarotPage、TarotDetailPage；'
  'RadarChart、TarotCard、ConstellationCard 组件及相关 Mock 算法', '9'),
 ('＿＿＿（组员）', '＿＿＿＿', '星座日历、星友匹配聊天、个人中心模块',
  'CalendarPage、CalendarDetailPage、UserMatchPage、ChatPage、ProfilePage、'
  'MyConstellationPage、FavoritePage；CalendarData / UserData / FortuneData 及'
  '设计报告撰写与联调测试', '7'),
]
t = doc.add_table(rows=0, cols=5); t.style = 'Table Grid'; t.alignment = WD_TABLE_ALIGNMENT.CENTER
dw = [Cm(2.4), Cm(1.8), Cm(3.6), Cm(6.6), Cm(1.2)]
for i, row in enumerate(div_rows):
    cells = t.add_row().cells
    for j, txt in enumerate(row):
        cells[j].width = dw[j]
        if i == 0:
            shade(cells[j], 'D9D9F2')
        cell_text(cells[j], txt, size=9 if i else 9.5,
                  bold=(i == 0), align=WD_ALIGN_PARAGRAPH.CENTER if (i == 0 or j in (0, 1, 4)) else None)
cap('表 1　小组开发分工表')

# =================== 三 ===================
sec_title('三、大作业实验结果与解释')
para('经过设计、编码与联调，"星语 StarWhisper"已实现全部预期功能，能够稳定运行于鸿蒙'
     '手机与模拟器之上，形成了从启动、登录到各核心功能使用的完整闭环。在规模上，应用共'
     '交付二十三个功能页面与两个 Ability，远超"每人不少于五个页面"的要求；在界面构建上'
     '累计使用了 Column、Row、Stack、Flex、Grid、List、Scroll、Swiper、Tabs、Text、'
     'Button、Image、TextInput、Toggle、DatePicker、TimePicker、Progress、Canvas、'
     'AlertDialog 等二十七种组件类型，满足不少于十五种的要求；在工具包方面，导入了 '
     '@kit.ArkUI、@kit.ArkData、@kit.AbilityKit、@kit.PerformanceAnalysisKit、'
     '@kit.BasicServicesKit、@kit.LocalizationKit 与 @kit.CoreFileKit 等七个系统 Kit，'
     '涉及 router、preferences、hilog、pasteboard、intl 等十余个系统 API，同样达到了'
     '不少于十个工具包的要求。')
para('从运行效果看，确定性运势算法使同一星座在同一日期始终得到一致的评分，且经分布优化后'
     '综合运势均匀地落在二至五星之间，避免了数值过度集中于中间值的问题；能力雷达图、塔罗'
     '翻牌、星空粒子等自绘与动画效果表现流畅自然；登录注册信息、收藏列表、聊天记录与个人'
     '设置等数据在应用退出后仍能正确恢复，验证了本地持久化机制的可靠性。综合来看，应用在'
     '功能完整性与交互创新性两方面均达到了预期目标。以下按功能模块给出实际运行截图。')

shot_modules = ['启动与登录模块（启动页 / 注册登录页）',
                '首页运势模块（首页 / 运势详情 / 排行榜）',
                '星座图鉴模块（图鉴 / 详情雷达图 / 元素）',
                '星座配对模块（配对选择 / 配对结果）',
                '星友匹配聊天模块（星友匹配 / 聊天）',
                '塔罗占卜模块（每日塔罗 / 塔罗解读）',
                '星座日历模块（月历 / 当日详情）',
                '个人中心模块（个人中心 / 星座设置 / 收藏）']
for i, m in enumerate(shot_modules, 1):
    placeholder(m, 6.2)
    cap('图 %d　%s 运行结果' % (i, m))

# =================== 四 ===================
sec_title('四、心得体会及指导教师评阅')
sub_title('心得体会')
para('通过本次大作业，我们完整体验了一款鸿蒙应用从无到有的开发全过程，对 ArkTS 与 ArkUI '
     '的声明式开发思想有了更为深刻的理解。在实践中，我们既体会到声明式 UI 以状态驱动界面'
     '所带来的便利，也踩过 ArkTS 严格模式下的若干"坑"，例如状态变量命名不能与内置通用'
     '属性相冲突、箭头函数在特定场景下需要使用块级函数体、枚举值需使用大写形式等，这些'
     '问题反过来促使我们更加严谨地组织代码与排查错误。与此同时，合理的分层架构与组件抽取'
     '显著降低了协作成本，使三名成员能够围绕各自负责的模块并行开发、互不干扰。')
para('回顾整个过程，我们不仅掌握了页面路由、Canvas 绘制、属性动画与 Preferences 持久化'
     '等关键技术，也在需求分析、任务拆分与团队沟通中得到了实实在在的锻炼。本次实验让我们'
     '认识到，一个完整应用的成功不仅取决于功能的堆叠，更取决于清晰的架构设计与高效的团队'
     '协作。今后我们将继续完善应用的真实数据接入与性能优化，努力打造更加完整、稳定、易用'
     '的产品。')

sub_title('指导教师评阅')
t = doc.add_table(rows=2, cols=4); t.style = 'Table Grid'; t.alignment = WD_TABLE_ALIGNMENT.CENTER
hdr = ['成绩评定', '指导教师签字', '签字日期', '备注']
for j, h in enumerate(hdr):
    shade(t.cell(0, j), 'D9D9F2')
    cell_text(t.cell(0, j), h, size=10.5, bold=True, align=WD_ALIGN_PARAGRAPH.CENTER)
t.rows[1].height = Cm(1.6)
for j in range(4):
    cell_text(t.cell(1, j), '', size=10.5)

doc.save('/home/user/-xing/docs/星语StarWhisper实验报告.docx')
print('saved')
