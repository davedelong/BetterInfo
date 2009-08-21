//
//  InfoTabViewItem.h
//  BetterInfo
//
//  Created by Dave DeLong on 8/19/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Common.h"

@interface InfoTabViewItem : NSTabViewItem {
	NSString * path;
	
	NSView * infoView;
	
	NSTextField * kindField;
	NSTextField * totalSizeField;
	NSTextField * dataSizeField;
	NSTextField * resourceSizeField;
	NSTextField * versionField;
	
	NSDatePicker * createdDatePicker;
	NSDatePicker * modifiedDatePicker;
	
	NSProgressIndicator * sizeProgressBar;
	
	NSButton * extensionHiddenButton;
	NSButton * invisibleButton;
	NSButton * lockedButton;
	
	BIItemSize itemSize;
}

@property (nonatomic, assign) NSString * path;
@property (nonatomic, assign) IBOutlet NSView * infoView;

@property (nonatomic, assign) IBOutlet NSTextField * kindField;
@property (nonatomic, assign) IBOutlet NSTextField * totalSizeField;
@property (nonatomic, assign) IBOutlet NSTextField * dataSizeField;
@property (nonatomic, assign) IBOutlet NSTextField * resourceSizeField;
@property (nonatomic, assign) IBOutlet NSTextField * versionField;

@property (nonatomic, assign) IBOutlet NSDatePicker * createdDatePicker;
@property (nonatomic, assign) IBOutlet NSDatePicker * modifiedDatePicker;

@property (nonatomic, assign) IBOutlet NSProgressIndicator * sizeProgressBar;

@property (nonatomic, assign) IBOutlet NSButton * extensionHiddenButton;
@property (nonatomic, assign) IBOutlet NSButton * invisibleButton;
@property (nonatomic, assign) IBOutlet NSButton * lockedButton;

- (id) initWithPath:(NSString *)itemPath;

- (IBAction) changedCreationDate:(id)sender;
- (IBAction) changedModificationDate:(id)sender;

- (IBAction) changedExtensionHiddenFlag:(id)sender;

@end
