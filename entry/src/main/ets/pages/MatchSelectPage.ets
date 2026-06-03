import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { CONSTELLATIONS, getConstellationById } from '../mock/ConstellationData';
import { ConstellationInfo } from '../model/Constellation';
import { BottomTabBar } from '../components/BottomTabBar';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

@Entry
@Component
struct MatchSelectPage {
  @State myId: number = 1;
  @State taId: number = 6;
  @State heartScale: number = 1;
  private options: SelectOption[] = CONSTELLATIONS.map((c): SelectOption => {
    return { value: `${c.symbol} ${c.name}` };
  });

  aboutToAppear(): void {
    StorageUtils.getNumber(StoreKey.MY_CONSTELLATION, 1).then((v: number) => this.myId = v);
    // 爱心呼吸动画
    animateTo({ duration: 900, curve: Curve.EaseInOut, iterations: -1, playMode: PlayMode.Alternate }, () => {
      this.heartScale = 1.25;
    });
  }

  @Builder
  pickColumn(label: string, id: number, isMine: boolean) {
    Column({ space: 12 }) {
      Text(label).fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY)
      Stack() {
        Circle().width(96).height(96).fill(getConstellationById(id).color).opacity(0.22)
        Text(getConstellationById(id).symbol).fontSize(52).fontColor(getConstellationById(id).color)
      }
      Text(getConstellationById(id).name).fontSize(FontSize.SUBTITLE)
        .fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
      Select(this.options)
        .selected(id - 1)
        .value(`${getConstellationById(id).name}`)
        .fontColor(Colors.TEXT_PRIMARY)
        .selectedOptionFontColor(Colors.ACCENT_GOLD)
        .backgroundColor(Colors.BG_CARD)
        .borderRadius(BorderRadius.BUTTON)
        .onSelect((index: number) => {
          if (isMine) {
            this.myId = index + 1;
          } else {
            this.taId = index + 1;
          }
        })
    }
    .layoutWeight(1)
  }

  build() {
    Column() {
      Text('星座配对测试')
        .fontSize(FontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
        .margin({ top: 24, bottom: 8 })
      Text('看看你和 TA 的缘分指数')
        .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)

      Row() {
        this.pickColumn('我的星座', this.myId, true)
        Text('❤')
          .fontSize(40).fontColor(Colors.ACCENT_PINK)
          .scale({ x: this.heartScale, y: this.heartScale })
          .padding({ left: 8, right: 8 })
        this.pickColumn('TA 的星座', this.taId, false)
      }
      .width('100%').padding(20).margin({ top: 30 })
      .alignItems(VerticalAlign.Center)

      Blank()

      Button('开始测算 ✨')
        .width('80%').height(52)
        .fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.BG_PRIMARY).backgroundColor(Colors.ACCENT_GOLD)
        .borderRadius(BorderRadius.BUTTON)
        .margin({ bottom: 30 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/MatchResultPage', params: { id1: this.myId, id2: this.taId } });
        })

      BottomTabBar({ currentIndex: 2 })
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.Top])
  }
}
