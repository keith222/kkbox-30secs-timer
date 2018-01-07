//
//  CountDownViewController.swift
//  kkbox-30secs-timer
//
//  Created by Yang Tun-Kai on 2018/1/4.
//  Copyright © 2018年 Sparkr. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
import MediaPlayer

class CountDownViewController: UIViewController {

    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet var buttonGroup: [UIButton]!
    
    private var oldValue: Float? = 1.0
    private var timerData: (index: Int, name: String, second: Int, music: String)?
    fileprivate var isStart: Bool! = false
    fileprivate var timer: Timer?
    fileprivate var webView: WKWebView?
    fileprivate var activityIndicator: UIActivityIndicatorView?
    fileprivate var soundArray: [AVAudioPlayer]? = [AVAudioPlayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for button in buttonGroup {
            button.layer.cornerRadius = button.frame.width / 2
            button.clipsToBounds = true
        }
        webView?.center = circleView.center
        activityIndicator?.center = circleView.center
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AlarmSettingViewController
        destination.countdownData = (index: timerData!.index, name: timerData!.name, time: timerData!.second.secondToTime(), music: timerData!.music)
    }
    
    func setTimerDate(_ index: Int, name: String, time: String, music: String) {
        timerData = (index: index, name: name, second: time.toSecond(), music: music)
        oldValue = timerData?.second.float
    }
    
    private func setUp() {
        countDownLabel.text = timerData?.second.secondToTime()
        
        circleView.transform = CGAffineTransform(rotationAngle: -1.56)
        circleView.animateCircle(to: 1.0)
        
        webView = WKWebView(frame: circleView.frame)
        webView?.layer.cornerRadius = (webView?.frame.width)! / 2
        webView?.clipsToBounds = true
        webView?.navigationDelegate = self
        webView?.isHidden = true

        let url = URL(string: "https://widget.kkbox.com/v1/?id=_-gWo_8me1aCGD8S3R&type=playlist&autoplay=true&loop=true")!
        webView?.load(URLRequest(url: url))
        view.insertSubview(webView!, belowSubview: circleView)
        
        setAudioPlayer()
        
        activityIndicator = UIActivityIndicatorView(frame: circleView.frame)
        activityIndicator?.activityIndicatorViewStyle = .whiteLarge
        activityIndicator?.startAnimating()
        view.insertSubview(activityIndicator!, aboveSubview: webView!)
        
    }
    
    private func setAudioPlayer() {
        for i in 0..<2 {
            do {
                let audioPath = Bundle.main.path(forResource: (i == 0) ? "message-02" : "Timer-Bell", ofType: "m4a")
                let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
                player.prepareToPlay()
                player.delegate = self
                
                soundArray?.append(player)
                
            } catch {
                print(error)
            }
        }
    }
    
    @objc func timeCountdown() {
        timerData?.second -= 1
        
        if (timerData?.second)! >= 0 {
            countDownLabel.text = timerData?.second.secondToTime()
            let endValue = ((timerData?.second.float)! / oldValue!).cgFloat
            circleView.animateCircle(to: endValue)
            
        } else {
            timer?.invalidate()
            timer = nil
            
            webView?.evaluateJavaScript("document.getElementById('audio-player').pause();")

            soundArray![1].play()
        }


        
    }
    
    @IBAction func startStopAction(_ sender: UIButton) {
        if !isStart {
            soundArray![0].play()
            buttonGroup[0].isEnabled = false
        }
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension CountDownViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
        
        webView.evaluateJavaScript("document.getElementsByClassName('widget-cover')[0].style.backgroundSize='240px 240px';document.getElementsByClassName('widget-cover')[0].style.width='240px';document.getElementsByClassName('widget-cover')[0].style.height='240px';document.getElementsByClassName('widget-cover-container')[0].style.padding='0'")
        webView.isHidden = false
        buttonGroup[1].isEnabled = true
    }
}

extension CountDownViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag && !isStart {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeCountdown), userInfo: nil, repeats: true)
            webView?.evaluateJavaScript("document.getElementById('audio-player').play();")
            isStart = !isStart
            
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
