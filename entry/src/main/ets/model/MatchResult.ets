/**
 * 配对结果数据模型
 */
export interface MatchResult {
  constellation1: number;  // 星座1 id
  constellation2: number;  // 星座2 id
  loveScore: number;       // 爱情配对 0-100
  friendScore: number;     // 友情配对 0-100
  workScore: number;       // 工作配对 0-100
  comment: string;         // 配对点评
}
