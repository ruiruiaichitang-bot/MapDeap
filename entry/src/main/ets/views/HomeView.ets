// views/HomeView.ets
import { router } from '@kit.ArkUI';
import { SpotModel } from '../model/SpotModel';
import { SpotApi } from '../api/SpotApi';

@Component
export struct HomeView {
  // 状态变量搬过来
  @State spotList: SpotModel[] = [];
  @State isLoading: boolean = true;
  @StorageProp('isDarkMode') isDarkMode: boolean = false;

  // 自动获取之前的安全区域高度
  @StorageProp('topHeight') topHeight: number = 0;

  // 生命周期搬过来
  async aboutToAppear() {
    try {
      this.spotList = await SpotApi.getSpotList();
    } catch (error) {
      console.error('API Error', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  // 卡片布局搬过来
  @Builder SpotCard(item: SpotModel) {
    Column() {
      Image(item.image)
        .width('100%')
        .height(150)
        .backgroundColor('#E0E0E0')
        .objectFit(ImageFit.Cover)
        .borderRadius({ topLeft: 12, topRight: 12 })
        .sharedTransition('hero_' + item.id, { duration: 400, curve: Curve.Smooth })

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
    .onClick(() => {
      router.pushUrl({
        url: 'pages/SpotDetailPage',
        params: { id: item.id, title: item.title, location: item.location, image: item.image }
      })
    })
  }

  build() {
    Column() {
      // 标题
      Text('智行山海')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10, left: 16 })
        .width('100%')
        .fontColor(this.isDarkMode ? Color.White : Color.Black)

      // 瀑布流
      WaterFlow() {
        ForEach(this.spotList, (item: SpotModel) => {
          FlowItem() {
            this.SpotCard(item)
          }
        }, (item: SpotModel) => item.id.toString())
      }
      .columnsTemplate("1fr 1fr")
      .columnsGap(10)
      .rowsGap(10)
      .padding({ left: 10, right: 10, bottom: 20 })
      .height('100%')
    }
    .height('100%')
    .backgroundColor(this.isDarkMode ? '#121212' : '#F1F3F5')
    // 👇 关键：在这里应用顶部的避让高度
    .padding({ top: px2vp(this.topHeight) })
  }
}