//
//  RAlistManager.m
//  Raven
//
//  Created by Thomas Ricouard on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RAlistManager.h"
#import "RavenAppDelegate.h"
#import "RAHiddenWindow.h"
@implementation RAlistManager
@synthesize downloadPath;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(NSMutableArray *)readAppList
{
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *folders = [[dict objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
    return [folders autorelease];
}

-(void)writeNewAppList:(NSMutableArray *)appList
{
    NSString *path = [PLIST_PATH stringByExpandingTildeInPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [dict setObject:appList forKey:PLIST_KEY_DICTIONNARY];
    [dict writeToFile:path atomically:YES];
}

//Basically import app from separate app.plist to main app.plist after checking it is a real app.
//Need to check for duplicate and replace if yes 
-(void)importAppAthPath:(NSString *)path
{
    BOOL newApp;
    NSString *realPath = [NSString stringWithFormat:@"%@/app.plist", path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
    NSString *appFolder = [dict objectForKey:PLIST_KEY_FOLDER];
    NSString *appPlist = [PLIST_PATH stringByExpandingTildeInPath];
    NSMutableDictionary *dictToEdit = [NSMutableDictionary dictionaryWithContentsOfFile:appPlist];
    NSMutableArray *folders = [[dictToEdit objectForKey:PLIST_KEY_DICTIONNARY] mutableCopy];
    NSInteger indexIfExit = [self checkForDuplicate:[dict objectForKey:PLIST_KEY_UDID]];
    if (indexIfExit == -1) {
        [folders addObject:dict];
        newApp = YES;
    }
    else
    {
        [folders replaceObjectAtIndex:indexIfExit withObject:dict];
        newApp = NO;
    }
    [dictToEdit setObject:folders forKey:PLIST_KEY_DICTIONNARY];
    [dictToEdit writeToFile:appPlist atomically:YES];
    [folders release];
    NSString *applicationSupportPath = [[NSString stringWithFormat:application_support_path@"%@", appFolder]stringByExpandingTildeInPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager copyItemAtPath:path toPath:applicationSupportPath error:nil];
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/app.plist", applicationSupportPath] error:nil];
    [self updateProcess];
    if (newApp) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NEW_APP_INSTALLED object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:APP_UPDATED object:nil];

    }
}

//Check if the app is valid, if yes import it
-(BOOL)checkifAppIsValide:(NSString *)path
{
    NSString *realPath = [NSString stringWithFormat:@"%@/app.plist", path];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
    if (dict == nil) {
        NSAlert *alert = [[NSAlert alloc]init];
        [alert setMessageText:NSLocalizedString(@"This Raven Application file is invalid.", @"invalideAppMessage")];
        [alert setInformativeText:NSLocalizedString(@"Please check the source of the file.", @"invalideAppContinur")];
        //[alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        //call the alert and check the selected button
        [alert addButtonWithTitle:NSLocalizedString(@"Ok", @"Ok")];
        [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [alert release]; 
        return NO;
    }
    else {
        return YES;
    }

}

//used to update plist and maintain it up to date with all latest key pair, fired at each launch for beta period
-(void)updateProcess
{
    NSMutableArray *folders = [self readAppList];
    for (int x=0; x<[folders count]; x++) {
        NSMutableDictionary *item = [folders objectAtIndex:x];
        if ([item objectForKey:PLIST_KEY_UDID] == nil) {
            NSString *udid = [NSString stringWithFormat:@"com.yourname.%@", [item objectForKey:PLIST_KEY_APPNAME]];
            [item setObject:udid forKey:PLIST_KEY_UDID];
        }
        if ([item objectForKey:PLIST_KEY_ENABLE] == nil){
            [item setObject:[NSNumber numberWithInt:1] forKey:PLIST_KEY_ENABLE];
        }
        if ([item objectForKey:PLIST_KEY_CATEGORY] == nil) {
            [item setObject:@"No category" forKey:PLIST_KEY_CATEGORY];
        }
        if ([[item objectForKey:PLIST_KEY_CATEGORY]isEqualToString:@"No categorie"]) {
            [item setObject:@"No category" forKey:PLIST_KEY_CATEGORY];
        }
        if ([item objectForKey:PLIST_KEY_OFFICIAL] == nil) {
            [item setObject:@"Unofficial" forKey:PLIST_KEY_OFFICIAL];
        }
        [folders replaceObjectAtIndex:x withObject:item];
    }
    [self writeNewAppList:folders];


}

//Fired by the download view, once app unziped, delete the zip
-(void)installApp
{
    [self UnzipFile:downloadPath];
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    [fileManager removeItemAtPath:downloadPath error:nil];

}

//if install is ok then import
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    if (returnCode == NSAlertFirstButtonReturn) {
        [self importAppAthPath:destinationPath];
        [fileManager removeItemAtPath:destinationPath error:nil];
    }
    else
    {
       [fileManager removeItemAtPath:destinationPath error:nil];  
    }
}

//unzip, and see if the user want to import it
- (void)UnzipFile:(NSString*)sourcePath
{
    NSString *downloadFolder = [@"~/Downloads" stringByExpandingTildeInPath];
    destinationPath = [sourcePath stringByReplacingOccurrencesOfString:@".zip" withString:@""];
    NSTask    *unzip = [[[NSTask alloc] init] autorelease];
    [unzip setLaunchPath:@"/usr/bin/unzip"];
    [unzip setArguments:[NSArray arrayWithObjects:@"-o", sourcePath, @"-d", downloadFolder, nil]];
    [unzip launch];
    [unzip waitUntilExit];
    BOOL success = [self checkifAppIsValide:destinationPath]; 
    if (success) {
        NSString *realPath = [NSString stringWithFormat:@"%@/app.plist", destinationPath];
        [destinationPath retain];
        NSDictionary*dict = [NSMutableDictionary dictionaryWithContentsOfFile:realPath];
        NSString *appname = [NSString stringWithFormat:@"Would you like to install this web app? %@",[dict objectForKey:PLIST_KEY_APPNAME]];
        NSAlert *alert = [[NSAlert alloc]init];
        [alert setMessageText:appname];
        [alert setInformativeText:@"If you already have this app installed it will just be replaced and updated"];
        NSImage *icon = [[NSImage alloc]initWithContentsOfFile:
                         [NSString stringWithFormat:@"%@/main.png", destinationPath]];
        [destinationPath retain];
        [alert setIcon:icon];
        //[alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        //call the alert and check the selected button
        [alert addButtonWithTitle:NSLocalizedString(@"Ok", @"Yeah")];
        [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
        [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        [alert release]; 
        [icon release]; 
    }
}


-(NSInteger)checkForDuplicate:(NSString *)Identifier
{
    NSMutableArray *folders = [self readAppList];
    for (int x=0; x<[folders count]; x++) {
        NSMutableDictionary *item = [folders objectAtIndex:x];
        if ([[item objectForKey:PLIST_KEY_UDID]isEqualToString:Identifier]) {
            return x; 
        }
    }
    return -1; 
}


-(void)swapObjectAtIndex:(NSInteger)index upOrDown:(NSInteger)order
{
    NSMutableArray *folders = [self readAppList];
    if (order == 1 && index+1 < [folders count]) {
        id tempA = [folders objectAtIndex:index];
        id tempB = [folders objectAtIndex:index + 1];
        [folders replaceObjectAtIndex:index withObject:tempB];
        [folders replaceObjectAtIndex:index+1 withObject:tempA];
    }
    else if (order == 0 && index > 0)
    {
        id tempA = [folders objectAtIndex:index];
        id tempB = [folders objectAtIndex:index - 1];
        [folders replaceObjectAtIndex:index withObject:tempB];
        [folders replaceObjectAtIndex:index-1 withObject:tempA];
    }
    [self writeNewAppList:folders];
}

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    NSMutableArray *folders = [self readAppList];
    if (to != from) {
        id obj = [folders objectAtIndex:from];
        [obj retain];
        [folders removeObjectAtIndex:from];
        if (to >= [folders count]) {
            [folders addObject:obj];
        } else {
            [folders insertObject:obj atIndex:to];
        }
        [obj release];
    }
    [self writeNewAppList:folders];
}

-(void)changeStateOfAppAtIndex:(NSInteger)index withState:(NSInteger)state
{
    NSMutableArray *folders = [self readAppList];
    NSMutableDictionary *item = [folders objectAtIndex:index]; 
    [item setObject:[NSNumber numberWithInteger:state] forKey:PLIST_KEY_ENABLE];
    [folders replaceObjectAtIndex:index withObject:item];
    [self writeNewAppList:folders];
}


-(NSInteger)returnStateOfAppAtIndex:(NSInteger)index
{
    NSMutableArray *folders = [self readAppList];
    NSMutableDictionary *item = [folders objectAtIndex:index]; 
    NSNumber *state = [item objectForKey:PLIST_KEY_ENABLE]; 
    return [state integerValue];
    
}

-(void)deleteAppAtIndex:(NSInteger)index
{
    NSMutableArray *folders = [self readAppList];
    NSMutableDictionary *appToDelete = [folders objectAtIndex:index];
    NSString *folderName = [appToDelete objectForKey:PLIST_KEY_FOLDER];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[[NSString stringWithFormat:application_support_path@"%@", folderName]stringByExpandingTildeInPath] error:nil];
    [folders removeObjectAtIndex:index];
    [self writeNewAppList:folders];
    
}


@end
