//
//  facebookDemo1ViewController.h
//  facebookDemo1
//
//  Created by Wes Duff on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "facebookDemo1AppDelegate.h"

/**
 DIALOG info
*/
#define IMAGEURLFORDIALOG @"<add your image url path>"
#define URLFORDIALOGIMAGELINK @"<add your url fo dialog image link>"
#define NAMEFORDIALOG @"DIALOG name goes here"
#define DIALOGCAPTION @"Dialog caption text goes here"
#define DIALOGDESCRIPTION @"Dialog description goes here"
#define DIALOGDESCRIPTIONHREF @"<add your dialog description url>"

@interface facebookDemo1ViewController : UIViewController <FBRequestDelegate, FBDialogDelegate>{
    
    UIButton *getUserInfoButton;
    UIButton *getFriendsCheckinButton;
    facebookDemo1AppDelegate *appDelegate;
    Facebook *facebook;
}
- (IBAction)getUserInfo:(id)sender;
- (IBAction)dialogPopUpExample:(id)sender;
@property (nonatomic, retain) IBOutlet UIButton *getUserInfoButton;
@property (nonatomic, retain) IBOutlet UIButton *getFriendsCheckinButton;
@property (nonatomic, retain) facebookDemo1AppDelegate *appDelegate;
@property (nonatomic, retain) Facebook *facebook;


@end
