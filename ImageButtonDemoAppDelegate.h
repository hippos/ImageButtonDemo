//
//  ImageButtonDemoAppDelegate.h
//  ImageButtonDemo
//
//  Created by hippos on 10/06/09.
//  Copyright 2010 hippos-lab.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RYZImagePopUpButton;

@interface ImageButtonDemoAppDelegate : NSObject<NSApplicationDelegate>
{
  NSWindow            *window;
  NSBox               *iview;
  RYZImagePopUpButton *imagePopUpButton;
  NSArray             *icons;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSBox *iview;

-(void)changeIcon:(id)sender;

@end
