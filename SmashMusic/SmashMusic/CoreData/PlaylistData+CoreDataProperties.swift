//
//  PlaylistData+CoreDataProperties.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 08/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//
//

import Foundation
import CoreData


extension PlaylistData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaylistData> {
        return NSFetchRequest<PlaylistData>(entityName: "PlaylistData")
    }

    @NSManaged public var descriptions: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var songs: NSSet

}

// MARK: Generated accessors for songs
extension PlaylistData {

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: SongData)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: SongData)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSSet)

}
