import { router } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Colors, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

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
  private timerId: number = -1;
  private jumpTimer: number = -1;
  private t: number = 0;
  private initialized: Promise<void> = Promise.resolve();
  @State logoOpacity: number = 0;
  @State logoScale: number = 0.7;

  aboutToAppear(): void {
    // 初始化本地存储
    const ctx = getContext(this) as common.UIAbilityContext;
    this.initialized = StorageUtils.init(ctx);
    this.initialized.catch((e: Error) => {
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

    // 2 秒后根据登录态跳转：已登录→首页，未登录→登录页
    this.jumpTimer = setTimeout(async () => {
      await this.initialized;
      const logged: boolean = await StorageUtils.getBool(StoreKey.LOGGED_IN, false);
      const dest: string = logged ? 'pages/HomePage' : 'pages/LoginPage';
      router.replaceUrl({ url: dest }).catch((e: Error) => {
        hilog.error(0x0001, 'Splash', 'jump failed: %{public}s', e.message);
      });
    }, 2200);
  }

  aboutToDisappear(): void {
    if (this.timerId >= 0) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
    if (this.jumpTimer >= 0) {
      clearTimeout(this.jumpTimer);
      this.jumpTimer = -1;
    }
  }

  private startParticles(): void {
    this.drawParticles(0);
    // 定时重绘实现星点闪烁（粒子动画）
    this.timerId = setInterval(() => {
      this.t += 0.03;
      if (this.t > 1) {
        this.t -= 1;
      }
      this.drawParticles(this.t);
    }, 50);
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
