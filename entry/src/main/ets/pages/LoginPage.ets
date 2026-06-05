import { router, promptAction } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

@Entry
@Component
struct LoginPage {
  @State isRegister: boolean = false;     // false=登录, true=注册
  @State username: string = '';
  @State password: string = '';
  @State confirm: string = '';

  aboutToAppear(): void {
    // 确保默认账号存在（msh / 12345678）
    StorageUtils.ensureDefaultAccount();
  }

  private switchMode(toRegister: boolean): void {
    this.isRegister = toRegister;
    this.password = '';
    this.confirm = '';
  }

  private async doLogin(): Promise<void> {
    const u: string = this.username.trim();
    if (u.length === 0 || this.password.length === 0) {
      promptAction.showToast({ message: '请输入账号和密码' });
      return;
    }
    const ok: boolean = await StorageUtils.validateAccount(u, this.password);
    if (!ok) {
      promptAction.showToast({ message: '账号或密码不正确' });
      return;
    }
    await this.finishLogin(u);
  }

  private async doRegister(): Promise<void> {
    const u: string = this.username.trim();
    if (u.length < 2) {
      promptAction.showToast({ message: '账号至少 2 个字符' });
      return;
    }
    if (this.password.length < 6) {
      promptAction.showToast({ message: '密码至少 6 位' });
      return;
    }
    if (this.password !== this.confirm) {
      promptAction.showToast({ message: '两次输入的密码不一致' });
      return;
    }
    const created: boolean = await StorageUtils.registerAccount(u, this.password);
    if (!created) {
      promptAction.showToast({ message: '该账号已存在，请直接登录' });
      return;
    }
    promptAction.showToast({ message: '注册成功，已自动登录 ✨' });
    await this.finishLogin(u);
  }

  private async finishLogin(username: string): Promise<void> {
    await StorageUtils.put(StoreKey.LOGGED_IN, true);
    await StorageUtils.put(StoreKey.USERNAME, username);
    // 若尚未设置昵称，用账号名作为默认昵称
    const nick: string = await StorageUtils.getString(StoreKey.MY_NICKNAME, '');
    if (nick.length === 0) {
      await StorageUtils.put(StoreKey.MY_NICKNAME, username);
    }
    router.replaceUrl({ url: 'pages/HomePage' });
  }

  private async guestLogin(): Promise<void> {
    await StorageUtils.put(StoreKey.LOGGED_IN, true);
    await StorageUtils.put(StoreKey.USERNAME, '游客');
    router.replaceUrl({ url: 'pages/HomePage' });
  }

  build() {
    Column() {
      // Logo 区
      Column({ space: 10 }) {
        Text('✦').fontSize(60).fontColor(Colors.ACCENT_GOLD)
        Text('星语').fontSize(34).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
        Text(this.isRegister ? '创建账号，开启你的星辰之旅' : '账号登录，遇见每日星语')
          .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
      }
      .width('100%').padding({ top: 70, bottom: 24 })

      // 切换 登录 / 注册
      Row({ space: 0 }) {
        Text('登录')
          .fontSize(FontSize.SUBTITLE)
          .fontWeight(this.isRegister ? FontWeight.Normal : FontWeight.Bold)
          .fontColor(this.isRegister ? Colors.TEXT_HINT : Colors.ACCENT_GOLD)
          .padding({ left: 18, right: 18, top: 8, bottom: 8 })
          .onClick(() => this.switchMode(false))
        Text('|').fontSize(FontSize.SUBTITLE).fontColor(Colors.DIVIDER)
        Text('注册')
          .fontSize(FontSize.SUBTITLE)
          .fontWeight(this.isRegister ? FontWeight.Bold : FontWeight.Normal)
          .fontColor(this.isRegister ? Colors.ACCENT_GOLD : Colors.TEXT_HINT)
          .padding({ left: 18, right: 18, top: 8, bottom: 8 })
          .onClick(() => this.switchMode(true))
      }
      .margin({ bottom: 8 })

      // 账号
      TextInput({ placeholder: '请输入账号', text: this.username })
        .type(InputType.Normal)
        .placeholderColor(Colors.TEXT_HINT).fontColor(Colors.TEXT_PRIMARY)
        .backgroundColor(Colors.BG_CARD).borderRadius(BorderRadius.BUTTON)
        .maxLength(20).width('86%').height(52).margin({ top: 14 })
        .onChange((v: string) => this.username = v)
      // 密码
      TextInput({ placeholder: '请输入密码', text: this.password })
        .type(InputType.Password)
        .placeholderColor(Colors.TEXT_HINT).fontColor(Colors.TEXT_PRIMARY)
        .backgroundColor(Colors.BG_CARD).borderRadius(BorderRadius.BUTTON)
        .maxLength(20).width('86%').height(52).margin({ top: 14 })
        .onChange((v: string) => this.password = v)
      // 确认密码（仅注册）
      if (this.isRegister) {
        TextInput({ placeholder: '请再次输入密码', text: this.confirm })
          .type(InputType.Password)
          .placeholderColor(Colors.TEXT_HINT).fontColor(Colors.TEXT_PRIMARY)
          .backgroundColor(Colors.BG_CARD).borderRadius(BorderRadius.BUTTON)
          .maxLength(20).width('86%').height(52).margin({ top: 14 })
          .onChange((v: string) => this.confirm = v)
      }

      Button(this.isRegister ? '注 册 并 登 录' : '登 录')
        .width('86%').height(52).margin({ top: 30 })
        .fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.BG_PRIMARY).backgroundColor(Colors.ACCENT_GOLD)
        .borderRadius(BorderRadius.BUTTON)
        .onClick(() => {
          if (this.isRegister) {
            this.doRegister();
          } else {
            this.doLogin();
          }
        })

      Text('游客登录')
        .fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY)
        .margin({ top: 18 })
        .onClick(() => this.guestLogin())

      // 默认账号提示
      if (!this.isRegister) {
        Text('演示账号：msh　密码：12345678')
          .fontSize(FontSize.CAPTION).fontColor(Colors.ACCENT_PURPLE).margin({ top: 16 })
      }

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
