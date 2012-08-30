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
//  GHSignInViewController.h
//  Greenhouse
//
//  Created by Roy Clarkson on 7/12/12.
//

#import <UIKit/UIKit.h>


@interface GHSignInViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *logoImage;
@property (nonatomic, strong) IBOutlet UITableView *signInForm;
@property (nonatomic, strong) IBOutlet UITableViewCell *emailCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *passwordCell;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

- (IBAction)actionCancel:(id)sender;
- (IBAction)actionSubmit:(id)sender;
- (void)signInWithUserName:(NSString *)username andPassword:(NSString *)password;
- (void)hideKeyboard;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end
