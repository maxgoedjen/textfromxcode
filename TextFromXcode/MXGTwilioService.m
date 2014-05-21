//
//  MXGTwilioService.m
//  TextFromXcode
//
//  Created by Max Goedjen on 5/20/14.
//  Copyright (c) 2014 MXG. All rights reserved.
//

#import "MXGTwilioService.h"

static NSString * const MXGTwilioEndpoint = @"https://%@@api.twilio.com/2010-04-01/Accounts/%@/Messages.json";
static NSString * const MXGTwilioAPISid = @"";
static NSString * const MXGTwilioAPIToken = @"";

@implementation MXGTwilioService

+ (void)sendMessage:(NSString *)message sender:(NSString *)sender recipient:(NSString *)recipient completion:(MXGCompletionHandler)completion {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [self _requestForMessage:message sender:sender recipient:recipient];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"Data task response: %@ %@", response, dict);
        if (completion) {
            completion(error);
        }
    }];
    [task resume];
}

+ (NSURLRequest *)_requestForMessage:(NSString *)message sender:(NSString *)sender recipient:(NSString *)recipient {
    NSString *authString = [NSString stringWithFormat:@"%@:%@", MXGTwilioAPISid, MXGTwilioAPIToken];
    NSString *endpoint = [NSString stringWithFormat:MXGTwilioEndpoint, authString, MXGTwilioAPISid];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0];
    request.HTTPMethod = @"POST";
    NSString *body = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", sender, recipient, message];
    NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    return request;
}

@end
