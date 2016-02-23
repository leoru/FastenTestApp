//
//  MBBaseRequest.m
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import "FTSocketData.h"

@interface FTSocketData()

@property (nonatomic, strong, readwrite) NSString *type;
@property (nonatomic, strong, readwrite) NSDictionary *data;

@end

@implementation FTSocketData

- (instancetype)initWithType:(NSString *)type data:(NSDictionary *)data
{
    self = [self init];
    if (self) {
        self.type = type;
        self.data = data;
    }
    return self;
}

#pragma mark - Error handling

- (BOOL)hasError
{
    if (self.data == nil) {
        return YES;
    }
    
    return self.data[@"error_description"] != nil;
}

- (NSString *)errorDescription
{
    if (self.data == nil) {
        return nil;
    }
    
    return self.data[@"error_description"];
}

@end
