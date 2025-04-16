import Foundation

enum SettingType {
    case toggle
    case selection
}

struct Setting: Equatable {
    let key: String
    let title: String
    var value: Any
    let type: SettingType
    let options: [String]?
    
    init(key: String, title: String, value: Any, type: SettingType, options: [String]? = nil) {
        self.key = key
        self.title = title
        self.value = value
        self.type = type
        self.options = options
    }
    
    static func == (lhs: Setting, rhs: Setting) -> Bool {
        return lhs.key == rhs.key
    }
}

struct SettingsModel {
    let settings: [Setting]
}

enum SettingsError: Error, LocalizedError {
    case invalidSetting
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidSetting:
            return "Invalid setting value"
        case .saveFailed:
            return "Failed to save settings"
        }
    }
}
