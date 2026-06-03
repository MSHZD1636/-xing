import { ConstellationInfo } from '../model/Constellation';
import { Colors, FontSize, BorderRadius } from '../utils/Constants';

/**
 * 星座卡片组件：用于图鉴网格、生日查询结果等
 */
@Component
export struct ConstellationCard {
  @Prop info: ConstellationInfo;
  onCardClick?: (id: number) => void;

  build() {
    Column({ space: 6 }) {
      // 符号圆形徽章
      Stack() {
        Circle()
          .width(54)
          .height(54)
          .fill(this.info.color)
          .opacity(0.22)
        Text(this.info.symbol)
          .fontSize(28)
          .fontColor(this.info.color)
      }

      Text(this.info.name)
        .fontSize(FontSize.BODY)
        .fontColor(Colors.TEXT_PRIMARY)
        .fontWeight(FontWeight.Medium)

      Text(this.info.dateRange)
        .fontSize(FontSize.CAPTION)
        .fontColor(Colors.TEXT_SECONDARY)
    }
    .width('100%')
    .padding(14)
    .borderRadius(BorderRadius.CARD)
    .backgroundColor(Colors.BG_CARD)
    .border({ width: 1, color: Colors.DIVIDER })
    .onClick(() => {
      if (this.onCardClick) {
        this.onCardClick(this.info.id);
      }
    })
  }
}
