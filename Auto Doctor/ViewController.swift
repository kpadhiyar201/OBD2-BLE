//
//  ViewController.swift
//  Auto Doctor
//
//  Created by Kiran on 9/20/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    let bluetoothService = BluetoothService()
    lazy var pairingFlow = PairingFlow(bluetoothService: self.bluetoothService)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.bluetoothService.flowController = self.pairingFlow // 1.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkBluetoothState()
    }
    
    // TODO: probably you should modify current implementation of BluetoothService to notify you about this change
    private func checkBluetoothState() {
        self.statusLabel.text = "Status: bluetooth is \(bluetoothService.bluetoothState == .poweredOn ? "ON" : "OFF")"
        
        if self.bluetoothService.bluetoothState != .poweredOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.checkBluetoothState() }
        }
    }
    
    @IBAction func didClickOnPair(_ sender: Any) {
        guard self.bluetoothService.bluetoothState == .poweredOn else { return }
 
        self.statusLabel.text = "Status: waiting for peripheral..."
        self.pairingFlow.waitForPeripheral { // start flow
            
            self.statusLabel.text = "Status: connecting..."
            self.pairingFlow.pair { result in // continue with next step
                self.statusLabel.text = "Status: pairing \(result ? "successful" : "failed")"
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func didClickOnAvailableDevices(_ sender: UIButton) {
        let vc = AvailableDevicesVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didClickOnLTAutomotiveObjCDemo(_ sender: UIButton) {
        let vc = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "LTSupportAutomotiveVC") as! LTSupportAutomotiveVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

