//
//  BetterInfoAppDelegate.h
//  BetterInfo
//
//  Created by Dave DeLong on 8/18/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PTHotKey;

@interface BetterInfoAppDelegate : NSObject <NSApplicationDelegate> {
	PTHotKey * globalHotkey;
}

@end
