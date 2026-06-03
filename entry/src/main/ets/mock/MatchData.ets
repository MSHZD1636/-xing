import { MatchResult } from '../model/MatchResult';
import { getConstellationById } from './ConstellationData';
import { ConstellationInfo } from '../model/Constellation';

/**
 * 配对 Mock 数据
 * 查表逻辑：以 min(id1,id2)*100 + max(id1,id2) 作为 key，结合元素相性确定性生成。
 */

// 元素相性加权：同元素及互补元素更高
function elementBonus(e1: string, e2: string): number {
  if (e1 === e2) {
    return 25; // 同元素，理解深
  }
  // 火风相生、水土相融
  const harmony: boolean =
    (e1 === '火' && e2 === '风') || (e1 === '风' && e2 === '火') ||
    (e1 === '水' && e2 === '土') || (e1 === '土' && e2 === '水');
  if (harmony) {
    return 20;
  }
  // 火水、土风等相对冲突
  return 5;
}

const COMMENTS_HIGH: string[] = [
  '天生一对！你们的磁场高度契合，彼此欣赏又能共同成长，是令人羡慕的灵魂伴侣。',
  '默契满分的组合，一个眼神就能读懂对方。携手前行，你们能创造属于自己的星辰大海。',
  '互补又和谐，你们像拼图般完美贴合。珍惜这份难得的缘分，未来可期。'
];
const COMMENTS_MID: string[] = [
  '潜力股组合！虽偶有摩擦，但只要多一些沟通与包容，就能把差异变成成长的养分。',
  '需要磨合的搭档，你们各有坚持。学会换位思考，关系会越来越稳固。',
  '不温不火却也踏实，平淡中见真情。给彼此多一点耐心，感情会慢慢升温。'
];
const COMMENTS_LOW: string[] = [
  '差异较大的组合，思维方式截然不同。这既是挑战也是新鲜感，关键在于是否愿意为对方改变。',
  '相处需要更多智慧，你们的节奏并不同步。坦诚沟通、互相尊重，才能跨越分歧。',
  '看似不搭却也可能擦出火花，前提是双方都珍惜并主动经营这段关系。'
];

function hashKey(id1: number, id2: number, salt: number): number {
  const lo: number = Math.min(id1, id2);
  const hi: number = Math.max(id1, id2);
  return Math.abs((lo * 100 + hi) * (salt + 7));
}

function clampScore(v: number): number {
  return Math.max(45, Math.min(99, v));
}

export function getMatchResult(id1: number, id2: number): MatchResult {
  const c1: ConstellationInfo = getConstellationById(id1);
  const c2: ConstellationInfo = getConstellationById(id2);
  const bonus: number = elementBonus(c1.element, c2.element);
  const same: boolean = id1 === id2;

  const love: number = clampScore((hashKey(id1, id2, 1) % 40) + 50 + bonus - (same ? 5 : 0));
  const friend: number = clampScore((hashKey(id1, id2, 2) % 40) + 50 + bonus);
  const work: number = clampScore((hashKey(id1, id2, 3) % 40) + 48 + bonus);
  const avg: number = (love + friend + work) / 3;

  let comment: string;
  const idx: number = hashKey(id1, id2, 4) % 3;
  if (avg >= 80) {
    comment = COMMENTS_HIGH[idx];
  } else if (avg >= 65) {
    comment = COMMENTS_MID[idx];
  } else {
    comment = COMMENTS_LOW[idx];
  }

  return {
    constellation1: id1,
    constellation2: id2,
    loveScore: love,
    friendScore: friend,
    workScore: work,
    comment: comment
  };
}
