//
//  Copyright 2012 the original author or authors.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
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

@interface GHSignInViewController ()
{
    BOOL keyboardIsDisplaying;
}

@end

@implementation GHSignInViewController

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
    
    GHActivityAlertView *activityAlertView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Signing in..."];
	[activityAlertView startAnimating];
    NSURLRequest *request = [[GHOAuth2Controller sharedInstance] signInRequestWithUsername:usernameValue password:passwordValue];
    DLog(@"%@", request);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         dispatch_sync(dispatch_get_main_queue(), ^{
             [activityAlertView stopAnimating];
         });
         
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];         
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             NSError *errorInternal;
             OA2AccessGrant *accessGrant = [[OA2AccessGrant alloc] initWithData:data error:&errorInternal];
             if (!errorInternal)
             {
                 [GHOAuth2Controller storeAccessGrant:accessGrant];
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [(GreenhouseAppDelegate *)[[UIApplication sharedApplication] delegate] showTabBarController];
                 });
             }
             else
             {
                 DLog(@"error parsing access grant: %@", [errorInternal localizedDescription]);
             }
         }
         else if (error)
         {
             DLog(@"%d - %@", [error code], [error localizedDescription]);
             NSString *msg;
             switch ([error code]) {
                 case NSURLErrorUserCancelledAuthentication:
                     msg = @"Your email or password was entered incorrectly.";
                     break;
                 case NSURLErrorCannotConnectToHost:
                     msg = @"The server is unavailable. Please try again in a few minutes.";
                     break;
                 default:
                     msg = @"A problem occurred with the network connection. Please try again in a few minutes.";
                     break;
             }
             dispatch_sync(dispatch_get_main_queue(), ^{
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:msg
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
             });
         }
         else if (statusCode != 200)
         {
             DLog(@"HTTP Status Code: %d", statusCode);
             NSString *msg;
             switch (statusCode) {
                 default:
                     msg = @"You cannot be signed in.";
                     break;
             }
             dispatch_sync(dispatch_get_main_queue(), ^{
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                     message:msg
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                 [alertView show];
             });
         }
     }];
    
    activityAlertView = nil;
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

- (void)keyboardWillShow:(NSNotification *)notification
{
    DLog(@"");
    if (keyboardIsDisplaying)
    {
        return;
    }

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= logoImage.frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsDisplaying = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    DLog(@"");

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += logoImage.frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.2];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsDisplaying = NO;
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

    self.logoImage = nil;
    self.signInForm = nil;
    self.emailCell = nil;
    self.passwordCell = nil;
    self.emailTextField = nil;
    self.passwordTextField = nil;
}

@end
