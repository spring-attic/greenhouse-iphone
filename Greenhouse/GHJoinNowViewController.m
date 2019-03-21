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
//  GHJoinNowViewController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/1/12.
//

#define TOOLBAR_ORIGIN_OFFSET 200

#import "GHJoinNowViewController.h"
#import "GHFormTextFieldCell.h"
#import "GHAuthController.h"
#import "GHSignUpForm.h"
#import "GHActivityAlertView.h"

@interface GHJoinNowViewController ()
{
    BOOL keyboardIsDisplaying;
    NSInteger selectedFormField;
}

@property (nonatomic, strong) NSArray *formCells;
@property (nonatomic, strong) NSArray *genderValues;
@property (nonatomic, strong) GHActivityAlertView *activityView;

- (void)signUp;
- (BOOL)validateFormData:(GHSignUpForm *)form;
- (void)addNotificationCenterObservers;
- (void)removeNotificationCenterObservers;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification;

@end

@implementation GHJoinNowViewController

@synthesize formCells;
@synthesize genderValues;
@synthesize activityView;
@synthesize containerView;
@synthesize signUpForm;
@synthesize firstNameCell;
@synthesize lastNameCell;
@synthesize emailCell;
@synthesize confirmEmailCell;
@synthesize passwordCell;
@synthesize genderCell;
@synthesize birthdayCell;
@synthesize formToolbar;
@synthesize formTextFields;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize emailTextField;
@synthesize confirmEmailTextField;
@synthesize passwordTextField;
@synthesize genderTextField;
@synthesize birthdayTextField;
@synthesize genderPickerView;
@synthesize birthdayPickerView;


#pragma mark -
#pragma mark Public methods

- (IBAction)actionCancel:(id)sender
{
    [self resetTextFields];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionSubmit:(id)sender
{
    [self signUp];
}

- (IBAction)actionPrevious:(id)sender
{
    [formCells enumerateObjectsUsingBlock:^(GHFormTextFieldCell *cell, NSUInteger idx, BOOL *stop) {
        if (cell.formTextField.isFirstResponder)
        {
            NSUInteger prevIdx = idx - 1;
            if (idx > 0)
            {
                GHFormTextFieldCell *cell = [self.formCells objectAtIndex:prevIdx];
                [cell.formTextField becomeFirstResponder];
            }
            *stop = YES;
        }
    }];
}

- (IBAction)actionNext:(id)sender
{
    [formCells enumerateObjectsUsingBlock:^(GHFormTextFieldCell *cell, NSUInteger idx, BOOL *stop) {
        if (cell.formTextField.isFirstResponder)
        {
            NSUInteger nextIdx = idx + 1;
            if (idx < formCells.count-1)
            {
                GHFormTextFieldCell *cell = [self.formCells objectAtIndex:nextIdx];
                [cell.formTextField becomeFirstResponder];
            }
            *stop = YES;
        }
    }];
}

- (IBAction)actionDone:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)actionBirthdayValueChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM, yyyy"];
    birthdayTextField.text = [dateFormatter stringFromDate:birthdayPickerView.date];
}


#pragma mark -
#pragma mark Private methods

- (void)resetTextFields
{
    [formTextFields enumerateObjectsUsingBlock:^(UITextField *field, NSUInteger idx, BOOL *stop) {
        field.text = nil;
    }];
    [self.view endEditing:YES];
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    [(UIScrollView *)self.view scrollRectToVisible:rect animated:NO];
}

