//
//  SeaCastAppDelegate.m
//  SeaCast
//
//  Created by Dana Spisak on 5/29/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "SeaCastAppDelegate.h"
#import "ForecastRegionViewController.h"
#import "TideRegionViewController.h"
#import "BuoyRegionViewController.h"
#import "RootViewController.h"

#import <sqlite3.h>

@implementation SeaCastAppDelegate

@synthesize window;
@synthesize databasePath;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	// Get the database ready
	databaseName = @"SeaCast.sql";
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	
	
	[self checkAndCreateDatabase];
	
	
	
	// Set up the views 
	
	tabBarController = [[UITabBarController alloc] init];
	
	/* Navigation controller for the forecast zones */
	UINavigationController *frNavCtrl = [[UINavigationController alloc] init];
	frNavCtrl.navigationBar.tintColor = [UIColor colorWithRed:0.14 green:0.18 blue:0.25 alpha:1.00];

	frNavCtrl.tabBarItem.image = [UIImage imageNamed:@"search.png"];

	RootViewController *frViewController = [[RootViewController alloc] init];
	frViewController.databasePath = databasePath;
	[frNavCtrl pushViewController:frViewController animated:NO];

	
	/* Navigation controller for buoy */
	UINavigationController *brNavCtrl = [[UINavigationController alloc] init];
	brNavCtrl.navigationBar.tintColor = [UIColor colorWithRed:0.14 green:0.18 blue:0.25 alpha:1.00];

	brNavCtrl.tabBarItem.image = [UIImage imageNamed:@"faves.png"];	
	BuoyRegionViewController *brViewController = [[BuoyRegionViewController alloc] init];
	[brNavCtrl pushViewController:brViewController animated:NO];
	
	
	/* Nav controller for the tides */
	UINavigationController *trNavCtrl = [[UINavigationController alloc] init];
	trNavCtrl.navigationBar.tintColor = [UIColor colorWithRed:0.14 green:0.18 blue:0.25 alpha:1.00];

	trNavCtrl.tabBarItem.image = [UIImage imageNamed:@"all.png"];
	TideRegionViewController *trViewController = [[TideRegionViewController alloc] init];
	trViewController.title = @"Tides";
	[trNavCtrl pushViewController:trViewController animated:NO];
	
	tabBarController.viewControllers = [NSArray arrayWithObjects:frNavCtrl,brNavCtrl,trNavCtrl,nil];
	
	[trViewController release];
	[brViewController release];
	[frViewController release];
	[frNavCtrl release];
	[brNavCtrl release];
	[trNavCtrl release];
	
	
    // Override point for customization after application launch
    [window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
}

-(void) checkAndCreateDatabase
{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database exists, delete it?
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
	[fileManager release];
}





- (void)dealloc {
	[tabBarController release];
    [window release];
    [super dealloc];
}


@end
