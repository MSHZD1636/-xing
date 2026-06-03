import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { DateUtils } from '../utils/DateUtils';
import { getFortune } from '../mock/FortuneData';
import { getConstellationById } from '../mock/ConstellationData';
import { DailyFortune } from '../model/Fortune';
import { ConstellationInfo } from '../model/Constellation';
import { StarRating } from '../components/StarRating';
import { FortuneScoreBar } from '../components/FortuneScoreBar';

interface CalParam {
  date: string;
  id: number;
}

@Entry
@Component
struct CalendarDetailPage {
  @State dateStr: string = DateUtils.formatDate(new Date());
  @State id: number = 1;
  @State fortune: DailyFortune = getFortune(1, DateUtils.formatDate(new Date()));

  aboutToAppear(): void {
    const p = router.getParams() as CalParam;
    if (p && p.date) {
      this.dateStr = p.date;
      this.id = p.id;
    }
    this.reload();
  }

  private reload(): void {
    this.fortune = getFortune(this.id, this.dateStr);
  }

  private shiftDay(delta: number): void {
    const parts: string[] = this.dateStr.split('-');
    const d: Date = new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]));
    d.setDate(d.getDate() + delta);
    this.dateStr = DateUtils.formatDate(d);
    this.reload();
  }

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('当日运势详情').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Blank().width(50)
    }.width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  build() {
    Column() {
      this.topBar()
      Scroll() {
        Column({ space: 16 }) {
          // 日期切换
          Row() {
            Text('‹ 前一天').fontSize(FontSize.BODY).fontColor(Colors.ACCENT_GOLD)
              .onClick(() => this.shiftDay(-1))
            Column({ space: 4 }) {
              Text(this.dateStr).fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
              Text(`${getConstellationById(this.id).symbol} ${getConstellationById(this.id).name}`)
                .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
            }.layoutWeight(1)
            Text('后一天 ›').fontSize(FontSize.BODY).fontColor(Colors.ACCENT_GOLD)
              .onClick(() => this.shiftDay(1))
          }
          .width('100%').padding(16).margin({ left: 16, right: 16 })
          .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)
          .alignItems(VerticalAlign.Center)

          Row({ space: 8 }) {
            StarRating({ score: this.fortune.overall, starSize: 22 })
            Text(`${this.fortune.overall}.0`).fontSize(FontSize.SUBTITLE)
              .fontColor(Colors.ACCENT_GOLD).fontWeight(FontWeight.Bold)
          }

          Column({ space: 14 }) {
            FortuneScoreBar({ label: '爱情', score: this.fortune.love, barColor: Colors.ACCENT_PINK })
            FortuneScoreBar({ label: '事业', score: this.fortune.career, barColor: Colors.ACCENT_TEAL })
            FortuneScoreBar({ label: '财运', score: this.fortune.wealth, barColor: Colors.ACCENT_GOLD })
            FortuneScoreBar({ label: '健康', score: this.fortune.health, barColor: Colors.SUCCESS })
          }
          .width('100%').padding(18).margin({ left: 16, right: 16 })
          .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)

          Column({ space: 8 }) {
            Text('运势详解').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
              .fontColor(Colors.TEXT_PRIMARY).width('100%')
            Divider().color(Colors.DIVIDER)
            Text(this.fortune.detail).fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY)
              .lineHeight(24).width('100%')
          }
          .width('100%').padding(18).margin({ left: 16, right: 16 })
          .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)

          Blank().height(24)
        }
      }.layoutWeight(1).scrollBar(BarState.Off).align(Alignment.Top)
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.Top])
  }
}
