//
//  DownloadDelegate.h
//  Raven
//
//  Created by Thomas Ricouard on 15/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "RADownloadController.h"
#import "RADownloadObject.h"

@interface RANSURLDownloadDelegate : NSObject <NSAlertDelegate, NSURLDownloadDelegate>{
    NSString *downloadPath;
    NSString *downloadUrl; 
    NSUInteger downloadIndex; 
    NSData *downloadBlob; 
    NSNumber *totalByes; 
    NSNumber *progressBytes; 
    NSNumber *percentage; 
    NSString *downloadName;
    NSInteger bytesReceived;
    NSURLResponse *downloadResponse;
    NSTimeInterval startTime; 
    RADownloadObject *aDownload;
    BOOL trackDownload; 
}
-(void)setDownloadResponse:(NSURLResponse *)aDownloadResponse;
-(void)updateDownloadInformation; 
@end
