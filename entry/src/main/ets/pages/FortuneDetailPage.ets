import { router, promptAction } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { DateUtils } from '../utils/DateUtils';
import { getConstellationById } from '../mock/ConstellationData';
import { getFortune } from '../mock/FortuneData';
import { ConstellationInfo } from '../model/Constellation';
import { DailyFortune } from '../model/Fortune';
import { StarRating } from '../components/StarRating';
import { FortuneScoreBar } from '../components/FortuneScoreBar';
import { StorageUtils } from '../utils/StorageUtils';

interface IdParam {
  id: number;
}

@Entry
@Component
struct FortuneDetailPage {
  @State cstId: number = 1;
  @State info: ConstellationInfo = getConstellationById(1);
  @State fortune: DailyFortune = getFortune(1, DateUtils.formatDate(new Date()));
  @State isFav: boolean = false;
  private todayStr: string = DateUtils.formatDate(new Date());

  aboutToAppear(): void {
    const p = router.getParams() as IdParam;
    if (p && p.id) {
      this.cstId = p.id;
    }
    this.info = getConstellationById(this.cstId);
    this.fortune = getFortune(this.cstId, this.todayStr);
    StorageUtils.isFavorite(this.cstId).then((v: boolean) => {
      this.isFav = v;
    });
  }

  private async toggleFav(): Promise<void> {
    const added: boolean = await StorageUtils.toggleFavorite(this.cstId);
    this.isFav = added;
    promptAction.showToast({ message: added ? '已收藏 ⭐' : '已取消收藏' });
  }

  @Builder
  topBar() {
    Row() {
      Text('‹')
        .fontSize(34)
        .fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 })
        .onClick(() => router.back())
      Text('今日运势')
        .fontSize(FontSize.SUBTITLE)
        .fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
      Text(this.isFav ? '★' : '☆')
        .fontSize(26)
        .fontColor(this.isFav ? Colors.ACCENT_GOLD : Colors.TEXT_SECONDARY)
        .padding({ left: 16, right: 16 })
        .onClick(() => this.toggleFav())
    }
    .width('100%')
    .height(52)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  headerCard() {
    Column({ space: 10 }) {
      Stack() {
        Circle().width(90).height(90).fill(this.info.color).opacity(0.22)
        Text(this.info.symbol).fontSize(50).fontColor(this.info.color)
      }
      Text(`${this.info.name} · ${this.info.nameEn}`)
        .fontSize(FontSize.TITLE)
        .fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY)
      Text(this.info.dateRange)
        .fontSize(FontSize.CAPTION)
        .fontColor(Colors.TEXT_SECONDARY)
      Row({ space: 8 }) {
        StarRating({ score: this.fortune.overall, starSize: 22 })
        Text(`${this.fortune.overall}.0`)
          .fontSize(FontSize.SUBTITLE)
          .fontColor(Colors.ACCENT_GOLD)
          .fontWeight(FontWeight.Bold)
      }
      .margin({ top: 6 })
    }
    .width('100%')
    .padding(20)
  }

  @Builder
  scoreSection() {
    Column({ space: 14 }) {
      Text('运势分项').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).width('100%')
      FortuneScoreBar({ label: '爱情', score: this.fortune.love, barColor: Colors.ACCENT_PINK })
      FortuneScoreBar({ label: '事业', score: this.fortune.career, barColor: Colors.ACCENT_TEAL })
      FortuneScoreBar({ label: '财运', score: this.fortune.wealth, barColor: Colors.ACCENT_GOLD })
      FortuneScoreBar({ label: '健康', score: this.fortune.health, barColor: Colors.SUCCESS })
    }
    .width('100%')
    .padding(18)
    .margin({ left: 16, right: 16 })
    .borderRadius(BorderRadius.CARD)
    .backgroundColor(Colors.BG_CARD)
  }

  @Builder
  luckyChip(title: string, value: string) {
    Column({ space: 4 }) {
      Text(title).fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
      Text(value).fontSize(FontSize.BODY).fontColor(Colors.ACCENT_GOLD).fontWeight(FontWeight.Bold)
    }
    .layoutWeight(1)
    .padding(14)
    .borderRadius(BorderRadius.CARD)
    .backgroundColor(Colors.BG_CARD2)
  }

  build() {
    Column() {
      this.topBar()
      Scroll() {
        Column({ space: 16 }) {
          this.headerCard()
          this.scoreSection()

          // 详细描述
          Column({ space: 8 }) {
            Text('今日详解').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
              .fontColor(Colors.TEXT_PRIMARY).width('100%')
            Text(this.fortune.detail)
              .fontSize(FontSize.BODY)
              .fontColor(Colors.TEXT_SECONDARY)
              .lineHeight(24)
              .width('100%')
          }
          .width('100%')
          .padding(18)
          .margin({ left: 16, right: 16 })
          .borderRadius(BorderRadius.CARD)
          .backgroundColor(Colors.BG_CARD)

          // 幸运信息
          Row({ space: 12 }) {
            this.luckyChip('幸运色', this.fortune.luckyColor)
            this.luckyChip('幸运数字', this.fortune.luckyNumber.toString())
            this.luckyChip('幸运方位', this.fortune.luckyDirection)
          }
          .padding({ left: 16, right: 16 })

          Button('查看星座百科 ›')
            .width('90%')
            .height(48)
            .fontColor(Colors.BG_PRIMARY)
            .backgroundColor(Colors.ACCENT_GOLD)
            .borderRadius(BorderRadius.BUTTON)
            .onClick(() => router.pushUrl({ url: 'pages/ConstellationDetailPage', params: { id: this.cstId } }))

          Blank().height(24)
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .backgroundColor(Colors.BG_PRIMARY)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
