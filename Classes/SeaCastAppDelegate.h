//
//  SeaCastAppDelegate.h
//  SeaCast
//
//  Created by Dana Spisak on 5/29/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeaCastAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
	
	// Database variables
	NSString *databaseName;
	NSString *databasePath;
	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSString *databasePath;

-(void) checkAndCreateDatabase;


@end

