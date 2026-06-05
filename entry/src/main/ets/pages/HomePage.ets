import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { DateUtils } from '../utils/DateUtils';
import { CONSTELLATIONS, getConstellationById } from '../mock/ConstellationData';
import { getFortune, getLuckyConstellationId } from '../mock/FortuneData';
import { ConstellationInfo } from '../model/Constellation';
import { DailyFortune } from '../model/Fortune';
import { BottomTabBar } from '../components/BottomTabBar';
import { StarRating } from '../components/StarRating';

@Entry
@Component
struct HomePage {
  @State todayStr: string = DateUtils.formatDate(new Date());
  @State localizedDate: string = DateUtils.formatLocalized(new Date());
  @State greeting: string = DateUtils.greeting(new Date());
  @State luckyId: number = 1;

  aboutToAppear(): void {
    this.luckyId = getLuckyConstellationId(this.todayStr);
  }

  @Builder
  header() {
    Row() {
      Column({ space: 4 }) {
        Text(this.localizedDate)
          .fontSize(FontSize.CAPTION)
          .fontColor(Colors.TEXT_SECONDARY)
        Text(this.greeting)
          .fontSize(FontSize.SUBTITLE)
          .fontWeight(FontWeight.Bold)
          .fontColor(Colors.TEXT_PRIMARY)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text('🔍')
        .fontSize(22)
        .padding(8)
        .onClick(() => {
          router.pushUrl({ url: 'pages/SearchPage' });
        })
    }
    .width('100%')
    .padding({ left: 20, right: 16, top: 12, bottom: 12 })
  }

  @Builder
  luckyBanner() {
    Swiper() {
      ForEach([this.luckyId], (id: number) => {
        this.bannerCard(id);
      }, (id: number) => id.toString())
      // 额外展示我的星座或次高运势，丰富轮播
      ForEach([((this.luckyId % 12) + 1)], (id: number) => {
        this.bannerCard(id);
      }, (id: number) => 'extra' + id.toString())
    }
    .autoPlay(true)
    .interval(4000)
    .loop(true)
    .indicator(
      new DotIndicator()
        .color(Colors.TEXT_HINT)
        .selectedColor(Colors.ACCENT_GOLD)
    )
    .margin({ left: 16, right: 16 })
  }

  @Builder
  bannerCard(id: number) {
    Column({ space: 10 }) {
      Row() {
        Text('今日幸运星座')
          .fontSize(FontSize.CAPTION)
          .fontColor(Colors.BG_PRIMARY)
          .backgroundColor(Colors.ACCENT_GOLD)
          .borderRadius(BorderRadius.TAG)
          .padding({ left: 10, right: 10, top: 3, bottom: 3 })
        Blank()
      }
      .width('100%')

      Row({ space: 14 }) {
        Stack() {
          Circle().width(64).height(64).fill(getConstellationById(id).color).opacity(0.25)
          Text(getConstellationById(id).symbol).fontSize(36).fontColor(getConstellationById(id).color)
        }
        Column({ space: 6 }) {
          Text(getConstellationById(id).name)
            .fontSize(FontSize.TITLE)
            .fontWeight(FontWeight.Bold)
            .fontColor(Colors.TEXT_PRIMARY)
          StarRating({ score: getFortune(id, this.todayStr).overall, starSize: 18 })
          Text(getFortune(id, this.todayStr).summary)
            .fontSize(FontSize.CAPTION)
            .fontColor(Colors.TEXT_SECONDARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding(18)
    .borderRadius(BorderRadius.CARD)
    .linearGradient({ angle: 135, colors: [['#2A1A4A', 0.0], ['#1C1033', 1.0]] })
    .border({ width: 1, color: Colors.ACCENT_PURPLE })
    .onClick(() => {
      router.pushUrl({ url: 'pages/FortuneDetailPage', params: { id: id } });
    })
  }

  @Builder
  matchEntry() {
    Row({ space: 14 }) {
      Stack() {
        Circle().width(48).height(48).fill(Colors.ACCENT_PINK).opacity(0.28)
        Text('💞').fontSize(24)
      }
      Column({ space: 4 }) {
        Text('星友匹配 / 聊天')
          .fontSize(FontSize.BODY)
          .fontWeight(FontWeight.Bold)
          .fontColor(Colors.TEXT_PRIMARY)
        Text('找到与你星座契合的 TA，开启缘分对话')
          .fontSize(FontSize.CAPTION)
          .fontColor(Colors.TEXT_SECONDARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text('去匹配 ›')
        .fontSize(FontSize.CAPTION)
        .fontColor(Colors.BG_PRIMARY)
        .backgroundColor(Colors.ACCENT_PINK)
        .borderRadius(BorderRadius.TAG)
        .padding({ left: 12, right: 12, top: 6, bottom: 6 })
    }
    .width('100%')
    .padding(16)
    .margin({ left: 16, right: 16, top: 14 })
    .borderRadius(BorderRadius.CARD)
    .linearGradient({ angle: 135, colors: [['#3A1A3A', 0.0], ['#1C1033', 1.0]] })
    .border({ width: 1, color: Colors.ACCENT_PINK })
    .onClick(() => router.pushUrl({ url: 'pages/UserMatchPage' }))
  }

  @Builder
  fortuneGrid() {
    Column() {
      Row() {
        Text('十二星座运势')
          .fontSize(FontSize.SUBTITLE)
          .fontWeight(FontWeight.Bold)
          .fontColor(Colors.TEXT_PRIMARY)
        Blank()
        Text('查看全部 ›')
          .fontSize(FontSize.CAPTION)
          .fontColor(Colors.ACCENT_GOLD)
          .onClick(() => router.pushUrl({ url: 'pages/AllFortuneListPage' }))
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 10 })

      Grid() {
        ForEach(CONSTELLATIONS, (c: ConstellationInfo) => {
          GridItem() {
            this.gridCell(c)
          }
        }, (c: ConstellationInfo) => c.id.toString())
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsGap(12)
      .columnsGap(12)
      .padding({ left: 16, right: 16 })
    }
  }

  @Builder
  gridCell(c: ConstellationInfo) {
    Column({ space: 4 }) {
      Text(c.symbol).fontSize(26).fontColor(c.color)
      Text(c.name).fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY)
      StarRating({ score: getFortune(c.id, this.todayStr).overall, starSize: 11 })
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .borderRadius(BorderRadius.CARD)
    .backgroundColor(Colors.BG_CARD)
    .border({ width: 1, color: Colors.DIVIDER })
    .onClick(() => {
      router.pushUrl({ url: 'pages/FortuneDetailPage', params: { id: c.id } });
    })
  }

  build() {
    Column() {
      this.header()
      Scroll() {
        Column() {
          this.luckyBanner()
          this.matchEntry()
          this.fortuneGrid()
          Blank().height(20)
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)

      BottomTabBar({ currentIndex: 0 })
    }
    .width('100%')
    .height('100%')
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .backgroundColor(Colors.BG_PRIMARY)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
