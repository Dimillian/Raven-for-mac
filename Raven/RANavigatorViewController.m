//
//  NavigatorViewController.m
//  Raven
//
//  Created by Thomas Ricouard on 26/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


//*****BEFORE YOU READ*****
//THIS CLASS IS FAT, IT IS A MESS, YOU DON'T WANT TO READ IT, YOU SHOULD REWRITE IT NOW
//*****YOU CAN START READING THE CODE IF YOU WANT*****

#import "RANavigatorViewController.h"
#import "RavenAppDelegate.h"
#import "RANSURLDownloadDelegate.h"

//the size of a tab button
#define tabButtonSize 190
@implementation RANavigatorViewController

@synthesize PassedUrl, tabsArray, fromOtherViews; 

#pragma -
#pragma mark action



-(id)init
{
    self = [super init]; 
    if (self !=nil)
    {
        [self initWithNibName:@"Navigator" bundle:nil]; 
    }
    
    return self; 
}


//WAKE UP
-(void)awakeFromNib
{ 
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
    [nc addObserver:self selector:@selector(windowResize:) name:NSWindowDidResizeNotification object:nil]; 
    //Initialize the array which contain tabs
    tabsArray = [[NSMutableArray alloc]init];
    //Value for the tabs button position and tag (y)
     buttonId = 0;
    
    istab = NO; 
    fromOtherViews = 2; 
    [allTabsButton setHidden:NO]; 
    [allTabsButton setAction:@selector(menutabs:)]; 
    [allTabsButton setTarget:self];
}

//Depreciated
-(void)checkua
{
    //Check if the UA and change the windows size
    if ([UA isEqualToString:@"Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543 Safari/419.3"]) {
        
    }
    else
    {
    
    }
}


-(void)windowResize:(id)sender
{
    if ([sender object] == [tabController window]){
        [self redrawTabs:YES];
    }
    /*
    NSRect windowSize = [[allTabsButton window]frame];
    int size = windowSize.size.width;  
    //WebViewController *button = [tabsArray lastObject];
    if ([tabController numberOfTabViewItems]*tabButtonSize > size - 120)
    {
        //[button.tabview setHidden:YES]; 
        [allTabsButton setHidden:NO]; 
        [allTabsButton setAction:@selector(menutabs:)]; 
        [allTabsButton setTarget:self];
    }
    else
    {
        //[button.tabview setHidden:NO]; 
        [allTabsButton setHidden:YES];   
    }
     */
    
    
}

-(void)setMenu{
    NSMenu *topMenu = [NSApp mainMenu]; 
    [topMenu setSubmenu:navigatorMenu forItem:[topMenu itemAtIndex:7]];
    //[NSApp setMenu:topMenu];
}


#pragma mark -
#pragma mark tab management

//Called once a tab button is clicked
-(void)tabs:(id)sender
{
    [tabController selectTabViewItemAtIndex:[sender tag]]; 
    //Instansiate the webviewcontroller with the object in the array at the button tag index
    RAWebViewController *clickedtab = [tabsArray objectAtIndex:[sender tag]];
    [clickedtab setMenu]; 
    curentSelectedTab = [sender tag];
    //load the clicked button
    //TabButtonControlle *clickedbutton = [buttonTabsArray objectAtIndex:[sender tag]];
    [[clickedtab backgroundTab]setAlphaValue:0.0]; 
    
    //RAMainWindowController *mainWindow = [[[clickedtab webview]window]windowController];
    //[mainWindow replaceTitleBarViewWith:[clickedtab addressBarView]];
    
    //reset all button state
    [self resetAllTabsButon]; 
    
    if (clickedtab != nil)
    {
            //Set the title of the windows
        [clickedtab setWindowTitle:allTabsButton];
        [self setImageOnSelectedTab]; 
    }
    
    //make the selected button appear to make an animation
    [[[clickedtab backgroundTab]animator]setAlphaValue:1.0];
}

