//
//  OAuthViewController.h
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/30.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AuthenticationViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView * webView;
}

@end
