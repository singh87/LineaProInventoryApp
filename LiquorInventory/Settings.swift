//
//  Settings.swift
//  LiquorInventory
//
//  Created by Jasvinder Singh on 5/31/19.
//  Copyright © 2019 Jasvinder Singh. All rights reserved.
//

import UIKit
import InfineaSDK

private let reuseIdentifier = "SettingsCell"

class Settings: UIViewController{
    
    // Properties
    var tableView: UITableView!
    let scanner = IPCDTDevices.sharedDevice()
    // Init
    override func viewDidLoad() {
        super.viewDidLoad()
        let scanner = IPCDTDevices.sharedDevice()
        scanner?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureUI()
        tableView.reloadData()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tableView.removeFromSuperview()
    }
    
    func configureTableView(){
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        tableView.tableFooterView = UIView()
        
    }
    func configureUI(){
        configureTableView()
    }
   
}
extension Settings: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else {return 0}
        
        switch section{
        case .Scanner: return ScannerSettings.allCases.count
        case .App: return AppSettings.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = SettingsSection(rawValue: indexPath.section) else {return UITableViewCell()}
        
        switch section{
        case .App:
            print("TODO APP")
        case .Scanner:
            let device = ScannerSettings(rawValue: indexPath.row)
            cell.sectionType = device
        }
        return cell
    }
    
}
extension Settings: IPCDTDeviceDelegate{
    func connectionState(_ state: Int32) {
        switch state {
        case CONN_STATES.DISCONNECTED.rawValue:
            break
        case CONN_STATES.CONNECTING.rawValue:
            break
        case CONN_STATES.CONNECTED.rawValue:
            print("lol")
        default:
            print("lol2")
        }
    }
}
