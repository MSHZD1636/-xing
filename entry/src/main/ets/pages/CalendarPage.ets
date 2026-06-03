import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { buildMonthCells, CalendarCell } from '../mock/CalendarData';
import { getConstellationById } from '../mock/ConstellationData';
import { getFortune } from '../mock/FortuneData';
import { DailyFortune } from '../model/Fortune';
import { BottomTabBar } from '../components/BottomTabBar';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

@Entry
@Component
struct CalendarPage {
  @State year: number = new Date().getFullYear();
  @State month: number = new Date().getMonth() + 1;
  @State myId: number = 1;
  @State cells: CalendarCell[] = [];
  @State selected: CalendarCell | null = null;
  private readonly weekLabels: string[] = ['日', '一', '二', '三', '四', '五', '六'];

  aboutToAppear(): void {
    StorageUtils.getNumber(StoreKey.MY_CONSTELLATION, 1).then((v: number) => {
      this.myId = v >= 1 ? v : 1;
      this.refresh();
    });
  }

  private refresh(): void {
    this.cells = buildMonthCells(this.year, this.month, this.myId);
    const today: CalendarCell | undefined = this.cells.find((c) => c.isToday);
    this.selected = today ?? this.cells.find((c) => c.day === 1) ?? null;
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

  private levelColor(level: number): string {
    switch (level) {
      case 5: return Colors.ACCENT_GOLD;
      case 4: return Colors.SUCCESS;
      case 3: return Colors.ACCENT_TEAL;
      case 2: return Colors.WARNING;
      default: return Colors.DANGER;
    }
  }

  @Builder
  monthHeader() {
    Row() {
      Text('‹ 上月').fontSize(FontSize.BODY).fontColor(Colors.ACCENT_GOLD)
        .onClick(() => this.changeMonth(-1))
      Column({ space: 2 }) {
        Text(`${this.year} 年 ${this.month} 月`).fontSize(FontSize.SUBTITLE)
          .fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
        Text(`${getConstellationById(this.myId).symbol} ${getConstellationById(this.myId).name}运势`)
          .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
      }.layoutWeight(1)
      Text('下月 ›').fontSize(FontSize.BODY).fontColor(Colors.ACCENT_GOLD)
        .onClick(() => this.changeMonth(1))
    }
    .width('100%').padding({ left: 20, right: 20, top: 16, bottom: 10 })
    .alignItems(VerticalAlign.Center)
  }

  private goHome(): void {
    if (Number(router.getLength()) > 1) {
      router.back();
    } else {
      router.replaceUrl({ url: 'pages/HomePage' });
    }
  }

  build() {
    Column() {
      Row() {
        Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
          .padding({ right: 12 }).onClick(() => this.goHome())
        Text('星座日历').fontSize(FontSize.TITLE).fontWeight(FontWeight.Bold)
          .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1)
        Text('返回首页').fontSize(FontSize.CAPTION).fontColor(Colors.ACCENT_GOLD)
          .onClick(() => this.goHome())
      }.width('100%').padding({ left: 16, right: 16, top: 16, bottom: 4 }).alignItems(VerticalAlign.Center)

      this.monthHeader()

      // 星期标题
      Row() {
        ForEach(this.weekLabels, (w: string) => {
          Text(w).fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_HINT)
            .layoutWeight(1).textAlign(TextAlign.Center)
        }, (w: string) => w)
      }.width('100%').padding({ left: 12, right: 12, bottom: 6 })

      // 月历网格
      Grid() {
        ForEach(this.cells, (cell: CalendarCell, index: number) => {
          GridItem() {
            if (cell.day > 0) {
              Column({ space: 3 }) {
                Text(`${cell.day}`)
                  .fontSize(FontSize.BODY)
                  .fontColor(cell.isToday ? Colors.BG_PRIMARY : Colors.TEXT_PRIMARY)
                Row().width(6).height(6).borderRadius(3).backgroundColor(this.levelColor(cell.level))
              }
              .width('100%').height(46).justifyContent(FlexAlign.Center)
              .borderRadius(BorderRadius.TAG)
              .backgroundColor(cell.isToday ? Colors.ACCENT_GOLD :
                (this.selected && this.selected.day === cell.day ? Colors.BG_CARD2 : Color.Transparent))
              .onClick(() => this.selected = cell)
            }
          }
        }, (cell: CalendarCell, index: number) => `${index}`)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .rowsGap(4).columnsGap(2)
      .padding({ left: 12, right: 12 })

      // 选中日期简要
      if (this.selected && this.selected.day > 0) {
        this.selectedSummary(this.selected)
      }

      Blank()
      BottomTabBar({ currentIndex: 4 })
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  selectedSummary(cell: CalendarCell) {
    Column({ space: 8 }) {
      Row() {
        Text(cell.dateStr).fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).fontWeight(FontWeight.Bold)
        Blank()
        Text(`运势 ${cell.level}.0`).fontSize(FontSize.CAPTION).fontColor(this.levelColor(cell.level))
      }.width('100%')
      Text(getFortune(this.myId, cell.dateStr).summary)
        .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY).width('100%')
      Button('查看当日详情 ›')
        .width('100%').height(40).fontSize(FontSize.BODY)
        .fontColor(Colors.BG_PRIMARY).backgroundColor(Colors.ACCENT_GOLD).borderRadius(BorderRadius.BUTTON)
        .onClick(() => router.pushUrl({
          url: 'pages/CalendarDetailPage',
          params: { date: cell.dateStr, id: this.myId }
        }))
    }
    .width('100%').padding(16).margin({ left: 16, right: 16, top: 12 })
    .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)
  }
}
