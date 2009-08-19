//
//  PTKeyCombo.h
//  Protein
//
//  Created by Quentin Carnicelli on Sat Aug 02 2003.
//  Copyright (c) 2003 Quentin D. Carnicelli. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PTKeyCombo : NSObject <NSCopying> {
	int	keyCode;
	unsigned int modifiers;
}

+ (id)clearKeyCombo;
+ (id)keyComboWithKeyCode:(int)newKeyCode modifiers:(unsigned int)newModifiers;
- (id)initWithKeyCode:(int)newKeyCode modifiers:(unsigned int)newModifiers;

- (id)initWithPlistRepresentation:(id)plist;
- (id)plistRepresentation;

- (BOOL)isEqual: (PTKeyCombo*)combo;

@property (readonly) int keyCode;
@property (readonly) unsigned int modifiers;

@property (readonly) BOOL isClearCombo;
@property (readonly) BOOL isValidHotKeyCombo;

@end
