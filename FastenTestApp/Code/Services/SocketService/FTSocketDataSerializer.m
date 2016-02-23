//
//  FTRequestSerializer.m
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import "FTSocketDataSerializer.h"

@interface FTSocketDataSerializer()

@property (nonatomic, strong) FTSocketData *serializableData;
@property (nonatomic, strong) NSString *rawData;

@end

@implementation FTSocketDataSerializer

#pragma mark - Initialization

- (instancetype)initWithSocketData:(FTSocketData *)data
{
    self = [self init];
    if (self) {
        self.serializableData = data;
    }
    return self;
}

- (instancetype)initWithSocketRawData:(NSString *)rawData
{
    self = [super init];
    if (self) {
        self.rawData = rawData;
    }
    return self;
}

#pragma mark - Serialization

- (NSString *)serialize
{
    if (self.serializableData == nil) {
        return nil;
    }
    
    NSDictionary *data = @{
                           @"type" : self.serializableData.type,
                           @"data" : self.serializableData.data
                           };
    NSError *error = nil;
    NSData *sendData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    if (sendData == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding];
    return string;
}

- (FTSocketData *)deserialize
{
    if (self.rawData == nil) {
        return nil;
    }
    
    NSData *data = [self.rawData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *socketDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (socketDictionary == nil) {
        return nil;
    }
    
    FTSocketData *socketData = [[FTSocketData alloc] initWithType:socketDictionary[@"type"] data:socketDictionary[@"data"]];
    return socketData;
}

@end
