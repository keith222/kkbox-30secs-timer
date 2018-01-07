//
//  Int+Addition.swift
//  kkbox-30secs-timer
//
//  Created by Yang Tun-Kai on 2018/1/7.
//  Copyright © 2018年 Sparkr. All rights reserved.
//

import Foundation

extension Int {
    
    func secondToTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour]
        formatter.zeroFormattingBehavior = .pad
        let output = formatter.string(from: TimeInterval(self))!
        //print(output.substring(from: output.range(of: ":")!.upperBound) )
        return self < 3600 ? String(output[output.range(of: ":")!.upperBound...]) : output
    }
}
