//
//  NSString+FSRef.h
//  BuildCleaner
//
//  Created by Dave DeLong on 8/13/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (BetterInfo)

- (FSRef) fsref;
- (NSString *) trimmedString;

@end

@interface NSMutableString (BetterInfo)

- (void) trim;

@end

