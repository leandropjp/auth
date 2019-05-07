//
//  UIDevice+ScreenType.swift
//  FractalAuth
//
//  Created by Leandro Paiva Andrade on 4/23/19.
//

import UIKit

enum ScreenType: String {
    case iPhone4
    case iPhones_5_5s_5c_SE
    case iPhones_6_6s_7_8
    case iPhones_6Plus_6sPlus_7Plus_8Plus
    case iPhoneX_Xs
    case iPhoneXsMax
    case iPhoneXr
    case unknown
}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    var isiPhoneXrAndAbove: Bool {
        return UIScreen.main.nativeBounds.height > 1792
    }

    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhoneXr
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX_Xs
        case 2688:
            return .iPhoneXsMax
        default:
            return .unknown
        }
    }
}

extension UIApplication {
    /// Returns the status bar UIView
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }

}

struct DeviceInfo {
    struct Orientation {
        // indicate current device is in the LandScape orientation
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }}
