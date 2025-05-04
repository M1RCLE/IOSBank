import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}


public enum Colors {
    public static let primary: UIColor = UIColor(hex: "#6200EE")
    public static let primaryVariant: UIColor = UIColor(hex: "#3700B3")
    public static let secondary: UIColor = UIColor(hex: "#03DAC6")
    public static let background: UIColor = UIColor(hex: "#FFFFFF")
    public static let surface: UIColor = UIColor(hex: "#FFFFFF")
    public static let error: UIColor = UIColor(hex: "#B00020")
    public static let onPrimary: UIColor = UIColor(hex: "#FFFFFF")
    public static let onSecondary: UIColor = UIColor(hex: "#000000")
    public static let onBackground: UIColor = UIColor(hex: "#000000")
    public static let onSurface: UIColor = UIColor(hex: "#000000")
    public static let onError: UIColor = UIColor(hex: "#FFFFFF")
}
