//
//  AppDelegate.m
//  GatherLogs
//
//  Created by Karthik Muppala on 8/31/16.
//  Copyright © 2016 Karthik Muppala. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+CommandExecution.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *startDateTextField;
@property (weak) IBOutlet NSTextField *endDateTextField;
@property (weak) IBOutlet NSButton *gatherLogsButton;
@property (copy) NSString *startDate;
@property (copy) NSString *endDate;
@property (weak) IBOutlet NSTextField *applicationNameTextField;

@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (IBAction)gatherLogsAction:(NSButton *)sender {
    if ([self.applicationNameTextField.stringValue isEqualToString:@""]) {
        NSLog(@"Application Name Emplty");
        [self oneButtonAlertWithTitle:@"Application Name!" informativeText:@"Please enter a valid application name"];
        return;
    }
    if ([self.startDateTextField.stringValue isEqualToString:@""]) {
        NSLog(@"Start date text field is empty");
        [self oneButtonAlertWithTitle:@"Start Date!" informativeText:@"Please enter a valid start date"];
        return;
    }else{
        self.startDate = self.startDateTextField.stringValue;
    }
    if ([self.endDateTextField.stringValue isEqualToString:@""]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.endDate = [dateFormatter stringFromDate:[NSDate date]];
    }else{
        self.endDate = self.endDateTextField.stringValue;
    }
    
    NSString * commandTorun = [NSString stringWithFormat:@"log show --predicate 'process == \"%@\"' --start \"%@\" --end \"%@\" --info --debug",self.applicationNameTextField.stringValue, self.startDate, self.endDate];

    NSError *error;
    NSString *outputLog = [commandTorun runAsCommand];
    [outputLog writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"]stringByAppendingPathComponent:@"Application.log"] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        [self oneButtonAlertWithTitle:@"Error" informativeText:@"Error gathering logs, please recheck the parameters"];
    }
    
}

- (void)oneButtonAlertWithTitle:(NSString *)title informativeText:(NSString *)informativeText
{
    title = title ? title : @"";
    informativeText = informativeText ? informativeText : @"";
    NSAlert *alert = [[NSAlert alloc]init];
    [alert setMessageText:title];
    [alert setInformativeText:informativeText];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [NSApp terminate:nil];
}


@end
