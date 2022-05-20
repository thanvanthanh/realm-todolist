//
//  TodoModel.swift
//  TodoList
//
//  Created by Thanh - iOS on 19/05/2022.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @Persisted var name = ""
    @Persisted var finished = false
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
