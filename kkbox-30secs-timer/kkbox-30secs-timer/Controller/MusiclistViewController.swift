//
//  MusiclistViewController.swift
//  kkbox-30secs-timer
//
//  Created by Yang Tun-Kai on 2018/1/8.
//  Copyright © 2018年 Sparkr. All rights reserved.
//

import UIKit
import KKBOXOpenAPI

class MusiclistViewController: UIViewController {

    @IBOutlet weak var musiclistTableView: UITableView!
    
    private var kkboxOpenAPI: KKBOXOpenAPI! = KKBOXOpenAPI(clientID: "80a2ed33da2ce623a17dc82e8f8794e8", secret: "eab1fb05bb589614ad797e6a0f7e5489")
    private var listArray: [KKPlaylistInfo] = []
    private var footerView: UIView!
    private var activity: UIActivityIndicatorView!
    
    fileprivate var musicOffset: Int = 0
    fileprivate var flag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUp()
    }
    
    private func setUp() {
        musiclistTableView.delegate = self
        musiclistTableView.dataSource = self
        musiclistTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // set activity indicator in foot view
        footerView = UIView(frame: CGRect(x: 0, y: 5, width: self.view.bounds.size.width, height: 50))
        activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.frame = CGRect(x: (self.view.bounds.size.width - 44) / 2, y: 5, width: 44, height: 44)
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        footerView.addSubview(activity)
        footerView.isHidden = false
        musiclistTableView.tableFooterView = footerView
        
        if kkboxOpenAPI.loggedIn {
            fetchList()
            
        } else {
            getAccessToken{ [weak self] in self?.fetchList() }
        }
    }
    
    private func getAccessToken(completion: @escaping (()->Void)) {
        kkboxOpenAPI.fetchAccessTokenByClientCredential { [weak self]
            accessToken, error in
            if error != nil {
                let alert = UIAlertController(title: "錯誤", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
                    self?.dismiss(animated: true, completion: nil)
                }))
                self?.present(alert, animated: true, completion: nil)
                
                return
            }
            
            completion()
        }
    }
    
    fileprivate func fetchList(from offset: Int = 0) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        activity.startAnimating()
        
        kkboxOpenAPI.fetchFeaturedPlaylists(forTerritory: .taiwan, offset: offset, limit: 20, callback: { [weak self] categories, paging, summary, error in
            UIApplication.shared.endIgnoringInteractionEvents()

            if let error = error {
                self?.flag = false
                print(error)
                
            } else {
                
                self?.flag = ((paging?.offset)! + 20 <= (summary?.total)!)
                self?.musicOffset = (paging?.offset)! + 20
                self?.listArray.append(contentsOf: categories!)
                self?.musiclistTableView.reloadData()
            }
            
            self?.activity.stopAnimating()
            self?.footerView.isHidden = false
        })
    }
    
    @IBAction func dismissAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MusiclistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = listArray[indexPath.row].playlistTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let presenter = presentingViewController as? AlarmSettingViewController {
            presenter.sendData(name: listArray[indexPath.row].playlistTitle, id: listArray[indexPath.row].playlistID)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (contentHeight - scrollView.frame.size.height) - offset < 44 && flag{
            flag = false
            fetchList(from: musicOffset)
        }
    }
}
