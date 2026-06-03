/**
 * 每日运势数据模型
 */
export interface DailyFortune {
  constellationId: number;
  date: string;         // "2025-04-15"
  overall: number;      // 总运势 1-5
  love: number;         // 爱情运 1-5
  career: number;       // 事业运 1-5
  wealth: number;       // 财运 1-5
  health: number;       // 健康运 1-5
  summary: string;      // 一句话总结
  detail: string;       // 详细描述
  luckyColor: string;
  luckyNumber: number;
  luckyDirection: string;
}
