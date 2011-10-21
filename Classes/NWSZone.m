//
//  zone.m
//  unitForecast
//
//  Created by Dana Spisak on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NWSZone.h"


@implementation NWSZone

@synthesize zoneName;
@synthesize zoneDescription;
@synthesize zoneType;
@synthesize zoneURL;
@synthesize loading;
@synthesize forecastString;

- (NSString *) zoneForecast
{
	NSString *baseURL = @"http://weather.noaa.gov/pub/data/forecasts/marine";
	NSString *totalZoneURL = [NSString stringWithFormat:@"%@%@", baseURL,self.zoneURL];
	
	[self getForecast:totalZoneURL withDelegate:self];	
	
	return (forecastString);
	
}

- (id) initWithName:(NSString *)name andDescription:(NSString*)description
{
	self.zoneName = name;
	self.zoneDescription = description;
	
	return self;
}

- (id) init
{
	return [self initWithName:nil andDescription:nil];
	
}	


- (void)getForecast:(NSString *)url withDelegate:(id)sender //onComplete:(SEL)callback 
{
	parentDelegate = sender;
	//onCompleteCallback = callback;
	requestUrl = [url retain];
	loading = YES;
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	
	[request setURL:[[NSURL alloc] initWithString:requestUrl]];
	[request setHTTPMethod:@"GET"];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[request setTimeoutInterval:60];
		

	theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	[request release];
	
	forecastData = [[NSMutableData data] retain];
	
	
	
}

/* ------------------ Stuff for handling loading the forecast ----------------------------------- */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
		
		NSLog(@"NWSZone: Response is an NSHTTPURLResponse: Response=%d", [httpResponse statusCode]);
		
		// Does not handle authentication quite yet.
		if ([httpResponse statusCode] >= 400 && [httpResponse statusCode] <= 599) {
			success = NO;
		} else if ([httpResponse statusCode] >= 100 && [httpResponse statusCode] <= 299) {
			success = YES;
		} else {
			NSLog(@"RssParser: Status code is unknown.");
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[forecastData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	success = NO;
	loading = NO;
	/*
	if ([parentDelegate respondsToSelector:onCompleteCallback]) {
		[parentDelegate performSelector:onCompleteCallback withObject:self];
	}
	 */
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	forecastString = [[[NSString alloc] initWithData:forecastData encoding:NSASCIIStringEncoding] autorelease];

	/* do processing of the forecast data here */
/*	
	if ([dataString length] > 0) {
		[self parseResponse];
	}
 */	success = YES;
	loading = NO;
}

- (void) dealloc
{
	[theConnection release];
	[forecastData release];
	[forecastString release];
	[requestUrl release];
	
	[super dealloc];
}


@end
