//
//  FTAuthController.m
//  FastenTestApp
//
//  Created by Kirill Kunst on 22.02.16.
//  Copyright © 2016 Kirill Kunst. All rights reserved.
//

#import "FTAuthController.h"
#import "FTConstants.h"
#import "FTBaseAuthService.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FTInformationViewController.h"
#import "FTStoryboards.h"
#import <ngrvalidator/NGRValidator.h>

@interface FTAuthController()

@property (weak, nonatomic) IBOutlet UITextField *fieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *fieldPassword;
@property (weak, nonatomic) IBOutlet UILabel *fieldErrorInfo;


@end

@implementation FTAuthController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configure];
}

- (void)configure
{
    self.navigationItem.title = FTControllerTitleLogin;
    
    __block __typeof__(self) __weak weakSelf = self;
    [self.authService setErrorBlock:^(NSString *error) {
        [weakSelf showError:error];
    }];
}

#pragma mark - Actions

- (BOOL)validate
{
    NSError *emailError = [NGRValidator validateValue:self.fieldEmail.text named:@"Email" rules:^(NGRPropertyValidator *validator) {
        validator.is.required().to.have.syntax(NGRSyntaxEmail);
    }];
    
    NSError *passwordError = [NGRValidator validateValue:self.fieldPassword.text named:@"Email" rules:^(NGRPropertyValidator *validator) {
        validator.is.required();
    }];
    
    NSString *errorString = @"";
    
    if (emailError != nil) {
        errorString = [errorString stringByAppendingFormat:@"%@ \n",FTErrorValidationEmail];
    }
    
    if (passwordError != nil) {
        errorString = [errorString stringByAppendingFormat:@"%@ \n",FTErrorValidationPassword];
    }
    
    if ([errorString isEqualToString:@""] == NO) {
        [self showError:errorString];
        return NO;
    }
    
    return YES;
}

- (IBAction)actionLogin:(id)sender
{
    BOOL formValid = [self validate];
    if (formValid == NO) {
        return;
    }
    
    NSString *fieldEmail = self.fieldEmail.text;
    NSString *fieldPass = self.fieldPassword.text;
    
    self.fieldErrorInfo.hidden = YES;
    
    [SVProgressHUD show];
    
    __block __typeof__(self) __weak weakSelf = self;
    [self.authService authenticate:fieldEmail password:fieldPass completion:^(FTSocketData *data, NSString *error) {
        [SVProgressHUD dismiss];
        
        if (error == nil) {
            [weakSelf completeAuthentication];
        } else {
            [weakSelf showError:error];
        }
    }];
}

- (void)completeAuthentication
{
    FTInformationViewController *infoController = [[FTStoryboards main] instantiateViewControllerWithIdentifier:NSStringFromClass([FTInformationViewController class])];
    infoController.authService = self.authService;
    
    [self.navigationController setViewControllers:@[infoController] animated:YES];
}

- (void)showError:(NSString *)error
{
    self.fieldErrorInfo.hidden = NO;
    self.fieldErrorInfo.text = error;
}

@end
