//
//  MBBaseRequest.h
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTSocketData : NSObject

@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSDictionary *data;

- (instancetype)initWithType:(NSString *)type data:(NSDictionary *)data;

- (BOOL)hasError;
- (NSString *)errorDescription;

@end
