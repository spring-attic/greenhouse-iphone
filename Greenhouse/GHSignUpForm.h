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
//  GHSignUpForm.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/23/12.
//

#import <Foundation/Foundation.h>

@interface GHSignUpForm : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *confirmEmail;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, assign, readonly) NSInteger birthdayDay;
@property (nonatomic, assign, readonly) NSInteger birthdayMonth;
@property (nonatomic, assign, readonly) NSInteger birthdayYear;

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email confirmEmail:(NSString *)confirmEmail password:(NSString *)password gender:(NSString *)gender birthdayMonth:(NSInteger)month birthdayDay:(NSInteger)day birthdayYear:(NSInteger)year;
- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email confirmEmail:(NSString *)confirmEmail password:(NSString *)password gender:(NSString *)gender birthday:(NSDate *)birthday;
- (NSDictionary *)dictionaryValue;

@end
