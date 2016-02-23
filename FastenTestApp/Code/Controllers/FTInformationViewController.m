//
//  FTInformationViewController.m
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import "FTInformationViewController.h"
#import "FTAuthController.h"
#import "FTStoryboards.h"
#import "FTConstants.h"
#import "FTAuthData.h"

@interface FTInformationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelExpireDate;

@end

@implementation FTInformationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
}

- (void)configure
{
    self.navigationItem.title = FTControllerTitleInformation;
    self.labelExpireDate.text = [[self.authService authentication] expirationDate];
}

- (IBAction)actionReset:(id)sender
{
    [self.authService clearAuthentication];
    
    FTAuthController *authController = [[FTStoryboards main] instantiateViewControllerWithIdentifier:NSStringFromClass([FTAuthController class])];
    authController.authService = self.authService;
    [self.navigationController setViewControllers:@[authController] animated:YES];
}

@end
