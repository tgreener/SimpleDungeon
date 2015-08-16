//
//  Notifier.swift
//  TextRPG
//
//  Created by Todd Greener on 4/19/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//


import Foundation

class Notifier<ListenerType> {
    var listeners : [ListenerType] = [ListenerType]()
    var listenerIndexes : [String: Int] = [String: Int]()
    
    func addListener(listener: ListenerType) {
        listeners.append(listener)
    }
    
    func addListenerWithName(listener: ListenerType, name : String) {
        addListener(listener)
        listenerIndexes[name] = listeners.endIndex - 1
    }
    
    func removeListener(#named : String) {
        if let index = listenerIndexes[named] { listeners.removeAtIndex(index) }
    }
    
    func removeAllListeners() {
        listeners.removeAll(keepCapacity: false)
    }
    
    func notify(closure: (ListenerType) -> Void) {
        for listener in listeners {
            closure(listener)
        }
    }
}

class NotifierListenerWrapper<ListenerType : AnyObject> {
    let value : ListenerType // TODO: Use this once the compiler is updated. The unowned and AnyObject parts throw it for a loop (figuratively).
    init(value: ListenerType) {
        self.value = value
    }
}