-(void)previousTab:(id)sender
{
    [self resetAllTabsButon]; 
    if ([tabController indexOfTabViewItem:[tabController selectedTabViewItem]] == 0){
        [tabController selectLastTabViewItem:self];
    }
    else{
        [tabController selectPreviousTabViewItem:self]; 
    }
    [self setImageOnSelectedTab];
}
-(void)nextTab:(id)sender
{
    [self resetAllTabsButon];
    if ([tabController indexOfTabViewItem:[tabController selectedTabViewItem]] == [tabController numberOfTabViewItems] -1) {
        [tabController selectFirstTabViewItem:self];
    }
    else{
    [tabController selectNextTabViewItem:self];
    }
    [self setImageOnSelectedTab];
}

//Add a new tabs
//Maybe a big piece of shit but it works. Need rewrite



-(void)redrawTabs:(BOOL)fromWindow
{
    if (localWindow == nil) {
        localWindow = [NSApp keyWindow];
    }
    if ([tabsArray count] <= 1 && !fromWindow) {
        for (RAWebViewController *aTab in tabsArray) {
            [[aTab tabHolder]setHidden:YES];
            [[aTab tabview]setHidden:YES]; 
            [[aTab webview]setFrame:NSMakeRect(aTab.webview.frame.origin.x, aTab.webview.frame.origin.y, aTab.webview.frame.size.width, aTab.webview.frame.size.height+22)];
        }
        
    }
    else
    {
        CGFloat x = 0;
        for (int i =0; i<[tabsArray count]; i++) {
            RAWebViewController *aTab = [tabsArray objectAtIndex:i];
            [[aTab tabHolder]setHidden:NO];
            CGFloat w = (localWindow.frame.size.width-80)/[tabsArray count];
            if (w > tabButtonSize){
                w=tabButtonSize;
                if (i==0){
                    x=0;
                }
                else{
                    x = x + tabButtonSize;   
                }
            }
            else {
                if (i==0){
                    x=0;
                }
                else{
                    x = x + (localWindow.frame.size.width - 77)/[tabsArray count];
                }
            }
            if (i == 0) {
                if ([[aTab tabview]isHidden] == YES && !fromWindow) {
                    [[aTab webview]setFrame:NSMakeRect(aTab.webview.frame.origin.x, aTab.webview.frame.origin.y, aTab.webview.frame.size.width, aTab.webview.frame.size.height - 22)];
                }
            }
            if (!fromWindow) {
                [[aTab tabview]setHidden:NO]; 
                [[aTab tabview]setAlphaValue:1.0]; 
                [NSAnimationContext beginGrouping];
                [[NSAnimationContext currentContext] setDuration:0.2];  
                [[[aTab tabview]animator]setFrame:NSMakeRect(x, 0, w, 22)];
                [NSAnimationContext endGrouping];
            }
            else{
                [[aTab tabview]setFrame:NSMakeRect(x, 0, w, 22)];   
            }
        }
    }
    localWindow = nil; 
}

