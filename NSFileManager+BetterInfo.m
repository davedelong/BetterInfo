//
//  NSFileManager+BetterInfo.m
//  BetterInfo
//
//  Created by Dave DeLong on 8/19/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "NSFileManager+BetterInfo.h"
#import "NSString+FSRef.h"

@implementation NSFileManager (BetterInfo)

- (BIItemSize) _sizeOfItemForFSRef:(FSRef *)theFileRef {
    FSIterator thisDirEnum = NULL;
	BIItemSize size;
	BIItemSizeClearSize(size);
	
    // Iterate the directory contents, recursing as necessary
    if (FSOpenIterator(theFileRef, kFSIterateFlat, &thisDirEnum) == noErr) {
        const ItemCount kMaxEntriesPerFetch = 40;
        ItemCount actualFetched;
        FSRef    fetchedRefs[kMaxEntriesPerFetch];
        FSCatalogInfo fetchedInfos[kMaxEntriesPerFetch];
		
		OSErr fsErr = FSGetCatalogInfoBulk(thisDirEnum,  
										   kMaxEntriesPerFetch, 
										   &actualFetched,
										   NULL, 
										   kFSCatInfoDataSizes | kFSCatInfoNodeFlags | kFSCatInfoRsrcSizes,
										   fetchedInfos,
										   fetchedRefs, 
										   NULL, 
										   NULL);
        while ((fsErr == noErr) || (fsErr == errFSNoMoreItems)) {
            ItemCount thisIndex;
            for (thisIndex = 0; thisIndex < actualFetched; thisIndex++) {
                // Recurse if it's a folder
                if (fetchedInfos[thisIndex].nodeFlags & kFSNodeIsDirectoryMask) {
					BIItemSize subSize = [self _sizeOfItemForFSRef:&fetchedRefs[thisIndex]];
					BIItemSizeAddSizes(size, subSize);
					//need to count the folder itself
					size.fileCount++;
                } else {
                    // add the size for this item
					BIItemSizeAddCatalogInfo(size, fetchedInfos[thisIndex]);
                }
            }
			
            if (fsErr == errFSNoMoreItems) {
                break;
            } else {
                // get more items
                fsErr = FSGetCatalogInfoBulk(thisDirEnum,  
											 kMaxEntriesPerFetch, 
											 &actualFetched,
											 NULL, 
											 kFSCatInfoDataSizes | kFSCatInfoNodeFlags | kFSCatInfoRsrcSizes, 
											 fetchedInfos,
											 fetchedRefs, 
											 NULL, 
											 NULL);
            }
        }
        FSCloseIterator(thisDirEnum);
    }
    return size;
}


- (NSString *)humanReadableTypeStringForItemAtPath:(NSString *)path{
	NSString *kind = nil;
	NSURL *url = [NSURL fileURLWithPath:[path stringByExpandingTildeInPath]];
	LSCopyKindStringForURL((CFURLRef)url, (CFStringRef *)&kind);
	return kind ? [kind autorelease] : @"n/a";
}

- (BIItemSize)sizeOfItemAtPath:(NSString *)path {
	FSRef itemRef = [path fsref];
	
	FSCatalogInfo itemInfo;
	BIItemSize size;
	BIItemSizeClearSize(size);
	OSErr err = FSGetCatalogInfo(&itemRef,  kFSCatInfoDataSizes | kFSCatInfoNodeFlags | kFSCatInfoRsrcSizes, &itemInfo, NULL, NULL, NULL);
	if (!err && (itemInfo.nodeFlags & kFSNodeIsDirectoryMask) == NO) {
		//just a file
		BIItemSizeAddCatalogInfo(size, itemInfo);
	} else {
		size = [self _sizeOfItemForFSRef:&itemRef];
	}
	//we don't count the item itself; only sub-items
	size.fileCount--;
	return size;
}

- (void) setAttributes:(NSDictionary *)attributes ofItemAtPath:(NSString *)path {
	NSError * error = nil;
	[self setAttributes:attributes ofItemAtPath:path error:&error];
	if (error) {
		NSLog(@"Error changing attributes: %@", error);
	}
}

@end
