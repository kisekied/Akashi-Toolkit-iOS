//
//  ATAreaModel.swift
//  akashiToolkit
//
//  Created by LarrySue on 2018/1/15.
//  Copyright © 2018年 kcwikizh. All rights reserved.
//

import Foundation
import WCDBSwift

///海域类型
enum ATAreaType: Int32, ColumnCodable {
    
    ///普通海域
    case normal = 0
    ///活动海域
    case event  = 1
    
    // MARK: *** WCDB.ColumnCodable ***
    
    static var columnType: ColumnType {
        get {
            return .integer32
        }
    }
    
    init?(with value: FundamentalValue) {
        self.init(rawValue: value.int32Value)
    }
    
    func archivedValue() -> FundamentalValue {
        return FundamentalValue(self.rawValue)
    }
}

// MARK: -

class ATAreaModel: TableCodable, ATDictCreatable {
    
    // MARK: *** 属性 ***
    
    ///ID
    var identifier: Int?
    ///服务端ID
    var serverId: Int = 0
    ///海域类型
    var type: ATAreaType = .normal
    ///海域名称 (日文
    var name: String = ""
    
    // MARK: *** 构造 ***
    
    convenience required init?(dict: [AnyHashable : AnyObject]) {
        self.init()
        
        if let serverId = dict["id"] as? Int {
            self.serverId = serverId
        }
        if let type = dict["type"] as? Int32 {
            if let type = ATAreaType(rawValue: type) {
                self.type = type
            } else {
                self.type = .normal
            }
        }
        if let name = dict["name"] as? String {
            self.name = name
        }
    }
    
    // MARK: *** WCBD ***
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ATAreaModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        ///ID
        case identifier = "id"
        ///服务端ID
        case serverId
        ///海域类型
        case type
        ///海域名称 (日文
        case name
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                identifier: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true)
            ]
        }
    }
    
    var lastInsertedRowID: Int64 = 0
}
