//
//  MXGTextFromXcode.m
//  MXGTextFromXcode
//
//  Created by Max Goedjen on 5/20/14.
//    Copyright (c) 2014 MXG. All rights reserved.
//

#import "MXGTextFromXcode.h"

static NSString * const IDEIssueManagerDidCoalesceIssuesNotification = @"IDEIssueManagerDidCoalesceIssuesNotification";
static NSString * const IDEIssueManagerCoalescedIssuesKey = @"IDEIssueManagerCoalescedIssuesKey";

@implementation MXGTextFromXcode

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static MXGTextFromXcode *sharedPlugin;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
        if ([currentApplicationName isEqual:@"Xcode"]) {
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        }
    });
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleError:) name:IDEIssueManagerDidCoalesceIssuesNotification object:nil];
    }
    return self;
}

- (void)handleError:(NSNotification *)note {
    NSLog(@"%@", note.userInfo[IDEIssueManagerCoalescedIssuesKey]);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
