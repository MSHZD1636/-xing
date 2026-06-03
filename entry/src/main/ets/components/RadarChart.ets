import { RadarValue } from '../model/Constellation';
import { Colors } from '../utils/Constants';

/**
 * 雷达图 Canvas 组件：绘制 魅力/智慧/勇气/忠诚/幽默/感性 六维属性
 */
@Component
export struct RadarChart {
  @Prop data: RadarValue;
  @Prop accent: string;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private readonly labels: string[] = ['魅力', '智慧', '勇气', '忠诚', '幽默', '感性'];

  private draw(): void {
    const ctx: CanvasRenderingContext2D = this.ctx;
    const w: number = ctx.width;
    const h: number = ctx.height;
    const cx: number = w / 2;
    const cy: number = h / 2;
    const radius: number = Math.min(w, h) / 2 - 34;
    const sides: number = 6;
    const values: number[] = [
      this.data.charm, this.data.wisdom, this.data.courage,
      this.data.loyalty, this.data.humor, this.data.sensitivity
    ];

    ctx.clearRect(0, 0, w, h);

    // 同心网格（4 层）
    ctx.strokeStyle = Colors.DIVIDER;
    ctx.lineWidth = 1;
    for (let layer = 1; layer <= 4; layer++) {
      const r: number = (radius * layer) / 4;
      ctx.beginPath();
      for (let i = 0; i <= sides; i++) {
        const angle: number = (Math.PI * 2 * i) / sides - Math.PI / 2;
        const x: number = cx + r * Math.cos(angle);
        const y: number = cy + r * Math.sin(angle);
        if (i === 0) {
          ctx.moveTo(x, y);
        } else {
          ctx.lineTo(x, y);
        }
      }
      ctx.stroke();
    }

    // 轴线 + 标签
    ctx.fillStyle = Colors.TEXT_SECONDARY;
    ctx.font = '12px sans-serif';
    for (let i = 0; i < sides; i++) {
      const angle: number = (Math.PI * 2 * i) / sides - Math.PI / 2;
      const x: number = cx + radius * Math.cos(angle);
      const y: number = cy + radius * Math.sin(angle);
      ctx.beginPath();
      ctx.moveTo(cx, cy);
      ctx.lineTo(x, y);
      ctx.stroke();
      const lx: number = cx + (radius + 16) * Math.cos(angle);
      const ly: number = cy + (radius + 16) * Math.sin(angle);
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(this.labels[i], lx, ly);
    }

    // 数据多边形
    ctx.beginPath();
    for (let i = 0; i < sides; i++) {
      const ratio: number = Math.max(0, Math.min(100, values[i])) / 100;
      const angle: number = (Math.PI * 2 * i) / sides - Math.PI / 2;
      const r: number = radius * ratio;
      const x: number = cx + r * Math.cos(angle);
      const y: number = cy + r * Math.sin(angle);
      if (i === 0) {
        ctx.moveTo(x, y);
      } else {
        ctx.lineTo(x, y);
      }
    }
    ctx.closePath();
    ctx.globalAlpha = 0.35;
    ctx.fillStyle = this.accent;
    ctx.fill();
    ctx.globalAlpha = 1;
    ctx.strokeStyle = this.accent;
    ctx.lineWidth = 2;
    ctx.stroke();

    // 顶点圆点
    ctx.fillStyle = Colors.ACCENT_GOLD;
    for (let i = 0; i < sides; i++) {
      const ratio: number = Math.max(0, Math.min(100, values[i])) / 100;
      const angle: number = (Math.PI * 2 * i) / sides - Math.PI / 2;
      const r: number = radius * ratio;
      const x: number = cx + r * Math.cos(angle);
      const y: number = cy + r * Math.sin(angle);
      ctx.beginPath();
      ctx.arc(x, y, 3, 0, Math.PI * 2);
      ctx.fill();
    }
  }

  build() {
    Canvas(this.ctx)
      .width('100%')
      .height(240)
      .onReady(() => {
        this.draw();
      })
  }
}
