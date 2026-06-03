import { router, promptAction } from '@kit.ArkUI';
import { pasteboard } from '@kit.BasicServicesKit';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { getTarotById } from '../mock/TarotData';
import { getConstellationById } from '../mock/ConstellationData';
import { TarotCardInfo } from '../model/TarotCard';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

interface CardParam {
  cardId: number;
}

@Entry
@Component
struct TarotDetailPage {
  @State cardId: number = 0;
  @State card: TarotCardInfo = getTarotById(0);
  @State myConstellation: string = '你的星座';

  aboutToAppear(): void {
    const p = router.getParams() as CardParam;
    if (p && p.cardId !== undefined) {
      this.cardId = p.cardId;
    }
    this.card = getTarotById(this.cardId);
    StorageUtils.getNumber(StoreKey.MY_CONSTELLATION, 0).then((id: number) => {
      if (id >= 1) {
        this.myConstellation = getConstellationById(id).name;
      }
    });
  }

  private shareCard(): void {
    const text: string = `【星语·每日塔罗】我抽到了「${this.card.name} ${this.card.nameEn}」\n${this.card.overall}`;
    const data: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    pasteboard.getSystemPasteboard().setData(data).then(() => {
      promptAction.showToast({ message: '解读已复制，去分享吧～' });
    }).catch(() => {
      promptAction.showToast({ message: '分享文案已生成' });
    });
  }

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('塔罗解读').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Blank().width(50)
    }.width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  @Builder
  bigCard() {
    Stack() {
      if (this.card.image) {
        Image(this.card.image!).width(200).height(320).objectFit(ImageFit.Cover).borderRadius(BorderRadius.CARD)
      } else {
        Column({ space: 12 }) {
          Text(this.card.roman).fontSize(28).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
          Text('🔮').fontSize(72)
          Text(this.card.name).fontSize(FontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
          Text(this.card.nameEn).fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY)
        }
        .width(200).height(320).justifyContent(FlexAlign.Center)
        .linearGradient({ angle: 160, colors: [[this.card.color, 0.0], ['#1C1033', 0.55], ['#0D0821', 1.0]] })
      }
    }
    .width(200).height(320).clip(true)
    .borderRadius(BorderRadius.CARD).border({ width: 2, color: this.card.color })
  }

  @Builder
  section(title: string, body: string, accent: string) {
    Column({ space: 8 }) {
      Row({ space: 6 }) {
        Row().width(4).height(16).borderRadius(2).backgroundColor(accent)
        Text(title).fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
      }.width('100%')
      Text(body).fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY).lineHeight(24).width('100%')
    }
    .width('100%').padding(18).margin({ bottom: 12 })
    .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD).alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      this.topBar()
      Scroll() {
        Column({ space: 4 }) {
          this.bigCard()
          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
            ForEach(this.card.keywords, (k: string) => {
              Text(`# ${k}`)
                .fontSize(FontSize.CAPTION).fontColor(Colors.ACCENT_TEAL)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .margin({ right: 8, top: 12 })
                .borderRadius(BorderRadius.TAG).backgroundColor(Colors.BG_CARD2)
            }, (k: string) => k)
          }.margin({ bottom: 16 })

          Text(`结合 ${this.myConstellation} 的专属解读`)
            .fontSize(FontSize.CAPTION).fontColor(Colors.ACCENT_GOLD).margin({ bottom: 12 })

          this.section('总体运势', this.card.overall, Colors.ACCENT_GOLD)
          this.section('爱情运势', this.card.love, Colors.ACCENT_PINK)
          this.section('事业运势', this.card.career, Colors.ACCENT_TEAL)

          Row({ space: 8 }) {
            Text('🌟').fontSize(20)
            Text(this.card.luckyTip).fontSize(FontSize.BODY).fontColor(Colors.ACCENT_GOLD).layoutWeight(1)
          }
          .width('100%').padding(16).borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD2)

          Button('再次分享 ♡')
            .width('80%').height(48).fontColor(Colors.BG_PRIMARY)
            .backgroundColor(Colors.ACCENT_TEAL).borderRadius(BorderRadius.BUTTON)
            .margin({ top: 18 })
            .onClick(() => this.shareCard())

          Blank().height(24)
        }.padding({ left: 16, right: 16, top: 10 })
      }.layoutWeight(1).scrollBar(BarState.Off).align(Alignment.Top)
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
