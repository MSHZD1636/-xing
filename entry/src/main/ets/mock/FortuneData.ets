import { DailyFortune } from '../model/Fortune';
import { getConstellationById } from './ConstellationData';
import { ConstellationInfo } from '../model/Constellation';

/**
 * 运势 Mock 数据
 * 说明：以 (星座id + 年 + 月 + 日) 作为种子，确定性地生成当日运势，
 * 保证同一星座同一天结果一致，同时覆盖任意日期。
 */

// 7 组预设一句话总结
const SUMMARIES: string[] = [
  '万事顺遂，是闪闪发光的一天',
  '小有波折，保持耐心终见曙光',
  '贵人相助，把握机会大胆前行',
  '宜静不宜动，沉淀自我蓄力待发',
  '桃花朵朵，人际关系格外融洽',
  '财气渐旺，但需理性消费不冲动',
  '灵感爆发，创意与好运双双降临'
];

// 7 组详细描述
const DETAILS: string[] = [
  '今天的你能量满格，无论工作还是生活都得心应手。主动出击会带来意想不到的收获，不妨大胆表达自己的想法，星辰正站在你这一边。',
  '前进的路上可能遇到些许阻碍，但这只是黎明前的考验。放慢脚步、调整心态，把困难拆解成小步骤，傍晚时分运势将明显回升。',
  '今日适合社交与合作，一位重要的人会在关键时刻拉你一把。保持开放与真诚，主动联络久未谋面的朋友，机会往往藏在交谈之中。',
  '内心略显疲惫，是时候给自己放个假。减少不必要的应酬，把精力用在真正重要的事上。独处与思考会让你找回方向感。',
  '魅力值飙升的一天，走到哪里都备受欢迎。单身者有机会邂逅心动对象，有伴侣的感情升温，主动制造浪漫会有惊喜。',
  '财运稳步上升，可能有意外的小进账。不过冲动消费的欲望也会增强，记得分清「想要」与「需要」，理性规划才能积少成多。',
  '脑海中灵光不断，特别适合处理需要创意的任务。把握住这股灵感的浪潮，记录下每一个闪现的念头，它们将成为未来的财富。'
];

const COLORS: string[] = ['星光金', '梦幻紫', '海洋蓝', '樱花粉', '森林绿', '珊瑚橙', '月光白'];
const DIRECTIONS: string[] = ['正东', '东南', '正南', '西南', '正西', '西北', '正北'];

function hashSeed(constellationId: number, dateStr: string): number {
  let sum: number = constellationId * 31;
  for (let i = 0; i < dateStr.length; i++) {
    sum += dateStr.charCodeAt(i) * (i + 1);
  }
  return Math.abs(sum);
}

// 1-5 评分，避免全部偏低
function scoreFrom(seed: number, salt: number): number {
  return ((seed * (salt + 3)) % 5) + 1;
}

/**
 * 综合运势评分：分布到 2~5 星，避免大量集中在 3 星，使各星座呈现多样性。
 * 用与单项评分不同的取模方式打散，得到约 2:3:4:5 = 1:2:2:1 的比例。
 */
function overallScore(seed: number): number {
  const v: number = Math.floor(seed / 7) % 6;
  if (v <= 0) {
    return 2;
  } else if (v <= 2) {
    return 3;
  } else if (v <= 4) {
    return 4;
  } else {
    return 5;
  }
}

export function getFortune(constellationId: number, dateStr: string): DailyFortune {
  const seed: number = hashSeed(constellationId, dateStr);
  const info: ConstellationInfo = getConstellationById(constellationId);
  const overall: number = overallScore(seed);
  return {
    constellationId: constellationId,
    date: dateStr,
    overall: overall,
    love: scoreFrom(seed, 4),
    career: scoreFrom(seed, 5),
    wealth: scoreFrom(seed, 6),
    health: scoreFrom(seed, 7),
    summary: SUMMARIES[seed % SUMMARIES.length],
    detail: `${info.name}，${DETAILS[seed % DETAILS.length]}`,
    luckyColor: COLORS[seed % COLORS.length],
    luckyNumber: (seed % 9) + 1,
    luckyDirection: DIRECTIONS[seed % DIRECTIONS.length]
  };
}

/**
 * 获取全部 12 星座某日运势，按总分降序
 */
export function getAllFortunesSorted(dateStr: string): DailyFortune[] {
  const list: DailyFortune[] = [];
  for (let id = 1; id <= 12; id++) {
    list.push(getFortune(id, dateStr));
  }
  list.sort((a, b) => b.overall - a.overall);
  return list;
}

/**
 * 今日幸运星座（总分最高者）
 */
export function getLuckyConstellationId(dateStr: string): number {
  const sorted: DailyFortune[] = getAllFortunesSorted(dateStr);
  return sorted[0].constellationId;
}
