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
//  GHSignUpFormTests.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/24/12.
//

#import "GHSignUpFormTests.h"
#import "GHSignUpForm.h"

@implementation GHSignUpFormTests


#pragma mark -
#pragma mark SenTestCase methods

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}


#pragma mark -
#pragma mark Test methods

- (void)testInitWithBirthDate
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:13];
    [components setMonth:4];
    [components setYear:1980];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *birthday = [calendar dateFromComponents:components];
    GHSignUpForm *signUpForm = [[GHSignUpForm alloc] initWithFirstName:@"John"
                                                              lastName:@"Smith"
                                                                 email:@"jsmith@email.com"
                                                          confirmEmail:@"jsmith@email.com"
                                                              password:@"opensaysme"
                                                                gender:@"Male"
                                                              birthday:birthday];
    STAssertEqualObjects(@"John", signUpForm.firstName, @"first names do not match");
    STAssertEqualObjects(@"Smith", signUpForm.lastName, @"last names do not match");
    STAssertEqualObjects(@"jsmith@email.com", signUpForm.email, @"emails do not match");
    STAssertEqualObjects(@"jsmith@email.com", signUpForm.confirmEmail, @"confirm emails do not match");
    STAssertEqualObjects(@"opensaysme", signUpForm.password, @"passwords do not match");
    STAssertEqualObjects(@"Male", signUpForm.gender, @"genders do not match");
    STAssertEquals(13, signUpForm.birthdayDay, @"birthday does not match");
    STAssertEquals(4, signUpForm.birthdayMonth, @"birthday does not match");
    STAssertEquals(1980, signUpForm.birthdayYear, @"birthday does not match");
    
    NSDictionary *birthdate = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInteger:4], @"month",
                               [NSNumber numberWithInteger:13], @"day",
                               [NSNumber numberWithInteger:1980], @"year",
                               nil];
    
    NSDictionary *expected = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"John", @"first-name",
                              @"Smith", @"last-name",
                              @"jsmith@email.com", @"email",
                              @"jsmith@email.com", @"confirm-email",
                              @"Male", @"gender",
                              birthdate, @"birthdate",
                              @"opensaysme", @"password",
                              nil];
    
    STAssertEqualObjects(expected, [signUpForm dictionaryValue], @"dictionaries do not match");
}

- (void)testInitWithBirthdayValues
{
    GHSignUpForm *signUpForm = [[GHSignUpForm alloc] initWithFirstName:@"John"
                                                              lastName:@"Smith"
                                                                 email:@"jsmith@email.com"
                                                          confirmEmail:@"jsmith@email.com"
                                                              password:@"opensaysme"
                                                                gender:@"Male"
                                                         birthdayMonth:8
                                                           birthdayDay:31
                                                          birthdayYear:1984];
    STAssertEqualObjects(@"John", signUpForm.firstName, @"first names do not match");
    STAssertEqualObjects(@"Smith", signUpForm.lastName, @"last names do not match");
    STAssertEqualObjects(@"jsmith@email.com", signUpForm.email, @"emails do not match");
    STAssertEqualObjects(@"jsmith@email.com", signUpForm.confirmEmail, @"confirm emails do not match");
    STAssertEqualObjects(@"opensaysme", signUpForm.password, @"passwords do not match");
    STAssertEqualObjects(@"Male", signUpForm.gender, @"genders do not match");
    STAssertEquals(31, signUpForm.birthdayDay, @"birthday does not match");
    STAssertEquals(8, signUpForm.birthdayMonth, @"birthday does not match");
    STAssertEquals(1984, signUpForm.birthdayYear, @"birthday does not match");
    
    NSDictionary *birthdate = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInteger:8], @"month",
                               [NSNumber numberWithInteger:31], @"day",
                               [NSNumber numberWithInteger:1984], @"year",
                               nil];
    
    NSDictionary *expected = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @"John", @"first-name",
                                @"Smith", @"last-name",
                                @"jsmith@email.com", @"email",
                                @"jsmith@email.com", @"confirm-email",
                                @"Male", @"gender",
                                birthdate, @"birthdate",
                                @"opensaysme", @"password",
                                nil];
    
    STAssertEqualObjects(expected, [signUpForm dictionaryValue], @"dictionaries do not match");
    
//    NSString *jsonString = @"{\"first-name\":\"John\",\"last-name\":\"Smith\",\"email\":\"jsmith@email.com\",\"gender\":\"Male\",\"birthdate\":{\"month\":8,\"day\":31,\"year\":1984},\"password\":\"opensaysme\"}";
}

- (void)testSpecialCharacters
{
    GHSignUpForm *signUpForm = [[GHSignUpForm alloc] initWithFirstName:@"J@\"oooo\"#h''n&*"
                                                              lastName:@"������"
                                                                 email:@"κόσμε@email.com"
                                                          confirmEmail:@"κόσμε@email.com"
                                                              password:@"������������������������������"
                                                                gender:@"Male"
                                                         birthdayMonth:4
                                                           birthdayDay:13
                                                          birthdayYear:1980];
    STAssertEqualObjects(@"J@\"oooo\"#h''n&*", signUpForm.firstName, @"first names do not match");
    STAssertEqualObjects(@"������", signUpForm.lastName, @"last names do not match");
    STAssertEqualObjects(@"κόσμε@email.com", signUpForm.email, @"emails do not match");
    STAssertEqualObjects(@"κόσμε@email.com", signUpForm.confirmEmail, @"confirm emails do not match");
    STAssertEqualObjects(@"������������������������������", signUpForm.password, @"passwords do not match");
    STAssertEqualObjects(@"Male", signUpForm.gender, @"genders do not match");
    STAssertEquals(13, signUpForm.birthdayDay, @"birthday does not match");
    STAssertEquals(4, signUpForm.birthdayMonth, @"birthday does not match");
    STAssertEquals(1980, signUpForm.birthdayYear, @"birthday does not match");
    
    NSDictionary *birthdate = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInteger:4], @"month",
                               [NSNumber numberWithInteger:13], @"day",
                               [NSNumber numberWithInteger:1980], @"year",
                               nil];
    
    NSDictionary *expected = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"J@\"oooo\"#h''n&*", @"first-name",
                              @"������", @"last-name",
                              @"κόσμε@email.com", @"email",
                              @"κόσμε@email.com", @"confirm-email",
                              @"Male", @"gender",
                              birthdate, @"birthdate",
                              @"������������������������������", @"password",
                              nil];
    
    STAssertEqualObjects(expected, [signUpForm dictionaryValue], @"dictionaries do not match");
}

@end
