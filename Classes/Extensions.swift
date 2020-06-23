
let TWITTER_DATE_FORMAT = "EEE MMM dd HH:mm:ss Z yyyy"
let SOUNDCLOUD_FORMAT = "yyyy-MM-dd HH:mm:ss Z"

public class StringUtils {
    
    public static func formatToShortNum(n: Double) ->String{
        let num = abs(Double(n))
        let sign = (n < 0) ? "-" : ""
        
        switch num {
            
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)B"
            
        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)M"
            
        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)k"
            
        case 0...:
            return "\(abs(Int(n)))"
            
        default:
            return "\(sign)\(n)"
            
        }
        
    }
}

extension String {
    
    public func getFileName() -> String? {
        let lastCompontent = (self as NSString).lastPathComponent as String
        let parts = lastCompontent.components(separatedBy: ".")
        if (parts.count > 0) {
           return parts[0]
        }
        return nil
    }

    public func isNumeric() -> Bool {
        return NumberFormatter().number(from: self) != nil
    }

    public func convertToDate(formatString : String? = nil) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if (formatString != nil) {
            formatter.dateFormat = formatString!
        } else {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSXXXXX"
        }
        return formatter.date(from: self)
    }
    
    public func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
}

extension Date {
    public func convertToString() -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSXXXXX"
        return formatter.string(from: self)
    }
}
    
extension Double {
    public func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

extension NSAttributedString {
    convenience init(data: Data, documentType: DocumentType, encoding: String.Encoding = .utf8) throws {
        try self.init(data: data,
                      options: [.documentType: documentType,
                                .characterEncoding: encoding.rawValue],
                      documentAttributes: nil)
    }
    convenience init(html data: Data) throws {
        try self.init(data: data, documentType: .html)
    }
    convenience init(txt data: Data) throws {
        try self.init(data: data, documentType: .plain)
    }
    convenience init(rtf data: Data) throws {
        try self.init(data: data, documentType: .rtf)
    }
    convenience init(rtfd data: Data) throws {
        try self.init(data: data, documentType: .rtfd)
    }
}

extension StringProtocol {
    var data: Data { return Data(utf8) }
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try .init(html: data)
        } catch {
            print("html error:", error)
            return nil
        }
    }
    var htmlDataToString: String? {
        return htmlToAttributedString?.string
    }
}

extension Data {
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try .init(html: self)
        } catch {
            print("html error:", error)
            return nil
        }
        
    }
}


// Extensions for ViewControllers
extension UIViewController {
    
    public func show() {
        self.view.show()
    }
    
    public func hide() {
        self.view.hide()
    }
    
    public class var storyboardID : String {
        return "\(self)"
    }
    
    public static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

extension UILabel {
    public func setTextWithShadow(_ string: String) {
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 5
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.3)
        
        let attributes = [ NSAttributedString.Key.shadow: shadow ]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        
        self.attributedText = attributedString
    }
}

extension UILabel {
    
    public func semiBoldWith(fontSize : CGFloat) {
        self.font = UIFont(name: "Gibson-SemiBold",size: fontSize)
    }
    
}

extension UIButton {
    
    public func semiBoldWith(fontSize : CGFloat) {
        if let font = UIFont(name: "Gibson-SemiBold",size: fontSize) {
            self.titleLabel?.font = font
        }
    }
    
}

extension UIView {
    
    public func removeAllConstraints() {
        var _superview = self.superview

        while let superview = _superview {
            for constraint in superview.constraints {

                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }

                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }

            _superview = superview.superview
        }

        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func addBorder(width : CGFloat, color : UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    public func hide(completionDelegate : AnyObject? = nil){
        self.isHidden = true
    }
    
    public func show(completionDelegate : AnyObject? = nil){
        self.isHidden = false
    }
    
    public func makeRounded(radius: CGFloat? = nil) {
        let radius = radius ?? self.frame.height/2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    public func addShadowWithRadius(cornerRadius : CGFloat? = nil, shadowColor : UIColor = UIColor.black, shadowOpacity : Float = 0.2, shadowOffsetX : Int = 0, shadowOffsetY : Int = 4, shadowRadius : CGFloat = 5, scale: Bool = true, usePlainShadow : Bool = true){
        
        let radius = cornerRadius ?? self.frame.height/2
        
        makeRounded(radius: radius)
        
        if(!usePlainShadow) {
        self.layer.shadowPath =
            UIBezierPath(roundedRect: self.bounds,
                         cornerRadius: self.layer.cornerRadius).cgPath
        }
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        self.layer.shadowRadius = shadowRadius
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        self.layer.masksToBounds = false
    }
    
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "tapGestureRecognizer_Key"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        }
    }
    
