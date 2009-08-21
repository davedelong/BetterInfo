//
//  BIByteFormatter.h
//  BetterInfo
//
//  Created by Dave DeLong on 8/20/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BIByteFormatter : NSNumberFormatter {
	BOOL convertsToBestUnit;
}

@property BOOL convertsToBestUnit;

@end
