import { getFortune } from './FortuneData';
import { DailyFortune } from '../model/Fortune';
import { DateUtils } from '../utils/DateUtils';

/**
 * 日历运势 Mock 数据
 * 复用 FortuneData 的确定性算法，为某月每一天生成指定星座的运势等级。
 */

export interface CalendarCell {
  day: number;        // 日期数字，0 表示占位空格
  dateStr: string;    // YYYY-MM-DD
  level: number;      // 1-5 运势等级
  isToday: boolean;
}

/**
 * 生成某年某月的日历格子（含前置空格对齐星期）
 */
export function buildMonthCells(year: number, month: number, constellationId: number): CalendarCell[] {
  const cells: CalendarCell[] = [];
  const firstWeek: number = DateUtils.firstDayWeek(year, month);
  const days: number = DateUtils.daysInMonth(year, month);
  const todayStr: string = DateUtils.formatDate(new Date());

  // 前置空格
  for (let i = 0; i < firstWeek; i++) {
    cells.push({ day: 0, dateStr: '', level: 0, isToday: false });
  }
  // 实际日期
  for (let d = 1; d <= days; d++) {
    const ds: string = `${year}-${month.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}`;
    const f: DailyFortune = getFortune(constellationId, ds);
    cells.push({
      day: d,
      dateStr: ds,
      level: f.overall,
      isToday: ds === todayStr
    });
  }
  return cells;
}
