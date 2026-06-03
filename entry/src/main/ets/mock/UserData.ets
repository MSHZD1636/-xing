import { AppUser } from '../model/AppUser';

/**
 * 其他 App 用户 Mock 数据（用于用户间匹配与聊天）
 */
export const MOCK_USERS: AppUser[] = [
  { id: 1, name: '星河', constellationId: 5, age: 24, emoji: '🦁', color: '#FFA63D', bio: '狮子座 · 爱旅行爱阳光，寻找同频的你' },
  { id: 2, name: '小满', constellationId: 4, age: 22, emoji: '🌙', color: '#6FA8FF', bio: '巨蟹座 · 喜欢猫和深夜的电影' },
  { id: 3, name: '阿琉', constellationId: 8, age: 26, emoji: '🦂', color: '#B05CFF', bio: '天蝎座 · 神秘但很专一，慢热型' },
  { id: 4, name: '柚子', constellationId: 7, age: 23, emoji: '⚖️', color: '#FF9EC4', bio: '天秤座 · 颜控+和平主义，爱美食' },
  { id: 5, name: '林木', constellationId: 10, age: 27, emoji: '🐐', color: '#7A8DA6', bio: '摩羯座 · 工作狂但也想谈恋爱' },
  { id: 6, name: '可乐', constellationId: 3, age: 21, emoji: '✨', color: '#FFD93D', bio: '双子座 · 话痨一枚，永远好奇' },
  { id: 7, name: '安然', constellationId: 12, age: 25, emoji: '🐟', color: '#9B7BFF', bio: '双鱼座 · 浪漫主义者，喜欢写诗' },
  { id: 8, name: '北辰', constellationId: 9, age: 28, emoji: '🏹', color: '#FF8A5C', bio: '射手座 · 自由灵魂，说走就走' },
  { id: 9, name: '清越', constellationId: 11, age: 24, emoji: '🌊', color: '#5CD6FF', bio: '水瓶座 · 脑洞清奇，热爱科技' },
  { id: 10, name: '麦子', constellationId: 6, age: 23, emoji: '🌾', color: '#8FD14F', bio: '处女座 · 细节控，养了三只多肉' }
];

export function getUserById(id: number): AppUser {
  const found: AppUser | undefined = MOCK_USERS.find((u) => u.id === id);
  return found ?? MOCK_USERS[0];
}

// 对方的若干寒暄/回复语料（随机选取，模拟聊天）
export const AUTO_REPLIES: string[] = [
  '哈哈哈你也是星座爱好者吗？',
  '我们的匹配度好像还不错诶 😜',
  '最近运势怎么样？我今天抽到的塔罗是太阳牌～',
  '你平时喜欢做什么呀？',
  '感觉我们挺聊得来的！',
  '周末有什么安排吗？',
  '你是哪个星座的呀？我猜你很有趣',
  '哇，这么巧，我也喜欢！',
  '要不要交换一下今天的幸运色？',
  '和你聊天好开心 😊'
];

export function randomReply(): string {
  return AUTO_REPLIES[Math.floor(Math.random() * AUTO_REPLIES.length)];
}
