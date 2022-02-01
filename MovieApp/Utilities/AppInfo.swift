//
//  AppInfo.swift
//  MovieApp
//
//  Created by osvaldo cespedes on 28/01/22.
//

import Foundation
import UIKit

struct AppInfo {

    static var shared:AppInfo {
        return AppInfo()
    }
        
    var UIID : String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    var appName : String {
        return readFromInfoPlist(withKey: "CFBundleName") ?? "(unknown app name)"
    }

    var version : String {
        return (readFromInfoPlist(withKey: "CFBundleShortVersionString") ?? "(unknown app version)")
    }

    var build : String {
        return readFromInfoPlist(withKey: "CFBundleVersion") ?? "(unknown build number)"
    }

    var minimumOSVersion : String {
        return readFromInfoPlist(withKey: "MinimumOSVersion") ?? "(unknown minimum OSVersion)"
    }

    var copyrightNotice : String {
        return readFromInfoPlist(withKey: "NSHumanReadableCopyright") ?? "(unknown copyright notice)"
    }

    var bundleIdentifier : String {
        return readFromInfoPlist(withKey: "CFBundleIdentifier") ?? "(unknown bundle identifier)"
    }

    var environment: String  {
        return readFromInfoPlist(withKey: "Configuration") ?? ""
    }
    
    var developer : String { return "Osvaldo Cespedes Hernandez" }

    // lets hold a reference to the Info.plist of the app as Dictionary
    private let infoPlistDictionary = Bundle.main.infoDictionary

    /// Retrieves and returns associated values (of Type String) from info.Plist of the app.
    private func readFromInfoPlist(withKey key: String) -> String? {
        return infoPlistDictionary?[key] as? String
    }
    
}


