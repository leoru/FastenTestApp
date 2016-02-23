//
//  FTAuthData.h
//  FastenTestApp
//
//  Created by Kirill Kunst on 23.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTAuthData : NSObject

@property (nonatomic, strong) NSString *apiToken;
@property (nonatomic, strong) NSString *expirationDate;

- (instancetype)initWithApiToken:(NSString *)apiToken expirationDate:(NSString *)expirationDate;

- (NSDate *)expirationDateFormatted;

@end