    public func fadeIn(duration: TimeInterval = 0.3, completionDelegate: AnyObject? = nil) {
        self.show()
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    public func fadeOut(duration: TimeInterval = 0.3, completionDelegate: @escaping (_ result: Bool) -> Void) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }) { _ in
            completionDelegate(true)
        }
    }
    
    public func addBorder(borderColor : UIColor, borderWidth : CGFloat) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    public func removeBorder(){
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
    public func roundCornerByRect(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    public func startShimmer(repeatAnimation : Bool = true) {
        stopShimmer()
        self.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
        gradientLayer.frame = self.bounds
        self.layer.mask = gradientLayer
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.5
        animation.fromValue = -self.frame.size.width
        animation.toValue = self.frame.size.width
        if (repeatAnimation) {
            animation.repeatCount = .infinity
        } else {
            animation.repeatCount = 1
        }
        
        gradientLayer.add(animation, forKey: "")
    }
    
    public func stopShimmer() {
        self.layer.removeAllAnimations()
        self.layer.mask = nil
    }
    
    public func removeShadow(){
        self.layer.shadowPath = nil
        self.layer.shadowOpacity = 0.0
    }
    
    public func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowRadius = 1
    }
    
    public func glow() {
        if let bgColor = self.backgroundColor {
            self.layer.shadowColor = bgColor.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 5
            self.layer.masksToBounds = false
        }
    }
    
    public func applyGradient(colors: [UIColor]) -> Void {
        self.applyGradient(colors: colors, locations: nil)
    }
    
    public func applyGradient(colors: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension StringProtocol {
    
    public func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    public func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    
    public func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    public func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    public static func randomEmoji(forIndex : Int) -> String {
        let availableEmojis = ["😀","😃","😄","😁","😆","🤣",
                               "😂","😉","😇","🥰","🥰","🥰",
                               "🤑","🤪","😜","🥶","🤮","🤯",
                               "🤠","🥳","😎","🥵","🤓","😭",
                               "😈","💩","👽","🙊","🤖"]
        
        return availableEmojis[abs(forIndex%availableEmojis.count)]
    }
}

extension UIFont {
    public static func semibold(size : CGFloat) -> UIFont {
        return UIFont (name: "Gibson-SemiBold", size: size)!
    }
}


extension UIButton {
    
//    public func imageFromURL(urlString: String) {
//        self.sd_setBackgroundImage(with: URL(string: urlString), for: .normal)
//    }
    
    public func convertToEditButton() {
        self.setTitle(NSLocalizedString("settings_edit", comment: ""), for: .normal)
        self.backgroundColor = UIColor.PrimeColor.Button.settingsPurple
        self.setTitleColor(.white, for: .normal)
        self.layer.borderWidth = 0
    }
    
    public func convertToSaveButton() {
        self.setTitle(NSLocalizedString("settings_save", comment: ""), for: .normal)
        self.backgroundColor = UIColor.PrimeColor.Button.enabledBackground
        self.setTitleColor(UIColor.PrimeColor.Button.enabledText, for: .normal)
        self.layer.borderWidth = 0
    }
    
    public func convertToProfileButton() {
        self.setTitle(NSLocalizedString("common_profile_button", comment: ""), for: .normal)
        self.backgroundColor = UIColor.PrimeColor.Button.enabledBackground
        self.setTitleColor(UIColor.PrimeColor.Button.enabledText, for: .normal)
        self.layer.borderWidth = 0
    }
    
    public func convertToAddButton() {
        self.setTitle(NSLocalizedString("common_add_button", comment: ""), for: .normal)
        self.backgroundColor = UIColor.PrimeColor.Button.disabledBackground
        self.setTitleColor(UIColor.PrimeColor.Button.disabledText, for: .normal)
        self.layer.borderWidth = 0
    }
    
    public func lookDeactivated() {
        self.backgroundColor = UIColor.PrimeColor.Button.disabledBackground
        self.setTitleColor(UIColor.PrimeColor.Button.disabledText, for: .normal)
        self.layer.borderWidth = 0
    }
    
    public func convertToUnmaskButton() {
        self.setTitle(NSLocalizedString("common_unmask_button", comment: ""), for: .normal)
        self.backgroundColor = .clear
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.PrimeColor.Button.unmaskBorder.cgColor
        self.setTitleColor(UIColor.PrimeColor.Button.unmaskText, for: .normal)
    }
    
    public func convertToTooLateButton() {
        self.setTitle(NSLocalizedString("common_too_late_button", comment: ""), for: .normal)
        self.backgroundColor = .clear
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.PrimeColor.Button.tooLateBorder.cgColor
        self.setTitleColor(UIColor.PrimeColor.Button.tooLateText, for: .normal)
    }
    
    public func convertToUnlockButton() {
        self.setTitle(NSLocalizedString("common_unlock_button", comment: ""), for: .normal)
    }
}



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    public static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    
    
    struct PrimeColor {
        static let Grey = UIColor(rgb: 0xefefef)
        struct Primary {
            static let Red = UIColor(rgb: 0xff005f)
            static let Blue = UIColor(rgb: 0x3de9da)
            static let Yellow = UIColor(rgb: 0xFFFF02)
            static let Purple = UIColor(rgb: 0x9E4AFF)
        }
        struct Secondary {
            static let Orange = UIColor(rgb: 0xff6e1b)
            static let Pink = UIColor(rgb: 0xf038ff)
            static let Indigo = UIColor(rgb: 0x3772ff)
        }
        struct Button {
            static let disabledText = UIColor(rgb: 0x90979D)
            static let disabledBackground = UIColor(rgb: 0xEFEFEF)
            static let darkDisabledBackground = UIColor(rgb: 0x242424)
            static let enabledText = UIColor.white
            static let enabledBackground = Primary.Red
            static let unmaskBorder = UIColor(rgb: 0xfdd11b)
            static let unmaskText = UIColor(rgb: 0xfdd11b)
            static let tooLateBorder = UIColor(rgb: 0xEFEFEF)
            static let tooLateText = UIColor(rgb: 0x90979D)
            static let settingsPurple = UIColor(rgb: 0x9747F8)
        }
        struct RewardButton {
            static let Yellow = UIColor(rgb: 0xfcd038)
        }
    }
    
    public static func primeColor(forIndex : Int, usePrimary : Bool = false) -> UIColor {
        let denom = (usePrimary) ? 4 : 8
        switch (abs(forIndex%denom)) {
        case 1 :
            return UIColor.PrimeColor.Primary.Blue
        case 2:
            return UIColor.PrimeColor.Primary.Purple
        case 3 :
            return UIColor.PrimeColor.Primary.Yellow
        case 5 :
            return UIColor.PrimeColor.Secondary.Orange
        case 6 :
            return UIColor.PrimeColor.Secondary.Pink
        case 7 :
            return UIColor.PrimeColor.Secondary.Indigo
        default:
            return UIColor.PrimeColor.Primary.Red
        }
    }
}

extension CGFloat {
    public static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension Date {
    public func timeAgoDisplay() -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return String(format:NSLocalizedString("common_seconds_ago", comment: ""),diff,"s")
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            if diff == 1 {
                return String(format:NSLocalizedString("common_mins_ago", comment: ""),diff,"")
            } else {
                return String(format:NSLocalizedString("common_mins_ago", comment: ""),diff,"s")
            }
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            if diff == 1 {
                return String(format:NSLocalizedString("common_hours_ago", comment: ""),diff,"")
            } else {
                return String(format:NSLocalizedString("common_hours_ago", comment: ""),diff,"s")
            }
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            if diff == 1 {
                return String(format:NSLocalizedString("common_days_ago", comment: ""),diff,"")
            } else {
                return String(format:NSLocalizedString("common_days_ago", comment: ""),diff,"s")
            }
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return String(format:NSLocalizedString("common_weeks_ago", comment: ""),diff,"s")
    }
}

extension String {
    public func getYoutubeId() -> String? {
        return URLComponents(string: self)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
}

// MARK: Localizable
public protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

// MARK: XIBLocalizable
public protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}

extension UINavigationItem: XIBLocalizable {
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
    }
}

