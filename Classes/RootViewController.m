//
//  RootViewController.m
//  Forecast
//
//  Created by Dana Spisak on 5/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"
#import "NWSZone.h"
#import "NWSForecastRegion.h"
#import "ZoneViewController.h"
//#import "CustomTableViewCell.h"
#import "FastFeedCell.h"
#import <sqlite3.h>


@implementation RootViewController

@synthesize databasePath;

- (void) readRegionsFromDatabase
{
	sqlite3 *database;
	
	// our regions array
	regions = [[NSMutableArray alloc] init];
	
	if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Get the regions
		
		const char *sqlStatement = "select * from regions";
		sqlite3_stmt *compiledStatement;
		if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
		{
			while (sqlite3_step(compiledStatement) == SQLITE_ROW)
			{
				// Get the data from the results
				NSString *aRegion = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)];
				NSString *aTitle = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 1)];
				NSString *aDescription = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];					 
				
				NWSForecastRegion *region = [[NWSForecastRegion alloc] initWithTitle:aTitle andAcronym:aRegion andDescription:aDescription];
				[regions addObject:region];
				[region release];
				
				//NSLog(@"%@|%@|%@", aRegion, aTitle,aDescription);
			}
		}
		// release the statement from memory
		sqlite3_finalize(compiledStatement);
		
		
	}
	sqlite3_close(database);	
	
}

- (void) setupZonesFromDatabase
{
	sqlite3 *database;
	if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{
		// Get the zones
		
		// for each region, select the matching zones and add them to the region's zone array
		for (NWSForecastRegion *region in regions)
		{
			NSString *stringSQLStatement = [NSString stringWithFormat:@"select * from zones where region='%@'",region.regionAcronym];
			const char *sqlStatement = [stringSQLStatement UTF8String];
			
			//NSLog(stringSQLStatement);

			sqlite3_stmt *compiledStatement;
			if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
			{
				while (sqlite3_step(compiledStatement) == SQLITE_ROW)
				{
					// Get the data from the results
					NSString *aZone = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)];
					NSString *aType = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 2)];
					NSString *aDescription = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 3)];					 
					NSString *aURL = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 4)];					 
					
					// Setup the zone object
					NWSZone *zone = [[NWSZone alloc] initWithName:aZone andDescription:aDescription];
					[zone setZoneType:aType];
					[zone setZoneURL:aURL];					
					
					// Add to the region's zone array
					[region addZone:zone];
					[zone release];
					
				}
			}
			// release the statement from memory
			sqlite3_finalize(compiledStatement);
					
		}// For each region in regions array
		
	}
	sqlite3_close(database);	
	
}

- (void)viewDidLoad {
    [super viewDidLoad];

	
	[self readRegionsFromDatabase];
	[self setupZonesFromDatabase];
	
	//self.title = @"Forecast Regions";
	self.title = @"Forecast";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   [self.tableView setBackgroundColor:[UIColor colorWithRed:0.14 green:0.18 blue:0.25 alpha:1.00]];

#if 0 // this is getting changed to using a database	
	/* Read in a zones file from the bundle */
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zones" ofType:@"txt"];
	NSString *fileString = [NSString stringWithContentsOfFile:filePath];
	NSArray *fileLines = [[NSArray alloc] initWithArray:[fileString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]]];
	zones = [NSMutableDictionary dictionary];
	for (NSString *line in fileLines)
	{
		NSArray *lineParts = [[NSArray alloc] initWithArray:[line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]]];
		NWSZone *zone = [[NWSZone alloc] initWithName:[lineParts objectAtIndex:0] andDescription:[lineParts objectAtIndex:2]];
		[zone setZoneType:[lineParts objectAtIndex:1]];
		[zone setZoneURL:[lineParts objectAtIndex:3]];
		[zones setValue:zone forKey:zone.zoneName];
		[zone release];
		[lineParts release];
	
	}
	
	//zones = dict;
	[zones retain];
//	[filePath release];
//	[fileString release];
	[fileLines release];
	
	/* Read in the regions */
	filePath = [[NSBundle mainBundle] pathForResource:@"regions" ofType:@"txt"];
	fileString = [NSString stringWithContentsOfFile:filePath];

	fileLines = [[NSArray alloc] initWithArray:[fileString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]]];
	regions = [NSMutableArray array];
	
	for (NSString *line in fileLines)
	{
		
		NSArray *lineParts = [[NSArray alloc] initWithArray:[line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]]];
		NWSForecastRegion *region = [[NWSForecastRegion alloc] initWithTitle:[lineParts objectAtIndex:0] andDescription:[lineParts objectAtIndex:1]];
		
		/* The zone list starts at [2]  ----> [myRegions addZone] */
		/* process the zone list as a single zone for now */
		NSString *zonesString = [[NSString alloc]initWithString:[lineParts objectAtIndex:2]];
		NSArray *zoneList = [[NSArray alloc] initWithArray:[zonesString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]]];
		for (NSString *myZone in zoneList)
		{
			NWSZone *zone = [zones objectForKey:myZone];
			[region addZone:zone];
			[zone release];
		}
		
		[regions addObject:region];
		[lineParts release];
		[zonesString release];
		[zoneList release];
		[region release];
	}
	
	//regions = myRegions;
	[regions retain];
//	[filePath release];
//	[fileString release];
	[fileLines release];
	
	//[dict release];
#endif // end ommitted code for reading regions and zone in to a file
	
	UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Regions" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    [backBarButtonItem release];
	

}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [regions count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
#if 0	
/*    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	NWSForecastRegion *region = [regions objectAtIndex:indexPath.row];
	NSString *cellValue = region.regionTitle;
	cell.text = cellValue;
*/
	CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[CustomTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	NWSForecastRegion *region = [regions objectAtIndex:indexPath.row];

	cell.nameLabel.text = region.regionTitle;
	cell.descriptionLabel.text = region.regionDescription;
#endif
	
	FastFeedCell *tvCell = (FastFeedCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (tvCell == nil) {
		tvCell = [[[FastFeedCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NWSForecastRegion *region = [regions objectAtIndex:indexPath.row];
	[tvCell setMainLabel:region.regionTitle];
	[tvCell setSubLabel:region.regionDescription];
	
    return tvCell;
}




// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here -- for example, create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController animated:YES];
	// [anotherViewController release];
	ZoneViewController *viewController = [[ZoneViewController alloc] init]; //WithNibName:nil bundle:nil];
	NWSForecastRegion *region = [regions objectAtIndex:indexPath.row];
	viewController.zoneArray = region.zoneArray;
	
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
	
	
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[regions release];
	//[zones release];
    [super dealloc];
}


@end

