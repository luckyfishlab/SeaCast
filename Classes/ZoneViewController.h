//
//  ZoneViewController.h
//  Forecast
//
//  Created by Dana Spisak on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NWSZone.h"

@interface ZoneViewController : UITableViewController {

	NSMutableArray *zoneArray;
	
	
}

@property (copy) NSMutableArray *zoneArray;

- (id) init;

@end
