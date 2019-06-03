//
//  SettingsSection.swift
//  LiquorInventory
//
//  Created by Jasvinder Singh on 5/31/19.
//  Copyright © 2019 Jasvinder Singh. All rights reserved.
//

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Scanner, App
    
    var description: String {
        switch self {
        case .App: return "App Settings"
        case .Scanner: return "Scanner Settings"
        }
    }
}

enum ScannerSettings: Int, CaseIterable, SectionType {
    
    
    case passThroughSync
    case backupCharge
    case beepUponScan
    case scanButton
//    case setTimeout
//    case resetBarcodeEngine
//    case scanEngineFirmware
//    case scannerIllumination
    
    var containsSwitch: Bool {
        switch self{
            case .passThroughSync: return true
            case .backupCharge: return true
            case .beepUponScan: return true
            case .scanButton: return true
//            case .setTimeout: return false
//            case .resetBarcodeEngine: return true
//            case .scanEngineFirmware: return true
//            case .scannerIllumination: return true
        }
    }
    
    var description: String {
        switch self {
        case .passThroughSync: return "Pass Through Sync"
        case .backupCharge: return "Backup Charge"
        case .beepUponScan: return "Beep Upon Scan"
        case .scanButton: return "Scan Button"
//        case .setTimeout: return "Set Timeout in Minutes"
//        case .resetBarcodeEngine: return "Reset Barcode Engine"
//        case .scanEngineFirmware: return "Scan Engine Firmware Info"
//        case .scannerIllumination: return "Scanner Illumination"
        }
    }
}

enum AppSettings: Int, CaseIterable, SectionType {
    case autoAddToList
    
    var containsSwitch: Bool{
        switch self {
        case .autoAddToList: return true
        }
    }
    
    var description: String {
        switch self {
        case .autoAddToList: return "Auto Add on Scan"
        }
    }
}
