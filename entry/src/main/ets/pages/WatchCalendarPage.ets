import { common } from '@kit.AbilityKit';
import { Colors, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { buildMonthCells, CalendarCell } from '../mock/CalendarData';
import { getConstellationById } from '../mock/ConstellationData';
import { getFortune } from '../mock/FortuneData';
import { DateUtils } from '../utils/DateUtils';
import { StarRating } from '../components/StarRating';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

/**
 * 手表模态专用页面：星座日历运势走势
 * 针对圆形小屏（约 233vp）做紧凑布局：
 * 月历色点 + 近 7 日走势柱状图 + 点按日期查看当日摘要。
 */

interface TrendDay {
  day: number;
  level: number;
  isToday: boolean;
}

@Entry
@Component
struct WatchCalendarPage {
  @State year: number = new Date().getFullYear();
  @State month: number = new Date().getMonth() + 1;
  @State myId: number = 1;
  @State cells: CalendarCell[] = [];
  @State selected: CalendarCell | null = null;
  @State trend: TrendDay[] = [];
  private readonly weekLabels: string[] = ['日', '一', '二', '三', '四', '五', '六'];

  aboutToAppear(): void {
    // 手表模态不经过启动页，需自行初始化本地存储
    const ctx = getContext(this) as common.UIAbilityContext;
    StorageUtils.init(ctx).then(() => {
      return StorageUtils.getNumber(StoreKey.MY_CONSTELLATION, 1);
    }).then((v: number) => {
      this.myId = v >= 1 ? v : 1;
      this.refresh();
    }).catch(() => {
      this.refresh();
    });
    this.refresh();
  }

  private refresh(): void {
    this.cells = buildMonthCells(this.year, this.month, this.myId);
    const today: CalendarCell | undefined = this.cells.find((c) => c.isToday);
    this.selected = today ?? this.cells.find((c) => c.day === 1) ?? null;
    this.buildTrend();
  }

  /** 以今天为中心，前后各 3 天的运势走势 */
  private buildTrend(): void {
    const list: TrendDay[] = [];
    const base: Date = new Date();
    for (let i = -3; i <= 3; i++) {
      const d: Date = new Date(base.getFullYear(), base.getMonth(), base.getDate() + i);
      const ds: string = DateUtils.formatDate(d);
      list.push({
        day: d.getDate(),
        level: getFortune(this.myId, ds).overall,
        isToday: i === 0
      });
    }
    this.trend = list;
  }

  private changeMonth(delta: number): void {
    let m: number = this.month + delta;
    let y: number = this.year;
    if (m < 1) { m = 12; y -= 1; }
    if (m > 12) { m = 1; y += 1; }
    this.month = m;
    this.year = y;
    this.refresh();
  }

  /** 点按星座名循环切换 1-12，并持久化 */
  private nextConstellation(): void {
    this.myId = this.myId % 12 + 1;
    StorageUtils.put(StoreKey.MY_CONSTELLATION, this.myId);
    this.refresh();
  }

  private levelColor(level: number): string {
    switch (level) {
      case 5: return Colors.ACCENT_GOLD;
      case 4: return Colors.SUCCESS;
      case 3: return Colors.ACCENT_TEAL;
      case 2: return Colors.WARNING;
      default: return Colors.DANGER;
    }
  }

  private levelText(level: number): string {
    switch (level) {
      case 5: return '极佳';
      case 4: return '不错';
      case 3: return '一般';
      case 2: return '偏低';
      default: return '较差';
    }
  }

  /** 将月历格子按 7 个一组切分为周 */
  private weeks(): CalendarCell[][] {
    const rows: CalendarCell[][] = [];
    for (let i = 0; i < this.cells.length; i += 7) {
      rows.push(this.cells.slice(i, i + 7));
    }
    return rows;
  }

  @Builder
  dayCell(cell: CalendarCell) {
    Column({ space: 1 }) {
      if (cell.day > 0) {
        Text(`${cell.day}`)
          .fontSize(9)
          .fontColor(cell.isToday ? Colors.BG_PRIMARY : Colors.TEXT_PRIMARY)
        Row().width(4).height(4).borderRadius(2)
          .backgroundColor(this.levelColor(cell.level))
      }
    }
    .width(25).height(24)
    .justifyContent(FlexAlign.Center)
    .borderRadius(6)
    .backgroundColor(cell.day > 0 && cell.isToday ? Colors.ACCENT_GOLD :
      (cell.day > 0 && this.selected && this.selected.day === cell.day ? Colors.BG_CARD2 : Color.Transparent))
    .onClick(() => {
      if (cell.day > 0) {
        this.selected = cell;
      }
    })
  }

  build() {
    Scroll() {
      Column({ space: 6 }) {
        // 月份切换
        Row() {
          Text('‹').fontSize(18).fontColor(Colors.ACCENT_GOLD)
            .padding({ left: 10, right: 10 })
            .onClick(() => this.changeMonth(-1))
          Text(`${this.year}年${this.month}月`)
            .fontSize(13).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
            .layoutWeight(1).textAlign(TextAlign.Center)
          Text('›').fontSize(18).fontColor(Colors.ACCENT_GOLD)
            .padding({ left: 10, right: 10 })
            .onClick(() => this.changeMonth(1))
        }.width('100%')

        // 星座（点按切换）
        Text(`${getConstellationById(this.myId).symbol} ${getConstellationById(this.myId).name} · 点按切换`)
          .fontSize(10).fontColor(Colors.TEXT_SECONDARY)
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          .borderRadius(8).backgroundColor(Colors.BG_CARD)
          .onClick(() => this.nextConstellation())

        // 星期标题
        Row() {
          ForEach(this.weekLabels, (w: string) => {
            Text(w).fontSize(8).fontColor(Colors.TEXT_HINT)
              .layoutWeight(1).textAlign(TextAlign.Center)
          }, (w: string) => w)
        }.width('100%')

        // 月历（按周分行）
        Column({ space: 2 }) {
          ForEach(this.weeks(), (week: CalendarCell[], idx: number) => {
            Row() {
              ForEach(week, (cell: CalendarCell, ci: number) => {
                this.dayCell(cell)
              }, (cell: CalendarCell, ci: number) => `${this.year}-${this.month}-${idx}-${ci}`)
            }.width('100%').justifyContent(FlexAlign.SpaceBetween)
          }, (week: CalendarCell[], idx: number) => `w-${this.year}-${this.month}-${idx}`)
        }.width('100%')

        // 选中日期摘要
        if (this.selected && this.selected.day > 0) {
          Column({ space: 3 }) {
            Row({ space: 6 }) {
              Text(`${this.month}月${this.selected!.day}日`)
                .fontSize(11).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
              Text(this.levelText(this.selected!.level))
                .fontSize(10).fontColor(this.levelColor(this.selected!.level))
            }
            StarRating({ score: this.selected!.level, starSize: 10 })
            Text(getFortune(this.myId, this.selected!.dateStr).summary)
              .fontSize(9).fontColor(Colors.TEXT_SECONDARY)
              .maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
              .textAlign(TextAlign.Center)
          }
          .width('100%').padding(8)
          .borderRadius(10).backgroundColor(Colors.BG_CARD)
          .alignItems(HorizontalAlign.Center)
        }

        // 近 7 日运势走势（柱状）
        Column({ space: 4 }) {
          Text('近 7 日走势').fontSize(9).fontColor(Colors.ACCENT_GOLD)
          Row() {
            ForEach(this.trend, (t: TrendDay) => {
              Column({ space: 2 }) {
                Row()
                  .width(9)
                  .height(t.level * 7)
                  .borderRadius(3)
                  .backgroundColor(this.levelColor(t.level))
                  .opacity(t.isToday ? 1 : 0.55)
                Text(`${t.day}`)
                  .fontSize(8)
                  .fontColor(t.isToday ? Colors.ACCENT_GOLD : Colors.TEXT_HINT)
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.End)
            }, (t: TrendDay) => `t-${this.myId}-${t.day}`)
          }
          .width('100%').height(52)
          .alignItems(VerticalAlign.Bottom)
        }
        .width('100%').padding(8)
        .borderRadius(10).backgroundColor(Colors.BG_CARD)
        .alignItems(HorizontalAlign.Center)

        // 图例
        Row({ space: 6 }) {
          ForEach([5, 4, 3, 2, 1], (lv: number) => {
            Row({ space: 2 }) {
              Row().width(5).height(5).borderRadius(3).backgroundColor(this.levelColor(lv))
              Text(this.levelText(lv)).fontSize(8).fontColor(Colors.TEXT_HINT)
            }
          }, (lv: number) => `lv${lv}`)
        }.justifyContent(FlexAlign.Center)

        Blank().height(8)
      }
      .width('100%')
      .padding({ left: 22, right: 22, top: 26, bottom: 26 })
    }
    .width('100%').height('100%')
    .scrollBar(BarState.Off)
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
  }
}
