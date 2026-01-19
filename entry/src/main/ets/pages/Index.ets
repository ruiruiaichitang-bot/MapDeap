// pages/Index.ets
import { HomeView } from '../views/HomeView'; // 引入组件
import { MineView } from '../views/MineView';

@Entry
@Component
struct Index {
  // 记录当前选中的是第几个 Tab (0: 首页, 1: 我的)
  @State currentIndex: number = 0;

  // 自定义 Tab 按钮的样式 (选中变绿，没选中变灰)
  @Builder TabBarBuilder(title: string, index: number, icon: ResourceStr) {
    Column() {
      // 图标 (实际开发会用 Image，这里暂时用文字代替或者简单圆点)
      // 如果你有图标资源：Image(icon).width(24).fillColor(...)
      Text(index === 0 ? '🏠' : '👤')
        .fontSize(24)
        .margin({ bottom: 4 })

      Text(title)
        .fontColor(this.currentIndex === index ? '#1BAE5D' : '#999999')
        .fontSize(10)
        .fontWeight(this.currentIndex === index ? 500 : 400)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    // 👇 核心组件：Tabs
    Tabs({ barPosition: BarPosition.End }) { // End 表示导航栏在底部

      // --- 第 1 页：首页 ---
      TabContent() {
        HomeView() // <--- 使用我们拆分出来的组件
      }
      .tabBar(this.TabBarBuilder('首页', 0, $r('app.media.Shoye')))

      // --- 第 2 页：我的 ---
      TabContent() {
        MineView() // <--- 使用我们拆分出来的组件
      }
      .tabBar(this.TabBarBuilder('我的', 1, $r('app.media.My')))
    }
    .barHeight(60) // 底部导航栏高度
    .onChange((index) => {
      this.currentIndex = index; // 记录切换状态
    })
    .scrollable(false) // 禁止左右滑动切换 (标准 App 通常是点按切换)
  }
}