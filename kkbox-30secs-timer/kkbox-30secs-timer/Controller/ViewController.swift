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
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    fileprivate var dataArray: [[String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let timeData = UserDefaults.standard.array(forKey: "TimerData") as? [[String]] {
            dataArray = timeData
            listTableView.reloadData()
            alertLabel.isHidden = true
        } else {
            listTableView.backgroundColor = .clear
            alertLabel.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        settingButton.layer.cornerRadius = settingButton.frame.width / 2
        settingButton.clipsToBounds = true
        
        listTableView.tableHeaderView?.size.height = view.frame.height - 70
    }
    
    private func setUp() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableFooterView = UIView()
        listTableView.contentInset = UIEdgeInsetsMake(0, 0, 22, 0)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountdownCell = tableView.dequeueReusableCell(withIdentifier: "CountdownCell") as! CountdownCell
        cell.titleLabel.text = dataArray![indexPath.row][0]
        cell.timeLabel.text = dataArray![indexPath.row][1]
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination: CountDownViewController = self.storyboard?.instantiateViewController(withIdentifier: "CountDownViewController") as! CountDownViewController
        destination.setTimerDate(indexPath.row, name: dataArray![indexPath.row][0], time: dataArray![indexPath.row][1], music: dataArray![indexPath.row][2])
        
        present(destination, animated: true, completion: nil)
    }
}

