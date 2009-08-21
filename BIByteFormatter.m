//
//  BIByteFormatter.m
//  BetterInfo
//
//  Created by Dave DeLong on 8/20/09.
//  Copyright 2009 Home. All rights reserved.
//

static NSUInteger bytesPerUnit;

#import "BIByteFormatter.h"

static NSString * units[8] = {@"bytes", @"KB", @"MB", @"GB", @"TB", @"PB", @"EB", @"YB"};

@implementation BIByteFormatter
@synthesize convertsToBestUnit;

+ (void) initialize {
	SInt32 system = 0;
	OSErr err = Gestalt(gestaltSystemVersionMinor, &system);
	//10.6 counts mebibytes and gibibytes, not megabytes and gigabytes
	bytesPerUnit = (system == 6 && !err ? 1000 : 1024);	
}

- (id) init {
	if (self = [super init]) {
		convertsToBestUnit = YES;
	}
	return self;
}

- (NSString *)stringForObjectValue:(id)anObject {
	UInt64 intValue = [anObject unsignedLongLongValue];
	int unit = 0;
	if ([self convertsToBestUnit]) {
		while (intValue > bytesPerUnit) {
			if (unit == 7) { break; }
			intValue /= bytesPerUnit;
			unit++;
		}
	}
	
	NSString * formattedString = [super stringForObjectValue:[NSNumber numberWithUnsignedLongLong:intValue]];
	
	return [NSString stringWithFormat:@"%@ %@", formattedString, units[unit]];
}

@end
