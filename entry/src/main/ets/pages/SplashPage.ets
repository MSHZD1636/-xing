import { router, animator, AnimatorResult } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Colors, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { StorageUtils } from '../utils/StorageUtils';

interface Particle {
  x: number;
  y: number;
  r: number;
  phase: number;
  speed: number;
}

@Entry
@Component
struct SplashPage {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private particles: Particle[] = [];
  private anim: AnimatorResult | null = null;
  @State logoOpacity: number = 0;
  @State logoScale: number = 0.7;

  aboutToAppear(): void {
    // 初始化本地存储
    const ctx = getContext(this) as common.UIAbilityContext;
    StorageUtils.init(ctx).catch((e: Error) => {
      hilog.error(0x0001, 'Splash', 'storage init failed: %{public}s', e.message);
    });

    // 生成粒子
    for (let i = 0; i < 60; i++) {
      this.particles.push({
        x: Math.random(),
        y: Math.random(),
        r: Math.random() * 1.8 + 0.5,
        phase: Math.random() * Math.PI * 2,
        speed: Math.random() * 0.04 + 0.01
      });
    }

    // Logo 渐入
    animateTo({ duration: 1000, curve: Curve.EaseOut }, () => {
      this.logoOpacity = 1;
      this.logoScale = 1;
    });

    // 2 秒后跳转首页
    setTimeout(() => {
      router.replaceUrl({ url: 'pages/HomePage' }).catch((e: Error) => {
        hilog.error(0x0001, 'Splash', 'jump failed: %{public}s', e.message);
      });
    }, 2200);
  }

  aboutToDisappear(): void {
    if (this.anim) {
      this.anim.cancel();
    }
  }

  private startParticles(): void {
    this.anim = animator.create({
      duration: 3000,
      easing: 'linear',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: -1,
      begin: 0,
      end: 1
    });
    this.anim.onFrame = (value: number) => {
      this.drawParticles(value);
    };
    this.anim.play();
  }

  private drawParticles(t: number): void {
    const ctx: CanvasRenderingContext2D = this.ctx;
    const w: number = ctx.width;
    const h: number = ctx.height;
    ctx.clearRect(0, 0, w, h);
    for (let i = 0; i < this.particles.length; i++) {
      const p: Particle = this.particles[i];
      const twinkle: number = (Math.sin(p.phase + t * Math.PI * 2) + 1) / 2;
      ctx.globalAlpha = 0.2 + twinkle * 0.8;
      ctx.fillStyle = i % 3 === 0 ? Colors.ACCENT_GOLD : '#FFFFFF';
      ctx.beginPath();
      ctx.arc(p.x * w, p.y * h, p.r * (0.6 + twinkle * 0.6), 0, Math.PI * 2);
      ctx.fill();
    }
    ctx.globalAlpha = 1;
  }

  build() {
    Stack() {
      // 星空渐变背景
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })

      // 粒子层
      Canvas(this.ctx)
        .width('100%')
        .height('100%')
        .onReady(() => this.startParticles())

      // Logo + 名称
      Column({ space: 14 }) {
        Text('✦')
          .fontSize(72)
          .fontColor(Colors.ACCENT_GOLD)
        Text('星语')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .fontColor(Colors.TEXT_PRIMARY)
        Text('StarWhisper')
          .fontSize(16)
          .fontColor(Colors.TEXT_SECONDARY)
          .letterSpacing(3)
        Text('每日一语，星辰指引')
          .fontSize(14)
          .fontColor(Colors.ACCENT_PURPLE)
          .margin({ top: 6 })
      }
      .opacity(this.logoOpacity)
      .scale({ x: this.logoScale, y: this.logoScale })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
  }
}
