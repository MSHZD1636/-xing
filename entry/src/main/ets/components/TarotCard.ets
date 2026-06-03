import { TarotCardInfo } from '../model/TarotCard';
import { Colors, BorderRadius, FontSize } from '../utils/Constants';

/**
 * 塔罗牌翻转动画组件
 * 使用 animateTo 控制 rotateY 0 → 180deg，配合 Stack 正反面切换。
 * locked = true 时直接展示正面（当日已抽取）。
 */
@Component
export struct TarotCard {
  @Prop card: TarotCardInfo;
  @Prop locked: boolean;
  @State angle: number = 0;
  @State revealed: boolean = false;
  onRevealed?: () => void;

  aboutToAppear(): void {
    if (this.locked) {
      this.angle = 180;
      this.revealed = true;
    }
  }

  private flip(): void {
    if (this.revealed) {
      return;
    }
    animateTo({
      duration: 700,
      curve: Curve.EaseInOut,
      onFinish: () => {
        this.revealed = true;
        if (this.onRevealed) {
          this.onRevealed();
        }
      }
    }, () => {
      this.angle = 180;
    });
  }

  @Builder
  backFace() {
    Column({ space: 10 }) {
      Text('✦')
        .fontSize(40)
        .fontColor(Colors.ACCENT_GOLD)
      Text('点击翻牌')
        .fontSize(FontSize.BODY)
        .fontColor(Colors.TEXT_SECONDARY)
      Text('占卜今日命运')
        .fontSize(FontSize.CAPTION)
        .fontColor(Colors.TEXT_HINT)
    }
    .width(200)
    .height(340)
    .justifyContent(FlexAlign.Center)
    .borderRadius(BorderRadius.CARD)
    .border({ width: 2, color: Colors.ACCENT_TEAL })
    .linearGradient({
      angle: 135,
      colors: [['#241540', 0.0], ['#0D0821', 0.6], ['#163A4A', 1.0]]
    })
  }

  @Builder
  frontFace() {
    Stack() {
      if (this.card.image) {
        // 真实牌面图片
        Image(this.card.image!)
          .width(200)
          .height(340)
          .objectFit(ImageFit.Cover)
          .borderRadius(BorderRadius.CARD)
      } else {
        // 纯代码占位牌面
        Column({ space: 12 }) {
          Text(this.card.roman)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(Colors.TEXT_PRIMARY)
          Text('🔮')
            .fontSize(60)
          Text(this.card.name)
            .fontSize(FontSize.SUBTITLE)
            .fontWeight(FontWeight.Bold)
            .fontColor(Colors.TEXT_PRIMARY)
          Text(this.card.nameEn)
            .fontSize(FontSize.CAPTION)
            .fontColor(Colors.TEXT_SECONDARY)
        }
        .width(200)
        .height(340)
        .justifyContent(FlexAlign.Center)
        .linearGradient({
          angle: 160,
          colors: [[this.card.color, 0.0], ['#1C1033', 0.55], ['#0D0821', 1.0]]
        })
      }
    }
    .width(200)
    .height(340)
    .borderRadius(BorderRadius.CARD)
    .border({ width: 2, color: this.card.color })
    .clip(true)
    // 正面在翻转后需再翻 180° 以修正镜像
    .rotate({ x: 0, y: 1, z: 0, angle: 180, centerX: '50%', centerY: '50%' })
  }

  build() {
    Stack() {
      if (this.angle < 90) {
        this.backFace();
      } else {
        this.frontFace();
      }
    }
    .rotate({ x: 0, y: 1, z: 0, angle: this.angle, centerX: '50%', centerY: '50%' })
    .onClick(() => this.flip())
  }
}
