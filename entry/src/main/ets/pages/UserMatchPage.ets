import { router, promptAction } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { MOCK_USERS } from '../mock/UserData';
import { AppUser } from '../model/AppUser';
import { getConstellationById } from '../mock/ConstellationData';
import { getMatchResult } from '../mock/MatchData';
import { MatchResult } from '../model/MatchResult';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

@Entry
@Component
struct UserMatchPage {
  @State myId: number = 1;
  @State matchedIds: number[] = [];

  aboutToAppear(): void {
    StorageUtils.getNumber(StoreKey.MY_CONSTELLATION, 1).then((v: number) => this.myId = v >= 1 ? v : 1);
    this.refreshMatched();
  }

  onPageShow(): void {
    this.refreshMatched();
  }

  private refreshMatched(): void {
    StorageUtils.getMatchedUsers().then((list: number[]) => this.matchedIds = list);
  }

  private matchScore(user: AppUser): number {
    const r: MatchResult = getMatchResult(this.myId, user.constellationId);
    return Math.round((r.loveScore + r.friendScore + r.workScore) / 3);
  }

  private async doMatch(user: AppUser): Promise<void> {
    await StorageUtils.addMatchedUser(user.id);
    this.matchedIds = [...this.matchedIds, user.id];
    promptAction.showToast({ message: `💞 与 ${user.name} 匹配成功！` });
  }

  private enterChat(user: AppUser): void {
    router.pushUrl({ url: 'pages/ChatPage', params: { userId: user.id } });
  }

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('星座之缘 · 用户匹配').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Blank().width(50)
    }.width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  @Builder
  userCard(user: AppUser) {
    Column({ space: 12 }) {
      Row({ space: 14 }) {
        Stack() {
          Circle().width(56).height(56).fill(user.color).opacity(0.3)
          Text(user.emoji).fontSize(28)
        }
        Column({ space: 4 }) {
          Row({ space: 8 }) {
            Text(user.name).fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
            Text(`${user.age}岁`).fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
            Text(getConstellationById(user.constellationId).symbol).fontSize(16)
              .fontColor(getConstellationById(user.constellationId).color)
          }
          Text(user.bio).fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
            .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
        }.alignItems(HorizontalAlign.Start).layoutWeight(1)

        Column({ space: 2 }) {
          Text(`${this.matchScore(user)}%`).fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(Colors.ACCENT_PINK)
          Text('匹配度').fontSize(10).fontColor(Colors.TEXT_HINT)
        }
      }.width('100%')

      if (this.matchedIds.indexOf(user.id) >= 0) {
        Button('💬 进入聊天')
          .width('100%').height(42).fontSize(FontSize.BODY)
          .fontColor(Colors.BG_PRIMARY).backgroundColor(Colors.ACCENT_TEAL).borderRadius(BorderRadius.BUTTON)
          .onClick(() => this.enterChat(user))
      } else {
        Button('💞 匹配 TA')
          .width('100%').height(42).fontSize(FontSize.BODY)
          .fontColor(Colors.BG_PRIMARY).backgroundColor(Colors.ACCENT_PINK).borderRadius(BorderRadius.BUTTON)
          .onClick(() => this.doMatch(user))
      }
    }
    .width('100%').padding(16).margin({ bottom: 12 })
    .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)
    .border({ width: 1, color: Colors.DIVIDER })
  }

  build() {
    Column() {
      this.topBar()
      Scroll() {
        Column() {
          Text(`基于你的「${getConstellationById(this.myId).name}」为你推荐高契合度的星友`)
            .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
            .width('100%').padding({ top: 8, bottom: 14 })

          ForEach(MOCK_USERS, (user: AppUser) => {
            this.userCard(user)
          }, (user: AppUser) => user.id.toString())

          Blank().height(20)
        }.padding({ left: 16, right: 16 })
      }.layoutWeight(1).scrollBar(BarState.Off).align(Alignment.Top)
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
