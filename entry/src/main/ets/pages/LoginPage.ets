import { router, promptAction } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

@Entry
@Component
struct LoginPage {
  @State phone: string = '';
  @State code: string = '';
  @State sentCode: string = '';
  @State countdown: number = 0;
  private timerId: number = -1;

  aboutToDisappear(): void {
    if (this.timerId >= 0) {
      clearInterval(this.timerId);
    }
  }

  private isPhoneValid(): boolean {
    return /^1\d{10}$/.test(this.phone);
  }

  private sendCode(): void {
    if (!this.isPhoneValid()) {
      promptAction.showToast({ message: '请输入正确的 11 位手机号' });
      return;
    }
    if (this.countdown > 0) {
      return;
    }
    // 模拟下发验证码
    this.sentCode = (Math.floor(Math.random() * 9000) + 1000).toString();
    promptAction.showToast({ message: `验证码已发送：${this.sentCode}（演示）`, duration: 3000 });
    this.countdown = 60;
    this.timerId = setInterval(() => {
      this.countdown -= 1;
      if (this.countdown <= 0 && this.timerId >= 0) {
        clearInterval(this.timerId);
        this.timerId = -1;
      }
    }, 1000);
  }

  private async doLogin(): Promise<void> {
    if (!this.isPhoneValid()) {
      promptAction.showToast({ message: '请输入正确的手机号' });
      return;
    }
    if (this.sentCode.length === 0) {
      promptAction.showToast({ message: '请先获取验证码' });
      return;
    }
    if (this.code !== this.sentCode) {
      promptAction.showToast({ message: '验证码不正确' });
      return;
    }
    await StorageUtils.put(StoreKey.LOGGED_IN, true);
    await StorageUtils.put(StoreKey.PHONE, this.phone);
    // 若尚未设置昵称，用手机号尾号生成默认昵称
    const nick: string = await StorageUtils.getString(StoreKey.MY_NICKNAME, '');
    if (nick.length === 0) {
      await StorageUtils.put(StoreKey.MY_NICKNAME, '星友' + this.phone.slice(-4));
    }
    promptAction.showToast({ message: '登录成功，欢迎来到星语 ✨' });
    router.replaceUrl({ url: 'pages/HomePage' });
  }

  private async guestLogin(): Promise<void> {
    await StorageUtils.put(StoreKey.LOGGED_IN, true);
    await StorageUtils.put(StoreKey.PHONE, '');
    router.replaceUrl({ url: 'pages/HomePage' });
  }

  build() {
    Column() {
      // Logo 区
      Column({ space: 10 }) {
        Text('✦').fontSize(60).fontColor(Colors.ACCENT_GOLD)
        Text('星语').fontSize(34).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
        Text('手机号登录，开启你的星辰之旅').fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
      }
      .width('100%').padding({ top: 80, bottom: 40 })

      // 手机号
      Row() {
        Text('+86').fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY).margin({ right: 10 })
        TextInput({ placeholder: '请输入手机号', text: this.phone })
          .type(InputType.PhoneNumber)
          .placeholderColor(Colors.TEXT_HINT)
          .fontColor(Colors.TEXT_PRIMARY)
          .backgroundColor(Color.Transparent)
          .maxLength(11)
          .layoutWeight(1)
          .onChange((v: string) => this.phone = v)
      }
      .width('86%').height(52).padding({ left: 16, right: 16 })
      .borderRadius(BorderRadius.BUTTON).backgroundColor(Colors.BG_CARD)
      .alignItems(VerticalAlign.Center)

      // 验证码
      Row({ space: 10 }) {
        TextInput({ placeholder: '请输入验证码', text: this.code })
          .type(InputType.Number)
          .placeholderColor(Colors.TEXT_HINT)
          .fontColor(Colors.TEXT_PRIMARY)
          .backgroundColor(Colors.BG_CARD)
          .borderRadius(BorderRadius.BUTTON)
          .maxLength(4)
          .layoutWeight(1)
          .onChange((v: string) => this.code = v)
        Button(this.countdown > 0 ? `${this.countdown}s` : '获取验证码')
          .width(120).height(48)
          .fontSize(FontSize.BODY)
          .fontColor(this.countdown > 0 ? Colors.TEXT_HINT : Colors.BG_PRIMARY)
          .backgroundColor(this.countdown > 0 ? Colors.BG_CARD2 : Colors.ACCENT_GOLD)
          .borderRadius(BorderRadius.BUTTON)
          .enabled(this.countdown === 0)
          .onClick(() => this.sendCode())
      }
      .width('86%').margin({ top: 16 })

      Button('登 录')
        .width('86%').height(52).margin({ top: 30 })
        .fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.BG_PRIMARY).backgroundColor(Colors.ACCENT_GOLD)
        .borderRadius(BorderRadius.BUTTON)
        .onClick(() => this.doLogin())

      Text('游客登录')
        .fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY)
        .margin({ top: 20 })
        .onClick(() => this.guestLogin())

      Blank()

      Text('登录即代表同意《用户协议》与《隐私政策》')
        .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_HINT).margin({ bottom: 24 })
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
