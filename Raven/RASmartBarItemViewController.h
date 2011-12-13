//
//  RASmartBarViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 30/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "RANavigatorViewController.h"
#import "RASmartBarButton.h"
#import "RASBAPPMainButton.h"
#import "RASmartBarHolderView.h"
#import "RAlistManager.h"
#import "RASmartBarItem.h"
#import "RADotTextField.h"

@class RAMainWindowController; 
@protocol RASmartBarViewItemControllerDelegate;
@interface RASmartBarItemViewController : NSViewController <RASBAPPMainButtonDelegate>
{
    id<RASmartBarViewItemControllerDelegate> delegate;
    RASmartBarItem *_smartBarItem; 
    NSMutableArray *buttonArray; 
    NSMutableArray *tabNumberFieldArray; 
    NSInteger _state;
    NSInteger _selectedButton; 
    
    //self view outlet
    IBOutlet RASmartBarHolderView *mainView; 
    
    //Button outlet
    IBOutlet RASBAPPMainButton *mainButton; 
    IBOutlet NSButton *closeAppButton; 
    
    IBOutlet NSImageView *badgeView; 
    IBOutlet NSImageView *lightVIew; 

    NSUInteger totalTabs;
    
    NSInteger _appNumber; 
    
    CATransition *transition;

}
-(id)initWithDelegate:(id<RASmartBarViewItemControllerDelegate>)dgate 
            withRASmartBarItem:(RASmartBarItem *)item;

-(void)buttonDidClicked:(id)sender; 
-(void)calculateTotalTab;
-(IBAction)expandApp:(id)sender;
-(void)retractApp:(id)sender;
-(IBAction)closeAppButtonCliced:(id)sender; 
-(void)updateStatusAndCleanMemory;
-(void)resetAllButton; 
-(void)setSelectedButton;
-(void)updateTabsNumber; 
-(void)hideCloseAppButton; 
-(void)showCloseAppButton; 
-(void)hoverMainButton; 
-(void)hideHoverMainButton; 
-(void)receiveNotification:(NSNotification *)notification;
-(NSString *)numberOfDotToDisplay:(NSUInteger)numberOfTabs; 


@property (nonatomic, assign) id<RASmartBarViewItemControllerDelegate> delegate;
@property (nonatomic, retain) RASmartBarItem *smartBarItem; 
@property NSInteger selectedButton;
@property NSInteger state;

@end

@protocol RASmartBarViewItemControllerDelegate
@optional
//- (void)selectionDidChange:(RASmartBarViewController *)smartBarApp;
- (void)itemDidExpand:(RASmartBarItemViewController *)smartBarApp;
- (void)itemDidRetract:(RASmartBarItemViewController *)smartBarApp;
@end