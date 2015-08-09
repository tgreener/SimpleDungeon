//
//  Math.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/7/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

public func random(minVal: UInt, maxVal: UInt) -> UInt {
    assert(minVal <= maxVal, "In function random(minVal: UInt, maxVal: UInt) maxVal must be greater than minVal.")
    return UInt(arc4random_uniform(UInt32(maxVal) - UInt32(minVal))) + minVal
}