-(void)addtabs:(id)sender
{
    localWindow = [sender window];
    if (localWindow == nil) {
        localWindow = [NSApp keyWindow];
    }
    //Instanciate a new webviewcontroller and the button tab view with the view
    RAWebViewController *newtab = [[RAWebViewController alloc]init];
    //Set the Button view
    //force the view to init
    [newtab view]; 
    [[newtab tabview]setAlphaValue:0.0]; 
    [[newtab tabButtonTab]setAction:@selector(tabs:)]; 
    [[newtab tabButtonTab]setTarget:self]; 
    [[newtab tabButtonTab]setTag:buttonId]; 
        curentSelectedTab = buttonId; 
    [[newtab tabButtonTab]setEnabled:YES]; 
    [[newtab pageTitleTab]setStringValue:NSLocalizedString(@"New tab", @"NewTab")];
    [[newtab closeButtonTab]setTag:buttonId]; 
    [[newtab closeButtonTab]setAction:@selector(closeSelectedTab:)]; 
    [[newtab closeButtonTab]setTarget:self];
    [[newtab closeButtonTab]setEnabled:YES]; 
    [[newtab closeButtonTabShortcut]setTag:buttonId]; 
    [[newtab closeButtonTabShortcut]setAction:@selector(closeSelectedTab:)]; 
    [[newtab closeButtonTabShortcut]setTarget:self];
    [[newtab closeButtonTabShortcut]setEnabled:YES]; 
    
    //Bind the addtabd button to the current object action
    [[newtab tabsButton]setAction:@selector(addtabs:)];
    [[newtab tabsButton]setTarget:self]; 
    [[newtab secondTabButton]setAction:@selector(addtabs:)];
    [[newtab secondTabButton]setTarget:self]; 
    //set the new webview delegate to this class method
    [[newtab webview]setUIDelegate:self]; 
    [[newtab webview]setPolicyDelegate:self]; 
    //Set the host window to the actual window for plugin 
    [[newtab webview]setHostWindow:localWindow];
    

    
    NSRect windowSize = [[sender window]frame];
    CGFloat size = windowSize.size.width;  
    
    //If the buttposition is over 900 then display a button which will list tabs
    if ([tabController numberOfTabViewItems]*tabButtonSize > size - 250)
    {
        [allTabsButton setHidden:NO]; 
        [allTabsButton setAction:@selector(menutabs:)]; 
        [allTabsButton setTarget:self];
    }
    else
    {
        [allTabsButton setHidden:YES];   
    }

    
    //Add the button and webview instance in array.
    [tabsArray addObject:newtab]; 

    //Add created elements to the view
    [tabPlaceHolder addSubview:[newtab tabview]];
    [[newtab tabview]setFrame:NSMakeRect(buttonId*tabButtonSize, 22, tabButtonSize, 22)];
    
    //increment the position and the tag value for the next button placement
    buttonId = buttonId +1;
    
    //Pre select the address for faster typing
    [[newtab address]selectText:self];
    
    //if the passed URL value is different of nil then load it in the webview 
    if (PassedUrl != nil) {
        [newtab setIsNewTab:NO]; 
        [newtab initWithUrl:PassedUrl]; 

    }
    //if null then inti the webview with tthe welcom page
    else
    {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if (standardUserDefaults) {
            if ([standardUserDefaults integerForKey:@"doHaveLaunched"] == 0) {
                [standardUserDefaults setInteger:1 forKey:@"doHaveLaunched"];
                [standardUserDefaults synchronize];
                [newtab initWithFirstTimeLaunchPage];
            }
                else
                {
                    [newtab initWithPreferredUrl]; 
                }
            }
        }
    //[buttonview release]; 
    NSTabViewItem *item = [[NSTabViewItem alloc]init]; 
    [item setView:[newtab switchView]];
    [tabController addTabViewItem:item]; 
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults]; 
    if (standardUserDefault) {
        if ([standardUserDefault integerForKey:@"OpenTabInBackground"] == 0) {
                //reset all tabs button position
                [self resetAllTabsButon]; 
                [tabController selectTabViewItem:item]; 
                [newtab setMenu]; 
                //If the new tab object is diffrent of null then show it (it should be alway different of null)
                if (newtab != nil)
                {
                    [newtab setWindowTitle:sender];
                    //[newtab setCurrentButtonClicked:buttonview]; 
                    //Set the clicked button alpha value to show it activated
                }
        }
    }
    [self setImageOnSelectedTab];
    
    //RAMainWindowController *mainWindow = [[tabController window]windowController];
    //[mainWindow replaceTitleBarViewWith:[newtab addressBarView]];
    [item release]; 
    [newtab release]; 
    [self redrawTabs:NO];
    //reset the value
    PassedUrl = nil; 
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateTabNumber" object:nil];
    
}

