# FWStarView

> FWStarView是一个用于点评样式为⭐️⭐️的控件

![IMG_71D0571658D4-1](https://github.com/CoderJohnhao/FWStarView/blob/main/screenshot-20210816-173849.png)

> 使用方式

```swift
// 创建一个评分view
lazy var starView: FWStarView = {
	FWStarView(maxRating: 5, size: CGSize(width: 24, height: 24), space: 16)
}()

// 是否开启震动反馈，默认是true
starView.isVibrate = false
// 分数
starView.rating = 5.0
// 是否可以编辑，默认是true
starView.isEdit = false
```

  

