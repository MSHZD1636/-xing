import { animator, AnimatorResult } from '@kit.ArkUI';
import { TarotCardInfo } from '../model/TarotCard';
import { Colors, BorderRadius, FontSize } from '../utils/Constants';

/**
 * 塔罗牌翻转动画组件
 * 使用 @ohos.animator 控制 rotateY 0 → 180deg，配合 Stack 正反面切换。
 * locked = true 时直接展示正面（当日已抽取）。
 */
@Component
export struct TarotCard {
  @Prop card: TarotCardInfo;
  @Prop locked: boolean;
  @State angle: number = 0;
  @State revealed: boolean = false;
  onRevealed?: () => void;
  private anim: AnimatorResult | null = null;

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
    this.anim = animator.create({
      duration: 700,
      easing: 'ease-in-out',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: 1,
      begin: 0,
      end: 180
    });
    this.anim.onFrame = (value: number) => {
      this.angle = value;
    };
    this.anim.onFinish = () => {
      this.revealed = true;
      if (this.onRevealed) {
        this.onRevealed();
      }
    };
    this.anim.play();
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
    .borderRadius(BorderRadius.CARD)
    .border({ width: 2, color: this.card.color })
    .linearGradient({
      angle: 160,
      colors: [[this.card.color, 0.0], ['#1C1033', 0.55], ['#0D0821', 1.0]]
    })
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
