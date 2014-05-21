//
//  MXGTextFromXcode.m
//  MXGTextFromXcode
//
//  Created by Max Goedjen on 5/20/14.
//    Copyright (c) 2014 MXG. All rights reserved.
//

#import "MXGTextFromXcode.h"
#import "MXGTwilioService.h"

static NSString * const IDEIssueManagerDidCoalesceIssuesNotification = @"IDEIssueManagerDidCoalesceIssuesNotification";
static NSString * const IDEIssueManagerCoalescedIssuesKey = @"IDEIssueManagerCoalescedIssuesKey";

static NSTimeInterval const MXGMinimumTimeInterval = 60;
static NSString * const MXGTwilioSender = @"";
static NSString * const MXGTwilioRecipient = @"";

@protocol IDEIssue <NSObject>

@property (readonly) NSString *title;

@end

@interface MXGTextFromXcode ()

@property (strong, nonatomic) NSDate *lastSendDate;

@end

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
        _lastSendDate = [NSDate date];
    }
    return self;
}

- (void)handleError:(NSNotification *)note {
    NSSet *issues = note.userInfo[IDEIssueManagerCoalescedIssuesKey];
    NSMutableArray *errors = [NSMutableArray array];
    for (id item in issues) {
        if ([item isKindOfClass:NSClassFromString(@"IDEIssue")]) {
            [errors addObject:item];
        }
    }

    if ([errors count]) {
        id <IDEIssue> item = [errors firstObject];
        if (-[self.lastSendDate timeIntervalSinceNow] > MXGMinimumTimeInterval) {
            self.lastSendDate = [NSDate date];
            [MXGTwilioService sendMessage:item.title sender:MXGTwilioSender recipient:MXGTwilioRecipient completion:^(NSError *error) {
                if (error) {
                    NSLog(@"Error sending text from Xcode: %@", error);
                }
            }];
        } else {
            NSLog(@"Rate limiting texts from xcode %f", [self.lastSendDate timeIntervalSinceNow]);
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
