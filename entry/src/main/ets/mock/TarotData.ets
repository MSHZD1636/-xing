import { TarotCardInfo } from '../model/TarotCard';

/**
 * 塔罗牌 Mock 数据（大阿卡那 22 张）
 * 每日抽签逻辑：(年 + 月 + 日) % 22 决定当日牌。
 */
export const TAROT_CARDS: TarotCardInfo[] = [
  {
    id: 0, name: '愚者', nameEn: 'The Fool', roman: '0', color: '#FFD93D',
    keywords: ['新开始', '冒险', '纯真'],
    overall: '一切皆有可能！宇宙鼓励你迈出那一步。放下顾虑，以赤子之心拥抱未知，旅途本身就是礼物。',
    love: '感情迎来全新篇章，单身者可能邂逅令人心动的对象，有伴者不妨尝试新鲜的相处方式。',
    career: '适合开启新项目或转换跑道，大胆尝试会带来惊喜，但记得做好基本规划再出发。',
    luckyTip: '今天就去做那件你一直想做却不敢做的小事吧。'
  },
  {
    id: 1, name: '魔术师', nameEn: 'The Magician', roman: 'I', color: '#FF6B6B',
    keywords: ['创造', '行动', '掌控'],
    overall: '你拥有实现目标的全部资源，关键在于专注与行动。把想法化为现实，此刻的你能量充沛。',
    love: '主动出击会有回报，真诚表达你的心意，魅力正处于高点。',
    career: '是展现才华的好时机，把握主动权，你的能力将被看见与认可。',
    luckyTip: '相信自己的能力，从一个明确的小目标开始执行。'
  },
  {
    id: 2, name: '女祭司', nameEn: 'The High Priestess', roman: 'II', color: '#5CD6FF',
    keywords: ['直觉', '神秘', '内省'],
    overall: '倾听内心的声音，答案早已在你心中。今天适合静思与感受，直觉将成为你最好的向导。',
    love: '感情中存在未说出口的情绪，给彼此一些理解的空间，用心去感受对方。',
    career: '不必急于做决定，收集更多信息、相信直觉，时机成熟自会明朗。',
    luckyTip: '留一段安静的独处时间，记录闪现的念头。'
  },
  {
    id: 3, name: '女皇', nameEn: 'The Empress', roman: 'III', color: '#FF9EC4',
    keywords: ['丰盛', '滋养', '美感'],
    overall: '丰盈与爱意环绕着你。今天适合享受生活之美，慷慨地给予也大方地接受，幸福正在生长。',
    love: '感情甜蜜而温暖，是表达关爱、经营浪漫的好日子。',
    career: '创意与合作带来收获，团队氛围融洽，付出终有回报。',
    luckyTip: '为自己或所爱之人准备一份小小的美好。'
  },
  {
    id: 4, name: '皇帝', nameEn: 'The Emperor', roman: 'IV', color: '#B05CFF',
    keywords: ['权威', '秩序', '稳固'],
    overall: '是时候建立秩序、掌控全局。以理性和纪律面对挑战，你的坚定将赢得尊重与成果。',
    love: '关系需要稳定与承诺，展现你的可靠会让感情更踏实。',
    career: '领导力凸显，制定清晰的计划并坚定执行，事业稳步上升。',
    luckyTip: '列一份清单，把混乱的事项重新梳理排序。'
  },
  {
    id: 5, name: '教皇', nameEn: 'The Hierophant', roman: 'V', color: '#FFA63D',
    keywords: ['传统', '智慧', '指引'],
    overall: '寻求经验与智慧的指引会让你受益。今天适合学习、请教前辈，传统的方法此刻最为可靠。',
    love: '感情趋向认真与稳定，或有长辈、朋友为你牵线、给予建议。',
    career: '遵循规则与流程会更顺利，向有经验的人请教能少走弯路。',
    luckyTip: '向你信任的人请教一个困扰已久的问题。'
  },
  {
    id: 6, name: '恋人', nameEn: 'The Lovers', roman: 'VI', color: '#FF6B9D',
    keywords: ['爱情', '选择', '和谐'],
    overall: '一段重要的关系或抉择来到面前。跟随内心真正的渴望，和谐与连接将带来幸福。',
    love: '桃花运极旺！感情进展顺利，是表白、约会、加深关系的吉日。',
    career: '合作伙伴关系融洽，重要的选择请遵从价值观与真心。',
    luckyTip: '对重要的人说出你藏在心里的那句话。'
  },
  {
    id: 7, name: '战车', nameEn: 'The Chariot', roman: 'VII', color: '#7A8DA6',
    keywords: ['胜利', '意志', '前进'],
    overall: '凭借坚定的意志与掌控力，你将冲破阻碍勇往直前。专注目标，胜利在向你招手。',
    love: '主动争取会有收获，但别太过强势，刚柔并济更动人。',
    career: '克服困难、达成目标的好时机，全力以赴必有突破。',
    luckyTip: '锁定一个目标，今天就推进它一大步。'
  },
  {
    id: 8, name: '力量', nameEn: 'Strength', roman: 'VIII', color: '#FFD93D',
    keywords: ['勇气', '耐心', '内在力量'],
    overall: '真正的力量源于温柔与坚持。以耐心和爱化解难题，你内在的勇气足以驯服一切。',
    love: '用包容与温柔经营感情，理解胜过争辩，关系会更加牢固。',
    career: '面对压力保持冷静，温和而坚定地处理冲突会赢得信任。',
    luckyTip: '深呼吸，用平和的心态面对今天的挑战。'
  },
  {
    id: 9, name: '隐士', nameEn: 'The Hermit', roman: 'IX', color: '#8FD14F',
    keywords: ['独处', '探索', '智慧'],
    overall: '退一步，向内寻找答案。独处与沉思会带来深刻的领悟，这是自我成长的珍贵时刻。',
    love: '需要一些个人空间来思考感情，不必勉强，沉淀后会更清晰。',
    career: '适合独立钻研与规划，远离喧嚣才能看清方向。',
    luckyTip: '给自己留白，独自散步或阅读片刻。'
  },
  {
    id: 10, name: '命运之轮', nameEn: 'Wheel of Fortune', roman: 'X', color: '#5CD6FF',
    keywords: ['转机', '机遇', '循环'],
    overall: '命运的齿轮正在转动，变化即将来临。顺势而为，把握机遇，好运正悄然降临。',
    love: '感情出现新的契机或转折，保持开放心态迎接变化。',
    career: '机遇之门打开，抓住转瞬即逝的机会，时来运转。',
    luckyTip: '对突如其来的机会说「好」，别让它溜走。'
  },
  {
    id: 11, name: '正义', nameEn: 'Justice', roman: 'XI', color: '#B05CFF',
    keywords: ['公正', '平衡', '责任'],
    overall: '以公正与理性面对一切，因果终将平衡。诚实地对待自己与他人，正确的选择带来安心。',
    love: '感情讲求对等与坦诚，公平的相处方式会让关系更健康。',
    career: '涉及合约、决策时务必谨慎公正，付出与回报将成正比。',
    luckyTip: '做决定前，权衡利弊并坚持原则。'
  },
  {
    id: 12, name: '倒吊人', nameEn: 'The Hanged Man', roman: 'XII', color: '#6FA8FF',
    keywords: ['换位', '等待', '放下'],
    overall: '换个角度看世界，暂时的停顿并非停滞。学会放下与等待，新的视角将带来顿悟。',
    love: '感情中不妨退一步，理解对方的立场，耐心会有回报。',
    career: '计划或有延迟，不必焦虑，转换思路反而柳暗花明。',
    luckyTip: '把一件烦心事先放一放，换个角度再看。'
  },
  {
    id: 13, name: '死神', nameEn: 'Death', roman: 'XIII', color: '#7A8DA6',
    keywords: ['结束', '蜕变', '重生'],
    overall: '旧的篇章落幕，新的篇章开启。勇敢告别不再适合的人事物，蜕变之后是更好的你。',
    love: '感情或迎来转折，结束与开始皆是成长，顺其自然。',
    career: '放下过时的方式，拥抱改变，转型将带来新生。',
    luckyTip: '清理一样不再需要的旧物，为新事物腾出空间。'
  },
  {
    id: 14, name: '节制', nameEn: 'Temperance', roman: 'XIV', color: '#4ECDA0',
    keywords: ['平衡', '调和', '耐心'],
    overall: '中庸之道带来和谐。调和对立、把握分寸，以平和的节奏前行，一切都会恰到好处。',
    love: '感情趋于平稳和谐，包容与折中让关系更融洽。',
    career: '合作与协调是关键，平衡各方需求会收获顺利。',
    luckyTip: '今天凡事留三分余地，不急不躁。'
  },
  {
    id: 15, name: '恶魔', nameEn: 'The Devil', roman: 'XV', color: '#B05CFF',
    keywords: ['欲望', '束缚', '觉察'],
    overall: '审视那些束缚你的执念与诱惑。觉察即是解脱的开始，你有力量挣脱无形的枷锁。',
    love: '小心被一时的激情或占有欲牵引，理智地看待这段关系。',
    career: '警惕短期利益的诱惑，别被物欲绑架了长远目标。',
    luckyTip: '诚实面对一个你一直回避的小习惯。'
  },
  {
    id: 16, name: '塔', nameEn: 'The Tower', roman: 'XVI', color: '#FF6B6B',
    keywords: ['突变', '打破', '重建'],
    overall: '突如其来的变动看似动荡，实则是破除旧有束缚的契机。在废墟之上，你将建起更坚固的城堡。',
    love: '感情可能经历震荡，坦诚面对问题，破而后立。',
    career: '计划或被打乱，保持冷静应变，危机中藏着转机。',
    luckyTip: '面对意外保持镇定，先稳住再重建。'
  },
  {
    id: 17, name: '星星', nameEn: 'The Star', roman: 'XVII', color: '#5CD6FF',
    keywords: ['希望', '疗愈', '指引'],
    overall: '希望的星光照亮前路。经历低谷后迎来疗愈与平静，怀抱信念，美好的事物正在靠近。',
    love: '感情温柔而充满希望，敞开心扉会收获治愈与温暖。',
    career: '前景明朗，坚持理想会逐步实现，灵感与好运相伴。',
    luckyTip: '对未来许一个愿望，并相信它会实现。'
  },
  {
    id: 18, name: '月亮', nameEn: 'The Moon', roman: 'XVIII', color: '#9B7BFF',
    keywords: ['幻象', '潜意识', '直觉'],
    overall: '迷雾之中真假难辨，倾听直觉但别被恐惧蒙蔽。耐心穿过朦胧，黎明终会到来。',
    love: '感情中或有误会与不确定，多沟通、少猜疑，看清真心。',
    career: '信息可能不够明朗，谨慎判断，别被表象迷惑。',
    luckyTip: '遇到模糊不清的事，先求证再下结论。',
    image: $r('app.media.tarot_moon')
  },
  {
    id: 19, name: '太阳', nameEn: 'The Sun', roman: 'XIX', color: '#FFA63D',
    keywords: ['光明', '成功', '喜悦'],
    overall: '阳光普照，喜悦满溢！这是充满活力与成功的一天，自信地展现自己，幸运为你加冕。',
    love: '感情甜蜜热烈，是收获幸福与快乐的吉日，尽情享受吧。',
    career: '事业光明顺遂，成果显著，你的努力将被看见与嘉奖。',
    luckyTip: '把你的好心情分享给身边的人。'
  },
  {
    id: 20, name: '审判', nameEn: 'Judgement', roman: 'XX', color: '#6FA8FF',
    keywords: ['觉醒', '抉择', '重生'],
    overall: '内心的召唤让你觉醒。回顾过往、宽恕自己，做出忠于内心的抉择，迎接焕然一新的自己。',
    love: '是修复关系或重新审视感情的好时机，倾听内心真实的声音。',
    career: '过往的努力迎来评判与回报，重要的抉择将开启新阶段。',
    luckyTip: '原谅一个过去的自己，轻装上阵。'
  },
  {
    id: 21, name: '世界', nameEn: 'The World', roman: 'XXI', color: '#4ECDA0',
    keywords: ['圆满', '成就', '完整'],
    overall: '一个阶段圆满落幕，你已抵达旅程的高峰。庆祝你的成就，带着满满收获迈向新的循环。',
    love: '感情达到和谐圆满的状态，彼此成就，幸福水到渠成。',
    career: '目标达成、梦想成真，你的努力赢得了完整的回报。',
    luckyTip: '为自己的努力庆祝，并感恩一路同行的人。'
  },
  // ---------- 权杖牌组（小阿卡那 · 新增，含真实牌面图片） ----------
  {
    id: 22, name: '权杖三', nameEn: 'Three of Wands', roman: 'W·III', color: '#FF8A5C',
    keywords: ['远见', '扩展', '机遇'],
    overall: '你已迈出第一步，正眺望远方的可能。机会即将到来，保持开阔的视野，勇敢拓展你的版图。',
    love: '感情进入新阶段，适合规划共同的未来，异地或远方的缘分值得期待。',
    career: '事业有扩张之势，合作与拓展带来回报，把眼光放长远会更有收获。',
    luckyTip: '今天试着把目标定得更远大一些。',
    image: $r('app.media.tarot_wands03')
  },
  {
    id: 23, name: '权杖王后', nameEn: 'Queen of Wands', roman: 'W·Q', color: '#FFC83D',
    keywords: ['自信', '热情', '魅力'],
    overall: '你散发着温暖而自信的光芒，像盛放的向日葵。做真实的自己，魅力会吸引一切美好靠近。',
    love: '魅力值满分，主动而真诚地表达自己，会收获热烈的回应。',
    career: '以热情与领导力感染他人，独立自主地推进，你能成为众人焦点。',
    luckyTip: '今天大胆展现你的个性与才华。',
    image: $r('app.media.tarot_wands_queen')
  },
  {
    id: 24, name: '权杖国王', nameEn: 'King of Wands', roman: 'W·K', color: '#FF7A33',
    keywords: ['领导', '远见', '魄力'],
    overall: '你拥有掌控全局的魄力与远见。以坚定的信念带领方向，敢想敢做，成功会向你靠拢。',
    love: '在关系中展现担当与决断，给对方稳稳的安全感。',
    career: '是开创与领导的好时机，制定愿景并果断执行，他人会追随你的脚步。',
    luckyTip: '相信自己的判断，做那个拍板的人。',
    image: $r('app.media.tarot_wands_king')
  }
];

/**
 * 根据日期计算当日塔罗牌 id（同一天结果固定，覆盖全部牌）
 */
export function getDailyTarotId(date: Date): number {
  const sum: number = date.getFullYear() + (date.getMonth() + 1) + date.getDate();
  return TAROT_CARDS[sum % TAROT_CARDS.length].id;
}

/**
 * 随机抽取一张塔罗牌 id（用于「再抽一张」）
 */
export function getRandomTarotId(): number {
  return TAROT_CARDS[Math.floor(Math.random() * TAROT_CARDS.length)].id;
}

export function getTarotById(id: number): TarotCardInfo {
  const found: TarotCardInfo | undefined = TAROT_CARDS.find((c) => c.id === id);
  return found ?? TAROT_CARDS[0];
}