extension UIBarItem: XIBLocalizable { // Localizes UIBarButtonItem and UITabBarItem
    @IBInspectable public var xibLocKey: String? {
        get { return nil }
        set(key) {
            title = key?.localized
        }
    }
}

// MARK: Special protocol to localize multiple texts in the same control
public protocol XIBMultiLocalizable {
    var xibLocKeys: String? { get set }
}

extension UISegmentedControl: XIBMultiLocalizable {
    @IBInspectable public var xibLocKeys: String? {
        get { return nil }
        set(keys) {
            guard let keys = keys?.components(separatedBy: ","), !keys.isEmpty else { return }
            for (index, title) in keys.enumerated() {
                setTitle(title.localized, forSegmentAt: index)
            }
        }
    }
}

// MARK: Special protocol to localizaze UITextField's placeholder
public protocol UITextFieldXIBLocalizable {
    var xibPlaceholderLocKey: String? { get set }
}

extension UITextField: UITextFieldXIBLocalizable {
    @IBInspectable public var xibPlaceholderLocKey: String? {
        get { return nil }
        set(key) {
            placeholder = key?.localized
        }
    }
}

extension UIPageViewController {
    
    public func goToNextPage(){
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: false, completion: nil)
    }
    
    
    public func goToPreviousPage(){
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: false, completion: nil)
    }
    
}


extension UICollectionView {
    public func asyncReload() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}

extension Array {
    /// Picks `n` random elements (partial Fisher-Yates shuffle approach)
    subscript (randomPick n: Int) -> [Element] {
        if (n >= count || (count - n <= 0)) {
            return self
        } else {
            var copy = self
            for i in stride(from: count - 1, to: count - n - 1, by: -1) {
                copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
            }
            return Array(copy.suffix(n))
        }
    }
}

extension UIViewController {
    public func showAsAlert(string : String) {
        #if DEBUG
        let alert = UIAlertController(title: "DEBUG", message: string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        #endif
    }
}


public enum AppStoryboard : String {
    
    case Main
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    public func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard")
        }
        return scene
    }
    
    public func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
