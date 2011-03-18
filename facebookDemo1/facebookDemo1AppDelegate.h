//
//  facebookDemo1AppDelegate.h
//  facebookDemo1
//
//  Created by Wes Duff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "AuthenticationViewController.h"

@class facebookDemo1ViewController;
@interface facebookDemo1AppDelegate : NSObject <UIApplicationDelegate, FBSessionDelegate> {
    Facebook *facebook;
    UIWindow * window;
    UINavigationController *navigationController;
    AuthenticationViewController *authenticationViewController;
}
@property (nonatomic,retain) Facebook *facebook;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) AuthenticationViewController *authenticationViewController;

@end