//THe action when the tab menu button is clicked
-(void)menutabs:(id)sender
{
    NSMenu *menu = [[NSMenu alloc]init]; 
    for (int i=0;i<[tabsArray count];i++)
    {
        RAWebViewController *button =  [tabsArray objectAtIndex:i];
        //Create a menu and set the different items of the menu
        NSMenuItem *item = [[NSMenuItem alloc]init];
        [item setTarget:self]; 
        NSString *tempTitle = [button.pageTitleTab stringValue];
        tempTitle = [tempTitle stringByPaddingToLength:35 withString:@" " startingAtIndex:0];
        [item setTitle:tempTitle]; 
        [item setImage:[button.faviconTab image]];
        [item setTag:i]; 
        [item setAction:@selector(tabs:)];
        [item setEnabled:YES];
        [menu addItem:item];
        [item release]; 
    }
    
    //Draw the menu on a frame 
    NSRect frame = [(NSButton *)sender frame];
    NSPoint menuOrigin = [[(NSButton *)sender superview] convertPoint:NSMakePoint(frame.origin.x, frame.origin.y+frame.size.height-25)
                                                               toView:nil];
    
    NSEvent *event =  [NSEvent mouseEventWithType:NSLeftMouseDown
                                         location:menuOrigin
                                    modifierFlags:NSLeftMouseDownMask // 0x100
                                        timestamp:0
                                     windowNumber:[[(NSButton *)sender window] windowNumber]
                                          context:[[(NSButton *)sender window] graphicsContext]
                                      eventNumber:0
                                       clickCount:1
                                         pressure:1]; 
    
    [NSMenu popUpContextMenu:menu withEvent:event forView:(NSButton *)sender];
    
    [menu release]; 

}


//Reset all tabs button state
-(void)resetAllTabsButon
{
    for (RAWebViewController *tpsbutton in tabsArray) {
        [[tpsbutton boxTab]setFillColor:[NSColor scrollBarColor]];
        [[tpsbutton boxTab]setBorderWidth:1.0]; 
        [[tpsbutton boxTab]setBorderColor:[NSColor darkGrayColor]];
    }

}
-(void)setImageOnSelectedTab
{
    RAWebViewController *clickedtab = [tabsArray objectAtIndex:[tabController indexOfTabViewItem:[tabController selectedTabViewItem]]];
    //[[clickedtab backgroundTab]setImage:[NSImage imageNamed:@"active_tab.png"]];
    [[clickedtab boxTab]setBorderWidth:0.0]; 
    [[clickedtab boxTab]setBorderColor:[NSColor blackColor]];
    [[clickedtab boxTab]setFillColor:[NSColor windowBackgroundColor]];

}

//called when click on the home tab button, bring back the first view

