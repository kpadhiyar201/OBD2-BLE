//
//  BluetoothCommands.swift
//  Auto Doctor
//
//  Created by mac on 02/10/21.
//

import Foundation
import CoreBluetooth

extension BluetoothService {
    
    func getSettings() {
        self.peripheral?.readValue(for: self.dataCharacteristic!)
    }
    
    // TODO: add other methods to expose high level requests to peripheral
}
