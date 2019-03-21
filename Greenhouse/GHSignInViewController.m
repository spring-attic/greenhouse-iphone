//
//  Copyright 2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  GHSignInViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 7/12/12.
//

#import "GHSignInViewController.h"
#import "OA2SignInRequestParameters.h"
#import "GHURLPostRequest.h"
#import "OA2AccessGrant.h"
#import "GHActivityAlertView.h"
#import "GHAuthController.h"

@interface GHSignInViewController ()
{
    BOOL keyboardIsDisplaying;
}

@property (nonatomic, strong) GHActivityAlertView *activityView;

@end

@implementation GHSignInViewController

@synthesize activityView;
@synthesize logoImage;
@synthesize signInForm;
@synthesize emailCell;
@synthesize passwordCell;
@synthesize emailTextField;
@synthesize passwordTextField;

- (IBAction)actionCancel:(id)sender
{
    [self hideKeyboard];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionSubmit:(id)sender
{
    [self signInWithUserName:emailTextField.text andPassword:passwordTextField.text];
}

- (void)signInWithUserName:(NSString *)username andPassword:(NSString *)password
{
    NSString *usernameValue = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordValue = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(username == nil || [usernameValue isEqualToString:@""] ||
       password == nil || [passwordValue isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Your email or password was entered incorrectly."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        DLog(@"empty username or password");
        return;
    }
    
    activityView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Signing in..."];
	[activityView startAnimating];
    [[GHAuthController sharedInstance] sendRequestToSignIn:usernameValue password:passwordValue delegate:self];
}

- (void)hideKeyboard
{
    if (passwordTextField.isFirstResponder)
    {
        [passwordTextField resignFirstResponder];
    }
    else if (emailTextField.isFirstResponder)
    {
        [emailTextField resignFirstResponder];
    }
    
    keyboardIsDisplaying = NO;
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    DLog(@"");
    if (keyboardIsDisplaying)
    {
        return;
    }

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= logoImage.frame.size.height + 20;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[self keyboardAnimationDurationForNotification:notification]];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsDisplaying = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    DLog(@"");

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += logoImage.frame.size.height + 20;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[self keyboardAnimationDurationForNotification:notification]];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsDisplaying = NO;
}


#pragma mark -
#pragma mark GHAuthControllerDelegate methods

- (void)authRequestDidSucceed
{
    [activityView stopAnimating];
    self.activityView = nil;
    [(GreenhouseAppDelegate *)[[UIApplication sharedApplication] delegate] showTabBarController];
}

- (void)authRequestDidFailWithError:(NSError *)error
{
    [activityView stopAnimating];
    self.activityView = nil;
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0)
    {
        [passwordTextField becomeFirstResponder];
    }
    else if (textField.tag ==1)
    {
        [passwordTextField resignFirstResponder];
        [self signInWithUserName:emailTextField.text andPassword:passwordTextField.text];
    }
    
    return NO;
}


#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.row == 0) 
    {
        return emailCell;
    } 
    
    else if (indexPath.row == 1) 
    {
        return passwordCell;
    }
    
    // static table content will not reach here
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // fixed size table to include rows for email and password fields
    return 2;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    keyboardIsDisplaying = NO;
    
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
//    CGSize scrollContentSize = CGSizeMake(320, 345);
//    self.scrollView.contentSize = scrollContentSize;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.emailTextField.text = nil;
    self.passwordTextField.text = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

    self.activityView = nil;
    self.logoImage = nil;
    self.signInForm = nil;
    self.emailCell = nil;
    self.passwordCell = nil;
    self.emailTextField = nil;
    self.passwordTextField = nil;
}

@end
