import { router } from '@kit.ArkUI';
import { Colors, FontSize, BorderRadius, STARRY_COLORS, STARRY_ANGLE } from '../utils/Constants';
import { CONSTELLATIONS } from '../mock/ConstellationData';
import { ConstellationInfo } from '../model/Constellation';

@Entry
@Component
struct SearchPage {
  @State keyword: string = '';
  @State history: string[] = [];
  @State results: ConstellationInfo[] = [];

  private doSearch(kw: string): void {
    const k: string = kw.trim();
    this.keyword = k;
    if (k.length === 0) {
      this.results = [];
      return;
    }
    this.results = CONSTELLATIONS.filter((c) =>
      c.name.indexOf(k) >= 0 ||
      c.nameEn.toLowerCase().indexOf(k.toLowerCase()) >= 0 ||
      c.element.indexOf(k) >= 0 ||
      c.traits.some((t) => t.indexOf(k) >= 0)
    );
    if (this.history.indexOf(k) < 0) {
      this.history = [k, ...this.history].slice(0, 8);
    }
  }

  @Builder
  topBar() {
    Row({ space: 10 }) {
      Text('‹').fontSize(34).fontColor(Colors.TEXT_PRIMARY)
        .onClick(() => router.back())
      Row() {
        Text('🔍').fontSize(16).margin({ right: 6 })
        TextInput({ placeholder: '搜索星座 / 元素 / 关键词', text: this.keyword })
          .placeholderColor(Colors.TEXT_HINT)
          .fontColor(Colors.TEXT_PRIMARY)
          .backgroundColor(Color.Transparent)
          .layoutWeight(1)
          .onChange((v: string) => this.keyword = v)
          .onSubmit(() => this.doSearch(this.keyword))
      }
      .layoutWeight(1).padding({ left: 12, right: 12 }).height(40)
      .borderRadius(BorderRadius.BUTTON).backgroundColor(Colors.BG_CARD)
      Text('搜索').fontSize(FontSize.BODY).fontColor(Colors.ACCENT_GOLD)
        .onClick(() => this.doSearch(this.keyword))
    }
    .width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  tagSection(title: string, tags: string[]) {
    Column({ space: 10 }) {
      Text(title).fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY).width('100%')
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(tags, (t: string) => {
          Text(t)
            .fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
            .padding({ left: 14, right: 14, top: 7, bottom: 7 })
            .margin({ right: 10, bottom: 10 })
            .borderRadius(BorderRadius.TAG)
            .backgroundColor(Colors.BG_CARD)
            .onClick(() => this.doSearch(t))
        }, (t: string, i: number) => t + i)
      }
    }
    .width('100%').padding({ left: 16, right: 16, top: 14 }).alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      this.topBar()
      if (this.results.length > 0) {
        List({ space: 10 }) {
          ForEach(this.results, (c: ConstellationInfo) => {
            ListItem() {
              Row({ space: 12 }) {
                Text(c.symbol).fontSize(26).fontColor(c.color)
                Column({ space: 2 }) {
                  Text(c.name).fontSize(FontSize.BODY).fontColor(Colors.TEXT_PRIMARY)
                  Text(`${c.nameEn} · ${c.element}象`).fontSize(FontSize.CAPTION).fontColor(Colors.TEXT_SECONDARY)
                }.alignItems(HorizontalAlign.Start).layoutWeight(1)
                Text('›').fontSize(24).fontColor(Colors.TEXT_HINT)
              }
              .width('100%').padding(14).borderRadius(BorderRadius.CARD).backgroundColor(Colors.BG_CARD)
              .onClick(() => router.pushUrl({ url: 'pages/ConstellationDetailPage', params: { id: c.id } }))
            }
          }, (c: ConstellationInfo) => c.id.toString())
        }
        .layoutWeight(1).scrollBar(BarState.Off).padding({ left: 16, right: 16, top: 8 })
      } else {
        Scroll() {
          Column() {
            this.tagSection('十二星座', CONSTELLATIONS.map((c) => c.name))
            if (this.history.length > 0) {
              this.tagSection('搜索历史', this.history)
            }
            if (this.keyword.length > 0) {
              Text('未找到相关星座，换个关键词试试～')
                .fontSize(FontSize.BODY).fontColor(Colors.TEXT_HINT).margin({ top: 40 })
            }
          }
        }.layoutWeight(1).align(Alignment.Top)
      }
    }
    .width('100%').height('100%')
    .linearGradient({ angle: STARRY_ANGLE, colors: STARRY_COLORS })
    .backgroundColor(Colors.BG_PRIMARY)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.Top])
  }
}
