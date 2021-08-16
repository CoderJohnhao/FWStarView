# FWStarView

> FWStarView是一个用于点评样式为⭐️⭐️的控件

![IMG_71D0571658D4-1](https://github.com/CoderJohnhao/FWStarView/blob/main/IMG_71D0571658D4-1.jpeg)

> 使用方式

```swift
/// 创建一个评分view
lazy var starView: FWStarView = {
	FWStarView(maxRating: 5, size: CGSize(width: 24, height: 24), space: 16)
}()

starView.isVibrate = false
starView.rating = 5.0
starView.isEdit = false
```

- isVibrate是否开启震动反馈，默认是true

- rating分数

- isEdit是否可以编辑，默认是true

  

