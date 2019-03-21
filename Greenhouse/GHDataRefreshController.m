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
//  GHDataRefreshController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 9/25/12.
//

#import "GHDataRefreshController.h"
#import "GHCoreDataManager.h"
#import "GHEventController.h"
#import "GHEventSessionController.h"
#import "DataRefresh.h"
#import "Event.h"
#import "EventSession.h"

@interface GHDataRefreshController ()

- (NSDate *)fetchLastRefreshDateWithPredicate:(NSPredicate *)predicate;
- (DataRefresh *)createDataRefreshWithDescriptor:(NSString *)descriptor;

@end

@implementation GHDataRefreshController


#pragma mark -
#pragma mark Static methods

// Use this class method to obtain the shared instance of the class.
+ (GHDataRefreshController *)sharedInstance
{
    static GHDataRefreshController *_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[GHDataRefreshController alloc] init];
    });
    return _sharedInstance;
}

+ (NSDate *)defaultDate
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:2001];
    [components setMonth:1];
    [components setDay:1];
    return [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] dateFromComponents:components];
}


#pragma mark -
#pragma mark Instance methods

- (NSDate *)fetchLastRefreshDateWithEventId:(NSNumber *)eventId descriptor:(NSString *)descriptor
{
    DLog(@"event: %@, descriptor: %@", eventId, descriptor);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(event.eventId == %@) AND (descriptor == %@)",
                              eventId, descriptor];
    return [self fetchLastRefreshDateWithPredicate:predicate];
}

- (NSDate *)fetchLastRefreshDateWithEventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber descriptor:(NSString *)descriptor
{
    DLog(@"event: %@, session: %@, descriptor: %@", eventId, sessionNumber, descriptor);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(event.eventId == %@) AND (session.number == %@) AND (descriptor == %@)",
                              eventId, sessionNumber, descriptor];
    return [self fetchLastRefreshDateWithPredicate:predicate];
}

- (void)setLastRefreshDateWithEventId:(NSNumber *)eventId descriptor:(NSString *)descriptor
{
    DLog(@"event: %@, descriptor: %@", eventId, descriptor);
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    DataRefresh *dataRefresh = [self createDataRefreshWithDescriptor:descriptor];
    Event *event = [[GHEventController sharedInstance] fetchEventWithId:eventId];
    [event addDataRefreshesObject:dataRefresh];
    NSError *error;
    [context save:&error];
    if (error)
    {
        DLog(@"%@ - %@", [error domain], [error localizedDescription]);
    }
}

- (void)setLastRefreshDateWithEventId:(NSNumber *)eventId sessionNumber:(NSNumber *)sessionNumber descriptor:(NSString *)descriptor
{
    DLog(@"event: %@, session: %@, descriptor: %@", eventId, sessionNumber, descriptor);
    
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    DataRefresh *dataRefresh = [self createDataRefreshWithDescriptor:descriptor];
    Event *event = [[GHEventController sharedInstance] fetchEventWithId:eventId];
    [event addDataRefreshesObject:dataRefresh];
    EventSession *session = [[GHEventSessionController sharedInstance] fetchSessionWithNumber:sessionNumber];
    [session addDataRefreshesObject:dataRefresh];
    NSError *error;
    [context save:&error];
    if (error)
    {
        DLog(@"%@ - %@", [error domain], [error localizedDescription]);
    }
}



#pragma mark -
#pragma mark Private Instance methods

- (NSDate *)fetchLastRefreshDateWithPredicate:(NSPredicate *)predicate
{
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DataRefresh" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        DLog(@"%@ - %@", [error domain], [error localizedDescription]);
    }
    
    NSDate *date;
    if (fetchedObjects && fetchedObjects.count > 0)
    {
        DataRefresh *dataRefresh = [fetchedObjects objectAtIndex:0];
        date = dataRefresh.date;
    }
    else
    {
        date = [GHDataRefreshController defaultDate];
    }
    DLog(@"%@", date);
    return date;
}

- (DataRefresh *)createDataRefreshWithDescriptor:(NSString *)descriptor
{
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    DataRefresh *dataRefresh = [NSEntityDescription
                                insertNewObjectForEntityForName:@"DataRefresh"
                                inManagedObjectContext:context];
    dataRefresh.descriptor = descriptor;
    dataRefresh.date = [NSDate date];
    return dataRefresh;
}

@end
