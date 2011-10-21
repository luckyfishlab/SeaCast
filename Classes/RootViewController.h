//
//  RootViewController.h
//  Forecast
//
//  Created by Dana Spisak on 5/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface RootViewController : UITableViewController {
	NSMutableArray *regions;
//	NSMutableDictionary *zones;
	NSString *databasePath;
	
	
	
}

@property (nonatomic, retain) NSString *databasePath;

- (void) readRegionsFromDatabase;

- (void) setupZonesFromDatabase;


@end
