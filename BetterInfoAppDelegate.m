//
//  BetterInfoAppDelegate.m
//  BetterInfo
//
//  Created by Dave DeLong on 8/18/09.
//  Copyright 2009 Home. All rights reserved.
//
//#import <ApplicationServices/Events.h>
//#include <IOKit/hidsystem/IOLLEvent.h>

#import <ScriptingBridge/ScriptingBridge.h>
#import "BetterInfoAppDelegate.h"
#import "BetterInfoDocument.h"
#import "Finder.h"

#import "PTHotKeyCenter.h"
#import "PTHotKey.h"
#import "PTKeyCombo.h"

@implementation BetterInfoAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	//0x1100 = ctrl + cmd
	PTKeyCombo * combo = [[PTKeyCombo alloc] initWithKeyCode:0x22 modifiers:(NSCommandKeyMask | NSControlKeyMask)];
	globalHotkey = [[PTHotKey alloc] initWithIdentifier:@"BIHotKey" keyCombo:combo];
	[globalHotkey setName:@"BIHotKey"];
	[globalHotkey setTarget:self];
	[globalHotkey setAction:@selector(hotKeyPressed:)];
	[combo release];
	
	NSLog(@"Registered? %d", [[PTHotKeyCenter sharedCenter] registerHotKey:globalHotkey]);
}

- (void) hotKeyPressed:(PTKeyCombo *)hotKey {
	FinderApplication * finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.finder"];
	SBElementArray * selection = [[finder selection] get];
	
	NSArray * items = [selection arrayByApplyingSelector:@selector(URL)];
	for (NSString * item in items) {
		NSURL * url = [NSURL URLWithString:item];
		
		BetterInfoDocument * d = [[BetterInfoDocument alloc] initWithURL:url];
		[[NSDocumentController sharedDocumentController] addDocument:d];
		[d makeWindowControllers];
		[d showWindows];
		[d release];
	}
}

- (void) applicationWillTerminate:(NSNotification *)aNotification {
	[[PTHotKeyCenter sharedCenter] unregisterHotKey:globalHotkey];
	
	[globalHotkey release];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
	return NO;
}

@end
