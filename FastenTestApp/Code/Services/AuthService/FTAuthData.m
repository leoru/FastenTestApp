//
//  FTAuthData.m
//  FastenTestApp
//
//  Created by Kirill Kunst on 23.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import "FTAuthData.h"

@implementation FTAuthData

- (instancetype)initWithApiToken:(NSString *)apiToken expirationDate:(NSString *)expirationDate
{
    self = [self init];
    if (self) {
        self.apiToken = apiToken;
        self.expirationDate = expirationDate;
        [self expirationDateFormatted];
    }
    return self;
}

- (NSDate *)expirationDateFormatted
{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate* date = [df dateFromString:self.expirationDate];
    return date;
}

@end
