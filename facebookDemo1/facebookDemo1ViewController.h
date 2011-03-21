//
//  facebookDemo1ViewController.h
//  facebookDemo1
//
//  Created by Wes Duff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "OAuthConsumer.h"
#import "facebookDemo1AppDelegate.h"
#import "AuthenticationViewController.h"
#import "AuthenticationTwitterViewController.h"


/**
 DIALOG info
*/
#define IMAGEURLFORDIALOG @"<add your image url path>"
#define URLFORDIALOGIMAGELINK @"<add your url fo dialog image link>"
#define NAMEFORDIALOG @"DIALOG name goes here"
#define DIALOGCAPTION @"Dialog caption text goes here"
#define DIALOGDESCRIPTION @"Dialog description goes here"
#define DIALOGDESCRIPTIONHREF @"<add your dialog description url>"

@interface facebookDemo1ViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, AuthenticationTwitterViewControllerDelegate>{
    
    UIButton *getUserInfoButton;
    UIButton *displayDialogBoxButton;
    facebookDemo1AppDelegate *appDelegate;
    Facebook *facebook;
    IBOutlet UIButton *logIntoGowallaButton;
    AuthenticationViewController *authenticationViewController;
    IBOutlet UIButton *logIntoTwitterButton;
    
    /*Twitter stuff*/
    OAConsumer *consumer;
    OAToken *accessToken;
    
}
- (IBAction)LogIntoTwitter:(id)sender;
- (IBAction)getUserInfo:(id)sender;
- (IBAction)DisplayDialogBox:(id)sender;
- (IBAction)LogIntoGowalla:(id)sender;
@property (nonatomic, retain) OAConsumer *consumer;
@property (nonatomic, retain) OAToken *accessToken;
@property (nonatomic, retain) IBOutlet UIButton *getUserInfoButton;
@property (nonatomic, retain) IBOutlet UIButton *displayDialogBoxButton;
@property (nonatomic, retain) facebookDemo1AppDelegate *appDelegate;
@property (nonatomic, retain) AuthenticationViewController *authenticationViewController;
@property (nonatomic, retain) Facebook *facebook;


@end
