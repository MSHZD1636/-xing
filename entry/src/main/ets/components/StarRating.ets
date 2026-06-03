import { Colors } from '../utils/Constants';

/**
 * 星级评分组件：根据 1-5 分数显示金色星星
 */
@Component
export struct StarRating {
  @Prop score: number;        // 1-5
  @Prop starSize: number;     // 单颗星字号

  build() {
    Row({ space: 2 }) {
      ForEach([1, 2, 3, 4, 5], (i: number) => {
        Text(i <= this.score ? '★' : '☆')
          .fontSize(this.starSize > 0 ? this.starSize : 16)
          .fontColor(i <= this.score ? Colors.ACCENT_GOLD : Colors.TEXT_HINT)
      }, (i: number) => i.toString())
    }
  }
}
