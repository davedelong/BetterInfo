//
//  BetterInfoWindowController.h
//  BetterInfo
//
//  Created by Dave DeLong on 8/18/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class InfoTabViewItem;
@class PermissionsTabViewItem;

@interface BetterInfoDocument : NSDocument {
	NSString * itemPath;
	
	NSTabView * tabView;
	
	NSTextField * fileNameField;
	NSTextField * filePathField;
	NSImageView * fileImageView;
	
	InfoTabViewItem * infoTab;
	PermissionsTabViewItem * permsTab;
}

@property (nonatomic, copy) NSString * itemPath;

@property (nonatomic, assign) IBOutlet NSTabView * tabView;
@property (nonatomic, assign) IBOutlet NSTextField * fileNameField;
@property (nonatomic, assign) IBOutlet NSTextField * filePathField;
@property (nonatomic, assign) IBOutlet NSImageView * fileImageView;

- (id) initWithURL:(NSURL *)url;

@end
