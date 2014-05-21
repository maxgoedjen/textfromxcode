//
//  MXGTwilioService.h
//  TextFromXcode
//
//  Created by Max Goedjen on 5/20/14.
//  Copyright (c) 2014 MXG. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void (^MXGCompletionHandler)(NSError *error);

@interface MXGTwilioService : NSObject

+ (void)sendMessage:(NSString *)message recipient:(NSString *)recipient completion:(MXGCompletionHandler)completion;

@end
