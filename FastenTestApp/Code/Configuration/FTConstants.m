//
//  FTConstants.m
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import "FTConstants.h"

NSString *const FTAppBaseURL = @"ws://52.29.182.220:8080/customer-gateway/customer";
NSString *const FTKeychainServiceName = @"com.fastenapp.mainkeychain";

NSString *const FTErrorUndefined = @"Undefined error happened";
NSString *const FTErrorSocketConnectionFailed = @"Socket connection is down";
NSString *const FTErrorValidationEmail = @"E-mail is required";
NSString *const FTErrorValidationPassword = @"Password is required";

NSString *const FTControllerTitleLogin = @"Login";
NSString *const FTControllerTitleInformation = @"Information";

NSString *const FTExpirationDateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";