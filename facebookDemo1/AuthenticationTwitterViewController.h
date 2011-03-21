//
//  AuthenticationTwitterViewController.h
//  facebookDemo1
//
//  Created by Wes Duff on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthenticationTwitterViewControllerDelegate <NSObject>

@optional
-(void)successfulAuthorizationWithPin:(NSString *)pin;
-(void)failedAuthorization;
@end

@interface AuthenticationTwitterViewController : UIViewController <UIWebViewDelegate> {
    id <AuthenticationTwitterViewControllerDelegate> delegate;
    UIBarButtonItem *doneButton;
    UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) id<AuthenticationTwitterViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)DoneButtonAction:(id)sender;
@end
