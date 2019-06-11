//
//  HistoryData+CoreDataProperties.swift
//  
//
//  Created by Mubaarak Hassan on 08/11/2017.
//
//

import Foundation
import CoreData


extension HistoryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryData> {
        return NSFetchRequest<HistoryData>(entityName: "HistoryData")
    }

    @NSManaged public var song: String?
    @NSManaged public var playlist: String?

}
