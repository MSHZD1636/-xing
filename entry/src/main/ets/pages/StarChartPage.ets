import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';

interface ChartSection {
  emoji: string;
  title: string;
  subtitle: string;
  concept: string;
  diff: string;
  howto: string;
  color: string;
}

@Entry
@Component
struct StarChartPage {
  @State expanded: boolean[] = [true, false, false];
  private sections: ChartSection[] = [
    {
      emoji: '☀️', title: '太阳星座', subtitle: '外在性格与自我展示', color: Colors.ACCENT_GOLD,
      concept: '太阳星座由出生日期决定，是我们最熟悉的「星座」。它代表你的核心自我、意志力与对外展现的性格特质，是生命能量的源头。',
      diff: '太阳星座是基础，描绘了你「想成为」的样子，决定了你面对世界时最鲜明的个性标签。',
      howto: '只需知道出生的公历月日，即可直接查到太阳星座（本 App 的生日查询功能即可获取）。'
    },
    {
      emoji: '🌙', title: '月亮星座', subtitle: '内心情感与潜意识', color: Colors.ACCENT_PURPLE,
      concept: '月亮星座是出生时月亮所在的星座，代表你的情绪模式、内在需求与安全感来源，是私密而真实的内心世界。',
      diff: '相比外显的太阳星座，月亮星座揭示了你独处时、亲密关系中真正的情感反应，常常只有亲近的人才能体会。',
      howto: '需要精确的出生日期、时间与地点，通过星盘排盘工具计算月亮的位置即可得知。'
    },
    {
      emoji: '⬆️', title: '上升星座', subtitle: '第一印象与外貌气质', color: Colors.ACCENT_TEAL,
      concept: '上升星座是出生时东方地平线上升起的星座，代表别人对你的第一印象、外在气质以及你面对新环境时的本能反应。',
      diff: '上升星座像一层「面具」，是他人初识你时感受到的气场，往往与太阳星座共同塑造完整的个人形象。',
      howto: '对出生时间最为敏感，需精确到分钟，并结合出生地经纬度排盘才能准确得出。'
    }
  ];

  @Builder
  topBar() {
    Row() {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .padding({ left: 16, right: 16 }).onClick(() => router.back())
      Text('认识你的星盘').fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold)
        .fontColor(Colors.TEXT_PRIMARY).layoutWeight(1).textAlign(TextAlign.Center)
      Blank().width(50)
    }.width('100%').height(52).alignItems(VerticalAlign.Center)
  }

  @Builder
  sectionCard(sec: ChartSection, index: number) {
    Column({ space: 0 }) {
      Row({ space: 12 }) {
        Text(sec.emoji).fontSize(30)
        Column({ space: 2 }) {
          Text(sec.title).fontSize(FontSize.SUBTITLE).fontWeight(FontWeight.Bold).fontColor(sec.color)
          Text(sec.subtitle).fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
        }.alignItems(HorizontalAlign.Start).layoutWeight(1)
        Text(this.expanded[index] ? '∧' : '∨').fontSize(20).fontColor(Colors.TEXT_HINT)
      }
      .width('100%').padding(16)
      .onClick(() => {
        const next: boolean[] = this.expanded.slice();
        next[index] = !next[index];
        this.expanded = next;
      })

      if (this.expanded[index]) {
        Column({ space: 12 }) {
          Divider().color(Colors.DIVIDER)
          this.detailRow('概念', sec.concept)
          this.detailRow('与太阳星座的区别', sec.diff)
          this.detailRow('如何查询', sec.howto)
        }
        .width('100%').padding({ left: 16, right: 16, bottom: 16 })
      }
    }
    .width('100%').margin({ bottom: 14 })
    .borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)
    .border({ width: 1, color: Colors.DIVIDER })
  }

  @Builder
  detailRow(label: string, body: string) {
    Column({ space: 4 }) {
      Text(label).fontSize(FontSize.CAPTION).fontColor(Colors.ACCENT_GOLD).width('100%')
      Text(body).fontSize(FontSize.BODY).fontColor(Colors.TEXT_SECONDARY).lineHeight(23).width('100%')
    }.width('100%').alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      this.topBar()
      Scroll() {
        Column() {
          Text('完整的星盘由太阳、月亮、上升等多个要素构成，三者结合才能描绘真正的你。')
            .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY).lineHeight(20)
            .width('100%').padding({ top: 10, bottom: 14 })

          ForEach(this.sections, (sec: ChartSection, index: number) => {
            this.sectionCard(sec, index)
          }, (sec: ChartSection) => sec.title)

          // 小贴士
          Row({ space: 10 }) {
            Text('💡').fontSize(20)
            Text('小贴士：三者结合才是完整的你').fontSize(FontSize.BODY)
              .fontColor(Colors.ACCENT_GOLD).fontWeight(FontWeight.Medium).layoutWeight(1)
          }
          .width('100%').padding(16).borderRadius(BorderRadius.CARD)
          .backgroundColor(Colors.BG_CARD2).margin({ top: 4 })

          Blank().height(24)
        }.padding({ left: 16, right: 16 })
      }.layoutWeight(1).scrollBar(BarState.Off).align(Alignment.Top)
    }
    .width('100%').height('100%')
    .backgroundColor(Colors.BG_PRIMARY)
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
