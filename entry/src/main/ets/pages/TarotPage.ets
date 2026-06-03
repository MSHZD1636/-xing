import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { DateUtils } from '../utils/DateUtils';
import { getDailyTarotId, getTarotById } from '../mock/TarotData';
import { TarotCardInfo } from '../model/TarotCard';
import { TarotCard } from '../components/TarotCard';
import { BottomTabBar } from '../components/BottomTabBar';
import { StorageUtils, StoreKey } from '../utils/StorageUtils';

interface TarotRecord {
  date: string;
  cardId: number;
}

@Entry
@Component
struct TarotPage {
  private todayStr: string = DateUtils.formatDate(new Date());
  @State cardId: number = 0;
  @State card: TarotCardInfo = getTarotById(0);
  @State locked: boolean = false;   // 当日已抽
  @State revealed: boolean = false;
  @State loaded: boolean = false;

  aboutToAppear(): void {
    this.cardId = getDailyTarotId(new Date());
    this.card = getTarotById(this.cardId);
    StorageUtils.getString(StoreKey.TAROT_RECORD, '').then((raw: string) => {
      if (raw.length > 0) {
        try {
          const rec: TarotRecord = JSON.parse(raw) as TarotRecord;
          if (rec.date === this.todayStr) {
            this.locked = true;
            this.revealed = true;
            this.cardId = rec.cardId;
            this.card = getTarotById(rec.cardId);
          }
        } catch (e) {
        }
      }
      this.loaded = true;
    });
  }

  private async onRevealed(): Promise<void> {
    this.revealed = true;
    const rec: TarotRecord = { date: this.todayStr, cardId: this.cardId };
    await StorageUtils.put(StoreKey.TAROT_RECORD, JSON.stringify(rec));
  }

  build() {
    Column() {
      Column({ space: 6 }) {
        Text('🔮 每日塔罗')
          .fontSize(FontSize.TITLE).fontWeight(FontWeight.Bold).fontColor(Colors.TEXT_PRIMARY)
        Text(DateUtils.formatLocalized(new Date()))
          .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
      }.margin({ top: 24, bottom: 10 })

      Stack() {
        Column().width('100%').height('100%')
          .linearGradient({ angle: 160, colors: [['#163A4A', 0.0], ['#0D0821', 0.7]] })
          .opacity(0.5)

        Column({ space: 20 }) {
          if (this.loaded) {
            TarotCard({
              card: this.card,
              locked: this.locked,
              onRevealed: () => { this.onRevealed(); }
            })
          }
          Text(this.revealed ? this.card.name : '今日为你抽取一张牌')
            .fontSize(FontSize.SUBTITLE).fontColor(Colors.ACCENT_TEAL).fontWeight(FontWeight.Bold)
          if (this.revealed) {
            Text(this.card.keywords.join(' · '))
              .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
          } else {
            Text('点击卡牌揭晓今日运势（每日一次）')
              .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_HINT)
          }
        }.justifyContent(FlexAlign.Center)
      }
      .layoutWeight(1).width('100%')

      if (this.revealed) {
        Button('查看详细解读 ›')
          .width('80%').height(50)
          .fontSize(FontSize.SUBTITLE).fontColor(Colors.BG_PRIMARY)
          .backgroundColor(Colors.ACCENT_TEAL).borderRadius(BorderRadius.BUTTON)
          .margin({ bottom: 20 })
          .onClick(() => router.pushUrl({ url: 'pages/TarotDetailPage', params: { cardId: this.cardId } }))
      }

      BottomTabBar({ currentIndex: 3 })
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
