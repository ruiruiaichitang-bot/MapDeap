// views/MineView.ets
@Component
export struct MineView {
  @StorageProp('topHeight') topHeight: number = 0;
  @StorageLink('isDarkMode') isDarkMode: boolean = false;

  build() {
    Column() {
      // 头像区域
      Column() {
        Image($r('app.media.Renye'))
          .width(80)
          .height(80)
          .borderRadius(40)
          .margin({ bottom: 10 })

        Text('HarmonyOS 开发者')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.isDarkMode ? Color.White : Color.Black)
      }
      .width('100%')
      .padding({ top: 50, bottom: 50 })
      .backgroundColor(this.isDarkMode ? '#222222' : Color.White)

      // 菜单列表
      List() {
        ListItem() {
          Row() {
            Text('夜间模式').fontSize(16).fontColor(this.isDarkMode ? Color.White : Color.Black)
            Blank()
            // Text('我的收藏').fontSize(16)
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: this.isDarkMode })
              .onChange((isOn: boolean) => {
                // 更新状态，AppStorage 会自动通知所有页面
                this.isDarkMode = isOn;
              })
          }
          .width('100%')
          .padding(20)
          .backgroundColor(this.isDarkMode ? '#333333' : Color.White)
        }

        ListItem() {
          Row() {
            Text('系统设置').fontSize(16).fontColor(this.isDarkMode ? Color.White : Color.Black)
            Blank()
            Text('>').fontColor('#999').fontColor(this.isDarkMode ? Color.White : Color.Black)
          }
          .width('100%')
          .padding(20)
          .backgroundColor(this.isDarkMode ? '#333333' : Color.White)
          .margin({ top: 10 })
        }
      }
      .layoutWeight(1) // 填满剩余空间
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isDarkMode ? '#121212' : '#F1F3F5')
    // 👇 同样要避让顶部
    .padding({ top: px2vp(this.topHeight) })
  }
}