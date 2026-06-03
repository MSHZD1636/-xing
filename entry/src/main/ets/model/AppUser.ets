/**
 * 应用用户与聊天数据模型
 */
export interface AppUser {
  id: number;
  name: string;
  constellationId: number;  // 1-12
  age: number;
  emoji: string;            // 头像占位 emoji
  color: string;            // 头像底色
  bio: string;              // 个性签名
}

export interface ChatMessage {
  fromMe: boolean;          // true=我方，false=对方
  text: string;
  time: string;             // HH:mm
}
