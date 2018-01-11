//
//  AlarmSettingViewController.swift
//  kkbox-30secs-timer
//
//  Created by Yang Tun-Kai on 2018/1/3.
//  Copyright © 2018年 Sparkr. All rights reserved.
//

import UIKit
import SwifterSwift

protocol SendListDataDelegate {
    func sendData(name: String, id: String)
}

class AlarmSettingViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeSettingTextField: UITextField!
    @IBOutlet weak var selectButton: UIButton!
    
    fileprivate var delegate: SendListDataDelegate?
    fileprivate var music: String?
    
    var countdownData: (index: String, name: String, time: String, music: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeSettingTextField.delegate = self
        nameTextField.delegate = self
        delegate = self
        
        setDoneButton()
        
        if countdownData != nil {
            setUp()
        }
    }
    
    private func setUp() {
        nameTextField.text = countdownData?.name
        timeSettingTextField.text = countdownData?.time
        selectButton.setTitle(countdownData?.music.splitted(by: ";")[0], for: .normal)
        music = countdownData?.music
    }
    
    private func setDoneButton() {
        let tooBar: UIToolbar = UIToolbar()
        tooBar.barStyle = .default
        tooBar.items=[
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(donePressedAction))]
        
        tooBar.sizeToFit()
        timeSettingTextField.inputAccessoryView = tooBar
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc private func donePressedAction() {
        timeSettingTextField.resignFirstResponder()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard !(nameTextField.text?.isEmpty)! && !(timeSettingTextField.text?.isEmpty)! && (selectButton.title(for: .normal) != "選擇音樂清單") else {
            let alertController = UIAlertController(title: "提示", message: "喔喔，資料沒有輸入完全唷！", preferredStyle: .alert)
                
            alertController.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
                
            return
        }

        var data: [[String]] = [["0", nameTextField.text!, timeSettingTextField.text!, music!]]
        var timerArray: Array = UserDefaults.standard.array(forKey: "TimerData") as? [[String]] ?? [[String]]()
        if timerArray.isEmpty {
            UserDefaults.standard.set(data, forKey: "TimerData")
            
        } else {
            if countdownData != nil {
                data[0][0] = (countdownData?.index)!
                timerArray[timerArray.index(where: {$0[0] == countdownData?.index})!] = data[0]
                
            } else {
                let index = timerArray.last![0].int! + 1
                data[0][0] = (index.string)
                print(data)
                timerArray.append(contentsOf: data)
            }
            
            UserDefaults.standard.set(timerArray, forKey: "TimerData")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        sender.text = sender.text?.format()
    }
    
    
}

extension AlarmSettingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension AlarmSettingViewController: SendListDataDelegate {
    
    func sendData(name: String, id: String) {
        selectButton.setTitle(name, for: .normal)
        music = "\(name);\(id)"
    }
}
