//
//  AlarmSettingViewController.swift
//  kkbox-30secs-timer
//
//  Created by Yang Tun-Kai on 2018/1/3.
//  Copyright © 2018年 Sparkr. All rights reserved.
//

import UIKit
import SwifterSwift

class AlarmSettingViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeSettingTextField: UITextField!
    
    var countdownData: (index: Int, name: String, time: String, music: String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeSettingTextField.delegate = self
        nameTextField.delegate = self
        
        setDoneButton()
        
        if countdownData != nil {
            setUp()
        }
    }
    
    private func setUp() {
        nameTextField.text = countdownData?.name
        timeSettingTextField.text = countdownData?.time
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
        guard !(nameTextField.text?.isEmpty)! && !(timeSettingTextField.text?.isEmpty)! else {
            let alertController = UIAlertController(title: "提示", message: "喔喔，資料沒有輸入完全唷！", preferredStyle: .alert)
                
            alertController.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
                
            return
        }
        
        let data: [[String]] = [[nameTextField.text!, timeSettingTextField.text!, ""]]
        var timerArray: Array = UserDefaults.standard.array(forKey: "TimerData") as? [[String]] ?? [[String]]()
        if timerArray.isEmpty {
            UserDefaults.standard.set(data, forKey: "TimerData")
            
        } else {
            if countdownData != nil {
                timerArray[(countdownData?.index)!] = data[0]
                
            } else {
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
