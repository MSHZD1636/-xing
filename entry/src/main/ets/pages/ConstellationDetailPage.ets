import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { getConstellationById } from '../mock/ConstellationData';
import { ConstellationInfo } from '../model/Constellation';
import { RadarChart } from '../components/RadarChart';

interface IdParam {
  id: number;
}

@Entry
@Component
struct ConstellationDetailPage {
  @State id: number = 1;
  @State info: ConstellationInfo = getConstellationById(1);

  aboutToAppear(): void {
    const p = router.getParams() as IdParam;
    if (p && p.id) {
      this.id = p.id;
    }
    this.info = getConstellationById(this.id);
  }

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('星座百科').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Blank().width(50)
    }
    .width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  @Builder
  headerCard() {
    Column({ space: 8 }) {
      Stack() {
        Circle().width(80).height(80).fill(this.info.color).opacity(0.22)
        Text(this.info.symbol).fontSize(46).fontColor(this.info.color)
      }
      Text(`${this.info.name} · ${this.info.nameEn}`)
        .fontSize(FontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
      Row({ space: 8 }) {
        this.miniTag(`${this.info.element}象`)
        this.miniTag(`守护星 ${this.info.planet}`)
        this.miniTag(this.info.dateRange)
      }
    }
    .width('100%').padding({ top: 8, bottom: 16 })
  }

  @Builder
  miniTag(text: string) {
    Text(text)
      .fontSize(FontSize.CAPTION).fontColor(Colors.ACCENT_GOLD)
      .padding({ left: 10, right: 10, top: 4, bottom: 4 })
      .borderRadius(BorderRadius.TAG).backgroundColor(Colors.BG_CARD2)
  }

  @Builder
  paragraph(title: string, body: string) {
    Column({ space: 10 }) {
      Text(title).fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY).width('100%')
      Text(body).fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY).lineHeight(24).width('100%')
    }
    .width('100%').padding(18).alignItems(HorizontalAlign.Start)
  }

  @Builder
  basicTab() {
    Scroll() {
      Column({ space: 12 }) {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.info.traits, (t: string) => {
            Text(`# ${t}`)
              .fontSize(FontSize.CAPTION).fontColor(Colors.ACCENT_PURPLE)
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .margin({ right: 10, bottom: 10 })
              .borderRadius(BorderRadius.TAG).backgroundColor(Colors.BG_CARD)
          }, (t: string) => t)
        }.padding({ left: 18, right: 18, top: 12 })
        this.paragraph('星座简介', this.info.description)
        Text('六维属性').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
          .fontColor(Colors.TEXT_PRIMARY).width('100%').padding({ left: 18 })
        RadarChart({ data: this.info.radar, accent: this.info.color })
        Blank().height(20)
      }
    }.scrollBar(BarState.Off).align(Alignment.Top)
  }

  @Builder
  characterTab() {
    Scroll() {
      Column() {
        this.paragraph('性格分析', this.info.description)
        this.paragraph('代表名人', this.info.celebrities.join('、'))
        RadarChart({ data: this.info.radar, accent: this.info.color })
        Blank().height(20)
      }
    }.scrollBar(BarState.Off).align(Alignment.Top)
  }

  build() {
    Column() {
      this.topBar()
      this.headerCard()
      Tabs() {
        TabContent() { this.basicTab() }.tabBar(this.barLabel('基本信息'))
        TabContent() { this.characterTab() }.tabBar(this.barLabel('性格分析'))
        TabContent() {
          Scroll() { this.paragraph('爱情观', this.info.loveView) }.align(Alignment.Top)
        }.tabBar(this.barLabel('爱情观'))
        TabContent() {
          Scroll() { this.paragraph('职业建议', this.info.careerAdvice) }.align(Alignment.Top)
        }.tabBar(this.barLabel('职业建议'))
      }
      .barMode(BarMode.Scrollable)
      .barWidth('100%')
      .layoutWeight(1)
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.Top])
  }

  @Builder
  barLabel(text: string) {
    Text(text)
      .fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY)
      .padding({ left: 16, right: 16, top: 10, bottom: 10 })
  }
}
