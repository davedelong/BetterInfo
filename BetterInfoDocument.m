//
//  BetterInfoWindowController.m
//  BetterInfo
//
//  Created by Dave DeLong on 8/18/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "BetterInfoDocument.h"


@implementation BetterInfoDocument
@synthesize itemPath;
@synthesize fileNameField, filePathField, fileImageView;

- (id) initWithURL:(NSURL *)url {
	if (self = [super init]) {
		[self setItemPath:[url path]];
		NSLog(@"Loaded: %@", [self itemPath]);
	}
	return self;
}

- (NSString *)windowNibName {
    return @"BetterInfoDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController {
    [super windowControllerDidLoadNib:aController];
	
	NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self itemPath] error:nil];
	NSLog(@"Attributes: %@", attributes);
	
	NSImage * image = [[NSWorkspace sharedWorkspace] iconForFile:[self itemPath]];
	[fileNameField setStringValue:[[NSFileManager defaultManager] displayNameAtPath:[self itemPath]]];
	[filePathField setStringValue:[self itemPath]];
	[fileImageView setImage:image];
}

@end
