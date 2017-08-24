//
//  Todo+CoreDataProperties.swift
//  todoListWithRxSwift
//
//  Created by DatouHsu on 2017/8/23.
//  Copyright © 2017年 datouHsu. All rights reserved.
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func todoFetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var isCompleted: Bool
    @NSManaged public var todo: String?

}
