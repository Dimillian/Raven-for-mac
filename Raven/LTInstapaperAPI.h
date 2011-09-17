//
// LTInstapaperAPI.h
//
// Created by David E. Wheeler on 2/3/11.
// Copyright (c) 2011, Lunar/Theory, LLC.
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer. Redistributions in binary
// form must reproduce the above copyright notice, this list of conditions and
// the following disclaimer in the documentation and/or other materials
// provided with the distribution. Neither the name of the Lunar/Theory, LLC
// nor the names of its contributors may be used to endorse or promote
// products derived from this software without specific prior written
// permission. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
// CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
// NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
// OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
// OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import <Foundation/Foundation.h>

@protocol LTInstapaperAPIDelegate;

@interface LTInstapaperAPI : NSObject {
    id<LTInstapaperAPIDelegate> delegate;
    NSString *username;
    NSString *password;
    NSURLConnection *conn;
    BOOL authenticating;
}

@property (nonatomic, assign) id<LTInstapaperAPIDelegate> delegate;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

- (id)initWithUsername:(NSString *)username password:(NSString *)password delegate:(id<LTInstapaperAPIDelegate>)delegate;
- (void)authenticate;
- (void)addURL:(NSString *)url;
- (void)addURL:(NSString *)url title:(NSString *)title;
- (void)addURL:(NSString *)url title:(NSString *)title selection:(NSString *)selection;

@end

@protocol LTInstapaperAPIDelegate
@optional
- (void) instapaper:(LTInstapaperAPI *)instapaper authDidFinishWithCode:(NSUInteger)code;
- (void) instapaper:(LTInstapaperAPI *)instapaper addDidFinishWithCode:(NSUInteger)code;
@end