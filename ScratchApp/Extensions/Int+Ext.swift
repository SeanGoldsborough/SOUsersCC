//
//  NumberFormattingExtension.swift
//  ScratchApp
//
//  Created by Sean Goldsborough on 1/3/20.
//  Copyright © 2020 Sean Goldsborough. All rights reserved.
//

import Foundation

extension Int {
    func abbreviateNumber() -> String {
        if self < 1000 {
            return "\(self)"
        }

        if self < 1000000 {
            var n = Double(self);
            n = Double( floor(n/100)/10 )
            return "\(n.description)K"
        }
        return "\(self)"
    }
}
