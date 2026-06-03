import { router, promptAction } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { DateUtils } from '../utils/DateUtils';
import { CONSTELLATIONS, getConstellationById } from '../mock/ConstellationData';
import { ConstellationInfo } from '../model/Constellation';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

@Entry
@Component
struct MyConstellationPage {
  @State selectedId: number = 1;
  @State birthday: Date = new Date(2000, 0, 1);
  @State nickname: string = '星语用户';

  aboutToAppear(): void {
    StorageUtils.getNumber(StoreKey.MY_CONSTELLATION, 1).then((v: number) => {
      if (v >= 1) {
        this.selectedId = v;
      }
    });
    StorageUtils.getString(StoreKey.MY_NICKNAME, '星语用户').then((v: string) => this.nickname = v);
    StorageUtils.getString(StoreKey.MY_BIRTHDAY, '').then((v: string) => {
      if (v.length > 0) {
        const parts: string[] = v.split('-');
        if (parts.length === 3) {
          this.birthday = new Date(parseInt(parts[0]), parseInt(parts[1]) - 1, parseInt(parts[2]));
        }
      }
    });
  }

  private async save(): Promise<void> {
    await StorageUtils.put(StoreKey.MY_CONSTELLATION, this.selectedId);
    await StorageUtils.put(StoreKey.MY_BIRTHDAY, DateUtils.formatDate(this.birthday));
    await StorageUtils.put(StoreKey.MY_NICKNAME, this.nickname.trim().length > 0 ? this.nickname.trim() : '星语用户');
    promptAction.showToast({ message: '已保存你的专属星座 ✨' });
    setTimeout(() => {
      router.back();
    }, 600);
  }

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('我的星座设置').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Blank().width(50)
    }.width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  build() {
    Column() {
      this.topBar()
      Scroll() {
        Column({ space: 16 }) {
          // 当前识别结果
          Column({ space: 8 }) {
            Stack() {
              Circle().width(72).height(72).fill(getConstellationById(this.selectedId).color).opacity(0.22)
              Text(getConstellationById(this.selectedId).symbol).fontSize(40)
                .fontColor(getConstellationById(this.selectedId).color)
            }
            Text(getConstellationById(this.selectedId).name)
              .fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
          }
          .width('100%').padding({ top: 10, bottom: 6 })

          // 昵称
          Column({ space: 8 }) {
            Text('昵称').fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).width('100%')
            TextInput({ text: this.nickname, placeholder: '给自己起个名字' })
              .placeholderColor(Colors.TEXT_HINT).fontColor(Colors.TEXT_PRIMARY)
              .backgroundColor(Colors.BG_CARD2).borderRadius(BorderRadius.TAG)
              .onChange((v: string) => this.nickname = v)
          }
          .width('100%').padding(16).margin({ left: 16, right: 16 })
          .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD).alignItems(HorizontalAlign.Start)

          // 生日识别
          Column({ space: 8 }) {
            Text('输入生日自动识别').fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).width('100%')
            DatePicker({
              start: new Date('1950-01-01'),
              end: new Date('2025-12-31'),
              selected: this.birthday
            })
              .onDateChange((value: Date) => {
                this.birthday = value;
                this.selectedId = DateUtils.getConstellationId(value.getMonth() + 1, value.getDate());
              })
          }
          .width('100%').padding(16).margin({ left: 16, right: 16 })
          .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD).alignItems(HorizontalAlign.Start)

          // 手动选择
          Column({ space: 10 }) {
            Text('或手动选择星座').fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).width('100%')
            Grid() {
              ForEach(CONSTELLATIONS, (c: ConstellationInfo) => {
                GridItem() {
                  Column({ space: 2 }) {
                    Text(c.symbol).fontSize(22).fontColor(c.color)
                    Text(c.name).fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_PRIMARY)
                  }
                  .width('100%').padding({ top: 10, bottom: 10 })
                  .borderRadius(BorderRadius.TAG)
                  .backgroundColor(this.selectedId === c.id ? Colors.ACCENT_PURPLE : Colors.BG_CARD2)
                  .onClick(() => this.selectedId = c.id)
                }
              }, (c: ConstellationInfo) => c.id.toString())
            }
            .columnsTemplate('1fr 1fr 1fr 1fr').rowsGap(10).columnsGap(10)
          }
          .width('100%').padding(16).margin({ left: 16, right: 16 })
          .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD).alignItems(HorizontalAlign.Start)

          Button('保存')
            .width('90%').height(50).fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
            .fontColor(Colors.BG_PRIMARY).backgroundColor(Colors.ACCENT_GOLD).borderRadius(BorderRadius.BUTTON)
            .onClick(() => this.save())

          Blank().height(24)
        }.padding({ top: 8 })
      }.layoutWeight(1).scrollBar(BarState.Off).align(Alignment.Top)
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
