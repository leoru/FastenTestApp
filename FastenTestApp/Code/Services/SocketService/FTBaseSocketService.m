//
//  FTBaseSocketService.m
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import "FTBaseSocketService.h"
#import <SocketRocket/SRWebSocket.h>
#import "FTConstants.h"
#import "FTSocketData.h"
#import "FTSocketDataSerializer.h"

@interface FTBaseSocketService() <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic, strong) NSHashTable *delegates;

@end


@implementation FTBaseSocketService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegates = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}

#pragma mark - Connection

- (void)connect
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:FTAppBaseURL]];
    self.socket = [[SRWebSocket alloc] initWithURLRequest:request];
    self.socket.delegate = self;
    [self.socket open];
    
}

- (void)disconnect
{
    if (self.socket != nil) {
        [self.socket close];
    }
}

- (BOOL)connected
{
    return self.socket.readyState == SR_OPEN;
}

- (void)send:(FTSocketData *)data
{
    FTSocketDataSerializer *serializer = [[FTSocketDataSerializer alloc] initWithSocketData:data];
    NSString *rawData = [serializer serialize];
    [self.socket send:rawData];
}

#pragma mark - Handling Methods

- (void)handleRecievedMessage:(NSString *)message
{
    FTSocketDataSerializer *serializer = [[FTSocketDataSerializer alloc] initWithSocketRawData:message];
    FTSocketData *socketData = [serializer deserialize];
    [self notifyConnectionRecieveData:socketData];
}


#pragma mark - Delegates Registration

- (void)registerDelegate:(id<FTSocketServiceDelegate>)delegate
{
    [self.delegates addObject:delegate];
}

- (void)unregisterDelegate:(id<FTSocketServiceDelegate>)delegate
{
    [self.delegates removeObject:delegate];
}


#pragma mark - Notifications 

- (void)notifyConnectionOpen
{
    for (id<FTSocketServiceDelegate> delegate in self.delegates) {
        [delegate connectionDidOpen];
    }
    
}

- (void)notifyConnectionFailWithError:(NSError *)error
{
    for (id<FTSocketServiceDelegate> delegate in self.delegates) {
        [delegate connectionFailWithError:error];
    }
}

- (void)notifyConnectionRecieveData:(FTSocketData *)socketData
{
    for (id<FTSocketServiceDelegate> delegate in self.delegates) {
        [delegate connectionDidRecieveData:socketData];
    }
}


#pragma mark - SocketRocket Delegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Socket did connect");
    
    [self notifyConnectionOpen];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Socket did recieve message: %@",message);
    
    NSString *msg = (NSString *)message;
    [self handleRecievedMessage:msg];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Socket connection closed with reason: %@",reason);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Socket fail connect with error: %@",error);
    
    [self notifyConnectionFailWithError:error];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    NSLog(@"Socket did recieve pong");
}

@end
