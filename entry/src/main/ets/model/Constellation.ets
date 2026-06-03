/**
 * 星座数据模型
 */

export interface RadarValue {
  charm: number;        // 魅力
  wisdom: number;       // 智慧
  courage: number;      // 勇气
  loyalty: number;      // 忠诚
  humor: number;        // 幽默
  sensitivity: number;  // 感性
}

export interface ConstellationInfo {
  id: number;          // 1-12
  name: string;        // "白羊座"
  nameEn: string;      // "Aries"
  symbol: string;      // "♈"
  dateRange: string;   // "3.21 - 4.19"
  element: string;     // "火"
  planet: string;      // "火星"
  color: string;       // 该星座主题色
  lucky: string[];     // 幸运色
  traits: string[];    // 性格关键词标签（3-5个）
  description: string;  // 详细描述
  loveView: string;    // 爱情观
  careerAdvice: string;// 职业建议
  celebrities: string[];// 代表名人
  radar: RadarValue;   // 雷达图数值 0-100
}
