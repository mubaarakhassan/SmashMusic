//
//  SongData+CoreDataProperties.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 08/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//
//

import Foundation
import CoreData


extension SongData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SongData> {
        return NSFetchRequest<SongData>(entityName: "SongData")
    }

    @NSManaged public var albumname: String?
    @NSManaged public var artist: String?
    @NSManaged public var artwork: NSData?
    @NSManaged public var duration: Float
    @NSManaged public var title: String?
    @NSManaged public var dateAdded: NSDate?

}
