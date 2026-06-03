import { router, promptAction } from '@kit.ArkUI';
import { pasteboard } from '@kit.BasicServicesKit';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { getConstellationById } from '../mock/ConstellationData';
import { getMatchResult } from '../mock/MatchData';
import { ConstellationInfo } from '../model/Constellation';
import { MatchResult } from '../model/MatchResult';
import { FortuneScoreBar } from '../components/FortuneScoreBar';

interface MatchParam {
  id1: number;
  id2: number;
}

@Entry
@Component
struct MatchResultPage {
  @State id1: number = 1;
  @State id2: number = 6;
  @State result: MatchResult = getMatchResult(1, 6);
  @State ringValue: number = 0;

  aboutToAppear(): void {
    const p = router.getParams() as MatchParam;
    if (p && p.id1 && p.id2) {
      this.id1 = p.id1;
      this.id2 = p.id2;
    }
    this.result = getMatchResult(this.id1, this.id2);
    const avg: number = Math.round((this.result.loveScore + this.result.friendScore + this.result.workScore) / 3);
    animateTo({ duration: 1200, curve: Curve.EaseOut }, () => {
      this.ringValue = avg;
    });
  }

  private shareResult(): void {
    const c1: ConstellationInfo = getConstellationById(this.id1);
    const c2: ConstellationInfo = getConstellationById(this.id2);
    const text: string =
      `【星语配对】${c1.name} × ${c2.name}\n综合匹配度 ${this.avg()}%\n${this.result.comment}`;
    const data: pasteboard.PasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    const board: pasteboard.SystemPasteboard = pasteboard.getSystemPasteboard();
    board.setData(data).then(() => {
      promptAction.showToast({ message: '配对文案已复制，快去分享吧～' });
    }).catch(() => {
      promptAction.showToast({ message: '分享文案已生成' });
    });
  }

  private avg(): number {
    return Math.round((this.result.loveScore + this.result.friendScore + this.result.workScore) / 3);
  }

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('配对结果').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Blank().width(50)
    }.width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  build() {
    Column() {
      this.topBar()
      Scroll() {
        Column({ space: 18 }) {
          // 两个星座 + 连接
          Row() {
            this.constellationBadge(this.id1)
            Column() {
              Text('✦ ✧ ✦').fontSize(16).fontColor(Colors.ACCENT_GOLD)
              Text('❤').fontSize(24).fontColor(Colors.ACCENT_PINK)
            }.layoutWeight(1)
            this.constellationBadge(this.id2)
          }
          .width('100%').padding({ left: 30, right: 30, top: 10 })
          .alignItems(VerticalAlign.Center)

          // 圆形匹配度
          Stack() {
            Progress({ value: this.ringValue, total: 100, type: ProgressType.Ring })
              .width(180).height(180)
              .color(Colors.ACCENT_PINK)
              .backgroundColor(Colors.BG_CARD2)
              .style({ strokeWidth: 14 })
            Column({ space: 2 }) {
              Text(`${this.avg()}`).fontSize(48).fontWeight(FontWeight.Bold).fontColor(Colors.ACCENT_GOLD)
              Text('综合匹配度').fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
            }
          }

          // 分项
          Column({ space: 14 }) {
            FortuneScoreBar({ label: '爱情', score: Math.round(this.result.loveScore / 20), barColor: Colors.ACCENT_PINK })
            FortuneScoreBar({ label: '友情', score: Math.round(this.result.friendScore / 20), barColor: Colors.ACCENT_TEAL })
            FortuneScoreBar({ label: '合作', score: Math.round(this.result.workScore / 20), barColor: Colors.ACCENT_GOLD })
          }
          .width('100%').padding(18).margin({ left: 16, right: 16 })
          .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)

          // 点评
          Column({ space: 8 }) {
            Text('缘分点评').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
              .fontColor(Colors.TEXT_PRIMARY).width('100%')
            Text(this.result.comment).fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY)
              .lineHeight(24).width('100%')
          }
          .width('100%').padding(18).margin({ left: 16, right: 16 })
          .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)

          Button('分享配对结果 ♡')
            .width('80%').height(48).fontColor(Colors.BG_PRIMARY)
            .backgroundColor(Colors.ACCENT_PINK).borderRadius(BorderRadius.BUTTON)
            .onClick(() => this.shareResult())

          Blank().height(24)
        }
      }.layoutWeight(1).scrollBar(BarState.Off).align(Alignment.Top)
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.Top])
  }

  @Builder
  constellationBadge(id: number) {
    Column({ space: 6 }) {
      Stack() {
        Circle().width(70).height(70).fill(getConstellationById(id).color).opacity(0.22)
        Text(getConstellationById(id).symbol).fontSize(38).fontColor(getConstellationById(id).color)
      }
      Text(getConstellationById(id).name).fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY)
    }
  }
}
