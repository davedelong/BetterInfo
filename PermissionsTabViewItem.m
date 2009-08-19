//
//  PermissionsTabViewItem.m
//  BetterInfo
//
//  Created by Dave DeLong on 8/19/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "PermissionsTabViewItem.h"
#import "NSFileManager+BetterInfo.h"

#define OWNER_RD 1<<8
#define OWNER_WR 1<<7
#define OWNER_EX 1<<6

#define GROUP_RD 1<<5
#define GROUP_WR 1<<4
#define GROUP_EX 1<<3

#define WORLD_RD 1<<2
#define WORLD_WR 1<<1
#define WORLD_EX 1<<0

@interface PermissionsTabViewItem ()

- (void) reloadPermissions;

@end


@implementation PermissionsTabViewItem

@synthesize path, permissionsView;
@synthesize ownerReadButton, ownerWriteButton, ownerExecuteButton;
@synthesize groupReadButton, groupWriteButton, groupExecuteButton;
@synthesize worldReadButton, worldWriteButton, worldExecuteButton;

- (id) initWithPath:(NSString *)itemPath {
	if (self = [super initWithIdentifier:@"perms"]) {
		[self setLabel:@"Permissions"];
		[self setPath:itemPath];
		NSNib * nib = [[NSNib alloc] initWithNibNamed:@"PermissionsTabView" bundle:nil];
		if (![nib instantiateNibWithOwner:self topLevelObjects:nil]) {
			NSLog(@"Unabled to load permissions view");
			[self release];
			return nil;
		}
		[self setView:[self permissionsView]];
		
		[self reloadPermissions];
	}
	return self;
}

- (void) reloadPermissions {
	NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil];
	NSNumber * perms = [attributes objectForKey:NSFilePosixPermissions];
	int permissions = [perms intValue];
	NSLog(@"Permissions: %o", permissions);
	[ownerReadButton setState:(permissions & OWNER_RD ? NSOnState : NSOffState)];
	[ownerWriteButton setState:(permissions & OWNER_WR ? NSOnState : NSOffState)];
	[ownerExecuteButton setState:(permissions & OWNER_EX ? NSOnState : NSOffState)];
	
	[groupReadButton setState:(permissions & GROUP_RD ? NSOnState : NSOffState)];
	[groupWriteButton setState:(permissions & GROUP_WR ? NSOnState : NSOffState)];
	[groupExecuteButton setState:(permissions & GROUP_EX ? NSOnState : NSOffState)];
	
	[worldReadButton setState:(permissions & WORLD_RD ? NSOnState : NSOffState)];
	[worldWriteButton setState:(permissions & WORLD_WR ? NSOnState : NSOffState)];
	[worldExecuteButton setState:(permissions & WORLD_EX ? NSOnState : NSOffState)];
}

- (IBAction) permissionsChanged:(id)sender {
	int newPermissions = 0;
	if ([ownerReadButton state] == NSOnState) { newPermissions |= OWNER_RD; }
	if ([ownerWriteButton state] == NSOnState) { newPermissions |= OWNER_WR; }
	if ([ownerExecuteButton state] == NSOnState) { newPermissions |= OWNER_EX; }
	
	if ([groupReadButton state] == NSOnState) { newPermissions |= GROUP_RD; }
	if ([groupWriteButton state] == NSOnState) { newPermissions |= GROUP_WR; }
	if ([groupExecuteButton state] == NSOnState) { newPermissions |= GROUP_EX; }
	
	if ([worldReadButton state] == NSOnState) { newPermissions |= WORLD_RD; }
	if ([worldWriteButton state] == NSOnState) { newPermissions |= WORLD_WR; }
	if ([worldExecuteButton state] == NSOnState) { newPermissions |= WORLD_EX; }
	
	NSLog(@"New permissions: %o", newPermissions);
	NSMutableDictionary * attributes = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil] mutableCopy];
	[attributes setObject:[NSNumber numberWithInt:newPermissions] forKey:NSFilePosixPermissions];
	[[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:[self path]];
	[attributes release];
	
	[self reloadPermissions];
}

@end
