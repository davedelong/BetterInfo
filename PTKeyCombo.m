//
//  PTKeyCombo.m
//  Protein
//
//  Created by Quentin Carnicelli on Sat Aug 02 2003.
//  Copyright (c) 2003 Quentin D. Carnicelli. All rights reserved.
//

#import "PTKeyCombo.h"
#import <Carbon/Carbon.h>

unsigned int SRCocoaToCarbonFlags( unsigned int cocoaFlags ) {
	unsigned int carbonFlags = 0;
	
	if (cocoaFlags & NSCommandKeyMask) carbonFlags |= cmdKey;
	if (cocoaFlags & NSAlternateKeyMask) carbonFlags |= optionKey;
	if (cocoaFlags & NSControlKeyMask) carbonFlags |= controlKey;
	if (cocoaFlags & NSShiftKeyMask) carbonFlags |= shiftKey;
	if (cocoaFlags & NSFunctionKeyMask) carbonFlags |= NSFunctionKeyMask;
	
	return carbonFlags;
}

@implementation PTKeyCombo

@synthesize keyCode, modifiers;

+ (id)clearKeyCombo {
	return [self keyComboWithKeyCode:-1 modifiers:0];
}

+ (id)keyComboWithKeyCode:(int)newKeyCode modifiers: (unsigned int)newModifiers {
	return [[[self alloc] initWithKeyCode:newKeyCode modifiers:newModifiers] autorelease];
}

- (id)initWithKeyCode: (int)newKeyCode modifiers: (unsigned int)newModifiers {
	[super init];
	
	keyCode = newKeyCode;
	modifiers = SRCocoaToCarbonFlags(newModifiers);
	
	return self;
}

- (id)initWithPlistRepresentation: (id)plist {
	int someKeyCode, someModifiers;
	
	if (!plist || [plist count] == 0) {
		someKeyCode = -1;
		someModifiers = 0;
	}
	else {
		someKeyCode = [[plist objectForKey: @"keyCode"] intValue];
		
		if (someKeyCode < 0)
			someKeyCode = -1;
		
		someModifiers = [[plist objectForKey: @"modifiers"] unsignedIntValue];
	}
	
	return [self initWithKeyCode:someKeyCode modifiers:someModifiers];
}

- (id)plistRepresentation {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithInt: [self keyCode]], @"keyCode",
			[NSNumber numberWithUnsignedInt: [self modifiers]], @"modifiers",
			nil];
}

- (id)copyWithZone:(NSZone*)zone {
	return [self retain];
}

- (BOOL)isEqual: (PTKeyCombo*)combo {
	return ([self keyCode] == [combo keyCode]) && ([self modifiers] == [combo modifiers]);
}

#pragma mark -

- (BOOL)isValidHotKeyCombo {
	return keyCode >= 0;
}

- (BOOL)isClearCombo {
	return keyCode == -1;
}

@end
