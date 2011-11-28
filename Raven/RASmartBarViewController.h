//
//  RASmartBarViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
/*
 TODO: Tied user script to an app. Load it at each webview did end loading. Use CM or not
        Add app URL handler (full domain/subdomain). 
*/
#import <Cocoa/Cocoa.h>
#import "RANavigatorViewController.h"
#import "RASmartBarButton.h"
#import "RASBAPPMainButton.h"
#import "RASmartBarHolderView.h"

@protocol RASmartBarViewControllerDelegate;
@interface RASmartBarViewController : NSViewController <RASBAPPMainButtonDelegate>
{
    id<RASmartBarViewControllerDelegate> delegate;
    NSImage *mainIcon; 
    NSImage *firstIcon; 
    NSImage *secondIcon; 
    NSImage *thirdIcon; 
    NSImage *fourthIcon; 
    NSString *folderName; 
    NSString *appName; 
    NSString *firstURL; 
    NSString *secondURL; 
    NSString *thirdURL; 
    NSString *fourthURL; 
    NSInteger *type; 
    int state;
    int selectedButton; 
    int index; 
    
    //Navigator hoder
    RANavigatorViewController *firstNavigatorView;
    RANavigatorViewController *SecondNavigatorView;
    RANavigatorViewController *ThirdtNavigatorView;
    RANavigatorViewController *FourthNavigatorView;
    
    //self view outlet
    IBOutlet RASmartBarHolderView *mainView; 
    
    //Button outlet
    IBOutlet RASBAPPMainButton *mainButton; 
    IBOutlet RASmartBarButton *firstButton; 
    IBOutlet RASmartBarButton *secondButton; 
    IBOutlet RASmartBarButton *thirdButton;
    IBOutlet RASmartBarButton *fourthButton;
    IBOutlet NSButton *closeAppButton; 
    
    
    IBOutlet NSImageView *badgeView; 
    IBOutlet NSImageView *lightVIew; 
    
    IBOutlet NSTextField *totalTabsNumber; 
    IBOutlet NSTextField *firstButtonNumber; 
    IBOutlet NSTextField *secondButtonNumber; 
    IBOutlet NSTextField *thirdButtonNumber; 
    IBOutlet NSTextField *fourfthButtonNumber; 
    
    
    NSUInteger totalTabs;
    
    int appNumber; 

}
-(id)initWithDelegate:(id<RASmartBarViewControllerDelegate>)dgate andDictionnary:(NSDictionary *)dictionnary;
-(IBAction)expandApp:(id)sender;
-(IBAction)retractApp:(id)sender;
-(IBAction)firstItemClicked:(id)sender;
-(IBAction)secondItemClicked:(id)sender;
-(IBAction)thirdItemClicked:(id)sender;
-(IBAction)fourItemClicked:(id)sender;
-(IBAction)closeAppButtonCliced:(id)sender; 
-(void)resetAllButton; 
-(void)setSelectedButton;
-(void)updateTabsNumber; 
-(void)calculateUrlNumber; 
-(void)hideCloseAppButton; 
-(void)showCloseAppButton; 
-(void)hoverMainButton; 
-(void)hideHoverMainButton; 
-(void)receiveNotification:(NSNotification *)notification;
-(NSString *)numberOfDotToDisplay:(NSUInteger)numberOfTabs; 


@property (nonatomic, assign) id<RASmartBarViewControllerDelegate> delegate;
@property (nonatomic, retain) NSButton *mainButton; 
@property (copy) NSString *folderName; 
@property (copy) NSString *appName; 
@property (copy) NSString *firstURL;
@property (copy) NSString *secondURL;
@property (copy) NSString *thirdURL;
@property (copy) NSString *fourthURL;
@property int selectedButton;
@property int state;
@property int appNumber;
@property int index; 
@end

@protocol RASmartBarViewControllerDelegate
@optional
//- (void)selectionDidChange:(RASmartBarViewController *)smartBarApp;
- (void)itemDidExpand:(RASmartBarViewController *)smartBarApp;
//- (void)itemDidRetract:(RASmartBarViewController *)smartBarApp;
@end