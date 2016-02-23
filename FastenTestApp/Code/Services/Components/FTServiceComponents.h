//
//  FTServiceComponents.h
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTAuthService.h"
#import "FTSocketService.h"

@interface FTServiceComponents : NSObject

@property (nonatomic,strong) id<FTAuthService> authService;
@property (nonatomic,strong) id<FTSocketService> socketService;

@end