-(void)closeSelectedTab:(id)sender
{
    NSInteger tag = [sender tag];
    //Two temporary array that will store temp object
    NSMutableArray *tpstabarray = [[NSMutableArray alloc]init];

    //The current webview remove
    RAWebViewController *clickedtab = [tabsArray objectAtIndex:tag];
    [clickedtab view];
    [[clickedtab webview]setHostWindow:nil];
    [[clickedtab webview]setUIDelegate:nil]; 
    [[clickedtab webview]setPolicyDelegate:nil];
    [[clickedtab webview]stopLoading:[clickedtab webview]];
    [[[clickedtab view]animator]setAlphaValue:0.0]; 
    [[clickedtab view]removeFromSuperview];
    [[[clickedtab tabview]animator]setAlphaValue:0.0]; 
    [[clickedtab tabview]removeFromSuperview];
    [[clickedtab webview]removeFromSuperview];
    [tabController removeTabViewItem:[tabController tabViewItemAtIndex:tag]]; 
    [tabsArray removeObjectAtIndex:tag];
    


    //reset the buttonid and position in preparation of reorg of tabs
    buttonId = 0; 
    
    //Transfert all the tabs from the real array to the tempsarray
    NSInteger resulttabs = [tabsArray count]; 
    for (int v=0; v<resulttabs; v++) {
        RAWebViewController *tpstab = [tabsArray objectAtIndex:v]; 
        [[tpstab tabButtonTab]setTag:buttonId]; 
        [[tpstab closeButtonTab]setTag:buttonId]; 
        [[tpstab closeButtonTabShortcut]setTag:buttonId]; 
        [self redrawTabs:NO];
        buttonId = buttonId +1; 
        [tpstabarray addObject:tpstab]; 
    }
    
    //remove all object from tabs and button array
    [tabsArray removeAllObjects]; 
    
    //pass the object from tps array in the originale array
    
    for (int v=0; v<resulttabs; v++) {
        [tabsArray addObject:[tpstabarray objectAtIndex:v]]; 
    }
    
    [tpstabarray release]; 
    
    if ([tabsArray count] == 0) {
        [self addtabs:tabsButton]; 
    }
    
    
    if (curentSelectedTab == [sender tag]) {
        if (curentSelectedTab == 0) {
            NSButton *button = [[NSButton alloc]init]; 
            NSInteger nb = 0;
            [button setTag:nb]; 
            [self tabs:button]; 
            [button release]; 
            [tabController selectTabViewItemAtIndex:nb]; 
        }
        else {
            NSButton *button = [[NSButton alloc]init]; 
            NSInteger nb = [sender tag]; 
            nb = nb -1; 
            [button setTag:nb]; 
            [self tabs:button]; 
            [button release]; 
            [tabController selectTabViewItemAtIndex:nb]; 
        }
    }
    [self setImageOnSelectedTab];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"updateTabNumber" object:nil];
    
    
}
//close all tabs
-(void)closeAllTabs:(id)sender
{
    int i = 0;
    for (RAWebViewController *clickedtab in tabsArray) {
        [clickedtab view];
        [[clickedtab webview]setHostWindow:nil];
        [[clickedtab webview]setUIDelegate:nil]; 
        [[clickedtab webview]setPolicyDelegate:nil];
        [[clickedtab webview]stopLoading:[clickedtab webview]];
        [[[clickedtab view]animator]setAlphaValue:0.0]; 
        [[clickedtab view]removeFromSuperview];
        [[[clickedtab tabview]animator]setAlphaValue:0.0]; 
        [[clickedtab tabview]removeFromSuperview];
        [[clickedtab webview]removeFromSuperview];
        [tabController removeTabViewItem:[tabController tabViewItemAtIndex:i]]; 
    }
    [tabsArray removeAllObjects];
    buttonId = 0; 
    [self redrawTabs:NO];
    @synchronized(self){
        [self addtabs:tabsButton]; 
    }
}
#pragma mark -
#pragma mark webview Delegate

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems
{   
    if ([element objectForKey:WebElementLinkURLKey] != nil) {
        NSMutableArray *newItem = [[defaultMenuItems mutableCopy]autorelease];
        NSMenuItem *item = [defaultMenuItems objectAtIndex:1]; 
        [item setTitle:@"Open in a new tab"];
        [newItem replaceObjectAtIndex:1 withObject:item]; 
        return newItem; 
    }
    else
    {
        return defaultMenuItems;
    }
}

- (void)webView:(WebView *)webView decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    if ([type hasPrefix:@"application"]) {
        RANSURLDownloadDelegate *dlDelegate = [[RANSURLDownloadDelegate alloc]init];
        NSURLDownload  *theDownload = [[NSURLDownload alloc] initWithRequest:request
                                                                delegate:dlDelegate];
        [theDownload release]; 
        [dlDelegate release]; 
        if (![type isEqualToString:@"application/pdf"]) {
            [webView stopLoading:nil];
        }
    }
}

//create a new tab with the clicked URL
//it create a temp webview, totally useless but necessary because webview API are broken in this part
- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    WebView *tempview = [[WebView alloc]init]; 
    [tempview setFrameLoadDelegate:self]; 
    [[tempview mainFrame]loadRequest:request]; 
    return tempview; 
}

//Little hack to intercept URL, the webview start provisiosing with the previous request. Only way to catch the URL
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
if (frame == [sender mainFrame]){
    if ([[sender mainFrameURL]isEqualToString:@""]) {
    }
        else
        {
            PassedUrl = [sender mainFrameURL]; 
            [self addtabs:tabsButton];
            [sender stopLoading:sender]; 
        }
    }
}


- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id < WebPolicyDecisionListener >)listener
{
    //PassedUrl = [[request URL]absoluteString]; 
    //[self addtabs:nil];
    [listener use];
}


//Manage javascript altert message
- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Alert"];
    [alert setInformativeText:message];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal]; 
    [alert release]; 
    
}

