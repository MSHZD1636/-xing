import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { DateUtils } from '../utils/DateUtils';
import { getAllFortunesSorted } from '../mock/FortuneData';
import { getConstellationById } from '../mock/ConstellationData';
import { DailyFortune } from '../model/Fortune';
import { StarRating } from '../components/StarRating';

@Entry
@Component
struct AllFortuneListPage {
  private todayStr: string = DateUtils.formatDate(new Date());
  @State list: DailyFortune[] = [];
  @State descending: boolean = true;

  aboutToAppear(): void {
    this.refresh();
  }

  private refresh(): void {
    const arr: DailyFortune[] = getAllFortunesSorted(this.todayStr);
    if (!this.descending) {
      arr.reverse();
    }
    this.list = arr;
  }

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('今日全部运势').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Text(this.descending ? '高→低' : '低→高')
        .fontSize(FontSize.CAPTION).fontColor(Colors.ACCENT_GOLD)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          this.descending = !this.descending;
          this.refresh();
        })
    }
    .width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  build() {
    Column() {
      this.topBar()
      List({ space: 10 }) {
        ForEach(this.list, (f: DailyFortune, index: number) => {
          ListItem() {
            Row({ space: 12 }) {
              Text(`${index + 1}`)
                .fontSize(FontSize.BODY)
                .fontColor(index < 3 ? Colors.ACCENT_GOLD : Colors.TEXT_HINT)
                .width(22)
                .textAlign(TextAlign.Center)
              Text(getConstellationById(f.constellationId).symbol)
                .fontSize(28).fontColor(getConstellationById(f.constellationId).color)
              Column({ space: 4 }) {
                Text(getConstellationById(f.constellationId).name)
                  .fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).fontWeight(FontWeight.Medium)
                Text(f.summary)
                  .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
                  .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .alignItems(HorizontalAlign.Start).layoutWeight(1)
              StarRating({ score: f.overall, starSize: 13 })
            }
            .width('100%').padding(14)
            .borderRadius(BorderRadius.CARD)
            .backgroundColor(Colors.BG_CARD)
            .onClick(() => router.pushUrl({ url: 'pages/FortuneDetailPage', params: { id: f.constellationId } }))
          }
        }, (f: DailyFortune) => f.constellationId.toString())
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .padding({ left: 16, right: 16, top: 8 })
    }
    .width('100%').height('100%')
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .backgroundColor(Colors.BG_PRIMARY)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
