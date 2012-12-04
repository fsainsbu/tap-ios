//
//  TAPTour.m
//  Tap
//
//  Created by Daniel Cervantes on 5/23/12.
//  Copyright (c) 2012 IMA Labs. All rights reserved.
//

#import "TAPTour.h"
#import "TAPAssetRef.h"
#import "TAPProperty.h"
#import "TAPStop.h"
#import "AppDelegate.h"

@implementation TAPTour

@dynamic author;
@dynamic id;
@dynamic bundlePath;
@dynamic lastModified;
@dynamic publishDate;
@dynamic title;
@dynamic desc;
@dynamic appResource;
@dynamic propertySet;
@dynamic rootStopRef;
@dynamic stop;

/**
 * Overriden getter that returns the localized title
 */
- (NSString *)title 
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self willAccessValueForKey:@"title"];
    NSDictionary *title = [self primitiveValueForKey:@"title"];
    [self didAccessValueForKey:@"title"];
    
    if ([title objectForKey:[appDelegate language]]) {
        return [title objectForKey:[appDelegate language]];
    } else {
        return [title objectForKey:@""];
    }
}

/**
 * Overriden getter that returns the localized description
 */
- (NSString *)desc 
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self willAccessValueForKey:@"desc"];
    NSDictionary *description = [self primitiveValueForKey:@"desc"];
    [self didAccessValueForKey:@"desc"];
    
    if ([description objectForKey:[appDelegate language]]) {
        return [description objectForKey:[appDelegate language]];
    } else {
        return [description objectForKey:@""];
    }
}

/**
 * Retrieves the stop for a given keycode
 */
- (TAPStop *)stopFromKeycode:(NSString *)keycode
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(propertySet, $ps, $ps.name = 'code' AND $ps.value = %@ AND ($ps.language == %@ OR $ps.language == nil)).@count > 0", 
                              keycode, appDelegate.language];
    TAPStop *stop = [[self.stop filteredSetUsingPredicate:predicate] anyObject];
    return stop;
}

/**
 * Retrieves the stop for a given id
 */
- (TAPStop *)stopFromId:(NSString *)id
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    TAPStop *stop = [[self.stop filteredSetUsingPredicate:predicate] anyObject];
    return stop;
}

/**
 * Convenience method for retrieving all assets for a stop
 */
- (NSArray *)getAssets
{
    NSMutableArray *assets = [[[NSMutableArray alloc] init] autorelease];
    for (TAPAssetRef *assetRef in [self.appResource allObjects]) {
        [assets addObject:assetRef.asset];
    }
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [assets sortedArrayUsingDescriptors:sortDescriptors];
}

/**
 * Convenience method for retrieving all assets with a particular usage
 */
- (NSArray *)getAssetsByUsage:(NSString *)usage
{
    NSMutableArray *assets = [[[NSMutableArray alloc] init] autorelease];
    for (TAPAssetRef *assetRef in [self.appResource allObjects]) {
        if ([assetRef.usage isEqualToString:usage]) {
            [assets addObject:assetRef.asset];
        }
    }
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [assets sortedArrayUsingDescriptors:sortDescriptors];
}

@end
