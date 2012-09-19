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
//  Event.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/15/12.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventSession, Tweet, Venue;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * hashtag;
@property (nonatomic, retain) NSString * information;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * timeZoneName;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *sessions;
@property (nonatomic, retain) NSSet *tweets;
@property (nonatomic, retain) NSSet *venues;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addSessionsObject:(EventSession *)value;
- (void)removeSessionsObject:(EventSession *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

- (void)addTweetsObject:(Tweet *)value;
- (void)removeTweetsObject:(Tweet *)value;
- (void)addTweets:(NSSet *)values;
- (void)removeTweets:(NSSet *)values;

- (void)addVenuesObject:(Venue *)value;
- (void)removeVenuesObject:(Venue *)value;
- (void)addVenues:(NSSet *)values;
- (void)removeVenues:(NSSet *)values;

@end
