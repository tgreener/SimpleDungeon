//
//  IPoint.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 8/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

struct IPoint {
    let x : Int
    let y : Int
    
    init(x : Int, y : Int) {
        self.x = x
        self.y = y
    }
}

struct UIPoint {
    let x : UInt
    let y : UInt
    
    var ix : Int { get { return Int(x) } }
    var iy : Int { get { return Int(y) } }
    
    init(x : UInt, y : UInt) {
        self.x = x
        self.y = y
    }
}