- (void)signUp
{
    GHSignUpForm *form = [[GHSignUpForm alloc]
                          initWithFirstName:[firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                          lastName:[lastNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                          email:[emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                          confirmEmail:[confirmEmailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                          password:[passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                          gender:[genderValues objectAtIndex:[genderPickerView selectedRowInComponent:0]]
                          birthday:birthdayPickerView.date];
    
    if (![self validateFormData:form])
    {
        return;
    }
    
    self.activityView = [[GHActivityAlertView alloc] initWithActivityMessage:@"Creating account..."];
    [activityView startAnimating];
    [[GHAuthController sharedInstance] sendRequestToSignUp:form delegate:self];
}

- (BOOL)validateFormData:(GHSignUpForm *)form
{
    NSString *firstNameValue = [firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *lastNameValue = [lastNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *emailValue = [emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *confirmEmailValue = [confirmEmailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordValue = [passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableArray *errors = [NSMutableArray array];
    if ([firstNameValue isEqualToString:@""])
        [errors addObject:@"First Name is required"];
    
    if ([lastNameValue isEqualToString:@""])
        [errors addObject:@"Last Name is required"];
    
    if ([emailValue isEqualToString:@""])
        [errors addObject:@"Email is required"];
    
    if (![emailValue isEqualToString:confirmEmailValue])
        [errors addObject:@"Emails do not match"];
    
    if (passwordValue.length < 6)
        [errors addObject:@"Password must be at least 6 characters"];
    
    NSInteger row = [genderPickerView selectedRowInComponent:0];
    if (row == 0)
        [errors addObject:@"Gender is required"];
    
    if (errors.count > 0)
    {
        NSString *message = [errors componentsJoinedByString:@"\n"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing Information"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)addNotificationCenterObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)removeNotificationCenterObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    DLog(@"");
    if (keyboardIsDisplaying)
    {
        return;
    }
    
    CGRect toolbarFrame = self.formToolbar.frame;
    NSInteger viewHeight = self.view.frame.size.height;
    NSInteger scrollViewOffset = ((UIScrollView *)self.view).contentOffset.y;
    NSInteger keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    NSInteger toolbarHeight = toolbarFrame.size.height;

    // position the toolbar when the keyboard displays
    toolbarFrame.origin.y = scrollViewOffset + (viewHeight - (keyboardHeight + toolbarHeight));

    // animate the toolbar movement
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[self keyboardAnimationDurationForNotification:notification]];
    [self.view bringSubviewToFront:formToolbar];
    self.formToolbar.frame = toolbarFrame;
    [UIView commitAnimations];

    keyboardIsDisplaying = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    DLog(@"");
    
    // hide the toolbar when the keyboard hides
    CGRect toolbarFrame = self.formToolbar.frame;
    toolbarFrame.origin.y = self.containerView.frame.size.height + TOOLBAR_ORIGIN_OFFSET;
    
    // animate the toolbar movement
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[self keyboardAnimationDurationForNotification:notification]];
    self.formToolbar.frame = toolbarFrame;
    [self.view sendSubviewToBack:formToolbar];
    [UIView commitAnimations];

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


#pragma mark -
#pragma mark GHAuthControllerDelegate methods

- (void)authRequestDidSucceed
{
    [activityView stopAnimating];
    self.activityView = nil;
    [self resetTextFields];
    [(GreenhouseAppDelegate *)[[UIApplication sharedApplication] delegate] showTabBarController];
}

- (void)authRequestDidFailWithError:(NSError *)error
{
    [activityView stopAnimating];
    self.activityView = nil;
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    DLog(@"begin editing %i", textField.tag);
        
    // move view to position visibility of form fields
    CGRect rect = [textField bounds];
    rect = [textField convertRect:rect toView:self.view];
    rect.origin.x = 0;
    rect.origin.y -= 60;
    rect.size.height = 400;

    // perform the animation
    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
    [(UIScrollView *)self.view scrollRectToVisible:rect animated:YES];
    [UIView commitAnimations];

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger cellIndex = textField.tag;
    NSInteger nextCellIndex = textField.tag + 1;
    NSInteger lastCellIndex = formCells.count - 1;

    // if we're on the last form field, then close the keyboard
    if (cellIndex >= lastCellIndex)
    {
        GHFormTextFieldCell *cell = formCells.lastObject;
        [cell.formTextField resignFirstResponder];
    }
    // otherwise, select the next form field
    else if (cellIndex >= 0 && cellIndex < lastCellIndex)
    {
        GHFormTextFieldCell *nextCell = [formCells objectAtIndex:nextCellIndex];
        [nextCell.formTextField becomeFirstResponder];
    }

    return NO;
}


#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    DLog(@"offset: %f", scrollView.contentOffset.y);
    
    if (keyboardIsDisplaying)
    {
        CGRect toolbarFrame = self.formToolbar.frame;
        NSInteger viewHeight = self.view.frame.size.height;
        NSInteger scrollViewOffset = ((UIScrollView *)self.view).contentOffset.y;
        // TODO: how to get this value here?
        NSInteger keyboardHeight = 216;
        NSInteger toolbarHeight = toolbarFrame.size.height;
        
        // keep the toolbar positioned directly above the keyboard when scrolling
        toolbarFrame.origin.y = scrollViewOffset + (viewHeight - (keyboardHeight + toolbarHeight));
        self.formToolbar.frame = toolbarFrame;
    }
}


#pragma mark -
#pragma mark UIPickerViewDelegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    genderTextField.text = [genderValues objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [genderValues objectAtIndex:row];
}


#pragma mark -
#pragma mark UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return genderValues.count;
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
    UITableViewCell *cell = nil;
    if (indexPath.row >= 0 && indexPath.row <= formCells.count)
    {
        cell = (UITableViewCell *)[formCells objectAtIndex:indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return formCells.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    DLog(@"");

    self.navigationItem.title = @"Join Now";

    // add the keyboard toolbar to the view and hide off screen
    [self.view addSubview:formToolbar];
    CGRect toolbarFrame = self.formToolbar.frame;
    toolbarFrame.origin.y = self.containerView.frame.size.height + TOOLBAR_ORIGIN_OFFSET;
    self.formToolbar.frame = toolbarFrame;

    birthdayPickerView.maximumDate = [NSDate date];
    genderTextField.inputView = genderPickerView;
    birthdayTextField.inputView = birthdayPickerView;

    self.formCells = [[NSArray alloc] initWithObjects:firstNameCell, lastNameCell, emailCell, confirmEmailCell, passwordCell, genderCell, birthdayCell, nil];
    [formCells enumerateObjectsUsingBlock:^(GHFormTextFieldCell *cell, NSUInteger index, BOOL *stop){
        cell.formTextField.tag = index;
    }];
    
    self.genderValues = [[NSArray alloc] initWithObjects:@"", @"Male", @"Female", nil];

    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = containerView.frame.size;
    [self.view addSubview:containerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog(@"");
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self addNotificationCenterObservers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    DLog(@"");
    
    [self removeNotificationCenterObservers];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    DLog(@"");

    self.formCells = nil;
    self.genderValues = nil;
    self.activityView = nil;
    self.containerView = nil;
    self.containerView = nil;
    self.signUpForm = nil;
    self.firstNameCell = nil;
    self.lastNameCell = nil;
    self.emailCell = nil;
    self.confirmEmailCell = nil;
    self.passwordCell = nil;
    self.genderCell = nil;
    self.birthdayCell = nil;
    self.firstNameCell = nil;
    self.formToolbar = nil;
    self.formTextFields = nil;
    self.firstNameTextField = nil;
    self.lastNameTextField = nil;
    self.emailTextField = nil;
    self.confirmEmailTextField = nil;
    self.passwordTextField = nil;
    self.genderTextField = nil;
    self.birthdayTextField = nil;
    self.genderPickerView = nil;
    self.birthdayPickerView = nil;
}

@end
