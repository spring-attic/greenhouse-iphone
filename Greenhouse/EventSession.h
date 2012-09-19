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
//  EventSession.h
//  Greenhouse
//
//  Created by Roy Clarkson on 9/15/12.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, EventSessionLeader, Tweet, VenueRoom;

@interface EventSession : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * hashtag;
@property (nonatomic, retain) NSString * information;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * sessionId;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSSet *leaders;
@property (nonatomic, retain) VenueRoom *room;
@property (nonatomic, retain) NSSet *tweets;
@end

@interface EventSession (CoreDataGeneratedAccessors)

- (void)addLeadersObject:(EventSessionLeader *)value;
- (void)removeLeadersObject:(EventSessionLeader *)value;
- (void)addLeaders:(NSSet *)values;
- (void)removeLeaders:(NSSet *)values;

- (void)addTweetsObject:(Tweet *)value;
- (void)removeTweetsObject:(Tweet *)value;
- (void)addTweets:(NSSet *)values;
- (void)removeTweets:(NSSet *)values;

@end
