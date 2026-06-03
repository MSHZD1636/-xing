import { router, promptAction } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { DateUtils } from '../utils/DateUtils';
import { getConstellationById } from '../mock/ConstellationData';
import { getFortune } from '../mock/FortuneData';
import { ConstellationInfo } from '../model/Constellation';
import { StarRating } from '../components/StarRating';
import { StorageUtils } from '../utils/StorageUtils';

@Entry
@Component
struct FavoritePage {
  @State favIds: number[] = [];
  private todayStr: string = DateUtils.formatDate(new Date());

  aboutToAppear(): void {
    this.load();
  }

  private load(): void {
    StorageUtils.getFavorites().then((list: number[]) => this.favIds = list);
  }

  private async remove(id: number): Promise<void> {
    await StorageUtils.removeFavorite(id);
    this.favIds = this.favIds.filter((v) => v !== id);
    promptAction.showToast({ message: '已移除收藏' });
  }

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('我的收藏').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Blank().width(50)
    }.width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  @Builder
  deleteButton(id: number) {
    Button('删除')
      .width(72).height('86%').fontColor(Colors.TEXT_PRIMARY)
      .backgroundColor(Colors.DANGER).borderRadius(BorderRadius.TAG)
      .margin({ left: 8 })
      .onClick(() => this.remove(id))
  }

  @Builder
  emptyState() {
    Column({ space: 12 }) {
      Text('✦').fontSize(56).fontColor(Colors.TEXT_HINT)
      Text('还没有收藏任何星座').fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY)
      Text('在运势详情页点击 ☆ 即可收藏').fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_HINT)
      Button('去逛逛星座图鉴')
        .height(44).fontColor(Colors.BG_PRIMARY).backgroundColor(Colors.ACCENT_GOLD)
        .borderRadius(BorderRadius.BUTTON).margin({ top: 8 })
        .onClick(() => router.pushUrl({ url: 'pages/ConstellationListPage' }))
    }
    .width('100%').height('70%').justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      this.topBar()
      if (this.favIds.length === 0) {
        this.emptyState()
      } else {
        List({ space: 12 }) {
          ForEach(this.favIds, (id: number) => {
            ListItem() {
              Row({ space: 12 }) {
                Stack() {
                  Circle().width(50).height(50).fill(getConstellationById(id).color).opacity(0.22)
                  Text(getConstellationById(id).symbol).fontSize(26).fontColor(getConstellationById(id).color)
                }
                Column({ space: 4 }) {
                  Text(getConstellationById(id).name).fontSize(FontSize.BODY)
                    .fontColor(Colors.TEXT_PRIMARY).fontWeight(FontWeight.Medium)
                  Text(getFortune(id, this.todayStr).summary).fontSize(FontSize.CAPTION)
                    .fontColor(Colors.TEXT_SECONDARY).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                }.alignItems(HorizontalAlign.Start).layoutWeight(1)
                StarRating({ score: getFortune(id, this.todayStr).overall, starSize: 13 })
              }
              .width('100%').padding(14).borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)
              .onClick(() => router.pushUrl({ url: 'pages/FortuneDetailPage', params: { id: id } }))
            }
            .swipeAction({ end: this.deleteButton(id) })
            .gesture(LongPressGesture().onAction(() => this.remove(id)))
          }, (id: number) => id.toString())
        }
        .layoutWeight(1).scrollBar(BarState.Off).padding({ left: 16, right: 16, top: 8 })
      }
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.Top])
  }
}
