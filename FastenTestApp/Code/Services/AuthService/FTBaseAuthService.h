//
//  FTAuthService.h
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTAuthService.h"

@interface FTBaseAuthService : NSObject <FTAuthService>

@property (nonatomic, strong,readonly) FTAuthData *authentication;

@end
