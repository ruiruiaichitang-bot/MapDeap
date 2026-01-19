// 1. 引入 AxiosResponse 类型 (必须显式引入)
import axios, { AxiosResponse } from '@ohos/axios';
import { SpotModel } from '../model/SpotModel';

interface PhotoResult {
  id: number;
  title: string;
  thumbnailUrl: string;
}

export class SpotApi {
  static async getSpotList(): Promise<SpotModel[]> {
    try {
      // 1. 定义一组国内访问飞快的风景图 (Gitee/CDN 源)
      const images = [
        'https://img.zcool.cn/community/01f13b5d22b644a801214837c35252.jpg@1280w_1l_2o_100sh.jpg', // 雪山
        'https://img.zcool.cn/community/010156554303490000019ae978f683.jpg@1280w_1l_2o_100sh.jpg', // 湖泊
        'https://img.zcool.cn/community/0150d15d5f66a2a80120695cc705b7.jpg@1280w_1l_2o_100sh.jpg', // 草原
        'https://img.zcool.cn/community/01374959ac0975a801211d2551408e.jpg@1280w_1l_2o_100sh.jpg', // 城市
      ];

      const response: AxiosResponse<PhotoResult[]> = await axios.get<PhotoResult[], AxiosResponse<PhotoResult[]>>(
        'https://jsonplaceholder.typicode.com/photos?_limit=10'
      );

      return response.data.map((item: PhotoResult, index: number) => {
        // 2. 用取余数的方法，循环使用上面那 4 张图
        const realImage = images[index % images.length];

        return new SpotModel(
          item.id,
          realImage, // ✅ 使用漂亮的风景图
          item.title.substring(0, 10),
          '中国 · 壮美河山'
        );
      });

    } catch (e) {
      let error = e as Error;
      console.error('请求失败: ' + JSON.stringify(error));
      return [];
    }
  }
}