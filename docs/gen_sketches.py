# -*- coding: utf-8 -*-
"""为星语 StarWhisper 全部页面生成低保真线稿（wireframe sketches）"""
import os
from PIL import Image, ImageDraw, ImageFont

OUT = '/home/user/-xing/docs/sketches'
os.makedirs(OUT, exist_ok=True)

# 画布
W, H = 360, 720
PAD = 18

# 颜色（线稿风）
BG       = (252, 252, 254)   # 画布背景
FRAME    = (40, 44, 60)      # 手机外框
STROKE   = (110, 116, 134)   # 普通描边
STROKE_L = (170, 175, 188)   # 浅描边
FILL     = (232, 235, 244)   # 占位填充
FILL_2   = (244, 246, 252)   # 浅占位填充
ACCENT   = (255, 196, 60)    # 强调色（按钮）
TEXT     = (45, 50, 70)      # 文字
TEXT_2   = (110, 116, 134)   # 次文字
PINK     = (255, 130, 170)   # 粉色辅助

# 字体
FONT = '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc'
def f(size, bold=False):
    return ImageFont.truetype(FONT, size)

# ----------- 基础绘制工具 -----------
def new_canvas():
    img = Image.new('RGB', (W, H), BG)
    d = ImageDraw.Draw(img)
    # 手机外框
    d.rounded_rectangle([4, 4, W-4, H-4], radius=28, outline=FRAME, width=3)
    # 状态栏 / 摄像头小条
    d.rounded_rectangle([W//2-30, 10, W//2+30, 22], radius=6, fill=FRAME)
    return img, d

def title_bar(d, title, back=True):
    """顶部 28px 高的标题栏"""
    y0 = 36
    if back:
        d.text((PAD, y0+4), '‹', font=f(22), fill=TEXT)
    tw = d.textlength(title, font=f(15))
    d.text(((W-tw)/2, y0+6), title, font=f(15), fill=TEXT)
    d.line([(PAD, y0+30), (W-PAD, y0+30)], fill=STROKE_L, width=1)
    return y0 + 36

def label_box(d, x, y, w, h, text='', font_size=11, fill=FILL, dashed=False, radius=6):
    if dashed:
        # 简单虚线框
        for i in range(x, x+w, 6):
            d.line([(i, y), (min(i+3, x+w), y)], fill=STROKE, width=1)
            d.line([(i, y+h), (min(i+3, x+w), y+h)], fill=STROKE, width=1)
        for j in range(y, y+h, 6):
            d.line([(x, j), (x, min(j+3, y+h))], fill=STROKE, width=1)
            d.line([(x+w, j), (x+w, min(j+3, y+h))], fill=STROKE, width=1)
    else:
        d.rounded_rectangle([x, y, x+w, y+h], radius=radius, outline=STROKE, fill=fill, width=1)
    if text:
        tw = d.textlength(text, font=f(font_size))
        d.text((x + (w - tw)/2, y + (h - font_size - 2)/2), text, font=f(font_size), fill=TEXT_2)

def left_label(d, x, y, w, h, text, font_size=11, fill=FILL_2):
    d.rounded_rectangle([x, y, x+w, y+h], radius=6, outline=STROKE_L, fill=fill, width=1)
    d.text((x+10, y + (h - font_size - 2)/2), text, font=f(font_size), fill=TEXT_2)

def circle(d, cx, cy, r, outline=STROKE, fill=FILL, width=1):
    d.ellipse([cx-r, cy-r, cx+r, cy+r], outline=outline, fill=fill, width=width)

def star(d, cx, cy, size=8, fill=ACCENT):
    """简易五角星"""
    import math
    pts = []
    for i in range(10):
        ang = -math.pi/2 + i * math.pi/5
        r = size if i % 2 == 0 else size * 0.45
        pts.append((cx + r*math.cos(ang), cy + r*math.sin(ang)))
    d.polygon(pts, fill=fill)

def stars_row(d, x, y, score, size=7):
    """1-5 星横排"""
    for i in range(5):
        color = ACCENT if i < score else STROKE_L
        star(d, x + i*(size*2+2), y, size, color)

def bottom_tab(d, active=0):
    """底部 6 Tab"""
    y0 = H - 56
    d.line([(PAD, y0), (W-PAD, y0)], fill=STROKE_L, width=1)
    labels = ['首页', '图鉴', '配对', '塔罗', '日历', '我的']
    cw = (W - 2*PAD) / 6
    for i, lab in enumerate(labels):
        cx = PAD + cw*i + cw/2
        # 圆点代表图标
        circle(d, cx, y0+18, 6, outline=STROKE_L,
               fill=ACCENT if i == active else FILL)
        tw = d.textlength(lab, font=f(10))
        d.text((cx - tw/2, y0+28), lab, font=f(10),
               fill=ACCENT if i == active else TEXT_2)

def caption(d, y, text):
    """页面底部说明文字"""
    tw = d.textlength(text, font=f(9))
    d.text(((W-tw)/2, y), text, font=f(9), fill=TEXT_2)

def save(img, name):
    p = os.path.join(OUT, name + '.png')
    img.save(p, 'PNG', optimize=True)
    return p

# ============================================================
# 各页面草图绘制函数
# ============================================================

def draw_splash():
    img, d = new_canvas()
    d.text((PAD+4, 36), '· · ·', font=f(14), fill=TEXT_2)
    # 渐变星空（用斜线表示）
    for i in range(0, H-60, 12):
        d.line([(PAD, 60+i), (W-PAD, 60+i)], fill=(245, 247, 252), width=1)
    # 中心 Logo
    star(d, W/2, H/2 - 40, 32, ACCENT)
    tw = d.textlength('星语', font=f(34))
    d.text(((W-tw)/2, H/2 + 10), '星语', font=f(34), fill=TEXT)
    tw = d.textlength('StarWhisper', font=f(13))
    d.text(((W-tw)/2, H/2 + 56), 'StarWhisper', font=f(13), fill=TEXT_2)
    tw = d.textlength('每日一语·星辰指引', font=f(11))
    d.text(((W-tw)/2, H/2 + 76), '每日一语·星辰指引', font=f(11), fill=TEXT_2)
    # 粒子点
    import random
    random.seed(2)
    for _ in range(30):
        x = random.randint(PAD, W-PAD); y = random.randint(60, H-60)
        d.ellipse([x-1, y-1, x+1, y+1], fill=STROKE_L)
    caption(d, H-30, '启动页 SplashPage')
    return save(img, '01_SplashPage')

def draw_login():
    img, d = new_canvas()
    # 顶部 logo
    star(d, W/2, 100, 24, ACCENT)
    tw = d.textlength('星语', font=f(28))
    d.text(((W-tw)/2, 130), '星语', font=f(28), fill=TEXT)
    tw = d.textlength('账号登录，遇见每日星语', font=f(11))
    d.text(((W-tw)/2, 168), '账号登录，遇见每日星语', font=f(11), fill=TEXT_2)
    # 登录/注册 切换
    d.text((W/2-50, 196), '登录', font=f(14), fill=ACCENT)
    d.text((W/2-15, 196), '|', font=f(14), fill=STROKE_L)
    d.text((W/2+8, 196), '注册', font=f(14), fill=TEXT_2)
    d.line([(W/2-50, 218), (W/2-22, 218)], fill=ACCENT, width=2)
    # 输入框
    label_box(d, PAD+10, 240, W-2*PAD-20, 38, '请输入账号', radius=18)
    label_box(d, PAD+10, 290, W-2*PAD-20, 38, '请输入密码', radius=18)
    # 登录按钮
    d.rounded_rectangle([PAD+10, 350, W-PAD-10, 388], radius=18, fill=ACCENT, outline=ACCENT)
    tw = d.textlength('登 录', font=f(15))
    d.text(((W-tw)/2, 358), '登 录', font=f(15), fill=TEXT)
    # 游客登录
    tw = d.textlength('游客登录', font=f(11))
    d.text(((W-tw)/2, 408), '游客登录', font=f(11), fill=TEXT_2)
    # 演示账号提示
    tw = d.textlength('演示账号：msh　密码：12345678', font=f(10))
    d.text(((W-tw)/2, 438), '演示账号：msh　密码：12345678', font=f(10), fill=TEXT_2)
    # 底部协议
    tw = d.textlength('登录即代表同意《用户协议》与《隐私政策》', font=f(9))
    d.text(((W-tw)/2, H-60), '登录即代表同意《用户协议》与《隐私政策》', font=f(9), fill=TEXT_2)
    caption(d, H-30, '注册登录页 LoginPage')
    return save(img, '02_LoginPage')

def draw_home():
    img, d = new_canvas()
    # header
    d.text((PAD, 50), '06月12日·星期五', font=f(10), fill=TEXT_2)
    d.text((PAD, 66), '午安，记得为自己充电', font=f(14), fill=TEXT)
    circle(d, W-30, 60, 12, outline=STROKE_L)
    d.text((W-34, 54), '🔍', font=f(13), fill=TEXT_2)
    # 幸运星座 Banner
    y = 96
    d.rounded_rectangle([PAD, y, W-PAD, y+96], radius=10, outline=STROKE, fill=FILL)
    d.rounded_rectangle([PAD+10, y+8, PAD+90, y+24], radius=8, fill=ACCENT)
    d.text((PAD+18, y+10), '今日幸运星座', font=f(10), fill=TEXT)
    circle(d, PAD+34, y+58, 22, outline=STROKE_L, fill=FILL_2)
    d.text((PAD+78, y+38), '巨蟹座', font=f(16), fill=TEXT)
    stars_row(d, PAD+78, y+62, 5)
    d.text((PAD+78, y+74), '万事顺遂，闪闪发光的一天', font=f(9), fill=TEXT_2)
    # 星友匹配入口
    y = 210
    d.rounded_rectangle([PAD, y, W-PAD, y+62], radius=10, outline=PINK, fill=FILL_2)
    circle(d, PAD+30, y+31, 18, outline=PINK, fill=(255, 240, 246))
    d.text((PAD+24, y+22), '💞', font=f(15))
    d.text((PAD+62, y+12), '星友匹配 / 聊天', font=f(13), fill=TEXT)
    d.text((PAD+62, y+34), '找到与你星座契合的 TA', font=f(10), fill=TEXT_2)
    d.rounded_rectangle([W-PAD-58, y+20, W-PAD-10, y+42], radius=10, fill=PINK)
    d.text((W-PAD-50, y+24), '去匹配›', font=f(9), fill=TEXT)
    # 十二星座宫格标题
    d.text((PAD, 290), '十二星座运势', font=f(13), fill=TEXT)
    d.text((W-PAD-60, 292), '查看全部 ›', font=f(10), fill=ACCENT)
    # 4x3 宫格
    cw = (W - 2*PAD - 20) / 3
    ch = 70
    cs = ['白羊','金牛','双子','巨蟹','狮子','处女','天秤','天蝎','射手','摩羯','水瓶','双鱼']
    for i, n in enumerate(cs):
        r, c = divmod(i, 3)
        cx = PAD + c*(cw+10); cy = 314 + r*(ch+8)
        d.rounded_rectangle([cx, cy, cx+cw, cy+ch], radius=8, outline=STROKE_L, fill=FILL_2)
        circle(d, cx + cw/2, cy + 22, 12, outline=STROKE_L)
        d.text((cx + cw/2 - 16, cy + 38), n+'座', font=f(11), fill=TEXT)
        stars_row(d, cx + cw/2 - 22, cy + 56, (i % 3) + 3, size=4)
    bottom_tab(d, active=0)
    caption(d, H-72, '首页 HomePage')
    return save(img, '03_HomePage')

def draw_fortune_detail():
    img, d = new_canvas()
    y = title_bar(d, '星座运势详情')
    # 顶部头
    circle(d, PAD+30, y+24, 22, outline=STROKE)
    d.text((PAD+62, y+8), '巨蟹座', font=f(16), fill=TEXT)
    d.text((PAD+62, y+30), '6.22 - 7.22', font=f(10), fill=TEXT_2)
    # 综合星级
    d.text((PAD, y+66), '综合运势', font=f(12), fill=TEXT)
    stars_row(d, PAD+80, y+72, 4, size=8)
    d.text((W-PAD-26, y+66), '4.0', font=f(14), fill=ACCENT)
    # 四维进度条
    items = ['爱情', '事业', '财运', '健康']
    for i, n in enumerate(items):
        ry = y + 110 + i*36
        d.text((PAD, ry), n, font=f(11), fill=TEXT)
        d.rounded_rectangle([PAD+42, ry+4, W-PAD-32, ry+14], radius=5, fill=FILL)
        d.rounded_rectangle([PAD+42, ry+4, PAD+42+(W-PAD-74)*(0.55+i*0.1), ry+14],
                            radius=5, fill=ACCENT)
        d.text((W-PAD-28, ry), str(3+i%3)+'.0', font=f(10), fill=TEXT_2)
    # 详细文字框
    y2 = y + 270
    d.text((PAD, y2), '运势详解', font=f(12), fill=TEXT)
    d.rounded_rectangle([PAD, y2+18, W-PAD, y2+120], radius=8, outline=STROKE_L, fill=FILL_2)
    for i in range(4):
        d.line([(PAD+10, y2+30+i*18), (W-PAD-10, y2+30+i*18)], fill=STROKE_L, width=1)
    # 幸运信息
    y3 = y + 410
    d.rounded_rectangle([PAD, y3, W-PAD, y3+62], radius=8, outline=STROKE_L, fill=FILL)
    for i, (l, v) in enumerate([('幸运色', '星光金'), ('数字', '7'), ('方位', '正东')]):
        cx = PAD + 30 + i*(W-2*PAD-60)/2
        d.text((cx-12, y3+10), l, font=f(10), fill=TEXT_2)
        d.text((cx-12, y3+28), v, font=f(12), fill=TEXT)
    # 收藏按钮
    d.rounded_rectangle([W/2-50, H-90, W/2+50, H-58], radius=16, outline=ACCENT, fill=FILL_2)
    d.text((W/2-28, H-82), '☆ 收藏', font=f(11), fill=ACCENT)
    caption(d, H-40, '运势详情页 FortuneDetailPage')
    return save(img, '04_FortuneDetailPage')

def draw_all_fortune():
    img, d = new_canvas()
    y = title_bar(d, '十二星座运势榜')
    d.text((PAD, y+6), '排序：', font=f(11), fill=TEXT_2)
    label_box(d, PAD+40, y+2, 96, 22, '高→低 / 低→高', font_size=10, fill=FILL, radius=11)
    y += 36
    for i in range(8):
        ly = y + i*48
        d.rounded_rectangle([PAD, ly, W-PAD, ly+40], radius=8, outline=STROKE_L, fill=FILL_2)
        circle(d, PAD+22, ly+20, 14, outline=STROKE_L)
        d.text((PAD+44, ly+6), '星座名 ' + str(i+1), font=f(11), fill=TEXT)
        d.text((PAD+44, ly+22), '一句话运势摘要 ...', font=f(9), fill=TEXT_2)
        stars_row(d, W-PAD-86, ly+16, 5-(i%4), size=5)
    caption(d, H-30, '运势排行榜 AllFortuneListPage')
    return save(img, '05_AllFortuneListPage')

def draw_search():
    img, d = new_canvas()
    y = title_bar(d, '搜索')
    label_box(d, PAD, y, W-2*PAD, 36, '🔍  搜索星座名称', radius=18)
    y += 50
    d.text((PAD, y), '热门标签', font=f(11), fill=TEXT)
    tags = ['白羊', '金牛', '巨蟹', '狮子', '处女', '天秤', '射手']
    tx, ty = PAD, y+18
    for t in tags:
        tw = d.textlength('# '+t, font=f(10)) + 16
        if tx + tw > W - PAD:
            tx = PAD; ty += 26
        d.rounded_rectangle([tx, ty, tx+tw, ty+22], radius=11, outline=STROKE_L, fill=FILL_2)
        d.text((tx+8, ty+4), '# '+t, font=f(10), fill=TEXT_2)
        tx += tw + 6
    y = ty + 50
    d.text((PAD, y), '搜索历史', font=f(11), fill=TEXT)
    for i in range(3):
        ly = y + 22 + i*30
        d.line([(PAD, ly+20), (W-PAD, ly+20)], fill=STROKE_L, width=1)
        d.text((PAD, ly), '🕒 上一次搜索 ' + str(i+1), font=f(10), fill=TEXT_2)
    caption(d, H-30, '搜索页 SearchPage')
    return save(img, '06_SearchPage')

def draw_notify():
    img, d = new_canvas()
    y = title_bar(d, '推送设置')
    # 开关
    d.rounded_rectangle([PAD, y, W-PAD, y+50], radius=8, outline=STROKE_L, fill=FILL_2)
    d.text((PAD+12, y+16), '每日运势推送', font=f(12), fill=TEXT)
    # toggle
    d.rounded_rectangle([W-PAD-50, y+14, W-PAD-12, y+34], radius=10, fill=ACCENT)
    circle(d, W-PAD-18, y+24, 9, outline=ACCENT, fill=BG)
    # 时间
    y += 64
    d.rounded_rectangle([PAD, y, W-PAD, y+58], radius=8, outline=STROKE_L, fill=FILL_2)
    d.text((PAD+12, y+8), '提醒时间', font=f(11), fill=TEXT)
    d.text((PAD+12, y+28), '08 : 30', font=f(20), fill=ACCENT)
    # 提示
    y += 80
    d.text((PAD, y), '说明：开启后每日早间将收到当日运势提醒。', font=f(10), fill=TEXT_2)
    caption(d, H-30, '推送设置页 NotificationSettingPage')
    return save(img, '07_NotificationSettingPage')

def draw_const_list():
    img, d = new_canvas()
    y = title_bar(d, '星座图鉴', back=False)
    # 快捷入口卡
    for i, (name, sub) in enumerate([('四象元素', '火水土风分类'), ('星盘知识', '太阳·月亮·上升')]):
        cy = y + i*60
        d.rounded_rectangle([PAD, cy, W-PAD, cy+50], radius=8, outline=STROKE_L, fill=FILL_2)
        circle(d, PAD+22, cy+25, 14, outline=ACCENT)
        d.text((PAD+44, cy+8), name, font=f(12), fill=TEXT)
        d.text((PAD+44, cy+26), sub, font=f(10), fill=TEXT_2)
        d.text((W-PAD-18, cy+14), '›', font=f(20), fill=TEXT_2)
    # 卡片宫格
    y += 130
    d.text((PAD, y-4), '十二星座图鉴', font=f(12), fill=TEXT)
    cw = (W - 2*PAD - 14) / 2
    ch = 80
    cs = ['白羊','金牛','双子','巨蟹','狮子','处女','天秤','天蝎','射手','摩羯']
    for i, n in enumerate(cs[:6]):
        r, c = divmod(i, 2)
        cx = PAD + c*(cw+14); cy = y+12 + r*(ch+8)
        d.rounded_rectangle([cx, cy, cx+cw, cy+ch], radius=8, outline=STROKE_L, fill=FILL_2)
        circle(d, cx + 22, cy + ch/2, 16, outline=STROKE_L)
        d.text((cx + 48, cy + 16), n+'座', font=f(12), fill=TEXT)
        d.text((cx + 48, cy + 38), '日期范围', font=f(9), fill=TEXT_2)
        d.text((cx + 48, cy + 54), '关键词', font=f(9), fill=TEXT_2)
    bottom_tab(d, active=1)
    caption(d, H-72, '星座图鉴页 ConstellationListPage')
    return save(img, '08_ConstellationListPage')

def draw_const_detail():
    img, d = new_canvas()
    y = title_bar(d, '星座详情')
    # 头像 + 名称
    circle(d, W/2, y+34, 26, outline=STROKE, fill=FILL)
    tw = d.textlength('巨蟹座', font=f(18))
    d.text(((W-tw)/2, y+68), '巨蟹座', font=f(18), fill=TEXT)
    tw = d.textlength('6月22日 - 7月22日 · 水象', font=f(10))
    d.text(((W-tw)/2, y+92), '6月22日 - 7月22日 · 水象', font=f(10), fill=TEXT_2)
    # Tabs
    y += 116
    tabs = ['基本', '性格', '爱情', '职业']
    for i, t in enumerate(tabs):
        cx = PAD + i*(W-2*PAD)/4
        d.text((cx + (W-2*PAD)/8 - 12, y), t, font=f(12),
               fill=ACCENT if i == 0 else TEXT_2)
    d.line([(PAD+8, y+22), (PAD+(W-2*PAD)/4-8, y+22)], fill=ACCENT, width=2)
    d.line([(PAD, y+24), (W-PAD, y+24)], fill=STROKE_L, width=1)
    # 雷达图占位（六边形）
    import math
    cx, cy, r = W/2, y+120, 70
    poly = []
    for i in range(6):
        ang = -math.pi/2 + i*math.pi/3
        poly.append((cx + r*math.cos(ang), cy + r*math.sin(ang)))
    d.polygon(poly, outline=STROKE_L, fill=FILL_2)
    for p in poly:
        d.line([(cx, cy), p], fill=STROKE_L, width=1)
    # 内部能力点
    pts = []
    for i in range(6):
        ang = -math.pi/2 + i*math.pi/3
        rr = r * (0.5 + 0.4*(i%2))
        pts.append((cx + rr*math.cos(ang), cy + rr*math.sin(ang)))
    d.polygon(pts, outline=ACCENT, fill=(255, 240, 200))
    labels6 = ['爱情', '事业', '财运', '健康', '人际', '学业']
    for i, p in enumerate(poly):
        tw = d.textlength(labels6[i], font=f(9))
        d.text((p[0]-tw/2, p[1] + (8 if i in (3,4,5) else -16)), labels6[i],
               font=f(9), fill=TEXT_2)
    # 文字描述
    y2 = y + 220
    d.rounded_rectangle([PAD, y2, W-PAD, y2+88], radius=8, outline=STROKE_L, fill=FILL_2)
    for i in range(4):
        d.line([(PAD+10, y2+12+i*18), (W-PAD-10, y2+12+i*18)], fill=STROKE_L, width=1)
    caption(d, H-30, '星座详情页 ConstellationDetailPage')
    return save(img, '09_ConstellationDetailPage')

def draw_element():
    img, d = new_canvas()
    y = title_bar(d, '四象元素')
    elems = [('🔥 火象', '白羊·狮子·射手'),
             ('💧 水象', '巨蟹·天蝎·双鱼'),
             ('⛰ 土象', '金牛·处女·摩羯'),
             ('💨 风象', '双子·天秤·水瓶')]
    for i, (name, sub) in enumerate(elems):
        cy = y + i*92
        d.rounded_rectangle([PAD, cy, W-PAD, cy+76], radius=8, outline=STROKE, fill=FILL_2)
        d.text((PAD+14, cy+8), name, font=f(14), fill=TEXT)
        d.text((PAD+14, cy+30), sub, font=f(11), fill=TEXT_2)
        d.text((PAD+14, cy+50), '关键特质：xxx · xxx · xxx', font=f(9), fill=TEXT_2)
        for j in range(3):
            cx2 = W-PAD-28-j*32
            circle(d, cx2, cy+38, 12, outline=STROKE_L)
    caption(d, H-30, '四象元素页 ElementPage')
    return save(img, '10_ElementPage')

def draw_starchart():
    img, d = new_canvas()
    y = title_bar(d, '星盘知识')
    items = [('☀ 太阳星座', '代表外在性格与人生方向'),
             ('🌙 月亮星座', '代表内在情感与潜意识'),
             ('↑ 上升星座', '代表第一印象与外显形象')]
    for i, (n, s) in enumerate(items):
        cy = y + i*84
        d.rounded_rectangle([PAD, cy, W-PAD, cy+72], radius=8, outline=STROKE, fill=FILL_2)
        d.text((PAD+14, cy+10), n, font=f(14), fill=TEXT)
        d.text((PAD+14, cy+32), s, font=f(10), fill=TEXT_2)
        # 折叠箭头
        d.text((W-PAD-22, cy+24), '∨', font=f(14), fill=TEXT_2)
        for k in range(2):
            d.line([(PAD+14, cy+52+k*10), (W-PAD-14, cy+52+k*10)], fill=STROKE_L, width=1)
    caption(d, H-30, '星盘知识页 StarChartPage')
    return save(img, '11_StarChartPage')

def draw_birthday():
    img, d = new_canvas()
    y = title_bar(d, '生日星座查询')
    d.text((PAD, y+4), '请选择你的生日', font=f(12), fill=TEXT)
    # DatePicker
    d.rounded_rectangle([PAD, y+28, W-PAD, y+96], radius=8, outline=STROKE_L, fill=FILL_2)
    for i, (lab, val) in enumerate([('年', '2000'), ('月', '06'), ('日', '12')]):
        cx = PAD + 30 + i*(W-2*PAD-60)/2
        d.text((cx-6, y+38), val, font=f(20), fill=ACCENT)
        d.text((cx-4, y+72), lab, font=f(10), fill=TEXT_2)
    # 查询按钮
    d.rounded_rectangle([PAD+30, y+118, W-PAD-30, y+154], radius=18, fill=ACCENT)
    tw = d.textlength('查询星座', font=f(14))
    d.text(((W-tw)/2, y+126), '查询星座', font=f(14), fill=TEXT)
    # 结果卡片
    y2 = y + 180
    d.rounded_rectangle([PAD, y2, W-PAD, y2+170], radius=10, outline=STROKE, fill=FILL_2)
    circle(d, PAD+34, y2+38, 22, outline=STROKE)
    d.text((PAD+72, y2+18), '巨蟹座', font=f(18), fill=TEXT)
    d.text((PAD+72, y2+44), '6月22日 - 7月22日', font=f(10), fill=TEXT_2)
    d.line([(PAD+10, y2+74), (W-PAD-10, y2+74)], fill=STROKE_L)
    d.text((PAD+10, y2+86), '性格特质', font=f(11), fill=TEXT)
    for i in range(3):
        d.line([(PAD+10, y2+108+i*16), (W-PAD-10, y2+108+i*16)], fill=STROKE_L)
    caption(d, H-30, '生日查询页 BirthdayQueryPage')
    return save(img, '12_BirthdayQueryPage')

def draw_match_select():
    img, d = new_canvas()
    y = title_bar(d, '星座配对', back=False)
    # 两个选择器
    for i, (lab, cap_) in enumerate([('TA', '请选择对方星座'), ('我', '请选择我的星座')]):
        cx = W/4 + i*W/2
        circle(d, cx, y+50, 36, outline=STROKE, fill=FILL_2)
        tw = d.textlength(lab, font=f(20))
        d.text((cx-tw/2, y+38), lab, font=f(20), fill=TEXT)
        tw = d.textlength(cap_, font=f(10))
        d.text((cx-tw/2, y+96), cap_, font=f(10), fill=TEXT_2)
    # 中间心
    d.text((W/2-10, y+44), '❤', font=f(20), fill=PINK)
    # 开始测算按钮
    y2 = y + 150
    d.rounded_rectangle([PAD+30, y2, W-PAD-30, y2+44], radius=22, fill=ACCENT)
    tw = d.textlength('开始测算', font=f(15))
    d.text(((W-tw)/2, y2+12), '开始测算', font=f(15), fill=TEXT)
    # 星友匹配入口
    y3 = y2 + 70
    d.rounded_rectangle([PAD+30, y3, W-PAD-30, y3+40], radius=20, outline=PINK, fill=FILL_2)
    tw = d.textlength('寻找星座之缘（用户匹配）', font=f(12))
    d.text(((W-tw)/2, y3+12), '寻找星座之缘（用户匹配）', font=f(12), fill=PINK)
    bottom_tab(d, active=2)
    caption(d, H-72, '配对选择页 MatchSelectPage')
    return save(img, '13_MatchSelectPage')

def draw_match_result():
    img, d = new_canvas()
    y = title_bar(d, '配对结果')
    # 环形进度
    import math
    cx, cy, r = W/2, y+90, 50
    d.ellipse([cx-r, cy-r, cx+r, cy+r], outline=STROKE_L, width=8)
    # 部分弧（用扇形覆盖）
    d.arc([cx-r, cy-r, cx+r, cy+r], start=-90, end=180, fill=ACCENT, width=8)
    tw = d.textlength('82', font=f(28))
    d.text((cx-tw/2, cy-18), '82', font=f(28), fill=ACCENT)
    d.text((cx-12, cy+12), '分', font=f(11), fill=TEXT_2)
    tw = d.textlength('巨蟹 ❤ 双鱼', font=f(14))
    d.text(((W-tw)/2, cy+r+10), '巨蟹 ❤ 双鱼', font=f(14), fill=TEXT)
    # 维度评分
    y2 = y + 200
    items = ['爱情契合', '相处和谐', '默契指数', '长期发展']
    for i, n in enumerate(items):
        ry = y2 + i*36
        d.text((PAD, ry), n, font=f(11), fill=TEXT)
        d.rounded_rectangle([PAD+72, ry+4, W-PAD-32, ry+14], radius=5, fill=FILL)
        d.rounded_rectangle([PAD+72, ry+4, PAD+72+(W-PAD-104)*(0.6+i*0.08), ry+14],
                            radius=5, fill=ACCENT)
        d.text((W-PAD-28, ry), str(3+i%3)+'.0', font=f(10), fill=TEXT_2)
    # 分享按钮
    d.rounded_rectangle([PAD+40, H-90, W-PAD-40, H-50], radius=20, outline=ACCENT, fill=FILL_2)
    tw = d.textlength('分享配对结果', font=f(13))
    d.text(((W-tw)/2, H-82), '分享配对结果', font=f(13), fill=ACCENT)
    caption(d, H-30, '配对结果页 MatchResultPage')
    return save(img, '14_MatchResultPage')

def draw_user_match():
    img, d = new_canvas()
    y = title_bar(d, '星友匹配')
    for i in range(4):
        cy = y + i*98
        d.rounded_rectangle([PAD, cy, W-PAD, cy+86], radius=10, outline=STROKE_L, fill=FILL_2)
        circle(d, PAD+34, cy+30, 22, outline=STROKE)
        d.text((PAD+68, cy+10), '星友 ' + chr(65+i) + '号', font=f(13), fill=TEXT)
        d.text((PAD+68, cy+32), '巨蟹座 · 在线', font=f(10), fill=TEXT_2)
        d.text((PAD+68, cy+50), '简介：喜欢音乐与旅行...', font=f(9), fill=TEXT_2)
        # 匹配分
        circle(d, W-PAD-30, cy+30, 18, outline=PINK, fill=FILL)
        d.text((W-PAD-38, cy+22), str(70+i*5), font=f(13), fill=PINK)
        d.rounded_rectangle([W-PAD-66, cy+58, W-PAD-12, cy+78], radius=10, fill=PINK)
        tw = d.textlength('匹配', font=f(10))
        d.text((W-PAD-39-tw/2, cy+62), '💞匹配', font=f(10), fill=TEXT)
    caption(d, H-30, '星友匹配页 UserMatchPage')
    return save(img, '15_UserMatchPage')

def draw_chat():
    img, d = new_canvas()
    # 自定义顶栏（带头像）
    d.line([(PAD, 70), (W-PAD, 70)], fill=STROKE_L, width=1)
    d.text((PAD-2, 42), '‹', font=f(22), fill=TEXT)
    circle(d, PAD+30, 50, 14, outline=STROKE)
    d.text((PAD+54, 38), '星友 A 号', font=f(13), fill=TEXT)
    d.text((PAD+54, 56), '巨蟹座 · 在线', font=f(9), fill=(80, 180, 130))
    y = 84
    # 对方气泡
    for i, txt in enumerate(['你好呀！我是星友A 很高兴和你匹配成功～', '今天运势如何？']):
        d.rounded_rectangle([PAD, y, PAD+200, y+38],
                            radius=12, outline=STROKE_L, fill=FILL_2)
        d.text((PAD+10, y+10), txt[:20], font=f(10), fill=TEXT)
        d.text((PAD+4, y+44), '10:0' + str(i+1), font=f(8), fill=TEXT_2)
        y += 64
    # 我的气泡
    for i, txt in enumerate(['挺不错的，金色五星！', '哈哈下午一起吗']):
        d.rounded_rectangle([W-PAD-200, y, W-PAD, y+38], radius=12, fill=ACCENT, outline=ACCENT)
        d.text((W-PAD-190, y+10), txt, font=f(10), fill=TEXT)
        d.text((W-PAD-28, y+44), '10:0' + str(i+3), font=f(8), fill=TEXT_2)
        y += 64
    # 输入栏
    d.line([(PAD-4, H-66), (W-PAD+4, H-66)], fill=STROKE_L)
    label_box(d, PAD, H-58, W-2*PAD-58, 36, '说点什么…', font_size=10, radius=18)
    d.rounded_rectangle([W-PAD-50, H-58, W-PAD, H-22], radius=18, fill=ACCENT)
    d.text((W-PAD-38, H-50), '发送', font=f(11), fill=TEXT)
    caption(d, H-12, '聊天页 ChatPage')
    return save(img, '16_ChatPage')

def draw_tarot():
    img, d = new_canvas()
    y = title_bar(d, '🔮 每日塔罗', back=False)
    # 大牌
    cw, ch = 180, 280
    cx = (W-cw)/2; cy = y + 16
    d.rounded_rectangle([cx, cy, cx+cw, cy+ch], radius=14,
                        outline=ACCENT, width=2, fill=FILL_2)
    d.text((cx+cw/2-12, cy+20), 'XII', font=f(20), fill=TEXT)
    d.text((cx+cw/2-12, cy+ch/2-10), '🔮', font=f(40))
    tw = d.textlength('倒吊人', font=f(16))
    d.text((cx+cw/2-tw/2, cy+ch-50), '倒吊人', font=f(16), fill=TEXT)
    tw = d.textlength('The Hanged Man', font=f(10))
    d.text((cx+cw/2-tw/2, cy+ch-28), 'The Hanged Man', font=f(10), fill=TEXT_2)
    # 关键词
    y2 = y + 310
    tw = d.textlength('换位 · 等待 · 放下', font=f(11))
    d.text(((W-tw)/2, y2), '换位 · 等待 · 放下', font=f(11), fill=TEXT_2)
    # 按钮
    y3 = y + 340
    d.rounded_rectangle([PAD+20, y3, W/2-6, y3+38], radius=19, outline=(0, 180, 160), fill=(232, 248, 244))
    d.text((PAD+50, y3+10), '查看详细解读 ›', font=f(11), fill=(0, 130, 110))
    d.rounded_rectangle([W/2+6, y3, W-PAD-20, y3+38], radius=19, outline=ACCENT, fill=FILL_2)
    d.text((W/2+30, y3+10), '🔀 再抽一张', font=f(11), fill=TEXT)
    bottom_tab(d, active=3)
    caption(d, H-72, '每日塔罗页 TarotPage')
    return save(img, '17_TarotPage')

def draw_tarot_detail():
    img, d = new_canvas()
    y = title_bar(d, '塔罗解读')
    # 大牌
    cw, ch = 160, 240
    cx = (W-cw)/2; cy = y+8
    d.rounded_rectangle([cx, cy, cx+cw, cy+ch], radius=12, outline=ACCENT, fill=FILL_2)
    d.text((cx+cw/2-12, cy+ch/2-12), '🔮', font=f(36))
    # 关键词标签
    y2 = y + 260
    tags = ['换位', '等待', '放下']
    tx = PAD + 20
    for t in tags:
        tw = d.textlength('# '+t, font=f(10)) + 16
        d.rounded_rectangle([tx, y2, tx+tw, y2+22], radius=11, outline=(0, 180, 160), fill=(232, 248, 244))
        d.text((tx+8, y2+4), '# '+t, font=f(10), fill=(0, 130, 110))
        tx += tw + 8
    # 三段式解读
    sections = ['总体运势', '爱情运势', '事业运势']
    for i, n in enumerate(sections):
        sy = y + 296 + i*64
        d.rounded_rectangle([PAD, sy, W-PAD, sy+54], radius=8, outline=STROKE_L, fill=FILL_2)
        # 强调左条
        d.rectangle([PAD+2, sy+8, PAD+6, sy+22], fill=ACCENT)
        d.text((PAD+14, sy+8), n, font=f(12), fill=TEXT)
        for k in range(2):
            d.line([(PAD+14, sy+30+k*10), (W-PAD-14, sy+30+k*10)], fill=STROKE_L)
    caption(d, H-30, '塔罗解读页 TarotDetailPage')
    return save(img, '18_TarotDetailPage')

def draw_calendar():
    img, d = new_canvas()
    y = title_bar(d, '星座日历', back=False)
    # 月份切换
    d.text((PAD, y), '‹ 上月', font=f(11), fill=ACCENT)
    tw = d.textlength('2026 年 6 月', font=f(14))
    d.text(((W-tw)/2, y-2), '2026 年 6 月', font=f(14), fill=TEXT)
    d.text((W-PAD-36, y), '下月 ›', font=f(11), fill=ACCENT)
    # 图例
    y += 24
    legend = [('金', ACCENT), ('绿', (80, 180, 130)), ('青', (90, 200, 220)),
              ('橙', (255, 160, 60)), ('红', (240, 90, 90))]
    lx = PAD + 4
    for n, c in legend:
        d.ellipse([lx, y+4, lx+8, y+12], fill=c)
        d.text((lx+12, y), n, font=f(9), fill=TEXT_2)
        lx += 44
    # 星期
    y += 22
    weeks = ['日', '一', '二', '三', '四', '五', '六']
    cw = (W - 2*PAD) / 7
    for i, w in enumerate(weeks):
        d.text((PAD+cw*i+cw/2-4, y), w, font=f(10), fill=TEXT_2)
    # 月历网格
    y += 22
    days = [['', '', '', '', '', '', '1']]
    cnt = 2
    while cnt <= 30:
        row = []
        for _ in range(7):
            if cnt <= 30:
                row.append(str(cnt)); cnt += 1
            else:
                row.append('')
        days.append(row)
    import random
    random.seed(3)
    for r, row in enumerate(days):
        for c, day in enumerate(row):
            cx = PAD + c*cw + cw/2; cy = y + r*42 + 16
            if day == '':
                continue
            # 今天高亮
            if day == '12':
                d.rounded_rectangle([cx-15, cy-12, cx+15, cy+22], radius=7, fill=ACCENT)
                d.text((cx-6, cy-9), day, font=f(11), fill=TEXT)
            else:
                d.text((cx-(6 if len(day)==1 else 8), cy-9), day, font=f(11), fill=TEXT)
            # 圆点
            lvl = random.randint(0, 4)
            d.ellipse([cx-3, cy+10, cx+3, cy+16], fill=legend[lvl][1])
    # 当日摘要
    y2 = y + len(days)*42 + 8
    d.rounded_rectangle([PAD, y2, W-PAD, y2+72], radius=8, outline=STROKE_L, fill=FILL_2)
    d.text((PAD+10, y2+8), '2026-06-12', font=f(12), fill=TEXT)
    d.text((W-PAD-60, y2+10), '运势 4.0', font=f(10), fill=ACCENT)
    d.line([(PAD+10, y2+30), (W-PAD-10, y2+30)], fill=STROKE_L)
    d.text((PAD+10, y2+38), '万事顺遂，是闪闪发光的一天', font=f(10), fill=TEXT_2)
    d.rounded_rectangle([PAD+10, y2+52, W-PAD-10, y2+68], radius=8, fill=ACCENT)
    d.text((W/2-44, y2+54), '查看当日详情 ›', font=f(10), fill=TEXT)
    bottom_tab(d, active=4)
    caption(d, H-72, '星座日历页 CalendarPage')
    return save(img, '19_CalendarPage')

def draw_calendar_detail():
    img, d = new_canvas()
    y = title_bar(d, '当日运势详情')
    # 日期切换
    d.rounded_rectangle([PAD, y, W-PAD, y+58], radius=8, outline=STROKE_L, fill=FILL_2)
    d.text((PAD+10, y+18), '‹ 前一天', font=f(11), fill=ACCENT)
    tw = d.textlength('2026-06-12', font=f(14))
    d.text(((W-tw)/2, y+10), '2026-06-12', font=f(14), fill=TEXT)
    tw = d.textlength('巨蟹座', font=f(10))
    d.text(((W-tw)/2, y+34), '♋ 巨蟹座', font=f(10), fill=TEXT_2)
    d.text((W-PAD-48, y+18), '后一天 ›', font=f(11), fill=ACCENT)
    # 综合星级
    y += 72
    stars_row(d, W/2-44, y, 4, size=8)
    d.text((W/2+30, y-4), '4.0', font=f(16), fill=ACCENT)
    # 四维评分
    y += 28
    items = ['爱情', '事业', '财运', '健康']
    for i, n in enumerate(items):
        ry = y + i*36
        d.text((PAD, ry), n, font=f(11), fill=TEXT)
        d.rounded_rectangle([PAD+42, ry+4, W-PAD-32, ry+14], radius=5, fill=FILL)
        d.rounded_rectangle([PAD+42, ry+4, PAD+42+(W-PAD-74)*(0.55+i*0.1), ry+14],
                            radius=5, fill=ACCENT)
        d.text((W-PAD-28, ry), str(3+i%3)+'.0', font=f(10), fill=TEXT_2)
    # 运势详解
    y2 = y + 168
    d.text((PAD, y2), '运势详解', font=f(12), fill=TEXT)
    d.rounded_rectangle([PAD, y2+22, W-PAD, y2+118], radius=8, outline=STROKE_L, fill=FILL_2)
    for i in range(4):
        d.line([(PAD+10, y2+34+i*18), (W-PAD-10, y2+34+i*18)], fill=STROKE_L, width=1)
    caption(d, H-30, '当日运势详情 CalendarDetailPage')
    return save(img, '20_CalendarDetailPage')

def draw_profile():
    img, d = new_canvas()
    # 头部
    circle(d, W/2, 86, 36, outline=STROKE, fill=FILL_2)
    tw = d.textlength('星语用户', font=f(16))
    d.text(((W-tw)/2, 130), '星语用户', font=f(16), fill=TEXT)
    tw = d.textlength('摩羯座 · 12.22 - 1.19', font=f(10))
    d.text(((W-tw)/2, 154), '摩羯座 · 12.22 - 1.19', font=f(10), fill=TEXT_2)
    # 今日运势卡
    y = 180
    d.rounded_rectangle([PAD, y, W-PAD, y+64], radius=10, outline=STROKE, fill=FILL_2)
    d.text((PAD+12, y+10), '我的今日运势', font=f(12), fill=TEXT)
    stars_row(d, W-PAD-90, y+12, 3, size=7)
    d.text((PAD+12, y+34), '桃花朵朵，人际关系格外融洽', font=f(10), fill=TEXT_2)
    # 修改我的星座按钮
    y += 80
    d.rounded_rectangle([PAD+10, y, W-PAD-10, y+38], radius=19, fill=ACCENT)
    tw = d.textlength('修改我的星座', font=f(13))
    d.text(((W-tw)/2, y+10), '修改我的星座', font=f(13), fill=TEXT)
    # 菜单
    y += 56
    menus = [('⭐', '我的收藏'),
             ('🎂', '生日星座查询'),
             ('🔔', '推送设置'),
             ('🌗', '星盘知识'),
             ('ℹ', '关于星语')]
    d.rounded_rectangle([PAD, y, W-PAD, y+len(menus)*48], radius=10, outline=STROKE_L, fill=FILL_2)
    for i, (ic, n) in enumerate(menus):
        my = y + i*48
        d.text((PAD+14, my+15), ic, font=f(15))
        d.text((PAD+44, my+16), n, font=f(12), fill=TEXT)
        d.text((W-PAD-20, my+14), '›', font=f(18), fill=TEXT_2)
        if i < len(menus)-1:
            d.line([(PAD+10, my+47), (W-PAD-10, my+47)], fill=STROKE_L)
    # 退出登录
    y += len(menus)*48 + 18
    d.rounded_rectangle([PAD+10, y, W-PAD-10, y+36], radius=18, outline=(220, 90, 90), fill=FILL_2)
    tw = d.textlength('退出登录', font=f(12))
    d.text(((W-tw)/2, y+10), '退出登录', font=f(12), fill=(220, 90, 90))
    bottom_tab(d, active=5)
    caption(d, H-72, '个人中心页 ProfilePage')
    return save(img, '21_ProfilePage')

def draw_my_constellation():
    img, d = new_canvas()
    y = title_bar(d, '我的星座设置')
    # 当前结果展示
    circle(d, W/2, y+34, 26, outline=STROKE, fill=FILL_2)
    tw = d.textlength('摩羯座', font=f(15))
    d.text(((W-tw)/2, y+72), '摩羯座', font=f(15), fill=TEXT)
    # 昵称
    y2 = y + 110
    d.rounded_rectangle([PAD, y2, W-PAD, y2+62], radius=10, outline=STROKE_L, fill=FILL_2)
    d.text((PAD+12, y2+8), '昵称', font=f(11), fill=TEXT)
    label_box(d, PAD+12, y2+28, W-2*PAD-24, 26, '给自己起个名字', font_size=10, radius=13)
    # 生日识别
    y3 = y2 + 80
    d.rounded_rectangle([PAD, y3, W-PAD, y3+90], radius=10, outline=STROKE_L, fill=FILL_2)
    d.text((PAD+12, y3+8), '输入生日自动识别', font=f(11), fill=TEXT)
    for i, v in enumerate(['2000', '01', '01']):
        cx = PAD + 30 + i*(W-2*PAD-60)/2
        d.text((cx-12, y3+34), v, font=f(20), fill=ACCENT)
    # 手动选择
    y4 = y3 + 110
    d.rounded_rectangle([PAD, y4, W-PAD, y4+150], radius=10, outline=STROKE_L, fill=FILL_2)
    d.text((PAD+12, y4+8), '或手动选择星座', font=f(11), fill=TEXT)
    cw = (W - 2*PAD - 60) / 4
    for i in range(12):
        r, c = divmod(i, 4)
        cx = PAD + 14 + c*(cw+8); cy = y4 + 32 + r*36
        d.rounded_rectangle([cx, cy, cx+cw, cy+32], radius=6,
                            outline=STROKE_L, fill=(255, 245, 220) if i == 9 else FILL)
        d.text((cx+cw/2-12, cy+8), '★', font=f(11), fill=ACCENT if i==9 else STROKE_L)
    # 保存按钮
    y5 = y4 + 168
    d.rounded_rectangle([PAD+30, y5, W-PAD-30, y5+36], radius=18, fill=ACCENT)
    tw = d.textlength('保存', font=f(13))
    d.text(((W-tw)/2, y5+10), '保存', font=f(13), fill=TEXT)
    caption(d, H-30, '我的星座设置页 MyConstellationPage')
    return save(img, '22_MyConstellationPage')

def draw_favorite():
    img, d = new_canvas()
    y = title_bar(d, '我的收藏')
    for i in range(5):
        cy = y + i*68
        d.rounded_rectangle([PAD, cy, W-PAD, cy+58], radius=8, outline=STROKE_L, fill=FILL_2)
        circle(d, PAD+30, cy+28, 18, outline=STROKE_L)
        d.text((PAD+58, cy+8), '收藏星座 ' + str(i+1), font=f(12), fill=TEXT)
        stars_row(d, PAD+58, cy+30, 5-i%3, size=6)
        d.text((PAD+58, cy+42), '一句话运势摘要 ...', font=f(9), fill=TEXT_2)
        d.text((W-PAD-22, cy+22), '›', font=f(16), fill=TEXT_2)
    caption(d, H-30, '我的收藏页 FavoritePage')
    return save(img, '23_FavoritePage')

def draw_watch():
    """手表模态：圆屏 233x233 风格"""
    img = Image.new('RGB', (W, H), BG)
    d = ImageDraw.Draw(img)
    # 表带
    d.rectangle([W/2-90, 8, W/2+90, 60], fill=(80, 80, 90))
    d.rectangle([W/2-90, H-60, W/2+90, H-8], fill=(80, 80, 90))
    # 圆形表壳
    R = 250
    d.ellipse([W/2-R, H/2-R+10, W/2+R, H/2+R+10], outline=FRAME, width=4, fill=BG)
    R2 = R - 8
    d.ellipse([W/2-R2, H/2-R2+10, W/2+R2, H/2+R2+10], outline=STROKE_L, width=1, fill=(248, 248, 255))
    # 内容
    cx, cy = W/2, H/2 + 10
    # 月份
    tw = d.textlength('2026年6月', font=f(13))
    d.text((cx-tw/2, cy-200), '2026年6月', font=f(13), fill=TEXT)
    # 星座小标
    d.rounded_rectangle([cx-46, cy-176, cx+46, cy-160], radius=8, fill=FILL_2, outline=STROKE_L)
    tw = d.textlength('♋ 巨蟹·点按切换', font=f(9))
    d.text((cx-tw/2, cy-174), '♋ 巨蟹·点按切换', font=f(9), fill=TEXT_2)
    # 星期
    weeks = ['日', '一', '二', '三', '四', '五', '六']
    cw = 22
    for i, w in enumerate(weeks):
        d.text((cx-7*cw/2 + i*cw + 6, cy-148), w, font=f(8), fill=TEXT_2)
    # 月历 5 行
    import random
    random.seed(5)
    legend = [ACCENT, (80, 180, 130), (90, 200, 220), (255, 160, 60), (240, 90, 90)]
    for r in range(5):
        for c in range(7):
            x = cx-7*cw/2 + c*cw + 6; ly = cy - 130 + r*22
            day = r*7 + c + 1
            if day <= 30:
                if day == 12:
                    d.rounded_rectangle([x-9, ly, x+11, ly+18], radius=4, fill=ACCENT)
                    d.text((x-3, ly+1), str(day), font=f(8), fill=TEXT)
                else:
                    d.text((x-3 if day<10 else x-6, ly+1), str(day), font=f(8), fill=TEXT)
                d.ellipse([x-2, ly+14, x+2, ly+18], fill=random.choice(legend))
    # 当日摘要
    d.rounded_rectangle([cx-90, cy+10, cx+90, cy+60], radius=8, outline=STROKE_L, fill=FILL_2)
    tw = d.textlength('6月12日  极佳', font=f(10))
    d.text((cx-tw/2, cy+14), '6月12日  极佳', font=f(10), fill=TEXT)
    stars_row(d, cx-22, cy+30, 4, size=4)
    tw = d.textlength('万事顺遂', font=f(9))
    d.text((cx-tw/2, cy+44), '万事顺遂', font=f(9), fill=TEXT_2)
    # 7 日走势
    d.rounded_rectangle([cx-90, cy+72, cx+90, cy+138], radius=8, outline=STROKE_L, fill=FILL_2)
    tw = d.textlength('近 7 日走势', font=f(9))
    d.text((cx-tw/2, cy+76), '近 7 日走势', font=f(9), fill=ACCENT)
    bw = 8
    for i in range(7):
        lvl = (i*2 + 3) % 5 + 1
        bx = cx - 7*16/2 + i*16
        d.rounded_rectangle([bx, cy+128 - lvl*7, bx+bw, cy+128],
                            radius=2, fill=legend[5-lvl] if lvl<=5 else ACCENT)
    # 图例
    lx = cx - 70
    for i, (n, c) in enumerate([('极佳', ACCENT), ('不错', (80, 180, 130)),
                                ('一般', (90, 200, 220)), ('偏低', (255, 160, 60)),
                                ('较差', (240, 90, 90))]):
        d.ellipse([lx, cy+158, lx+5, cy+163], fill=c)
        d.text((lx+8, cy+155), n, font=f(7), fill=TEXT_2)
        lx += 30
    tw = d.textlength('手表模态 WatchCalendarPage', font=f(11))
    d.text(((W-tw)/2, H-30), '手表模态 WatchCalendarPage', font=f(11), fill=TEXT_2)
    img.save(os.path.join(OUT, '24_WatchCalendarPage.png'), 'PNG', optimize=True)
    return os.path.join(OUT, '24_WatchCalendarPage.png')


# 生成全部
paths = []
for fn in [draw_splash, draw_login, draw_home, draw_fortune_detail, draw_all_fortune,
          draw_search, draw_notify, draw_const_list, draw_const_detail, draw_element,
          draw_starchart, draw_birthday, draw_match_select, draw_match_result,
          draw_user_match, draw_chat, draw_tarot, draw_tarot_detail, draw_calendar,
          draw_calendar_detail, draw_profile, draw_my_constellation, draw_favorite,
          draw_watch]:
    p = fn()
    paths.append(p)
    print(' ✓', os.path.basename(p))
print('共生成', len(paths), '张')
