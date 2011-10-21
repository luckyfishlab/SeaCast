//
//  zone.h
//  unitForecast
//
//  Created by Dana Spisak on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//




@interface NWSZone : NSObject 
{
	NSString *zoneName;
	NSString *zoneType; /* offshore, coastal, synopsis */
	NSString *zoneDescription; /* geographical description of the zone */
	NSString *zoneURL; /* partial url for retrieving the zone forecast */
	NSMutableData *forecastData;
	NSString *forecastString;
	
	NSString *requestUrl;
	NSURLConnection *theConnection;
	BOOL success;
	BOOL loading;
	
	NSInteger callID;
	id parentDelegate;
	SEL onCompleteCallback;
	

}

@property (copy) NSString *zoneName;
@property (copy) NSString *zoneDescription;
@property (copy) NSString *zoneType;
@property (copy) NSString *zoneURL;
@property (copy) NSString *forecastString;
@property (readonly) NSString *zoneForecast;
@property (readonly) BOOL loading;


- (id) init;
- (id) initWithName:(NSString *)name andDescription:(NSString *)description;
- (void)getForecast:(NSString *)url withDelegate:(id)sender;
@end
