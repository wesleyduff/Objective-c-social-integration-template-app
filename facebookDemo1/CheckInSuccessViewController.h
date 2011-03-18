//
//  CheckInSuccessViewController.h
//  Gowalla-Basic
//
//  Created by Mattt Thompson on 10/06/30.
//  Copyright 2010 Mattt Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckIn;

@interface CheckInSuccessViewController : UIViewController {
	CheckIn * checkIn;
	NSString * detailHTML;
	
	IBOutlet UIWebView * webView;
}

@property (nonatomic, retain) CheckIn * checkIn;
@property (nonatomic, retain) NSString * detailHTML;

- (id)initWithCheckIn:(CheckIn *)someCheckIn detailHTML:(NSString *)html;

@end
