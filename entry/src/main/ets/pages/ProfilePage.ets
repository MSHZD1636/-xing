import { router, promptAction } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { getConstellationById } from '../mock/ConstellationData';
import { getFortune } from '../mock/FortuneData';
import { DateUtils } from '../utils/DateUtils';
import { ConstellationInfo } from '../model/Constellation';
import { BottomTabBar } from '../components/BottomTabBar';
import { StarRating } from '../components/StarRating';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

interface MenuItem {
  icon: string;
  title: string;
  url: string;
}

@Entry
@Component
struct ProfilePage {
  @State myId: number = 0;
  @State nickname: string = '星语用户';
  private todayStr: string = DateUtils.formatDate(new Date());
  private menus: MenuItem[] = [
    { icon: '⭐', title: '我的收藏', url: 'pages/FavoritePage' },
    { icon: '🎂', title: '生日星座查询', url: 'pages/BirthdayQueryPage' },
    { icon: '🔔', title: '推送设置', url: 'pages/NotificationSettingPage' },
    { icon: '🌗', title: '星盘知识', url: 'pages/StarChartPage' }
  ];

  private logout(): void {
    AlertDialog.show({
      title: '退出登录',
      message: '确定要退出当前账号吗？',
      primaryButton: {
        value: '退出',
        fontColor: Colors.DANGER,
        action: () => {
          // 清除登录态（即使写入失败也照常跳转，保证退出可用）
          StorageUtils.logout().catch((e: Error) => {
            hilog.error(0x0002, 'Profile', 'clear login flag failed: %{public}s', e.message);
          });
          promptAction.showToast({ message: '已退出登录' });
          // 清空页面栈后跳转登录页，确保彻底退出
          router.clear();
          router.replaceUrl({ url: 'pages/LoginPage' }).catch((e: Error) => {
            hilog.error(0x0002, 'Profile', 'logout jump failed: %{public}s', e.message);
          });
        }
      },
      secondaryButton: {
        value: '取消',
        action: () => {}
      }
    });
  }

  onPageShow(): void {
    StorageUtils.getNumber(StoreKey.MY_CONSTELLATION, 0).then((v: number) => this.myId = v);
    StorageUtils.getString(StoreKey.MY_NICKNAME, '星语用户').then((v: string) => this.nickname = v);
  }

  @Builder
  profileHeader() {
    Column({ space: 12 }) {
      Stack() {
        Circle().width(88).height(88).fill(Colors.ACCENT_PURPLE).opacity(0.25)
        Text(this.myId >= 1 ? getConstellationById(this.myId).symbol : '✦')
          .fontSize(46).fontColor(Colors.ACCENT_GOLD)
      }
      Text(this.nickname).fontSize(FontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
      if (this.myId >= 1) {
        Text(`${getConstellationById(this.myId).name} · ${getConstellationById(this.myId).dateRange}`)
          .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
      } else {
        Text('点击下方设置你的专属星座')
          .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_HINT)
      }
    }
    .width('100%').padding({ top: 24, bottom: 16 })
  }

  @Builder
  fortuneCard() {
    if (this.myId >= 1) {
      Column({ space: 10 }) {
        Row() {
          Text('我的今日运势').fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).fontWeight(FontWeight.Bold)
          Blank()
          StarRating({ score: getFortune(this.myId, this.todayStr).overall, starSize: 14 })
        }.width('100%')
        Text(getFortune(this.myId, this.todayStr).summary)
          .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY).width('100%')
      }
      .width('100%').padding(16).margin({ left: 16, right: 16 })
      .borderRadius(BorderRadius.CARD)
      .linearGradient({ angle: 135, colors: [['#2A1A4A', 0.0], ['#1C1033', 1.0]] })
      .border({ width: 1, color: Colors.ACCENT_PURPLE })
      .onClick(() => router.pushUrl({ url: 'pages/FortuneDetailPage', params: { id: this.myId } }))
    }
  }

  build() {
    Column() {
      Scroll() {
        Column({ space: 14 }) {
          this.profileHeader()
          this.fortuneCard()

          Button(this.myId >= 1 ? '修改我的星座' : '设置我的星座')
            .width('90%').height(46).fontColor(Colors.BG_PRIMARY)
            .backgroundColor(Colors.ACCENT_GOLD).borderRadius(BorderRadius.BUTTON)
            .onClick(() => router.pushUrl({ url: 'pages/MyConstellationPage' }))

          List() {
            ForEach(this.menus, (m: MenuItem) => {
              ListItem() {
                Row() {
                  Text(m.icon).fontSize(20).margin({ right: 12 })
                  Text(m.title).fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).layoutWeight(1)
                  Text('›').fontSize(24).fontColor(Colors.TEXT_HINT)
                }
                .width('100%').height(56).padding({ left: 16, right: 16 })
              }
              .onClick(() => router.pushUrl({ url: m.url }))
            }, (m: MenuItem) => m.title)
            ListItem() {
              Row() {
                Text('ℹ️').fontSize(20).margin({ right: 12 })
                Text('关于星语').fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).layoutWeight(1)
                Text('v1.0.0').fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_HINT)
              }.width('100%').height(56).padding({ left: 16, right: 16 })
            }
            .onClick(() => promptAction.showToast({ message: '星语 StarWhisper · 每日一语，星辰指引' }))
          }
          .width('90%').borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)
          .divider({ strokeWidth: 1, color: Colors.DIVIDER, startMargin: 16, endMargin: 16 })

          Button('退出登录')
            .width('90%').height(46).margin({ top: 16 })
            .fontColor(Colors.DANGER).backgroundColor(Colors.BG_CARD)
            .border({ width: 1, color: Colors.DANGER }).borderRadius(BorderRadius.BUTTON)
            .onClick(() => this.logout())

          Blank().height(20)
        }
      }.layoutWeight(1).scrollBar(BarState.Off).align(Alignment.Top)

      BottomTabBar({ currentIndex: 5 })
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
