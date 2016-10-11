//
//  NSString+CommandExecution.m
//  LogDecryptor
//
//  Created by Neeraj Singh on 3/7/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "NSString+CommandExecution.h"

@implementation NSString (CommandExecution)

- (NSString*)runAsCommand
{
    NSPipe* pipe = [NSPipe pipe];
    
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    [task setArguments:@[@"-c", [NSString stringWithFormat:@"%@", self]]];
    [task setStandardOutput:pipe];
    
    NSFileHandle* file = [pipe fileHandleForReading];
    [task launch];
    
    return [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
}

@end
