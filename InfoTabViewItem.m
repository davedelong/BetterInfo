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

@interface InfoTabViewItem ()

- (void) reloadDates;
- (void) reloadSizes;
- (void) reloadVersion;
- (void) reloadType;

@end


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
		
		[self reloadType];
		[self reloadSizes];
		[self reloadVersion];
		[self reloadDates];
	}
	return self;
}

- (void) reloadDates {
	NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil];
	if (attributes) {
		NSDate * createDate = [attributes objectForKey:NSFileCreationDate];
		NSDate * modDate = [attributes objectForKey:NSFileModificationDate];
		[createdDatePicker setDateValue:createDate];
		[modifiedDatePicker setDateValue:modDate];
	}
}

- (void) reloadSizes {	
	BIItemSize sizes = [[NSFileManager defaultManager] sizeOfItemAtPath:[self path]];
	[totalSizeField setStringValue:[NSString stringWithFormat:@"%llu on disk (%llu bytes)", sizes.physicalSize, sizes.logicalSize]];
	[dataSizeField setStringValue:[NSString stringWithFormat:@"%llu on disk (%llu bytes)", sizes.dataPhysicalSize, sizes.dataLogicalSize]];
	[resourceSizeField setStringValue:[NSString stringWithFormat:@"%llu on disk (%llu bytes)", sizes.resourcePhysicalSize, sizes.resourceLogicalSize]];
}

- (void) reloadVersion {
	NSBundle * itemBundle = [NSBundle bundleWithPath:[self path]];
	if (itemBundle) {
		NSString * version = [[itemBundle infoDictionary] objectForKey:@"CFBundleGetInfoString"];
		if (version) {
			[versionField setStringValue:version];
		}
	}
}

- (void) reloadType {	
	NSString * type = [[NSFileManager defaultManager] humanReadableTypeStringForItemAtPath:[self path]];
	[kindField setStringValue:type];
}

- (IBAction) changedCreationDate:(id)sender {
	NSMutableDictionary * attributes = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil] mutableCopy];
	[attributes setObject:[createdDatePicker dateValue] forKey:NSFileCreationDate];
	[[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:[self path]];
	[attributes release];
	[self reloadDates];
}

- (IBAction) changedModificationDate:(id)sender {
	NSMutableDictionary * attributes = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil] mutableCopy];
	[attributes setObject:[modifiedDatePicker dateValue] forKey:NSFileModificationDate];
	[[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:[self path]];
	[attributes release];
	[self reloadDates];
}

@end
