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
  //轮播图的数据
  @State banners: string[] = [
    'https://img.freepik.com/free-photo/nature-landscape-with-hand-holding-frame_23-2149389976.jpg?t=st=1768881010~exp=1768884610~hmac=838377f7ce2d88ed5a575aadaa0a4a3053c3bebd836105a24eeab2a2fcac6196&w=1060',
    'https://img.freepik.com/free-photo/professional-photographer-takes-photos-with-camera-tripod-rocky-peak-sunset_335224-433.jpg?t=st=1768881113~exp=1768884713~hmac=6c395f9a4f2ad35f1a6b1d6b95bc6c6e9792e41585241d07a2a7bfe9bcb47bab&w=1060',
    'https://img.freepik.com/free-photo/beautiful-landscape-mountain-fuji-around-yamanakako-lake_74190-3041.jpg?t=st=1768881136~exp=1768884736~hmac=04526167d459b2a7c5f518e1aa5afd11a606cbfb90f674209e93198c55cd117c&w=1060'
  ];
  //控制刷新
  @State isRefreshing: boolean = false;

  async aboutToAppear() {
    try {
      this.spotList = await SpotApi.getSpotList();
    } catch (error) {
      console.error('API Error', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  @Builder
  SpotCard(item: SpotModel) {
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
        params: {
          id: item.id,
          title: item.title,
          location: item.location,
          image: item.image,
          detailUrl: item.detailUrl
        }
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

      // 轮播图

      Swiper() {
        ForEach(this.banners, (img: string) => {
          Image(img)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover) // 填满不留白
            .borderRadius(16) // 圆角
        })
      }
      .effectMode(EdgeEffect.Spring)
      .width('100%')
      .height(180)
      .autoPlay(true)
      .interval(3000)
      .indicator(true)
      .itemSpace(10)
      .padding({ left: 16, right: 16 })
      .margin({ bottom: 10 })

      // 瀑布流

      Refresh({ refreshing: $$this.isRefreshing }) {
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
        // .layoutWeight(1)
        .height('100%')
      }
      .layoutWeight(1)
      .onRefreshing(() => {
        // 👇 当用户下拉时，触发这个函数

        // 1. 重新请求数据
        SpotApi.getSpotList().then((newList) => {
          // 2. 为了演示效果，我们要么把列表清空再赋值，要么打乱一下顺序
          // 这里我们简单粗暴：直接覆盖 (实际开发中可能是追加或替换)
          this.spotList = newList;

          // 3. 告诉系统：刷新完了，把转圈圈收回去
          this.isRefreshing = false;

          // 💡 提示用户 (可选)
          // Prompt.showToast({ message: '刷新成功' });
        }).catch(() => {
          this.isRefreshing = false; // 即使失败也要关闭动画
        });
      })
    }
    .height('100%')
    .backgroundColor(this.isDarkMode ? '#121212' : '#F1F3F5')
    // 👇 关键：在这里应用顶部的避让高度
    .padding({ top: px2vp(this.topHeight) })
  }
}