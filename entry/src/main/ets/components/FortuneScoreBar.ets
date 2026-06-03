import { Colors, FontSize } from '../utils/Constants';

/**
 * 运势评分进度条组件：标签 + 进度条 + 星级数字
 * score 取 1-5，内部换算为百分比
 */
@Component
export struct FortuneScoreBar {
  @Prop label: string;
  @Prop score: number;        // 1-5
  @Prop barColor: string;

  private percent(): number {
    return (this.score / 5) * 100;
  }

  build() {
    Row({ space: 10 }) {
      Text(this.label)
        .fontSize(FontSize.BODY)
        .fontColor(Colors.TEXT_SECONDARY)
        .width(48)

      Stack({ alignContent: Alignment.Start }) {
        // 背景轨
        Row()
          .width('100%')
          .height(8)
          .borderRadius(4)
          .backgroundColor(Colors.BG_CARD2)
        // 前景进度
        Row()
          .width(`${this.percent()}%`)
          .height(8)
          .borderRadius(4)
          .backgroundColor(this.barColor)
      }
      .layoutWeight(1)

      Text(`${this.score}.0`)
        .fontSize(FontSize.CAPTION)
        .fontColor(Colors.ACCENT_GOLD)
        .width(30)
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }
}
