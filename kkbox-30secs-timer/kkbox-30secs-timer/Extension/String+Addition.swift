//
//  String+Addition.swfit
//  kkbox-30secs-timer
//
//  Created by Yang Tun-Kai on 2018/1/6.
//  Copyright © 2018年 Sparkr. All rights reserved.
//

import Foundation
import SwifterSwift

extension String {
    
    func format() -> String {
        //var newString: String = self.replac
        let string: String = self.replacingOccurrences(of: ":", with: "")
            
        let tempInt: Int = string.int!
        var newString: String = String(format: "%03d", tempInt)
        
        if newString.count >= 6 {
            let index = newString.index(newString.startIndex, offsetBy: 6)
            newString = String(newString.prefix(upTo: index))
        }
        
        for i in stride(from: (newString.count - 2), to: 0, by: -2) {
            let index = newString.index(newString.startIndex, offsetBy: i)
            newString = String(newString.prefix(upTo: index)) + ":" + String(newString.suffix(from: index))
            
        }

        return newString
    }
    
    func toSecond() -> Int {
        let totalSecond = self.splitted(by: ":")
            .reversed()
            .map{Int($0)}
            .enumerated()
            .reduce(0, {(accumulator,current) in
                let (index, element) = current
                return Int(accumulator.double + (element!.double * pow(60.0, index.double)))
            })
        
        return totalSecond
    }
}
