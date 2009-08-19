//
//  BetterInfoWindowController.m
//  BetterInfo
//
//  Created by Dave DeLong on 8/18/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "BetterInfoDocument.h"
#import "InfoTabViewItem.h"
#import "BetterInfoWindowController.h"


@implementation BetterInfoDocument
@synthesize itemPath;
@synthesize tabView;
@synthesize fileNameField, filePathField, fileImageView;

- (id) initWithURL:(NSURL *)url {
	if (self = [super init]) {
		[self setItemPath:[url path]];
		infoTab = [[InfoTabViewItem alloc] initWithPath:[self itemPath]];
	}
	return self;
}

- (void) dealloc {
	[infoTab release], infoTab = nil;
	[itemPath release], itemPath = nil;
	[super dealloc];
}

- (NSString *)windowNibName {
    return @"BetterInfoDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController {
    [super windowControllerDidLoadNib:aController];
	
	NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self itemPath] error:nil];
	NSLog(@"Attributes: %@", attributes);
	
	[fileNameField setStringValue:[[NSFileManager defaultManager] displayNameAtPath:[self itemPath]]];
	[filePathField setStringValue:[self itemPath]];
	
	NSImage * image = [[NSWorkspace sharedWorkspace] iconForFile:[self itemPath]];
	[fileImageView setImage:image];
	
	[tabView addTabViewItem:infoTab];
}

@end
