//
//  NSTask+BetterInfo.m
//  BetterInfo
//
//  Created by Dave DeLong on 8/20/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "NSTask+BetterInfo.h"


@implementation NSTask (BetterInfo)

+ (NSString *) stringByLaunchingTask:(NSString *)launchPath arguments:(NSArray *)arguments {
	NSTask * task = [[NSTask alloc] init];
	[task setLaunchPath:launchPath];
	[task setArguments:arguments];
	NSPipe * output = [NSPipe pipe];
	[task setStandardOutput:output];
	[task launch];
	[task waitUntilExit];
	NSFileHandle * outputHandle = [output fileHandleForReading];
	NSData * data = [outputHandle readDataToEndOfFile];
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

@end
