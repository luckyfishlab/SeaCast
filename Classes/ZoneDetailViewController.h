//
//  ZoneDetailViewController.h
//  Forecast
//
//  Created by Dana Spisak on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWSZone.h"

@interface ZoneDetailViewController : UIViewController {

	NWSZone *zone;
	int titleHeight;
	
	
}

@property (nonatomic, retain) NWSZone *zone;

@end
