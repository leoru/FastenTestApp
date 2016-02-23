//
//  FTServiceComponents.m
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import "FTServiceComponents.h"
#import "FTBaseAuthService.h"
#import "FTBaseSocketService.h"

@implementation FTServiceComponents

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.socketService = [[FTBaseSocketService alloc] init];
        self.authService = [[FTBaseAuthService alloc] initWithSocketService:self.socketService];
    }
    return self;
}

@end
