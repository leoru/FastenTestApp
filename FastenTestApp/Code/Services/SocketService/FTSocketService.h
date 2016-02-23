//
//  FTSocketService.h
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTSocketData;


@protocol FTSocketServiceDelegate <NSObject>

- (void)connectionDidOpen;
- (void)connectionFailWithError:(NSError *)error;
- (void)connectionDidRecieveData:(FTSocketData *)data;

@end


@protocol FTSocketService <NSObject>

#pragma mark - Connection

- (BOOL)connected;
- (void)connect;
- (void)disconnect;
- (void)send:(FTSocketData *)data;

#pragma mark - Delegates registration

- (void)registerDelegate:(id<FTSocketServiceDelegate>)delegate;
- (void)unregisterDelegate:(id<FTSocketServiceDelegate>)delegate;

@end
