import { router } from '@kit.ArkUI';
import { Colors, FontSize } from '../utils/Constants';

interface TabItem {
  icon: string;
  label: string;
  url: string;
}

const TABS: TabItem[] = [
  { icon: '🏠', label: '首页', url: 'pages/HomePage' },
  { icon: '✨', label: '图鉴', url: 'pages/ConstellationListPage' },
  { icon: '💞', label: '配对', url: 'pages/MatchSelectPage' },
  { icon: '🔮', label: '塔罗', url: 'pages/TarotPage' },
  { icon: '📅', label: '日历', url: 'pages/CalendarPage' },
  { icon: '👤', label: '我的', url: 'pages/ProfilePage' }
];

/**
 * 底部导航栏（公共组件），复用于首页、图鉴、配对、塔罗、日历、个人中心
 */
@Component
export struct BottomTabBar {
  @Prop currentIndex: number;

  private jump(index: number): void {
    if (index === this.currentIndex) {
      return;
    }
    router.replaceUrl({ url: TABS[index].url }).catch(() => {});
  }

  build() {
    Row() {
      ForEach(TABS, (item: TabItem, index: number) => {
        Column({ space: 2 }) {
          Text(item.icon)
            .fontSize(this.currentIndex === index ? 24 : 21)
            .opacity(this.currentIndex === index ? 1 : 0.6)
          Text(item.label)
            .fontSize(FontSize.CAPTION)
            .fontColor(this.currentIndex === index ? Colors.ACCENT_GOLD : Colors.TEXT_SECONDARY)
            .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
        }
        .layoutWeight(1)
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => this.jump(index))
      }, (item: TabItem) => item.url)
    }
    .width('100%')
    .height(64)
    .backgroundColor(Colors.BG_CARD)
    .border({ width: { top: 1 }, color: Colors.DIVIDER })
  }
}
