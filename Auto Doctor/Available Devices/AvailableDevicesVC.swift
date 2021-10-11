//
//  AvailableDevicesVC.swift
//  Auto Doctor
//
//  Created by Kiran on 9/20/21.
//

import UIKit
import CoreBluetooth

class AvailableDevicesVC: UIViewController {

    class func viewController() -> AvailableDevicesVC {
        let vc = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "AvailableDevicesVC") as! AvailableDevicesVC
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let scanningDelay = 1.0
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral!
    var array: [CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(type: AvailableDeviceCell.self)
//        tableView.tableHeaderView = UIView.init(frame: .zero)
//        tableView.tableFooterView = UIView.init(frame: .zero)
        
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        centralManager.delegate = self
    }

    func setupMenuBarButtons() {
        self.navigationItem.leftBarButtonItem = self.leftMenuBarButtonItem()
        self.navigationItem.rightBarButtonItem = self.rightMenuBarButtonItem()
    }
    
    func leftMenuBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "back_arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftSideMenuButtonPressed(_:)))
    }
    
    @objc func leftSideMenuButtonPressed(_ sender: UIBarButtonItem?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightMenuBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem.init(title: "Submit", style: .plain, target:self , action: #selector(rightSideMenuButtonPressed(_:)))
    }
    
    @objc func rightSideMenuButtonPressed(_ sender: UIBarButtonItem) {
        print("Submit")
    }
}

extension AvailableDevicesVC: CBCentralManagerDelegate, CBPeripheralDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(#function)
        if central.state == CBManagerState.poweredOn {
            print("BLE powered on")
            // Turned on
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                print("start scanning")
                let option:[String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey: false]
                self.centralManager.scanForPeripherals(withServices: nil, options: option)
//                self.centralManager.retrieveConnectedPeripherals(withServices: [])
            }
//            _manager?.scanForPeripherals(withServices: [serviceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
        }
        else {
            print("Something wrong with BLE")
            // Not on, but can have different issues
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(#function)
        print(error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print(#function)
        print(error)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(#function)
        didReadPeripheral(peripheral, rssi: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print(#function)
        self.myPeripheral.discoverServices(nil)
        peripheral.readRSSI()
        central.stopScan()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(#function)
        print(error)
        if let services = peripheral.services {
            //discover characteristics of services
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print(#function)
        print(error)
        if let charac = service.characteristics {
            for characteristic in charac {
                print(characteristic.uuid)
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print(#function)
        print(error)
        didReadPeripheral(peripheral, rssi: RSSI)
        delay(scanningDelay){
            peripheral.readRSSI()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print(#function)
        print(error)
    }
    
    fileprivate func didReadPeripheral(_ peripheral: CBPeripheral, rssi: NSNumber){
        print(#function, peripheral.name)
        if let name = peripheral.name {
            if array.firstIndex(where: { $0.name == name }) == nil {
                array.append(peripheral)
                if name == "VEEPEAK" {
                    centralManager.stopScan()
//                    connect(peripheral)
                }
            }
        }
        tableView.reloadData()
    }
    
    fileprivate func connect(_ peripheral: CBPeripheral) {
        print(#function)
        self.centralManager.stopScan()
        self.myPeripheral = peripheral
        self.myPeripheral.delegate = self
        self.centralManager.connect(peripheral, options: nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print(#function)
        if characteristic.isNotifying {
             print("Notification began on ", characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(#function)
        if characteristic.isNotifying {
             print("Notification began on ", characteristic)
        }
    }
    
    
}

extension AvailableDevicesVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AvailableDeviceCell = tableView.dequeueReusableCell(withIdentifier: AvailableDeviceCell.identifier, for: indexPath) as! AvailableDeviceCell
        cell.textLabel?.text = array[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = array[indexPath.row]
        connect(peripheral)
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
