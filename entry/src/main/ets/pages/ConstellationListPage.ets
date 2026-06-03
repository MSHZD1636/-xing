import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { CONSTELLATIONS } from '../mock/ConstellationData';
import { ConstellationInfo } from '../model/Constellation';
import { ConstellationCard } from '../components/ConstellationCard';
import { BottomTabBar } from '../components/BottomTabBar';

@Entry
@Component
struct ConstellationListPage {
  @Builder
  galaxyHeader() {
    Column({ space: 8 }) {
      Text('✦ 十二星座图鉴 ✦')
        .fontSize(FontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
      Text('探索每个星座的性格与命运')
        .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
    }
    .width('100%').height(120).justifyContent(FlexAlign.Center)
    .linearGradient({ angle: 160, colors: [['#3A1A5E', 0.0], ['#1A0A2E', 1.0]] })
  }

  @Builder
  quickEntry() {
    Row({ space: 12 }) {
      this.entryCard('🌗 星盘知识', '太阳·月亮·上升', 'pages/StarChartPage')
      this.entryCard('🔥 元素科普', '火水土风四象', 'pages/ElementPage')
    }
    .width('100%').padding({ left: 16, right: 16, top: 16 })
  }

  @Builder
  entryCard(title: string, sub: string, url: string) {
    Column({ space: 4 }) {
      Text(title).fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).fontWeight(FontWeight.Medium)
      Text(sub).fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
    }
    .alignItems(HorizontalAlign.Start).layoutWeight(1).padding(16)
    .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)
    .border({ width: 1, color: Colors.DIVIDER })
    .onClick(() => router.pushUrl({ url: url }))
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          this.galaxyHeader()
          this.quickEntry()
          Grid() {
            ForEach(CONSTELLATIONS, (c: ConstellationInfo) => {
              GridItem() {
                ConstellationCard({
                  info: c,
                  onCardClick: (id: number) => {
                    router.pushUrl({ url: 'pages/ConstellationDetailPage', params: { id: id } });
                  }
                })
              }
            }, (c: ConstellationInfo) => c.id.toString())
          }
          .columnsTemplate('1fr 1fr 1fr')
          .rowsGap(12).columnsGap(12)
          .padding(16)
        }
      }
      .layoutWeight(1).scrollBar(BarState.Off).align(Alignment.Top)

      BottomTabBar({ currentIndex: 1 })
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
