import { router, promptAction } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

@Entry
@Component
struct NotificationSettingPage {
  @State enabled: boolean = true;
  @State hour: number = 8;
  @State minute: number = 0;
  @State prefs: boolean[] = [true, true, false, false];
  private readonly prefLabels: string[] = ['每日运势', '幸运提示', '塔罗抽签提醒', '配对推荐'];

  aboutToAppear(): void {
    StorageUtils.getBool(StoreKey.NOTIFY_ENABLED, true).then((v: boolean) => this.enabled = v);
    StorageUtils.getString(StoreKey.NOTIFY_TIME, '08:00').then((v: string) => {
      const parts: string[] = v.split(':');
      if (parts.length === 2) {
        this.hour = parseInt(parts[0]);
        this.minute = parseInt(parts[1]);
      }
    });
  }

  private async save(): Promise<void> {
    await StorageUtils.put(StoreKey.NOTIFY_ENABLED, this.enabled);
    const t: string = `${this.hour.toString().padStart(2, '0')}:${this.minute.toString().padStart(2, '0')}`;
    await StorageUtils.put(StoreKey.NOTIFY_TIME, t);
    promptAction.showToast({ message: '推送设置已保存' });
  }

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('每日运势推送').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Text('保存').fontSize(FontSize.BODY).fontColor(Colors.ACCENT_GOLD)
        .padding({ left: 16, right: 16 }).onClick(() => this.save())
    }
    .width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  build() {
    Column() {
      this.topBar()
      Scroll() {
        Column({ space: 16 }) {
          // 开关
          Row() {
            Column({ space: 4 }) {
              Text('接收每日推送').fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY)
              Text('每天定时为你送上专属运势').fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
            }.alignItems(HorizontalAlign.Start).layoutWeight(1)
            Toggle({ type: ToggleType.Switch, isOn: this.enabled })
              .selectedColor(Colors.ACCENT_GOLD)
              .onChange((v: boolean) => this.enabled = v)
          }
          .width('100%').padding(16).borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)

          // 推送时间
          Column({ space: 10 }) {
            Text('推送时间').fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).width('100%')
            TimePicker({ selected: this.makeTime() })
              .enabled(this.enabled)
              .opacity(this.enabled ? 1 : 0.4)
              .onChange((v: TimePickerResult) => {
                this.hour = v.hour;
                this.minute = v.minute;
              })
          }
          .width('100%').padding(16).borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)

          // 内容偏好（多选）
          Column({ space: 12 }) {
            Text('推送内容偏好').fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).width('100%')
            ForEach(this.prefLabels, (label: string, index: number) => {
              Row() {
                Text(label).fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY).layoutWeight(1)
                Toggle({ type: ToggleType.Checkbox, isOn: this.prefs[index] })
                  .selectedColor(Colors.ACCENT_PURPLE)
                  .width(22).height(22)
                  .onChange((v: boolean) => {
                    const next: boolean[] = this.prefs.slice();
                    next[index] = v;
                    this.prefs = next;
                  })
              }.width('100%').height(40)
            }, (label: string) => label)
          }
          .width('100%').padding(16).borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)
          .alignItems(HorizontalAlign.Start)

          Blank().height(24)
        }
        .padding({ left: 16, right: 16, top: 12 })
      }.layoutWeight(1).scrollBar(BarState.Off).align(Alignment.Top)
    }
    .width('100%').height('100%')
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .backgroundColor(Colors.BG_PRIMARY)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.Top])
  }

  private makeTime(): Date {
    const d: Date = new Date();
    d.setHours(this.hour, this.minute, 0, 0);
    return d;
  }
}
