//
//  facebookDemo1AppDelegate.h
//  facebookDemo1
//
//  Created by Wes Duff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class facebookDemo1ViewController;

@interface facebookDemo1AppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {
    Facebook *facebook;
    
}
@property (nonatomic,retain) Facebook *facebook;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet facebookDemo1ViewController *viewController;

@end
