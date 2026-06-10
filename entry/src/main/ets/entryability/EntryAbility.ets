import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window, display } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { deviceInfo } from '@kit.BasicServicesKit';

const DOMAIN: number = 0x0001;
const TAG: string = 'StarWhisper';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 星空主题为深色，固定为深色模式以保持沉浸式视觉
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, TAG, 'EntryAbility onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, TAG, 'EntryAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, TAG, 'onWindowStageCreate');

    // 设置沉浸式全屏，贴合神秘星空风格
    windowStage.getMainWindow().then((win: window.Window) => {
      win.setWindowLayoutFullScreen(true).catch((err: Error) => {
        hilog.warn(DOMAIN, TAG, 'setWindowLayoutFullScreen failed: %{public}s', JSON.stringify(err));
      });
      win.setWindowSystemBarProperties({
        statusBarContentColor: '#FFFFFF',
        navigationBarContentColor: '#FFFFFF'
      }).catch((err: Error) => {
        hilog.warn(DOMAIN, TAG, 'setWindowSystemBarProperties failed: %{public}s', JSON.stringify(err));
      });
    });

    // 多模态入口：手表直接进入精简版日历运势页，手机走完整启动流程
    // 双重判断：1) deviceType（不同版本手表可能为 'wearable' 或 'watch'）
    //          2) 屏幕物理像素较小（兜底，防止 deviceType 返回意外值）
    const dt: string = deviceInfo.deviceType;
    let smallScreen: boolean = false;
    try {
      const disp = display.getDefaultDisplaySync();
      smallScreen = Math.min(disp.width, disp.height) <= 600;
    } catch (e) {
      hilog.warn(DOMAIN, TAG, 'getDefaultDisplaySync failed');
    }
    const isWearable: boolean = dt === 'wearable' || dt === 'watch' || smallScreen;
    const entryPage: string = isWearable ? 'pages/WatchCalendarPage' : 'pages/SplashPage';
    hilog.info(DOMAIN, TAG, 'deviceType=%{public}s, small=%{public}s, entryPage=%{public}s',
      dt, smallScreen ? 'Y' : 'N', entryPage);

    windowStage.loadContent(entryPage, (err) => {
      if (err.code) {
        hilog.error(DOMAIN, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, TAG, 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, TAG, 'onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, TAG, 'EntryAbility onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, TAG, 'EntryAbility onBackground');
  }
}
