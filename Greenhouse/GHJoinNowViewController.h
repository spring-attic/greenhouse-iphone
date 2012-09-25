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
//  GHJoinNowViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 8/1/12.
//

#import <UIKit/UIKit.h>
#import "GHAuthControllerDelegate.h"

@class GHFormTextFieldCell;

@interface GHJoinNowViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GHAuthControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UITableView *signUpForm;
@property (nonatomic, strong) IBOutlet GHFormTextFieldCell *firstNameCell;
@property (nonatomic, strong) IBOutlet GHFormTextFieldCell *lastNameCell;
@property (nonatomic, strong) IBOutlet GHFormTextFieldCell *emailCell;
@property (nonatomic, strong) IBOutlet GHFormTextFieldCell *confirmEmailCell;
@property (nonatomic, strong) IBOutlet GHFormTextFieldCell *passwordCell;
@property (nonatomic, strong) IBOutlet GHFormTextFieldCell *genderCell;
@property (nonatomic, strong) IBOutlet GHFormTextFieldCell *birthdayCell;
@property (nonatomic, strong) IBOutlet UIToolbar *formToolbar;
@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *formTextFields;
@property (nonatomic, strong) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *confirmEmailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UITextField *genderTextField;
@property (nonatomic, strong) IBOutlet UITextField *birthdayTextField;
@property (nonatomic, strong) IBOutlet UIPickerView *genderPickerView;
@property (nonatomic, strong) IBOutlet UIDatePicker *birthdayPickerView;

- (IBAction)actionCancel:(id)sender;
- (IBAction)actionSubmit:(id)sender;
- (IBAction)actionPrevious:(id)sender;
- (IBAction)actionNext:(id)sender;
- (IBAction)actionDone:(id)sender;
- (IBAction)actionBirthdayValueChanged:(id)sender;

@end
