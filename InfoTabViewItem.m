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
#import "BIByteFormatter.h"

@interface InfoTabViewItem ()

- (void) reloadDates;
- (void) reloadSizes;
- (void) reloadVersion;
- (void) reloadType;
- (void) reloadExtensionAndLocked;

@end


@implementation InfoTabViewItem

@synthesize path, infoView;
@synthesize kindField, totalSizeField, dataSizeField, resourceSizeField, versionField;
@synthesize createdDatePicker, modifiedDatePicker;
@synthesize sizeProgressBar;
@synthesize extensionHiddenButton, invisibleButton, lockedButton;

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
		[self reloadExtensionAndLocked];
	}
	return self;
}

- (void) reloadExtensionAndLocked {
	NSString * name = [[self path] lastPathComponent];
	NSString * extension = [name pathExtension];
	[extensionHiddenButton setEnabled:(![extension isEqualToString:@""])];
	NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil];
	[extensionHiddenButton setState:[attributes fileExtensionHidden]];
}

- (void) reloadDates {
	NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil];
	if (attributes) {
		[createdDatePicker setDateValue:[attributes fileCreationDate]];
		[modifiedDatePicker setDateValue:[attributes fileModificationDate]];
	}
}

- (void) computeSizes {
	NSAutoreleasePool * sizePool = [[NSAutoreleasePool alloc] init];
	itemSize = [[NSFileManager defaultManager] sizeOfItemAtPath:[self path]];
	[self performSelectorOnMainThread:@selector(updateSizes) withObject:nil waitUntilDone:NO];
	[sizePool release];
}

- (void) reloadSizes {	
	[totalSizeField setHidden:YES];
	[sizeProgressBar setIndeterminate:YES];
	[sizeProgressBar setUsesThreadedAnimation:YES];
	[sizeProgressBar startAnimation:self];
	[sizeProgressBar setHidden:NO];
	[NSThread detachNewThreadSelector:@selector(computeSizes) toTarget:self withObject:nil];
}

- (void) updateSizes {
	[sizeProgressBar stopAnimation:self];
	[sizeProgressBar setHidden:YES];
	[totalSizeField setHidden:NO];
	
	NSString * format = @"%@ on disk (%@)%@";
	
	BIByteFormatter * formatter = [[BIByteFormatter alloc] init];
	NSString * physical = [formatter stringForObjectValue:[NSNumber numberWithUnsignedLongLong:itemSize.physicalSize]];
	NSString * dataPhysical = [formatter stringForObjectValue:[NSNumber numberWithUnsignedLongLong:itemSize.dataPhysicalSize]];
	NSString * resourcePhysical = [formatter stringForObjectValue:[NSNumber numberWithUnsignedLongLong:itemSize.resourcePhysicalSize]];
	
	[formatter setConvertsToBestUnit:NO];
	NSString * logical = [formatter stringForObjectValue:[NSNumber numberWithUnsignedLongLong:itemSize.logicalSize]];
	NSString * dataLogical = [formatter stringForObjectValue:[NSNumber numberWithUnsignedLongLong:itemSize.dataLogicalSize]];
	NSString * resourceLogical = [formatter stringForObjectValue:[NSNumber numberWithUnsignedLongLong:itemSize.resourceLogicalSize]];
	
	NSString * fileCount = (itemSize.fileCount > 0 ? [NSString stringWithFormat:@" for %llu item%@", itemSize.fileCount, (itemSize.fileCount == 1 ? @"" : @"s")] : @"");
	[totalSizeField setStringValue:[NSString stringWithFormat:format, physical, logical, fileCount]];
	[dataSizeField setStringValue:[NSString stringWithFormat:format, dataPhysical, dataLogical, @""]];
	[resourceSizeField setStringValue:[NSString stringWithFormat:format, resourcePhysical, resourceLogical, @""]];
	
	[formatter release];
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

- (IBAction) changedExtensionHiddenFlag:(id)sender {
	NSMutableDictionary * attributes = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil] mutableCopy];
	NSNumber * hidden = [NSNumber numberWithInt:[extensionHiddenButton state]];
	[attributes setObject:hidden forKey:NSFileExtensionHidden];
	[[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:[self path]];
	[attributes release];
	[self reloadExtensionAndLocked];
}

@end
