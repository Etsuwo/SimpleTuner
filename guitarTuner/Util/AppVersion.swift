//
//  AppVersion.swift
//  guitarTuner
//
//  Created by Etsushi Otani on 2023/06/12.
//  Copyright © 2023 大谷悦志. All rights reserved.
//

import Foundation

struct AppVersion {

    let versionString: String
    let majorVersion: Int
    let minorVersion: Int
    let patchVersion: Int

    init?(_ version: String) {
        let versionNumbers = version.components(separatedBy: ".").compactMap { Int($0) }
        if versionNumbers.count == 3 {
            versionString = version
            majorVersion = versionNumbers[0]
            minorVersion = versionNumbers[1]
            patchVersion = versionNumbers[2]
        } else {
            print("Does not meet the conditions of Semantic Versioning. App Version: \(version)")
            return nil
        }
    }
}

extension AppVersion: Comparable {

    // 左辺と右辺は等しい
    static func == (lhs: AppVersion, rhs: AppVersion) -> Bool {

        if lhs.majorVersion == rhs.majorVersion,
           lhs.minorVersion == rhs.minorVersion,
           lhs.patchVersion == rhs.patchVersion {
            return true
        }

        return false
    }

    // 左辺は右辺より小さい
    static func < (lhs: AppVersion, rhs: AppVersion) -> Bool {

        if lhs.majorVersion != rhs.majorVersion {
            return lhs.majorVersion < rhs.majorVersion
        }

        if lhs.minorVersion != rhs.minorVersion {
            return lhs.minorVersion < rhs.minorVersion
        }

        if lhs.patchVersion != rhs.patchVersion {
            return lhs.patchVersion < rhs.patchVersion
        }

        return false
    }

    // 左辺は右辺より大きい
    static func > (lhs: AppVersion, rhs: AppVersion) -> Bool {

        if lhs.majorVersion != rhs.majorVersion {
            return lhs.majorVersion > rhs.majorVersion
        }

        if lhs.minorVersion != rhs.minorVersion {
            return lhs.minorVersion > rhs.minorVersion
        }

        if lhs.patchVersion != rhs.patchVersion {
            return lhs.patchVersion > rhs.patchVersion
        }

        return false
    }

    // 左辺は右辺以下
    static func <= (lhs: AppVersion, rhs: AppVersion) -> Bool {

        if lhs == rhs {
            return true
        }

        return lhs < rhs
    }

    // 左辺は右辺以上
    static func >= (lhs: AppVersion, rhs: AppVersion) -> Bool {

        if lhs == rhs {
            return true
        }

        return lhs > rhs
    }
}
