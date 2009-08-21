//
//  PermissionsTabViewItem.m
//  BetterInfo
//
//  Created by Dave DeLong on 8/19/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "PermissionsTabViewItem.h"
#import "NSFileManager+BetterInfo.h"
#import "BetterInfoAppDelegate.h"

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
- (void) reloadOwnerAndGroups;

@end


@implementation PermissionsTabViewItem

@synthesize path, permissionsView;
@synthesize ownerReadButton, ownerWriteButton, ownerExecuteButton;
@synthesize groupReadButton, groupWriteButton, groupExecuteButton;
@synthesize worldReadButton, worldWriteButton, worldExecuteButton;
@synthesize usersPopup, groupsPopup;

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
		[self reloadOwnerAndGroups];
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

- (void) reloadOwnerAndGroups {
	NSDictionary * attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil];
	BetterInfoAppDelegate * appD = (BetterInfoAppDelegate *)[NSApp delegate];
	[usersPopup removeAllItems];
	[usersPopup addItemsWithTitles:[appD users]];
	[usersPopup selectItemWithTitle:[attributes objectForKey:NSFileOwnerAccountName]];
	
	[groupsPopup removeAllItems];
	[groupsPopup addItemsWithTitles:[appD groups]];
	[groupsPopup selectItemWithTitle:[attributes objectForKey:NSFileGroupOwnerAccountName]];
}

- (IBAction) permissionsChanged:(id)sender {
	int newPermissions = 0;
	newPermissions |= ([ownerReadButton state] ? OWNER_RD : 0);
	newPermissions |= ([ownerWriteButton state] ? OWNER_WR : 0);
	newPermissions |= ([ownerExecuteButton state] ? OWNER_EX : 0);
	
	newPermissions |= ([groupReadButton state] ? GROUP_RD : 0);
	newPermissions |= ([groupWriteButton state] ? GROUP_WR : 0);
	newPermissions |= ([groupExecuteButton state] ? GROUP_EX : 0);
	
	newPermissions |= ([worldReadButton state] ? WORLD_RD : 0);
	newPermissions |= ([worldWriteButton state] ? WORLD_WR : 0);
	newPermissions |= ([worldExecuteButton state] ? WORLD_EX : 0);
	
	NSMutableDictionary * attributes = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self path] error:nil] mutableCopy];
	[attributes setObject:[NSNumber numberWithInt:newPermissions] forKey:NSFilePosixPermissions];
	[[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:[self path]];
	[attributes release];
	
	[self reloadPermissions];
}

- (IBAction) ownerChanged:(id)sender {
	
}

- (IBAction) groupChanged:(id)sender {
	
}

@end
