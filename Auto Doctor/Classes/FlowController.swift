//
//  FlowController.swift
//  Auto Doctor
//
//  Created by mac on 02/10/21.
//

import Foundation
import CoreBluetooth

protocol FlowController {
    func bluetoothOn()
    func bluetoothOff()
    func scanStarted()
    func scanStopped()
    func connected(peripheral: CBPeripheral)
    func disconnected(failure: Bool)
    func discoveredPeripheral()
    func readyToWrite()
    func received(response: Data)
    // TODO: add other events if needed
}

// Default implementation for FlowController
extension FlowController {
    func bluetoothOn() { }
    func bluetoothOff() { }
    func scanStarted() { }
    func scanStopped() { }
    func connected(peripheral: CBPeripheral) { }
    func disconnected(failure: Bool) { }
    func discoveredPeripheral() { }
    func readyToWrite() { }
    func received(response: Data) { }
}
