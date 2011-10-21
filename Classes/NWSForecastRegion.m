//
//  NWSForecastRegion.m
//  unitForecast
//
//  Created by Dana Spisak on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NWSForecastRegion.h"
@implementation NWSForecastRegion

@synthesize regionTitle;
@synthesize regionDescription;
@synthesize zoneArray;
@synthesize regionAcronym;



- (id) init
{
	return [self initWithTitle:nil andAcronym:nil andDescription:nil];
}

- (id) initWithTitle:(NSString *)title andAcronym:(NSString *)acronym andDescription:(NSString*)description
{
	self.regionAcronym = acronym;
	self.regionDescription = description;
	self.regionTitle = title;
	zoneArray = [[NSMutableArray alloc] initWithCapacity:2];
	
	return self;
	
	
}

- (void) addZone:(NWSZone *)zone;
{
	[zoneArray addObject:zone];

}

- (void) dealloc
{
	[zoneArray release];
	[super dealloc];
}	
@end
