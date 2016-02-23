//
//  FTAuthService.h
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//


@protocol FTSocketService;
@class FTSocketData;
@class FTAuthData;

typedef void (^FTAuthServiceAutherticateBlock)(FTSocketData *data, NSString *error);
typedef void (^FTAuthServiceErrorBlock)(NSString *error);

@protocol FTAuthService <NSObject>

@property (nonatomic, strong,readonly) FTAuthData *authentication;

- (instancetype)initWithSocketService:(id<FTSocketService>)socketService;

#pragma mark - Error block 

- (void)setErrorBlock:(FTAuthServiceErrorBlock)errorBlock;

#pragma mark - Authentication methods

- (void)authenticate:(NSString *)email
            password:(NSString *)password
          completion:(FTAuthServiceAutherticateBlock)completion;

- (BOOL)trySilentAuthentication;

- (void)clearAuthentication;


@end
