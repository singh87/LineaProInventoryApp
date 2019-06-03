//
//  SettingsCell.swift
//  LiquorInventory
//
//  Created by Jasvinder Singh on 5/31/19.
//  Copyright © 2019 Jasvinder Singh. All rights reserved.
//

import UIKit
import InfineaSDK
class SettingsCell: UITableViewCell {
    
    // Properties
    
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
            switchControl.isOn = getSetting(setting: sectionType)
        }
    }

    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.addTarget(self, action: #selector(switchActionHandler), for: .valueChanged)
        return switchControl
    }()
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    // Selectors
    
    @objc func switchActionHandler(sender: UISwitch){
        if sender.isOn {
            changeSettingOn(setting: self.sectionType!)
        }else{
            changeSettingOff(setting: self.sectionType!)
        }
    }
    func getSetting(setting: SectionType) -> Bool{
        let scanner = IPCDTDevices.sharedDevice()
        let enabled_bool = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        let enabled_int = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        switch setting{
        case ScannerSettings.passThroughSync:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                try! scanner?.getPassThroughSync(enabled_bool)
                return enabled_bool.pointee.boolValue
            }
        case ScannerSettings.backupCharge:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                try! scanner?.getCharging(enabled_bool)
                return enabled_bool.pointee.boolValue
            }
        case ScannerSettings.beepUponScan:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                return false
            }
        case ScannerSettings.scanButton:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                try! scanner?.barcodeGetScanButtonMode(enabled_int)
                return (enabled_int.pointee==BUTTON_STATES.ENABLED.rawValue)
            }
//        case ScannerSettings.setTimeout:
//            return false
        case ScannerSettings.resetBarcodeEngine:
            return false
//        case ScannerSettings.scanEngineFirmware:
//            return false
        case ScannerSettings.scannerIllumination:
            return false
        default: return true
        }
   return false
    }
    func changeSettingOn(setting: SectionType) -> Bool{
        let scanner = IPCDTDevices.sharedDevice()
        switch setting{
        case ScannerSettings.passThroughSync:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                try! scanner?.setPassThroughSync(true)
                return true
            }
        case ScannerSettings.backupCharge:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                try! scanner?.setCharging(true)
                return true
            }
        case ScannerSettings.beepUponScan:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                return false
            }
        case ScannerSettings.scanButton:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                try! scanner?.barcodeSetScanButtonMode(BUTTON_STATES.ENABLED.rawValue)
            }
//        case ScannerSettings.setTimeout:
//            return false
        case ScannerSettings.resetBarcodeEngine:
            return false
//        case ScannerSettings.scanEngineFirmware:
//            return false
        case ScannerSettings.scannerIllumination:
            return false
        default: return true
        }
        return true
    }
    func changeSettingOff(setting: SectionType) -> Bool{
        let scanner = IPCDTDevices.sharedDevice()
        switch setting{
        case ScannerSettings.passThroughSync:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                try! scanner?.setPassThroughSync(false)
                return true
            }
        case ScannerSettings.backupCharge:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                try! scanner?.setCharging(false)
                return true
            }
        case ScannerSettings.beepUponScan:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                return false
            }
        case ScannerSettings.scanButton:
            if scanner?.connstate==CONN_STATES.CONNECTED.rawValue{
                try! scanner?.barcodeSetScanButtonMode(BUTTON_STATES.DISABLED.rawValue)
            }
//        case ScannerSettings.setTimeout:
//            return false
        case ScannerSettings.resetBarcodeEngine:
            return false
//        case ScannerSettings.scanEngineFirmware:
//            return false
        case ScannerSettings.scannerIllumination:
            return false
        default: return true
        }
        return false
    }
}
