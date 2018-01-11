//
//  ViewController.swift
//  kkbox-30secs-timer
//
//  Created by Yang Tun-Kai on 2018/1/3.
//  Copyright © 2018年 Sparkr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var alertLabel: UILabel!
    fileprivate var dataArray: [[String]]? {
        didSet {
            listTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let timeData = UserDefaults.standard.array(forKey: "TimerData") as? [[String]] {
            dataArray = timeData
            alertLabel.isHidden = true
            
        } else {
            listTableView.backgroundColor = .clear
            alertLabel.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listTableView.tableHeaderView?.size.height = view.frame.height - 70
    } 
    
    private func setUp() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = 70
        listTableView.allowsSelectionDuringEditing = true
        listTableView.tableFooterView = UIView()
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        listTableView.setEditing((sender.title == "編輯"), animated: true)
        sender.title = (sender.title == "編輯") ? "完成" : "編輯"
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountdownCell = tableView.dequeueReusableCell(withIdentifier: "CountdownCell") as! CountdownCell
        cell.titleLabel.text = dataArray![indexPath.row][1]
        cell.timeLabel.text = dataArray![indexPath.row][2]
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing{
            let destination: CountDownViewController = self.storyboard?.instantiateViewController(withIdentifier: "CountDownViewController") as! CountDownViewController
            destination.setTimerDate(dataArray![indexPath.row][0], name: dataArray![indexPath.row][1], time: dataArray![indexPath.row][2], music: dataArray![indexPath.row][3])
            
            present(destination, animated: true, completion: nil)
            
        } else {
            let destination: AlarmSettingViewController = self.storyboard?.instantiateViewController(withIdentifier: "AlarmSettingViewController") as! AlarmSettingViewController
            destination.countdownData = (index: dataArray![indexPath.row][0], name: dataArray![indexPath.row][1], time: dataArray![indexPath.row][2], music: dataArray![indexPath.row][3])
            present(destination, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataArray?.remove(at: indexPath.row)
            UserDefaults.standard.set(dataArray, forKey: "TimerData")
            tableView.reloadData()
        }
    }
}

