//
//  ZoneDetailViewController.m
//  Forecast
//
//  Created by Dana Spisak on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZoneDetailViewController.h"


@implementation ZoneDetailViewController
@synthesize zone;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
	
	// don't need to do this, it is getting done in the loadView
	//[zone zoneForecast];

	
	
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	UIView *contentView = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
	//	[self.zone zoneForecast];
	contentView.autoresizesSubviews = YES;
	self.view = contentView;
	[self.view setBackgroundColor:[UIColor lightGrayColor]];
	
	CGRect frame = contentView.frame;
	frame.origin.x = 0;
	frame.origin.y = contentView.bounds.size.height - frame.size.height;
	frame.size.width = contentView.bounds.size.width;
	frame.size.height = contentView.bounds.size.height - 92;
/*	
	UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
	
	[dateLabel setFont:[UIFont boldSystemFontOfSize:14]];
	[dateLabel setTextColor:[UIColor whiteColor]];
	[dateLabel setText:[NSString stringWithFormat:@"   %@   ", [detailDictionary valueForKey:@"pubDate"]]];
	[dateLabel setBackgroundColor:[UIColor blackColor]];
	[dateLabel setTextAlignment:UITextAlignmentCenter];
	[self.view addSubview:dateLabel];
	[dateLabel release];
*/	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 320, 24)];
	CGSize fitSize = CGSizeMake(320, 400);
	CGRect titleRect = titleLabel.frame;
	
	fitSize = [zone.zoneName sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:fitSize lineBreakMode:UILineBreakModeWordWrap];
	titleRect.size.height = fitSize.height;
	
	[titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
	[titleLabel setTextColor:[UIColor whiteColor]];
	[titleLabel setText:zone.zoneName];
	[titleLabel setNumberOfLines:5];
	[titleLabel setTextAlignment:UITextAlignmentCenter];
	[titleLabel setFrame:titleRect];
	[titleLabel setBackgroundColor:[UIColor darkGrayColor]];
	[self.view addSubview:titleLabel];
	titleHeight = titleLabel.frame.size.height;
	[titleLabel release];
	
	// This was added so we can show the categories that is assigned to a feed.  It cycles through each category one-by-one,
	// but only if more than one was parsed out.
#if 0
	categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, fitSize.height + 16, 320, 16)];
	
	[categoryLabel setFont:[UIFont boldSystemFontOfSize:14]];
	[categoryLabel setTextColor:[UIColor whiteColor]];
	[categoryLabel setBackgroundColor:[UIColor blackColor]];
	[categoryLabel setTextAlignment:UITextAlignmentCenter];
	[categoryLabel setText:[self.categories objectAtIndex:categoryPosition]];
	[self.view addSubview:categoryLabel];
#endif	

	NSString *baseURL = @"http://weather.noaa.gov/pub/data/forecasts/marine";
	//	NSString *baseURL = @"http://weather.noaa.gov/cgi-bin/fmtbltn.pl?file=forecasts/marine";
	NSString *totalZoneURL = [NSString stringWithFormat:@"%@%@", baseURL,zone.zoneURL];
	NSURL *url = [NSURL URLWithString:totalZoneURL];
	
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(4, titleHeight + 42, 312, 480 - (titleHeight + 216))];
	NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
	[webView setBackgroundColor:[UIColor lightGrayColor]];
	[webView loadRequest:urlRequest];
	//	[webView loadHTMLString:zone.forecastString baseURL:nil];
	[self.view addSubview:webView];
//	Don't do this! It was created with autorelease!
//	[contentView release];
	[urlRequest release];
	[webView release];
	
	

}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

//	while (zone.loading == YES)
//		;
	

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[zone release];
	[super dealloc];
	

}


@end
