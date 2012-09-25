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
//  GHSignUpForm.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/23/12.
//

#import "GHSignUpForm.h"

@implementation GHSignUpForm

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize confirmEmail = _confirmEmail;
@synthesize gender = _gender;
@synthesize birthday = _birthday;
@dynamic birthdayDay;
@dynamic birthdayMonth;
@dynamic birthdayYear;

- (NSInteger)birthdayDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.birthday];
    return [components day];
}

- (NSInteger)birthdayMonth
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self.birthday];
    return [components month];
}

- (NSInteger)birthdayYear
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self.birthday];
    return [components year];
}

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email confirmEmail:(NSString *)confirmEmail password:(NSString *)password gender:(NSString *)gender birthdayMonth:(NSInteger)month birthdayDay:(NSInteger)day birthdayYear:(NSInteger)year
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:month];
    [components setDay:day];
    [components setYear:year];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *birthday = [calendar dateFromComponents:components];
    return [self initWithFirstName:firstName lastName:lastName email:email confirmEmail:confirmEmail password:password gender:gender birthday:birthday];
}

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email confirmEmail:(NSString *)confirmEmail password:(NSString *)password gender:(NSString *)gender birthday:(NSDate *)birthday
{
    if (self = [super init])
    {
        self.firstName = firstName;
        self.lastName = lastName;
        self.email = email;
        self.confirmEmail = confirmEmail;
        self.password = password;
        self.gender = gender;
        self.birthday = birthday;
    }
    return self;
}

- (NSDictionary *)dictionaryValue
{
    NSDictionary *birthdate = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInteger:self.birthdayMonth], @"month",
                               [NSNumber numberWithInteger:self.birthdayDay], @"day",
                               [NSNumber numberWithInteger:self.birthdayYear], @"year",
                               nil];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                self.firstName, @"first-name",
                                self.lastName, @"last-name",
                                self.email, @"email",
                                self.confirmEmail, @"confirm-email",
                                self.gender, @"gender",
                                birthdate, @"birthdate",
                                self.password, @"password",
                                nil];
    return dictionary;
}

@end
