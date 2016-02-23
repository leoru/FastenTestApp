//
//  FTAuthController.h
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTAuthService.h"

@interface FTAuthController : UIViewController

@property (nonatomic, weak) id<FTAuthService> authService;

@end
