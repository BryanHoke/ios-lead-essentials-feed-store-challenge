//
//  ManagedCache.swift
//  FeedStoreChallenge
//
//  Created by Bryan Hoke on 8/11/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
	static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
		let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
		return try context.fetch(request).first
	}

	static func deleteCache(in context: NSManagedObjectContext) throws {
		try find(in: context).map(context.delete).map(context.save)
	}

	static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
		try deleteCache(in: context)
		return ManagedCache(context: context)
	}

	var localFeed: [LocalFeedImage] {
		feed.compactMap { ($0 as? ManagedFeedImage)?.local }
	}
}
