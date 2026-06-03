import { ConstellationInfo } from '../model/Constellation';

/**
 * 十二星座静态数据
 */
export const CONSTELLATIONS: ConstellationInfo[] = [
  {
    id: 1, name: '白羊座', nameEn: 'Aries', symbol: '♈', dateRange: '3.21 - 4.19',
    element: '火', planet: '火星', color: '#FF6B6B',
    lucky: ['正红', '亮橙'], traits: ['热情', '冲劲', '直率', '勇敢'],
    description: '白羊座是十二星座的第一个星座，象征着新生与开端。他们充满活力、敢闯敢拼，喜欢站在最前线，是天生的领导者与冒险家。',
    loveView: '在爱情中主动而炽热，喜欢就会全力追求，讨厌拐弯抹角，需要伴侣同样坦诚直接。',
    careerAdvice: '适合开拓型、竞技型工作，如创业、销售、运动员、军人，能在压力中迸发斗志。',
    celebrities: ['Lady Gaga', '成龙', '罗伯特·唐尼'],
    radar: { charm: 78, wisdom: 70, courage: 95, loyalty: 72, humor: 80, sensitivity: 55 }
  },
  {
    id: 2, name: '金牛座', nameEn: 'Taurus', symbol: '♉', dateRange: '4.20 - 5.20',
    element: '土', planet: '金星', color: '#4ECDA0',
    lucky: ['翠绿', '大地棕'], traits: ['踏实', '稳重', '务实', '坚毅'],
    description: '金牛座务实稳健，热爱生活中的美好与安稳。他们重视物质安全感，做事有条不紊，是可靠的伙伴与坚定的执行者。',
    loveView: '慢热但专一，一旦认定便会长久守护，用实际行动而非甜言蜜语表达爱意。',
    careerAdvice: '适合金融、艺术、美食、园艺等需要耐心与审美的领域，稳扎稳打终有回报。',
    celebrities: ['奥黛丽·赫本', '王力宏', '大卫·贝克汉姆'],
    radar: { charm: 82, wisdom: 75, courage: 60, loyalty: 92, humor: 58, sensitivity: 70 }
  },
  {
    id: 3, name: '双子座', nameEn: 'Gemini', symbol: '♊', dateRange: '5.21 - 6.21',
    element: '风', planet: '水星', color: '#FFD93D',
    lucky: ['明黄', '天蓝'], traits: ['机智', '灵活', '健谈', '好奇'],
    description: '双子座聪慧灵动，思维敏捷，对世界充满好奇。他们能言善辩、社交广泛，永远在追逐新鲜事物与多元体验。',
    loveView: '需要精神共鸣与有趣灵魂，害怕一成不变，喜欢能不断给予新鲜感的伴侣。',
    careerAdvice: '适合媒体、传播、贸易、写作等需要沟通与多任务的工作，能快速适应变化。',
    celebrities: ['约翰尼·德普', '玛丽莲·梦露', '坎耶·维斯特'],
    radar: { charm: 80, wisdom: 90, courage: 65, loyalty: 60, humor: 92, sensitivity: 68 }
  },
  {
    id: 4, name: '巨蟹座', nameEn: 'Cancer', symbol: '♋', dateRange: '6.22 - 7.22',
    element: '水', planet: '月亮', color: '#6FA8FF',
    lucky: ['月白', '海蓝'], traits: ['温柔', '顾家', '敏感', '体贴'],
    description: '巨蟹座情感细腻、重视家庭，拥有强大的共情力与守护欲。他们外柔内刚，是温暖他人的港湾。',
    loveView: '渴望安全感与归属感，付出全心全意，希望与伴侣建立深厚而稳定的情感联结。',
    careerAdvice: '适合教育、医护、餐饮、心理咨询等关怀型职业，细腻与责任心是最大优势。',
    celebrities: ['汤姆·汉克斯', '黛安娜王妃', '林俊杰'],
    radar: { charm: 76, wisdom: 72, courage: 58, loyalty: 90, humor: 62, sensitivity: 95 }
  },
  {
    id: 5, name: '狮子座', nameEn: 'Leo', symbol: '♌', dateRange: '7.23 - 8.22',
    element: '火', planet: '太阳', color: '#FFA63D',
    lucky: ['金黄', '酒红'], traits: ['自信', '大方', '热情', '王者'],
    description: '狮子座天生具有王者风范，自信耀眼、慷慨大方。他们渴望被关注与认可，乐于成为人群中的焦点与领袖。',
    loveView: '在爱情中热烈而忠诚，喜欢被崇拜也愿意为对方付出，需要被欣赏与尊重。',
    careerAdvice: '适合管理、演艺、品牌、公关等舞台型工作，天生的领导魅力能感染团队。',
    celebrities: ['麦当娜', '巴拉克·奥巴马', '吴亦凡'],
    radar: { charm: 95, wisdom: 74, courage: 88, loyalty: 80, humor: 78, sensitivity: 60 }
  },
  {
    id: 6, name: '处女座', nameEn: 'Virgo', symbol: '♍', dateRange: '8.23 - 9.22',
    element: '土', planet: '水星', color: '#8FD14F',
    lucky: ['米白', '森绿'], traits: ['细致', '完美', '理性', '可靠'],
    description: '处女座追求完美、注重细节，拥有敏锐的洞察力与极强的分析能力。他们严于律己，是值得信赖的执行专家。',
    loveView: '理性而谨慎，关注细节中的体贴，用默默付出和无微不至的照顾表达爱。',
    careerAdvice: '适合科研、编辑、审计、医疗等需要精确与严谨的领域，细节决定成败。',
    celebrities: ['迈克尔·杰克逊', '碧昂丝', '基努·里维斯'],
    radar: { charm: 72, wisdom: 92, courage: 62, loyalty: 88, humor: 60, sensitivity: 80 }
  },
  {
    id: 7, name: '天秤座', nameEn: 'Libra', symbol: '♎', dateRange: '9.23 - 10.23',
    element: '风', planet: '金星', color: '#FF9EC4',
    lucky: ['粉蓝', '浅紫'], traits: ['优雅', '公正', '社交', '审美'],
    description: '天秤座优雅迷人、追求和谐，拥有出色的审美与社交天赋。他们重视公平与平衡，是天生的协调者与外交家。',
    loveView: '浪漫而注重氛围，渴望势均力敌的灵魂伴侣，难以忍受冲突与不和谐。',
    careerAdvice: '适合设计、外交、法律、艺术等需要审美与协调的工作，平衡之道是天赋。',
    celebrities: ['金·卡戴珊', '威尔·史密斯', '李宇春'],
    radar: { charm: 93, wisdom: 78, courage: 64, loyalty: 74, humor: 82, sensitivity: 76 }
  },
  {
    id: 8, name: '天蝎座', nameEn: 'Scorpio', symbol: '♏', dateRange: '10.24 - 11.22',
    element: '水', planet: '冥王星', color: '#B05CFF',
    lucky: ['暗紫', '墨黑'], traits: ['神秘', '深情', '洞察', '专注'],
    description: '天蝎座神秘深邃、意志坚定，拥有强大的洞察力与爆发力。他们爱憎分明、专注极致，是充满魅力的谜样存在。',
    loveView: '爱得深沉而专一，占有欲强，一旦投入便全情燃烧，需要绝对的信任与忠诚。',
    careerAdvice: '适合侦查、研究、心理、金融投资等需要深度与洞察的领域，专注成就卓越。',
    celebrities: ['比尔·盖茨', '莱昂纳多', '杨丞琳'],
    radar: { charm: 88, wisdom: 88, courage: 85, loyalty: 90, humor: 64, sensitivity: 90 }
  },
  {
    id: 9, name: '射手座', nameEn: 'Sagittarius', symbol: '♐', dateRange: '11.23 - 12.21',
    element: '火', planet: '木星', color: '#FF8A5C',
    lucky: ['宝蓝', '亮紫'], traits: ['自由', '乐观', '冒险', '豁达'],
    description: '射手座热爱自由、积极乐观，永远向往远方与未知。他们坦率豁达、充满哲思，是追逐理想的旅人与探险家。',
    loveView: '需要自由空间与共同成长，喜欢一起探索世界的伴侣，讨厌束缚与控制。',
    careerAdvice: '适合旅游、教育、出版、国际贸易等需要视野与探索精神的工作，世界是舞台。',
    celebrities: ['泰勒·斯威夫特', '布拉德·皮特', '周杰伦'],
    radar: { charm: 80, wisdom: 82, courage: 90, loyalty: 66, humor: 90, sensitivity: 58 }
  },
  {
    id: 10, name: '摩羯座', nameEn: 'Capricorn', symbol: '♑', dateRange: '12.22 - 1.19',
    element: '土', planet: '土星', color: '#7A8DA6',
    lucky: ['深灰', '墨绿'], traits: ['自律', '坚韧', '务实', '野心'],
    description: '摩羯座成熟稳重、目标明确，拥有超强的自律与耐力。他们脚踏实地、深谋远虑，是默默攀登人生高峰的实干家。',
    loveView: '含蓄而长情，把责任看得很重，认定后会以稳定与承诺给予伴侣最踏实的依靠。',
    careerAdvice: '适合管理、工程、政界、企业经营等需要规划与毅力的领域，时间是最好的盟友。',
    celebrities: ['马丁·路德·金', '甜茶', '吴尊'],
    radar: { charm: 70, wisdom: 86, courage: 78, loyalty: 92, humor: 56, sensitivity: 64 }
  },
  {
    id: 11, name: '水瓶座', nameEn: 'Aquarius', symbol: '♒', dateRange: '1.20 - 2.18',
    element: '风', planet: '天王星', color: '#5CD6FF',
    lucky: ['电光蓝', '银白'], traits: ['独立', '前卫', '理性', '博爱'],
    description: '水瓶座思想超前、特立独行，拥有独特的创造力与人文关怀。他们崇尚自由与平等，是引领潮流的革新者。',
    loveView: '需要精神契合与个人空间，看似疏离实则深情，欣赏独立而有思想的灵魂。',
    careerAdvice: '适合科技、创新、公益、设计等需要前瞻与创意的领域，与众不同就是力量。',
    celebrities: ['乔丹', '艾伦·德詹尼斯', '王菲'],
    radar: { charm: 78, wisdom: 94, courage: 72, loyalty: 70, humor: 86, sensitivity: 66 }
  },
  {
    id: 12, name: '双鱼座', nameEn: 'Pisces', symbol: '♓', dateRange: '2.19 - 3.20',
    element: '水', planet: '海王星', color: '#9B7BFF',
    lucky: ['梦幻紫', '海绿'], traits: ['浪漫', '共情', '艺术', '温柔'],
    description: '双鱼座感性浪漫、想象力丰富，拥有细腻的共情力与艺术天赋。他们温柔善良、富有同情心，是充满诗意的造梦者。',
    loveView: '为爱痴狂、全情投入，渴望童话般的浪漫，愿意为所爱的人无条件付出与包容。',
    careerAdvice: '适合艺术、音乐、影视、公益等需要想象与情感的领域，感性是创作的源泉。',
    celebrities: ['爱因斯坦', '蕾哈娜', '周迅'],
    radar: { charm: 86, wisdom: 80, courage: 56, loyalty: 82, humor: 74, sensitivity: 96 }
  }
];

/**
 * 根据 id 获取星座信息
 */
export function getConstellationById(id: number): ConstellationInfo {
  const found: ConstellationInfo | undefined = CONSTELLATIONS.find((c) => c.id === id);
  return found ?? CONSTELLATIONS[0];
}

/**
 * 元素 → 对应星座 id 列表
 */
export function getConstellationsByElement(element: string): ConstellationInfo[] {
  return CONSTELLATIONS.filter((c) => c.element === element);
}
