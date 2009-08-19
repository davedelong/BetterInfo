//
//  PermissionsTabViewItem.h
//  BetterInfo
//
//  Created by Dave DeLong on 8/19/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PermissionsTabViewItem : NSTabViewItem {
	NSString * path;
	NSView * permissionsView;
	
	NSButton * ownerReadButton;
	NSButton * ownerWriteButton;
	NSButton * ownerExecuteButton;
	NSButton * groupReadButton;
	NSButton * groupWriteButton;
	NSButton * groupExecuteButton;
	NSButton * worldReadButton;
	NSButton * worldWriteButton;
	NSButton * worldExecuteButton;
}

@property (nonatomic, assign) NSString * path;
@property (nonatomic, assign) IBOutlet NSView * permissionsView;

@property (nonatomic, assign) IBOutlet NSButton * ownerReadButton;
@property (nonatomic, assign) IBOutlet NSButton * ownerWriteButton;
@property (nonatomic, assign) IBOutlet NSButton * ownerExecuteButton;
@property (nonatomic, assign) IBOutlet NSButton * groupReadButton;
@property (nonatomic, assign) IBOutlet NSButton * groupWriteButton;
@property (nonatomic, assign) IBOutlet NSButton * groupExecuteButton;
@property (nonatomic, assign) IBOutlet NSButton * worldReadButton;
@property (nonatomic, assign) IBOutlet NSButton * worldWriteButton;
@property (nonatomic, assign) IBOutlet NSButton * worldExecuteButton;

- (id) initWithPath:(NSString *)itemPath;

- (IBAction) permissionsChanged:(id)sender;

@end
