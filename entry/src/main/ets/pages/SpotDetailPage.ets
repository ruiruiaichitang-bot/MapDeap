// pages/SpotDetailPage.ets
import { router } from '@kit.ArkUI';

// 定义我们期望接收的参数结构
interface RouterParams {
  id: number;
  title: string;
  location: string;
}

@Entry
@ComponentV2 // 👈 亮点：这是 V2 版本的组件标志
struct SpotDetailPage {
  // V2 新语法：使用 @Local 代替 @State 管理组件内部状态
  @Local title: string = '景点详情';
  @Local location: string = '';
  @Local imageId: number = 0;
  @Local isLiked: boolean = false; // 点赞状态

  // 页面加载时触发
  aboutToAppear(): void {
    // 获取上一页传过来的参数
    const params = router.getParams() as RouterParams;
    if (params) {
      this.title = params.title;
      this.location = params.location;
      this.imageId = params.id;
    }
  }

  build() {
    Column() {
      // --- 1. 顶部导航栏 ---
      Row() {
        // 返回箭头
        Text('<')
          .fontSize(30)
          .padding({ left: 16, right: 16 })
          .onClick(() => {
            router.back(); // 👈 返回上一页
          })

        Text(this.title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1) // 撑满中间
          .textAlign(TextAlign.Center) // 文字居中

        // 占位符，为了让标题视觉居中
        Text('  ').width(50)
      }
      .height(56)
      .width('100%')
      .border({ width: { bottom: 1 }, color: '#EEE' })

      // --- 2. 内容区域 ---
      Column({ space: 20 }) {
        // 大图
        Image($r('app.media.background')) // 暂时还用这个图，以后换
          .width('100%')
          .height(250)
          .objectFit(ImageFit.Cover)
          .borderRadius(16)
          .shadow({ radius: 10, color: '#33000000' })

        // 地点信息
        Row() {
          Text('📍 ' + this.location)
            .fontSize(16)
            .fontColor('#666')
            .backgroundColor('#F5F5F5')
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .borderRadius(20)
        }
        .width('100%')

        // 介绍文案
        Text('这里是详细介绍...\nArkTS V2 带来的 @Local 装饰器让状态管理更直观，只有真正变化的数据才会触发 UI 刷新，性能更强。')
          .fontSize(16)
          .lineHeight(26)
          .fontColor('#333')

        // --- 3. 互动按钮 (测试 V2 状态) ---
        Button(this.isLiked ? '已收藏 ❤️' : '收藏景点 🤍')
          .onClick(() => {
            this.isLiked = !this.isLiked; // 直接修改，UI 自动刷新
          })
          .width('100%')
          .height(45)
          .backgroundColor(this.isLiked ? '#FFEBEE' : '#222')
          .fontColor(this.isLiked ? Color.Red : Color.White)
          .margin({ top: 20 })
      }
      .padding(20)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}