/**
 * 塔罗牌数据模型（大阿卡那 22 张）
 */
export interface TarotCardInfo {
  id: number;          // 卡牌唯一 id
  name: string;        // "愚者"
  nameEn: string;      // "The Fool"
  roman: string;       // 罗马数字编号 "0" / "I" ...
  color: string;       // 占位卡牌渐变主色
  keywords: string[];  // ["新开始", "冒险", "纯真"]
  overall: string;     // 总体解读
  love: string;        // 爱情解读
  career: string;      // 事业解读
  luckyTip: string;    // 幸运提示
  image?: Resource;    // 牌面图片（可选，存在时优先展示真实图片）
}
