//
//  FTRequestSerializer.h
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTSocketData.h"

@interface FTSocketDataSerializer : NSObject

#pragma mark - Initialization

- (instancetype)initWithSocketData:(FTSocketData *)data;
- (instancetype)initWithSocketRawData:(NSString *)rawData;


#pragma mark - Serialization

- (NSString *)serialize;
- (FTSocketData *)deserialize;

@end
