//
//  BattleGrid.swift
//  SimpleDungeon
//
//  Created by Todd Greener on 1/24/16.
//  Copyright © 2016 Todd Greener. All rights reserved.
//

import Foundation

protocol BattleGrid {
    var numColumns : UInt { get }
    var numRows : UInt { get }
    var size : UInt { get }
    var positions : [BattleGridPosition] { get }
    
    func getEntityAt(column : UInt, row : UInt) throws -> Entity?
    mutating func placeEntity(entity : Entity, column : UInt, row : UInt) throws
}

protocol BattleGridPosition {
    var entity : Entity? { get }
    var position : UIPoint { get }
}

struct BaseBattleGrid : BattleGrid {
    
    enum BattleGridError : ErrorType{
        case OutOfBoundsError
    }
    
    struct GridPosition : BattleGridPosition {
        let entity : Entity?
        let position : UIPoint
        init(entity : Entity?, position : UIPoint) {
            self.entity = entity
            self.position = position
        }
    }
    
    var positions : [BattleGridPosition]
    let numColumns : UInt
    let numRows : UInt
    var size : UInt { get { return numColumns * numRows } }
    
    init() {
        self.init(numColumns: 2, numRows: 3);
    }
    
    init(numColumns : UInt, numRows : UInt) {
        self.numColumns = numColumns
        self.numRows = numRows
        
        positions = [BattleGridPosition]()
        positions.reserveCapacity(Int(self.size))
        for pos in 0..<self.size {
            let x : UInt = pos / numRows
            let y : UInt = pos % numRows
            positions.append(GridPosition(entity: nil, position: UIPoint(x: x, y: y)))
        }
    }
    
    mutating func placeEntity(entity : Entity, column : UInt, row : UInt) throws {
        guard column < numColumns && row < numRows else  { throw BattleGridError.OutOfBoundsError }
        
        positions[Int((column * numRows) + row)] = GridPosition(entity: entity, position: UIPoint(x: column, y: row))
    }
    
    func getEntityAt(column : UInt, row : UInt) throws -> Entity? {
        guard column < numColumns && row < numRows else  { throw BattleGridError.OutOfBoundsError }
        
        return positions[Int((column * numRows) + row)].entity
    }
    
    func getGridPositionAt(column : UInt, row : UInt) throws -> BattleGridPosition {
        guard column < numColumns && row < numRows else  { throw BattleGridError.OutOfBoundsError }
        
        return positions[Int((column * numRows) + row)]
    }
}
