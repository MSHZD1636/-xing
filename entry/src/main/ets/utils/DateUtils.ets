import { intl } from '@kit.LocalizationKit';

/**
 * 日期工具：根据生日判断星座、格式化日期等
 */

interface ConstellationBoundary {
  id: number;
  startMonth: number;
  startDay: number;
}

// 星座边界：每个星座的起始日期（按月日升序近似排列）
const BOUNDARIES: ConstellationBoundary[] = [
  { id: 10, startMonth: 1, startDay: 1 },    // 摩羯（延续上一年）
  { id: 11, startMonth: 1, startDay: 20 },   // 水瓶
  { id: 12, startMonth: 2, startDay: 19 },   // 双鱼
  { id: 1, startMonth: 3, startDay: 21 },    // 白羊
  { id: 2, startMonth: 4, startDay: 20 },    // 金牛
  { id: 3, startMonth: 5, startDay: 21 },    // 双子
  { id: 4, startMonth: 6, startDay: 22 },    // 巨蟹
  { id: 5, startMonth: 7, startDay: 23 },    // 狮子
  { id: 6, startMonth: 8, startDay: 23 },    // 处女
  { id: 7, startMonth: 9, startDay: 23 },    // 天秤
  { id: 8, startMonth: 10, startDay: 24 },   // 天蝎
  { id: 9, startMonth: 11, startDay: 23 },   // 射手
  { id: 10, startMonth: 12, startDay: 22 }   // 摩羯
];

export class DateUtils {
  /**
   * 根据月、日返回星座 id（1-12）
   */
  static getConstellationId(month: number, day: number): number {
    let result: number = 10; // 默认摩羯
    for (let i = 0; i < BOUNDARIES.length; i++) {
      const b: ConstellationBoundary = BOUNDARIES[i];
      if (month > b.startMonth || (month === b.startMonth && day >= b.startDay)) {
        result = b.id;
      }
    }
    return result;
  }

  /**
   * 格式化日期为 YYYY-MM-DD
   */
  static formatDate(date: Date): string {
    const y: number = date.getFullYear();
    const m: string = (date.getMonth() + 1).toString().padStart(2, '0');
    const d: string = date.getDate().toString().padStart(2, '0');
    return `${y}-${m}-${d}`;
  }

  /**
   * 使用 intl 进行本地化日期格式（如 "2026年6月3日 星期三"）
   */
  static formatLocalized(date: Date): string {
    try {
      const fmt: intl.DateTimeFormat = new intl.DateTimeFormat('zh-CN', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        weekday: 'long'
      });
      return fmt.format(date);
    } catch (e) {
      return DateUtils.formatDate(date);
    }
  }

  /**
   * 中文问候语
   */
  static greeting(date: Date): string {
    const h: number = date.getHours();
    if (h < 6) {
      return '夜深了，星辰守护着你';
    } else if (h < 11) {
      return '早安，今日宜追逐梦想';
    } else if (h < 14) {
      return '午安，记得为自己充电';
    } else if (h < 18) {
      return '下午好，灵感正在降临';
    } else {
      return '晚上好，仰望星空许个愿';
    }
  }

  /**
   * 该月的天数
   */
  static daysInMonth(year: number, month: number): number {
    return new Date(year, month, 0).getDate();
  }

  /**
   * 该月 1 号是星期几（0=周日）
   */
  static firstDayWeek(year: number, month: number): number {
    return new Date(year, month - 1, 1).getDay();
  }
}
