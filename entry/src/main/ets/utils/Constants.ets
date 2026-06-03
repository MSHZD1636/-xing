/**
 * 全局常量：主题色彩、字号、圆角等样式规范
 */

export class Colors {
  static readonly BG_PRIMARY: string = '#0D0821';     // 主背景（深夜紫黑）
  static readonly BG_CARD: string = '#1C1033';        // 卡片背景
  static readonly BG_CARD2: string = '#241540';       // 次卡片背景
  static readonly ACCENT_GOLD: string = '#FFD700';    // 强调色（星光金）
  static readonly ACCENT_PURPLE: string = '#9B59B6';  // 次强调色（紫）
  static readonly ACCENT_PINK: string = '#FF6B9D';    // 爱情色（粉）
  static readonly ACCENT_TEAL: string = '#00CED1';    // 塔罗色（神秘青）
  static readonly TEXT_PRIMARY: string = '#FFFFFF';   // 主文字
  static readonly TEXT_SECONDARY: string = '#B0A8C8'; // 副文字（淡紫灰）
  static readonly TEXT_HINT: string = '#6B5F7A';      // 提示文字
  static readonly DIVIDER: string = '#2E1F4A';        // 分割线
  static readonly SUCCESS: string = '#4ECDA0';        // 高运势
  static readonly WARNING: string = '#FFB74D';        // 中运势
  static readonly DANGER: string = '#FF6B6B';         // 低运势
}

export class FontSize {
  static readonly TITLE: number = 24;
  static readonly SUBTITLE: number = 18;
  static readonly BODY: number = 14;
  static readonly CAPTION: number = 12;
}

export class BorderRadius {
  static readonly CARD: number = 16;
  static readonly BUTTON: number = 24;
  static readonly TAG: number = 8;
}

/**
 * 全局星空渐变色（无图片依赖），用于 .linearGradient({ angle: 160, colors: STARRY_COLORS })
 */
export const STARRY_COLORS: Array<[string, number]> = [
  ['#1A0A2E', 0.0],
  ['#0D0821', 0.5],
  ['#160A33', 1.0]
];

export const STARRY_ANGLE: number = 160;