//Manage Javascript confirmation message
-(BOOL)webView:(WebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame
{
    BOOL result; 
    //prepare the alert
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Confirmation Alert"];
    [alert setInformativeText:message];
    [alert addButtonWithTitle:@"Ok"];
    [alert addButtonWithTitle:@"Cancel"];
    
    //call the alert and check the selected button
    if ([alert runModal] == NSAlertFirstButtonReturn)
    {
        result = YES; 
    }
     else
     {
         result = NO; 
     }
    
    [alert release];

    
    return result; 
    
}

//Mange Javascript string return prompt
- (NSString *)webView:(WebView *)sender runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WebFrame *)frame
{
    
    //Create a view
    NSView *alterView = [[NSView alloc]initWithFrame:NSMakeRect(0, 0, 300, 60)]; 
    //Creating the différents element for the view
    NSTextField *titleField = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,300,23)];
    [titleField setStringValue:defaultText]; 
    [titleField setEditable:YES];
    [titleField setDrawsBackground:NO];
    //Add created elements to the view
    [alterView addSubview:titleField]; 
    //prepare the alert
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Prompt"];
    [alert setAccessoryView:alterView];
    [alterView release]; 
    [alert setInformativeText:prompt];
    [alert addButtonWithTitle:@"Ok"];
    [alert addButtonWithTitle:@"Cancel"];
    
    //call the alert and check the selected button
    if ([alert runModal] == NSAlertFirstButtonReturn)
    {
        NSString *result = [titleField stringValue]; 
        [alert release];
        [titleField release]; 
        return result; 
        
    }
    else
    {
        [alert release];
        [titleField release]; 
        return nil;
    }
    
}
/*
//UPload window
- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id < WebOpenPanelResultListener >)resultListener
{       
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:YES];
    
    [openDlg setCanChooseDirectories:NO];
    
    // process the files.
    if ( [openDlg runModal] == NSOKButton )
    {
        NSString* fileString = [[openDlg URL]absoluteString];
        [resultListener chooseFilename:fileString]; 
    }
    
}
 */

- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id < WebOpenPanelResultListener >)resultListener
{       
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:NO];
    
    if ( [openDlg runModal] == NSOKButton )
    {
        NSArray* files = [[openDlg URLs]valueForKey:@"relativePath"];
        [resultListener chooseFilenames:files];
    }
    
}
/*
- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id < WebOpenPanelResultListener >)resultListener allowMultipleFiles:(BOOL)allowMultipleFiles
{
        // Create the File Open Dialog class.
        NSOpenPanel* openDlg = [NSOpenPanel openPanel];
        
        // Enable the selection of files in the dialog.
        [openDlg setCanChooseFiles:YES];
        
        // Enable the selection of directories in the dialog.
        [openDlg setCanChooseDirectories:NO];
        
        // Display the dialog.  If the OK button was pressed,
        // process the files.
        if ( [openDlg runModal] == NSOKButton )
        {
            // Get an array containing the full filenames of all
            // files and directories selected.
            NSArray* files = [openDlg URLs];
            NSArray* finalFiles = [[NSArray alloc]init];
            // Loop through all the files and process them.
            for(int i = 0; i < [files count]; i++ )
            {
                NSString* fileName = [files objectAtIndex:i]; //i]; 
                [finalFiles arrayByAddingObject:fileName];
                // Do something with the filename.
                [resultListener chooseFilenames:finalFiles]; 
            }
            [finalFiles release]; 
        }
        
}
 */

/*
- (BOOL)webViewIsStatusBarVisible:(WebView *)sender
{
    return YES; 
}
 */


#pragma -
#pragma mark memory management

//Bad memory maanagement for now ! 
- (void)dealloc
{   
    for (RAWebViewController *newtab in tabsArray) {
        [[newtab webview]setUIDelegate:nil]; 
        [[newtab webview]setPolicyDelegate:nil];
        [[newtab webview]removeFromSuperview];
    }
    [tabsArray removeAllObjects];
    [tabsArray release], tabsArray = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self]; 
    [super dealloc];
}
@end