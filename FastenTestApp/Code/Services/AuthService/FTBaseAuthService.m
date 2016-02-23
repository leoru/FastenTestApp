//
//  FTAuthService.m
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import "FTBaseAuthService.h"
#import "FTConstants.h"
#import "FTSocketData.h"
#import "FTSocketService.h"
#import <UICKeyChainStore/UICKeyChainStore.h>
#import "FTAuthData.h"

/**
 *  Socket data types
 */

static NSString *const FTAuthServiceLoginCustomerDataType = @"LOGIN_CUSTOMER";
static NSString *const FTAuthServiceAPITokenDataType = @"CUSTOMER_API_TOKEN";
static NSString *const FTAuthServiceCustomerValidationErrorDataType = @"CUSTOMER_VALIDATION_ERROR";
static NSString *const FTAuthServiceCustomerErrorDataType = @"CUSTOMER_ERROR";

/**
 *  Keychain saving properties keys
 */

static NSString *const FTAuthServiceKeychainApiTokenField = @"API_TOKEN";
static NSString *const FTAuthServiceKeychainApiTokenExpirationDateField = @"API_TOKEN_EXPIRATION_DATE";

/**
 *  Socket data fields
 */

static NSString *const FTAuthServiceSocketDataAPITokenField = @"api_token";
static NSString *const FTAuthServiceSocketDataAPITokenExpirationDateField = @"api_token_expiration_date";


@interface FTBaseAuthService() <FTSocketServiceDelegate>

@property (nonatomic, weak) id<FTSocketService> socketService;
@property (nonatomic, strong,readwrite) FTAuthData *authentication;

@property (nonatomic, copy) FTAuthServiceAutherticateBlock completionBlock;
@property (nonatomic, copy) FTAuthServiceErrorBlock errorBlock;

@end


@implementation FTBaseAuthService

- (instancetype)initWithSocketService:(id<FTSocketService>)socketService
{
    self = [self init];
    if (self) {
        self.socketService = socketService;
        [self.socketService registerDelegate:self];
        [self.socketService connect];
    }
    return self;
}

- (void)dealloc
{
    [self.socketService unregisterDelegate:self];
}

#pragma mark - Authentications

- (void)authenticate:(NSString *)email
            password:(NSString *)password
          completion:(FTAuthServiceAutherticateBlock)completion
{
    self.completionBlock = completion;
    
    if ([self.socketService connected] == NO) {
        self.completionBlock(nil, FTErrorSocketConnectionFailed);
        return;
    }
    
    FTSocketData *data = [[FTSocketData alloc] initWithType:FTAuthServiceLoginCustomerDataType data:@{@"email": email, @"password": password}];
    [self.socketService send:data];
}

- (BOOL)trySilentAuthentication
{
    self.authentication = [self getAuthenticationFromStore];
    if (self.authentication == nil) {
        return NO;
    }
    
    return YES;
}

- (void)clearAuthentication
{
    UICKeyChainStore *store = [self keychainStore];
    [store removeAllItems];
    
    self.authentication = nil;
}


#pragma mark - Keychain Methods

- (UICKeyChainStore *)keychainStore
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:FTKeychainServiceName];
    return store;
}

- (FTAuthData *)getAuthenticationFromStore
{
    UICKeyChainStore *store = [self keychainStore];
    
    NSString *expirationDate = store[FTAuthServiceKeychainApiTokenExpirationDateField];
    NSString *apiToken = store[FTAuthServiceKeychainApiTokenField];
    
    if (apiToken == nil || expirationDate == nil) {
        return nil;
    }
    
    BOOL tokenExpired = [self checkApiTokenExpiration:expirationDate];
    if (tokenExpired) {
        return nil;
    }
    
    return [[FTAuthData alloc] initWithApiToken:apiToken expirationDate:expirationDate];
}

- (BOOL)checkApiTokenExpiration:(NSString *)expirationDate
{
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:FTExpirationDateFormat];
    NSDate *date = [df dateFromString:expirationDate];
    
    if (date == nil) {
        return NO;
    }

    return [currentDate compare:date] != NSOrderedAscending;
}

#pragma mark - Saving data

- (void)saveAuthSocketData:(FTSocketData *)socketData
{
    UICKeyChainStore *store = [self keychainStore];
    store[FTAuthServiceKeychainApiTokenField] = socketData.data[FTAuthServiceSocketDataAPITokenField];
    store[FTAuthServiceKeychainApiTokenExpirationDateField] = socketData.data[FTAuthServiceSocketDataAPITokenExpirationDateField];
    
    self.authentication = [self getAuthenticationFromStore];
    
    if (self.completionBlock) {
        self.completionBlock(socketData,nil);
    }
}

- (void)handleUndefinedSocketData:(FTSocketData *)data
{
    NSString *error = nil;
    if ([data hasError]) {
        error = [data errorDescription];
    } else {
        error = FTErrorUndefined;
    }
    
    if (self.completionBlock) {
        self.completionBlock(nil, error);
    }
}

#pragma mark - SocketService Delegate

- (void)connectionDidOpen
{
    
}

- (void)connectionDidRecieveData:(FTSocketData *)data
{
    if (data == nil) {
        NSLog(@"Data from SocketService is nil");
    } else {
        if ([data.type isEqualToString:FTAuthServiceAPITokenDataType]) {
            [self saveAuthSocketData:data];
        } else  {
            [self handleUndefinedSocketData:data];
        }
    }
}

- (void)connectionFailWithError:(NSError *)error
{
    if (self.errorBlock) {
        self.errorBlock(error.userInfo[NSLocalizedDescriptionKey]);
    }
}

@end
