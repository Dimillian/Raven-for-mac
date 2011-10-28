//
//  WebViewController.h
//  Raven
//
//  Created by Thomas Ricouard on 22/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "RAItemObject.h"
#import "RADatabaseController.h"
#import "RADownloadController.h"
#import "RADownloadObject.h"
#import "RAFavoritePanelWController.h"
#import "RANSURLDownloadDelegate.h"
#import "RAAddressFieldBox.h"
@protocol RAWebViewControllerDelegate;
@interface RAWebViewController : NSViewController <NSMenuDelegate, NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource>{
    id<RAWebViewControllerDelegate> delegate;
    
    IBOutlet NSTabView *tabs; 
    IBOutlet NSView *mainView; 
    IBOutlet NSView *switchView; 
    //the view controller
    IBOutlet NSViewController* myCurrentViewController;
    IBOutlet WebView *webview; 
    IBOutlet NSTextField *address; 
    IBOutlet NSText *text; 
    IBOutlet NSProgressIndicator *progress;
    IBOutlet NSButton *mobileButton; 
    IBOutlet NSButton *stopLoading; 
    IBOutlet NSImage *favicon; 
    IBOutlet NSImageView *temp; 
    IBOutlet NSButton *tabsButton; 
    IBOutlet NSButton *secondTabButton;
    IBOutlet NSScrollView *scrollView; 
    
    IBOutlet NSProgressIndicator *progressMain; 
    
    BOOL isNewTab; 
    NSInteger bytesReceived;
    NSURLResponse *downloadResponse;
    NSString *UA; 
    NSString *passedUrl; 
    NSInteger count; 
    NSString *downloadPath;
    NSString *downloadUrl; 
    NSUInteger downloadIndex; 
    
    IBOutlet NSView *tabview; 
    IBOutlet NSImageView *backgroundTab;
    IBOutlet NSImageView *faviconTab; 
    IBOutlet NSTextField *pageTitleTab; 
    IBOutlet NSButton *tabButtonTab; 
    IBOutlet NSButton *closeButtonTab; 
    IBOutlet NSProgressIndicator *progressTab;
    IBOutlet NSView *addressBarView;
    IBOutlet NSBox *boxTab; 
    IBOutlet NSBox *tabHolder; 
    IBOutlet NSSearchField *searchWebView; 
    IBOutlet NSTextField *searchResults; 
    
    NSData *downloadBlob; 
    NSNumber *totalByes; 
    NSNumber *progressBytes; 
    NSNumber *percentage; 
    NSString *downloadName;
    
    int doRegisterHistory;
    int doComeFromHistoryOrBookmark; 
    
    IBOutlet RAAddressFieldBox *addressBox; 
    
    IBOutlet NSMenu *webviewMenu;
    
    
    

    
    
    
}
-(id)initWithDelegate:(id<RAWebViewControllerDelegate>)dgate;

//Bouton action method
-(IBAction)go:(id)sender; 
-(IBAction)mobile:(id)sender;
-(IBAction)addbookmark:(id)sender; 
-(IBAction)home:(id)sender; 
-(IBAction)favoriteMenu:(id)sender; 
-(IBAction)gotopage:(id)sender;
-(IBAction)doASearchOnWebView:(id)sender; 
-(IBAction)enableSearch:(id)sender; 

//tabs
-(IBAction)closeButtonTabClicked:(id)sender;
-(IBAction)tabsButtonClicked:(id)sender;

//Other method
-(void)setMenu;
-(NSMenu *)getFavoriteMenu; 
-(void)initWithUrl:(NSString *)url;
-(void)initWithWelcomePage; 
-(void)initWithPreferredUrl; 
-(void)initWithHistoryPage;;
-(void)initWithBookmarkPage;
-(void)initwithFavoritePage; 
-(void)initWithFirstTimeLaunchPage; 
-(void)checkua; 
-(void)setWindowTitle:(id)sender; 
-(id)infoValueForKey:(NSString*)key;
-(void)setMobileUserAgent;
-(void)setDesktopUserAgent; 
@property (nonatomic, assign) id<RAWebViewControllerDelegate> delegate;
@property (nonatomic, retain) NSSearchField *searchWebView;
@property (nonatomic, retain) NSString *passedUrl;
@property (nonatomic, retain) NSView *switchView;
@property (nonatomic, retain) NSView *addressBarView;
@property (nonatomic, retain) NSButton *tabsButton; 
@property (nonatomic, retain) NSButton *secondTabButton; 
@property (nonatomic, retain) WebView *webview; 
@property (nonatomic, retain) NSTextField *address;
@property int doRegisterHistory;
@property BOOL isNewTab;
@property (nonatomic, retain) IBOutlet NSView *tabview;
@property (nonatomic, retain) NSProgressIndicator *progressTab; 
@property (nonatomic, retain) NSBox *boxTab;
@property (nonatomic, retain) NSBox *tabHolder;
@property (nonatomic, retain) NSButton *tabButtonTab;
@property (nonatomic, retain) NSButton *closeButtonTab; 
@property (nonatomic, retain) NSImageView *backgroundTab; 
@property (nonatomic, retain) NSImageView *faviconTab; 
@property (nonatomic, retain) NSTextField *pageTitleTab;
@end

@protocol RAWebViewControllerDelegate
@optional
-(void)tabWillClose:(RAWebViewController *)RAWebView;
-(void)tabDidSelect:(RAWebViewController *)RAWebView;
@end
