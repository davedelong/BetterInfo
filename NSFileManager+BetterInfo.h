//
//  NSString+BetterInfo.h
//  BetterInfo
//
//  Created by Dave DeLong on 8/19/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Common.h"

@interface NSFileManager (BetterInfo)

- (NSString *)humanReadableTypeStringForItemAtPath:(NSString *)path;
- (BIItemSize)sizeOfItemAtPath:(NSString *)path;

@end
