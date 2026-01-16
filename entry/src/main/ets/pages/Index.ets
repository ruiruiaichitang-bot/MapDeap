// 引入刚刚写好的常量和模型
import { CommonConstants } from '@ohos/common';
import { SpotModel } from '../model/SpotModel';
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  // 模拟数据
  @State spotList: SpotModel[] = [
    new SpotModel(1, $r('app.media.background'), '东湖绿道', '武汉 · 东湖'),
    new SpotModel(2, $r('app.media.background'), '黄鹤楼', '武汉 · 蛇山'),
    new SpotModel(3, $r('app.media.background'), '长江大桥', '武汉 · 江边'),
  ];

  @Builder
  SpotCard(item: SpotModel) {
    Column() {
      Image(item.image)
        .width('100%')
        .height(150)
        .objectFit(ImageFit.Cover)
        .borderRadius({ topLeft: 12, topRight: 12 })

      Column() {
        Text(item.title).fontSize(16).fontWeight(FontWeight.Bold)
        Text(item.location).fontSize(12).fontColor('#999').margin({ top: 5 })
      }
      .padding(10)
      .alignItems(HorizontalAlign.Start)
      .width('100%')
    }
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 5, color: '#1A000000', offsetY: 2 })
  }

  build() {
    Column() {
      // 标题
      Text(CommonConstants.HOME_TITLE)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      // 瀑布流列表
      WaterFlow() {
        ForEach(this.spotList, (item: SpotModel) => {
          FlowItem() {
            this.SpotCard(item)
          }.onClick(() => {
            router.pushUrl({
              url: 'pages/SpotDetailPage', // 目标页面
              params: {
                // 携带包裹（参数）
                id: item.id,
                title: item.title,
                location: item.location
              }
            })
          })
        }, (item: SpotModel) => item.id.toString())
      }
      .columnsTemplate("1fr 1fr") // 两列
      .columnsGap(10)
      .rowsGap(10)
      .padding(10)
      .height('100%')
    }
    .backgroundColor('#F1F3F5')
    .height('100%')
  }
}