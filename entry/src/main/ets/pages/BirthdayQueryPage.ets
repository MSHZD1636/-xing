import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { DateUtils } from '../utils/DateUtils';
import { getConstellationById } from '../mock/ConstellationData';
import { getFortune } from '../mock/FortuneData';
import { ConstellationInfo } from '../model/Constellation';
import { DailyFortune } from '../model/Fortune';
import { StarRating } from '../components/StarRating';

@Entry
@Component
struct BirthdayQueryPage {
  @State picked: Date = new Date(2000, 0, 1);
  @State resultId: number = 0;     // 0 表示尚未查询
  private todayStr: string = DateUtils.formatDate(new Date());

  private query(): void {
    this.resultId = DateUtils.getConstellationId(this.picked.getMonth() + 1, this.picked.getDate());
  }

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('生日星座查询').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Blank().width(50)
    }.width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  @Builder
  resultCard() {
    Column({ space: 12 }) {
      Stack() {
        Circle().width(80).height(80).fill(getConstellationById(this.resultId).color).opacity(0.22)
        Text(getConstellationById(this.resultId).symbol).fontSize(46)
          .fontColor(getConstellationById(this.resultId).color)
      }
      Text(`${getConstellationById(this.resultId).name} ${getConstellationById(this.resultId).symbol}`)
        .fontSize(FontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
      Text(getConstellationById(this.resultId).dateRange)
        .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)

      Divider().color(Colors.DIVIDER)

      Row({ space: 8 }) {
        StarRating({ score: getFortune(this.resultId, this.todayStr).overall, starSize: 16 })
        Text(getFortune(this.resultId, this.todayStr).summary)
          .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY).layoutWeight(1)
      }.width('100%')

      // 性格关键词
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
        ForEach(getConstellationById(this.resultId).traits, (t: string) => {
          Text(`# ${t}`)
            .fontSize(FontSize.CAPTION).fontColor(Colors.ACCENT_PURPLE)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .margin({ right: 8, top: 8 })
            .borderRadius(BorderRadius.TAG).backgroundColor(Colors.BG_CARD2)
        }, (t: string) => t)
      }

      Button('查看完整星座详情 ›')
        .width('100%').height(46).fontColor(Colors.BG_PRIMARY)
        .backgroundColor(Colors.ACCENT_GOLD).borderRadius(BorderRadius.BUTTON).margin({ top: 6 })
        .onClick(() => router.pushUrl({ url: 'pages/ConstellationDetailPage', params: { id: this.resultId } }))
    }
    .width('100%').padding(20).margin({ left: 16, right: 16, top: 16 })
    .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)
    .border({ width: 1, color: Colors.DIVIDER })
  }

  build() {
    Column() {
      this.topBar()
      Scroll() {
        Column() {
          Text('选择任意日期，查询对应星座')
            .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY).margin({ top: 8, bottom: 8 })

          DatePicker({
            start: new Date('1900-01-01'),
            end: new Date('2030-12-31'),
            selected: this.picked
          })
            .margin({ left: 16, right: 16 })
            .onDateChange((value: Date) => this.picked = value)

          Button('查询 🔍')
            .width('90%').height(48).fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
            .fontColor(Colors.BG_PRIMARY).backgroundColor(Colors.ACCENT_GOLD)
            .borderRadius(BorderRadius.BUTTON).margin({ top: 14 })
            .onClick(() => this.query())

          if (this.resultId >= 1) {
            this.resultCard()
          }

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
