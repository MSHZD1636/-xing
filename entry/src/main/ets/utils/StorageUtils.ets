import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

/**
 * Preferences 封装：用户星座、收藏、塔罗抽签记录等本地持久化
 */
const STORE_NAME: string = 'star_whisper_store';
const DOMAIN: number = 0x0002;
const TAG: string = 'StorageUtils';

// 存储键
export class StoreKey {
  static readonly MY_CONSTELLATION: string = 'my_constellation_id';
  static readonly MY_BIRTHDAY: string = 'my_birthday';
  static readonly MY_NICKNAME: string = 'my_nickname';
  static readonly FAVORITES: string = 'favorite_ids';
  static readonly TAROT_RECORD: string = 'tarot_record';      // {date, cardId}
  static readonly NOTIFY_ENABLED: string = 'notify_enabled';
  static readonly NOTIFY_TIME: string = 'notify_time';
}

export class StorageUtils {
  private static store: preferences.Preferences | null = null;

  static async init(context: common.UIAbilityContext | common.Context): Promise<void> {
    if (StorageUtils.store) {
      return;
    }
    try {
      StorageUtils.store = await preferences.getPreferences(context, STORE_NAME);
    } catch (e) {
      hilog.error(DOMAIN, TAG, 'init failed: %{public}s', JSON.stringify(e));
    }
  }

  static async getString(key: string, def: string): Promise<string> {
    if (!StorageUtils.store) {
      return def;
    }
    const v: preferences.ValueType = await StorageUtils.store.get(key, def);
    return v as string;
  }

  static async getNumber(key: string, def: number): Promise<number> {
    if (!StorageUtils.store) {
      return def;
    }
    const v: preferences.ValueType = await StorageUtils.store.get(key, def);
    return v as number;
  }

  static async getBool(key: string, def: boolean): Promise<boolean> {
    if (!StorageUtils.store) {
      return def;
    }
    const v: preferences.ValueType = await StorageUtils.store.get(key, def);
    return v as boolean;
  }

  static async put(key: string, value: preferences.ValueType): Promise<void> {
    if (!StorageUtils.store) {
      return;
    }
    await StorageUtils.store.put(key, value);
    await StorageUtils.store.flush();
  }

  // ---------- 收藏夹封装 ----------
  static async getFavorites(): Promise<number[]> {
    const raw: string = await StorageUtils.getString(StoreKey.FAVORITES, '[]');
    try {
      return JSON.parse(raw) as number[];
    } catch (e) {
      return [];
    }
  }

  static async isFavorite(id: number): Promise<boolean> {
    const list: number[] = await StorageUtils.getFavorites();
    return list.indexOf(id) >= 0;
  }

  static async toggleFavorite(id: number): Promise<boolean> {
    const list: number[] = await StorageUtils.getFavorites();
    const idx: number = list.indexOf(id);
    let added: boolean;
    if (idx >= 0) {
      list.splice(idx, 1);
      added = false;
    } else {
      list.push(id);
      added = true;
    }
    await StorageUtils.put(StoreKey.FAVORITES, JSON.stringify(list));
    return added;
  }

  static async removeFavorite(id: number): Promise<void> {
    const list: number[] = await StorageUtils.getFavorites();
    const idx: number = list.indexOf(id);
    if (idx >= 0) {
      list.splice(idx, 1);
      await StorageUtils.put(StoreKey.FAVORITES, JSON.stringify(list));
    }
  }
}
