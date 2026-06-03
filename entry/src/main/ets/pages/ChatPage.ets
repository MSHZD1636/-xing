import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { AppUser, ChatMessage } from '../model/AppUser';
import { getUserById, randomReply } from '../mock/UserData';
import { getConstellationById } from '../mock/ConstellationData';
import { StorageUtils } from '../utils/StorageUtils';

interface UserParam {
  userId: number;
}

@Entry
@Component
struct ChatPage {
  @State userId: number = 1;
  @State user: AppUser = getUserById(1);
  @State messages: ChatMessage[] = [];
  @State input: string = '';
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    const p = router.getParams() as UserParam;
    if (p && p.userId) {
      this.userId = p.userId;
    }
    this.user = getUserById(this.userId);
    StorageUtils.getChat(this.userId).then((raw: string) => {
      let list: ChatMessage[] = [];
      try {
        list = JSON.parse(raw) as ChatMessage[];
      } catch (e) {
        list = [];
      }
      if (list.length === 0) {
        // 首次进入：对方先打招呼
        const greeting: string = `你好呀，我是${this.user.name} ${this.user.emoji}　很高兴和你匹配成功～`;
        list = [this.make(false, greeting)];
        StorageUtils.saveChat(this.userId, JSON.stringify(list));
      }
      this.messages = list;
      this.scrollToBottom();
    });
  }

  private now(): string {
    const d: Date = new Date();
    return `${d.getHours().toString().padStart(2, '0')}:${d.getMinutes().toString().padStart(2, '0')}`;
  }

  private make(fromMe: boolean, text: string): ChatMessage {
    return { fromMe: fromMe, text: text, time: this.now() };
  }

  private scrollToBottom(): void {
    setTimeout(() => this.scroller.scrollEdge(Edge.Bottom), 60);
  }

  private async persist(): Promise<void> {
    await StorageUtils.saveChat(this.userId, JSON.stringify(this.messages));
  }

  private send(): void {
    const text: string = this.input.trim();
    if (text.length === 0) {
      return;
    }
    this.messages = [...this.messages, this.make(true, text)];
    this.input = '';
    this.persist();
    this.scrollToBottom();
    // 模拟对方回复
    setTimeout(() => {
      this.messages = [...this.messages, this.make(false, randomReply())];
      this.persist();
      this.scrollToBottom();
    }, 900);
  }

  @Builder
  topBar() {
    Row({ space: 10 }) {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .onClick(() => router.back())
      Stack() {
        Circle().width(36).height(36).fill(this.user.color).opacity(0.3)
        Text(this.user.emoji).fontSize(18)
      }
      Column({ space: 2 }) {
        Text(this.user.name).fontSize(FontSize.BODY).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
        Text(`${getConstellationById(this.user.constellationId).name} · 在线`)
          .fontSize(10).fontColor(Colors.SUCCESS)
      }.alignItems(HorizontalAlign.Start).layoutWeight(1)
    }
    .width('100%').height(54).padding({ left: 12, right: 16 }).alignItems(VerticalAlign.Center)
    .backgroundColor(Colors.BG_CARD)
  }

  @Builder
  bubble(msg: ChatMessage) {
    Row() {
      if (msg.fromMe) {
        Blank().layoutWeight(1)
        Column({ space: 2 }) {
          Text(msg.text).fontSize(FontSize.BODY).fontColor(Colors.BG_PRIMARY)
            .padding(12).borderRadius({ topLeft: 14, topRight: 4, bottomLeft: 14, bottomRight: 14 })
            .backgroundColor(Colors.ACCENT_GOLD)
          Text(msg.time).fontSize(10).fontColor(Colors.TEXT_HINT)
        }.alignItems(HorizontalAlign.End).constraintSize({ maxWidth: '72%' })
      } else {
        Column({ space: 2 }) {
          Text(msg.text).fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY)
            .padding(12).borderRadius({ topLeft: 4, topRight: 14, bottomLeft: 14, bottomRight: 14 })
            .backgroundColor(Colors.BG_CARD2)
          Text(msg.time).fontSize(10).fontColor(Colors.TEXT_HINT)
        }.alignItems(HorizontalAlign.Start).constraintSize({ maxWidth: '72%' })
        Blank().layoutWeight(1)
      }
    }.width('100%').margin({ bottom: 12 })
  }

  build() {
    Column() {
      this.topBar()
      List({ space: 0, scroller: this.scroller }) {
        ForEach(this.messages, (msg: ChatMessage, index: number) => {
          ListItem() {
            this.bubble(msg)
          }
        }, (msg: ChatMessage, index: number) => `${index}`)
      }
      .layoutWeight(1).scrollBar(BarState.Off)
      .padding({ left: 16, right: 16, top: 12 })

      // 输入栏
      Row({ space: 10 }) {
        TextInput({ placeholder: '说点什么…', text: this.input })
          .placeholderColor(Colors.TEXT_HINT).fontColor(Colors.TEXT_PRIMARY)
          .backgroundColor(Colors.BG_CARD2).borderRadius(BorderRadius.BUTTON)
          .layoutWeight(1)
          .onChange((v: string) => this.input = v)
          .onSubmit(() => this.send())
        Button('发送')
          .height(44).fontColor(Colors.BG_PRIMARY).backgroundColor(Colors.ACCENT_GOLD)
          .borderRadius(BorderRadius.BUTTON)
          .onClick(() => this.send())
      }
      .width('100%').padding(12).backgroundColor(Colors.BG_CARD)
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
