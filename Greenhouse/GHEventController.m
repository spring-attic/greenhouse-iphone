//
//  Copyright 2010-2012 the original author or authors.
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
//  GHEventController.m
//  Greenhouse
//
//  Created by Roy Clarkson on 8/31/10.
//

#define KEY_SELECTED_EVENT_ID   @"selectedEventId"

#import "GHEventController.h"
#import "GHCoreDataManager.h"
#import "Event.h"
#import "Venue.h"
#import "EventDate.h"
#import "GHDateHelper.h"

@interface GHEventController ()

- (NSArray *)fetchEventsWithPredicate:(NSPredicate *)predicate;

@end

@implementation GHEventController


#pragma mark -
#pragma mark Static methods

// Use this class method to obtain the shared instance of the class.
+ (id)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


#pragma mark -
#pragma mark Public Instance methods

- (NSArray *)fetchEvents
{
    return [self fetchEventsWithPredicate:nil];
}

- (Event *)fetchEventWithId:(NSNumber *)eventId;
{
    DLog(@"eventId: %@", eventId);
    Event *event = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventId == %@", eventId];
    NSArray *fetchedObjects = [self fetchEventsWithPredicate:predicate];
    if (fetchedObjects && fetchedObjects.count > 0)
    {
        event = [fetchedObjects objectAtIndex:0];
    }
    return event;
}

- (Event *)fetchSelectedEvent
{
    DLog(@"");
    NSNumber *eventId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SELECTED_EVENT_ID];
    return [self fetchEventWithId:eventId];
}

- (void)setSelectedEvent:(Event *)event
{
	[[NSUserDefaults standardUserDefaults] setObject:event.eventId forKey:KEY_SELECTED_EVENT_ID];
}

- (void)sendRequestForEventsWithDelegate:(id<GHEventControllerDelegate>)delegate
{
    NSURL *url = [GHConnectionSettings urlWithFormat:@"/events/"];
    NSMutableURLRequest *request = [[GHAuthorizedRequest alloc] initWithURL:url];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	DLog(@"%@", request);

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if (statusCode == 200 && data.length > 0 && error == nil)
         {
             DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
             if (!error)
             {
                 DLog(@"%@", jsonArray);
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [self deleteEvents];
                     [self storeEventsWithJson:jsonArray];
                     NSArray *events = [self fetchEventsWithPredicate:nil];
                     [delegate fetchEventsDidFinishWithResults:events];
                 });
             }
             else
             {
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [delegate fetchEventsDidFailWithError:error];
                 });
             }
             
         }
         else if (error)
         {
             [self requestDidFailWithError:error];
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [delegate fetchEventsDidFailWithError:error];
             });
         }
         else if (statusCode != 200)
         {
             [self requestDidNotSucceedWithDefaultMessage:@"A problem occurred while retrieving the event data." response:response];
         }
     }];
}

- (void)storeEventsWithJson:(NSArray *)events
{
    DLog(@"");
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    [events enumerateObjectsUsingBlock:^(NSDictionary *eventDict, NSUInteger idx, BOOL *stop) {
        Event *event = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Event"
                        inManagedObjectContext:context];
        event.eventId = [eventDict numberForKey:@"id"];
        event.title = [eventDict stringByReplacingPercentEscapesForKey:@"title" usingEncoding:NSUTF8StringEncoding];
        event.startTime = [eventDict dateWithMillisecondsSince1970ForKey:@"startTime"];
        event.endTime = [eventDict dateWithMillisecondsSince1970ForKey:@"endTime"];
        event.location = [eventDict stringByReplacingPercentEscapesForKey:@"location" usingEncoding:NSUTF8StringEncoding];
        event.information = [[eventDict stringForKey:@"description"] stringByXMLDecoding];
        event.hashtag = [eventDict stringByReplacingPercentEscapesForKey:@"hashtag" usingEncoding:NSUTF8StringEncoding];
        event.groupName = [eventDict stringByReplacingPercentEscapesForKey:@"groupName" usingEncoding:NSUTF8StringEncoding];
        event.timeZoneName = [[eventDict objectForKey:@"timeZone"] objectForKey:@"id"];
        
        NSArray *venues = [eventDict objectForKey:@"venues"];
        [venues enumerateObjectsUsingBlock:^(NSDictionary *venueDict, NSUInteger idx, BOOL *stop) {
            Venue *venue = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Venue"
                            inManagedObjectContext:context];
            venue.venueId = [venueDict stringForKey:@"id"];
            venue.name = [venueDict stringForKey:@"name"];
			venue.locationHint = [venueDict stringForKey:@"locationHint"];
			venue.postalAddress = [venueDict stringForKey:@"postalAddress"];
            venue.latitude = [[venueDict objectForKey:@"location"] numberForKey:@"latitude"];
            venue.longitude = [[venueDict objectForKey:@"location"] numberForKey:@"longitude"];
            [event addVenuesObject:venue];
        }];
        
        NSArray *days = [GHDateHelper daysBetweenStartTime:event.startTime endTime:event.endTime];
        [days enumerateObjectsUsingBlock:^(NSDate *day, NSUInteger idx, BOOL *stop) {
            EventDate *eventDate = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"EventDate"
                                    inManagedObjectContext:context];
            eventDate.date = day;
            [event addDaysObject:eventDate];
        }];
    }];
    
    NSError *error;
    [context save:&error];
    if (error)
    {
        ProcessError(@"save event", error);
    }
}

- (void)deleteEvents
{
    DLog(@"");
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    NSArray *events = [self fetchEventsWithPredicate:nil];
    if (events)
    {
        [events enumerateObjectsUsingBlock:^(id event, NSUInteger idx, BOOL *stop) {
            [context deleteObject:event];
        }];
    }
    
    NSError *error;
    [context save:&error];
    if (error)
    {
        DLog(@"%@", [error localizedDescription]);
    }
}


#pragma mark -
#pragma mark Private Instance methods

- (NSArray *)fetchEventsWithPredicate:(NSPredicate *)predicate;
{
    NSManagedObjectContext *context = [[GHCoreDataManager sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:NO];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByDate]];
    if (predicate)
    {
        [fetchRequest setPredicate:predicate];
    }
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}


@end
