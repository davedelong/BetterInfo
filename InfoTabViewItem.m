//
//  InfoTabViewItem.m
//  BetterInfo
//
//  Created by Dave DeLong on 8/19/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "InfoTabViewItem.h"
#import "NSFileManager+BetterInfo.h"
#import "NSString+FSRef.h"
#import "Common.h"

@implementation InfoTabViewItem

@synthesize path, infoView;
@synthesize kindField, totalSizeField, dataSizeField, resourceSizeField, versionField;
@synthesize createdDatePicker, modifiedDatePicker;

- (id) initWithPath:(NSString *)itemPath {
	if (self = [super initWithIdentifier:@"info"]) {
		[self setLabel:@"Info"];
		[self setPath:itemPath];
		NSNib * nib = [[NSNib alloc] initWithNibNamed:@"InfoTabView" bundle:nil];
		if (![nib instantiateNibWithOwner:self topLevelObjects:nil]) {
			NSLog(@"Unabled to load info view");
			[self release];
			return nil;
		}
		[self setView:[self infoView]];
		
		NSString * type = [[NSFileManager defaultManager] humanReadableTypeStringForItemAtPath:[self path]];
		[kindField setStringValue:type];
		
		BIItemSize sizes = [[NSFileManager defaultManager] sizeOfItemAtPath:[self path]];
		
		[totalSizeField setStringValue:[NSString stringWithFormat:@"%llu on disk (%llu bytes)", sizes.physicalSize, sizes.logicalSize]];
		[dataSizeField setStringValue:[NSString stringWithFormat:@"%llu on disk (%llu bytes)", sizes.dataPhysicalSize, sizes.dataLogicalSize]];
		[resourceSizeField setStringValue:[NSString stringWithFormat:@"%llu on disk (%llu bytes)", sizes.resourcePhysicalSize, sizes.resourceLogicalSize]];
		
		NSBundle * itemBundle = [NSBundle bundleWithPath:[self path]];
		if (itemBundle) {
			NSString * version = [[itemBundle infoDictionary] objectForKey:@"CFBundleGetInfoString"];
			if (version) {
				[versionField setStringValue:version];
			}
		}
		
		NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil];
		if (attributes) {
			NSDate * createDate = [attributes objectForKey:NSFileCreationDate];
			NSDate * modDate = [attributes objectForKey:NSFileModificationDate];
			[createdDatePicker setDateValue:createDate];
			[modifiedDatePicker setDateValue:modDate];
		}
	}
	return self;
}

- (IBAction) changedCreationDate:(id)sender {
	NSMutableDictionary * attributes = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil] mutableCopy];
	[attributes setObject:[createdDatePicker dateValue] forKey:NSFileCreationDate];
	[[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:[self path]];
	[attributes release];
}

- (IBAction) changedModificationDate:(id)sender {
	NSMutableDictionary * attributes = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil] mutableCopy];
	[attributes setObject:[modifiedDatePicker dateValue] forKey:NSFileModificationDate];
	[[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:[self path]];
	[attributes release];
}

@end
