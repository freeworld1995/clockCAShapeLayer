//
//  Utils.swift
//  ClockCALayer
//
//  Created by Jimmy Hoang on 2/14/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//
import Foundation
import UIKit

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

extension Double {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}
