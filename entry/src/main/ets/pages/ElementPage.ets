import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { getConstellationsByElement } from '../mock/ConstellationData';
import { ConstellationInfo } from '../model/Constellation';

interface ElementInfo {
  emoji: string;
  name: string;
  color: string;
  desc: string;
}

@Entry
@Component
struct ElementPage {
  private elements: ElementInfo[] = [
    { emoji: '🔥', name: '火', color: '#FF6B6B', desc: '火象星座热情、行动力强、勇于冒险，是天生的开拓者，充满激情与领导魅力。' },
    { emoji: '🌊', name: '水', color: '#6FA8FF', desc: '水象星座情感细腻、直觉敏锐、富有同理心，重视情感联结与内心世界。' },
    { emoji: '⛰️', name: '土', color: '#8FD14F', desc: '土象星座务实稳重、脚踏实地、注重安全感，是可靠的执行者与守护者。' },
    { emoji: '🌬️', name: '风', color: '#5CD6FF', desc: '风象星座聪慧灵动、善于沟通、追求自由，思想前卫，热爱社交与新知。' }
  ];

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('四大元素科普').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Blank().width(50)
    }.width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  @Builder
  elementCard(el: ElementInfo) {
    Column({ space: 12 }) {
      Row({ space: 10 }) {
        Text(el.emoji).fontSize(32)
        Text(`${el.name}象星座`).fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(el.color)
      }.width('100%')
      Text(el.desc).fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY).lineHeight(23).width('100%')
      Divider().color(Colors.DIVIDER)
      Row({ space: 10 }) {
        ForEach(getConstellationsByElement(el.name), (c: ConstellationInfo) => {
          Column({ space: 4 }) {
            Text(c.symbol).fontSize(26).fontColor(el.color)
            Text(c.name).fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_PRIMARY)
          }
          .layoutWeight(1).padding({ top: 8, bottom: 8 })
          .borderRadius(BorderRadius.TAG).backgroundColor(Colors.BG_CARD2)
          .onClick(() => router.pushUrl({ url: 'pages/ConstellationDetailPage', params: { id: c.id } }))
        }, (c: ConstellationInfo) => c.id.toString())
      }.width('100%')
    }
    .width('100%').padding(18).margin({ bottom: 14 })
    .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)
    .border({ width: 1, color: Colors.DIVIDER })
  }

  build() {
    Column() {
      this.topBar()
      Scroll() {
        Column() {
          ForEach(this.elements, (el: ElementInfo) => {
            this.elementCard(el)
          }, (el: ElementInfo) => el.name)
          Blank().height(20)
        }.padding({ left: 16, right: 16, top: 8 })
      }.layoutWeight(1).scrollBar(BarState.Off).align(Alignment.Top)
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
