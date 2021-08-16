import UIKit
import AudioToolbox

/// 星星评分
public class FWStarView: UIView {
    /// 是否可编辑
    public var isEdit: Bool = true
    /// 分数
    public var rating: CGFloat = 0.0 {
        didSet {
            updateUI()
        }
    }
    /// 回传当前分数
    public var currentRatingBlock: ((CGFloat) -> Void)?
    /// 是否有震动效果
    public var isVibrate: Bool = true
    
    /// 设置最大评分数，默认是5分
    private var maxRating: UInt = 5
    /// 星星大小
    private var size: CGSize = CGSize(width: 20, height: 20)
    /// 星星之间的间距
    private var space: CGFloat = 5.0
    /// 图片视图数组
    private var imageViews: [UIImageView] = []
    /// all星星
    private var allImage = UIImage.image(named: "star_all")
    /// 半星星
    private var halfImage = UIImage.image(named: "star_half")
    /// 灰星星
    private var noneImage = UIImage.image(named: "star_none")
    
    /// 初始化
    /// - Parameters:
    ///   - frame: frame
    ///   - maxRating: 最大分数
    ///   - size: 星星size
    ///   - space: 星星间距
    public init(frame: CGRect = .zero,
                maxRating: UInt = 5,
                size: CGSize = CGSize(width: 20, height: 20),
                space: CGFloat = 5.0,
                allImage: UIImage? = nil,
                halfImage: UIImage? = nil,
                noneImage: UIImage? = nil) {
        super.init(frame: frame)
        self.maxRating = maxRating
        self.space = space
        self.size = size
        if let image = allImage {
            self.allImage = image
        }
        if let image = halfImage {
            self.halfImage = image
        }
        if let image = noneImage {
            self.noneImage = image
        }
        initUI()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    private func initUI() {
        
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = []
        
        var tempView: UIView = self
        for i in 0..<maxRating {
            let imageView = UIImageView()
            imageViews.append(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            switch i {
            case 0:
                NSLayoutConstraint.activate([
                    imageView.leftAnchor.constraint(equalTo: tempView.leftAnchor),
                    imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    imageView.widthAnchor.constraint(equalToConstant: size.width),
                    imageView.heightAnchor.constraint(equalToConstant: size.height)
                ])
            case _ where maxRating - 1 == i:
                NSLayoutConstraint.activate([
                    imageView.leftAnchor.constraint(equalTo: tempView.rightAnchor, constant: space),
                    imageView.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: 0),
                    imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    imageView.widthAnchor.constraint(equalToConstant: size.width),
                    imageView.heightAnchor.constraint(equalToConstant: size.height)
                ])
            default:
                NSLayoutConstraint.activate([
                    imageView.leftAnchor.constraint(equalTo: tempView.rightAnchor, constant: space),
                    imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    imageView.widthAnchor.constraint(equalToConstant: size.width),
                    imageView.heightAnchor.constraint(equalToConstant: size.height)
                ])
            }
            tempView = imageView
        }
    }
    
    /// 更新UI
    private func updateUI() {
        for (index, imageView) in imageViews.enumerated() {
            switch rating {
            case _ where rating >= CGFloat(index + 1 ):
                imageView.image = allImage
            case _ where rating > CGFloat(index):
                imageView.image = halfImage
            default:
                imageView.image = noneImage
            }
        }
        currentRatingBlock?(rating)
    }
    
    /// 手指点击位置
    /// - Parameter point: 点坐标
    func touchPoint(_ point: CGPoint) {
        var newRating: CGFloat = 0
        for i in stride(from: imageViews.count - 1, through: 0, by: -1) {
            let imageView = imageViews[i]
            let x = imageView.frame.origin.x
            let center = x + imageView.frame.size.width / 2.0
            if point.x > center {
                newRating = CGFloat(i + 1)
                break
            } else if (point.x > x && point.x <= center) {
                newRating = CGFloat(i) + 0.5
                break
            }
        }
        if rating != newRating {
            rating = newRating
            isVibrate ? AudioServicesPlaySystemSound(1520) : ()
        }
    }
}

// MARK: - Touch
extension FWStarView {
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEdit {
            let touches = touches as NSSet
            guard let touch = touches.anyObject() as? UITouch else { return }
            let point = touch.location(in: self)
            touchPoint(point)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEdit {
            let touches = touches as NSSet
            guard let touch = touches.anyObject() as? UITouch else { return }
            let point = touch.location(in: self)
            touchPoint(point)
        }
    }
}

extension UIImage {
    static func image(named: String) -> UIImage? {
        return UIImage(named: named, in: Bundle.module, compatibleWith: nil)
    }
}
