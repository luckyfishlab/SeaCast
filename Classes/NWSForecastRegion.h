//
//  NWSForecastRegion.h
//  unitForecast
//
//  Created by Dana Spisak on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "NWSZone.h"


@interface NWSForecastRegion : NSObject 
{

	NSString *regionAcronym;
	NSString *regionTitle;
	NSString *regionDescription;
	NSMutableArray *zoneArray;


}

@property (copy) NSString *regionAcronym;
@property (copy) NSString *regionTitle;
@property (copy) NSString *regionDescription;
@property (copy) NSMutableArray *zoneArray;

- (id) init;
- (id) initWithTitle:(NSString *)title andAcronym:(NSString *)acronym andDescription:(NSString*)description;

- (void)addZone:(NWSZone*)zone;
- (void) dealloc;


@end
