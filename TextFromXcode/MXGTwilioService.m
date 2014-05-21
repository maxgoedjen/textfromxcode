//
//  MXGTwilioService.m
//  TextFromXcode
//
//  Created by Max Goedjen on 5/20/14.
//  Copyright (c) 2014 MXG. All rights reserved.
//

#import "MXGTwilioService.h"

static NSString * const MXGTwilioEndpoint = @"https://api.twilio.com/2010-04-01/Accounts/%@/Messages";
static NSString * const MXGTwilioAPIKey = @"";
static NSString * const MXGTwilioSender = @"";
static NSString * const MXGTwilioRecipient = @"";

@implementation MXGTwilioService

+ (void)sendMessage:(NSString *)message recipient:(NSString *)recipient completion:(MXGCompletionHandler)completion {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [self _requestForMessage:message recipient:recipient];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
    [task resume];
}

+ (NSURLRequest *)_requestForMessage:(NSString *)message recipient:(NSString *)recipient {
    NSString *endpoint = [NSString stringWithFormat:MXGTwilioEndpoint, MXGTwilioAPIKey];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];request.HTTPMethod = @"POST";
    NSDictionary *body = @{
                           @"From": MXGTwilioSender,
                           @"To": MXGTwilioRecipient,
                           @"Body": message
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    request.HTTPBody = data;
    return request;
}

@end
