//
//  ImageButtonDemoAppDelegate.m
//  ImageButtonDemo
//
//  Created by hippos on 10/06/09.
//  Copyright 2010 hippos-lab.com. All rights reserved.
//

#import "ImageButtonDemoAppDelegate.h"
#import "RYZImagePopUpButton.h"

#define kIconSize 36.0

@implementation ImageButtonDemoAppDelegate

@synthesize window;
@synthesize iview;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
}

- (void)awakeFromNib
{
  NSRect contentViewFrame = [[iview contentView] frame];

  DLog(@"x:%.1f y:%.1f w:%.1f h:%.1f", contentViewFrame.origin.x, contentViewFrame.origin.y,
       contentViewFrame.size.width,
       contentViewFrame.size.height);

  icons = [NSArray arrayWithObjects:[NSNumber numberWithInteger:kFinderIcon],
           [NSNumber numberWithInteger:kGenericHardDiskIcon],
           [NSNumber numberWithInteger:kComputerIcon],
           [NSNumber numberWithInteger:kInternetLocationHTTPIcon], nil];

  NSImage *image =
    [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode([[icons objectAtIndex:0] integerValue])];

  imagePopUpButton =
    [[RYZImagePopUpButton alloc] initWithFrame:NSMakeRect(3.75, NSHeight(contentViewFrame) - 42, 42, 42)];

  [[imagePopUpButton cell] setUsesItemFromMenu: NO];
  [imagePopUpButton setIconImage: image];
  [imagePopUpButton setShowsMenuWhenIconClicked: YES];

  NSMenuItem *menuItem = nil;
  NSInteger   tag      = 0;

  for (NSNumber *icon in icons)
  {
    menuItem = [[NSMenuItem alloc] initWithTitle: @""  action:@selector(changeIcon:)keyEquivalent: @""];
    image    = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode([icon integerValue])];

    [image setSize: NSMakeSize(kIconSize, kIconSize)];
    [menuItem setImage: image];
    [menuItem setTarget: self];
    [menuItem setTag:tag];
    [[imagePopUpButton menu] addItem: menuItem];
    [menuItem release];
    tag++;
  }

  [[iview contentView] addSubview:imagePopUpButton];
  [imagePopUpButton setFocusRingType:NSFocusRingTypeNone];
  
  [imagePopUpButton retain];
  [icons retain];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
  [imagePopUpButton release];
  [icons release];
}

- (void)changeIcon:(id)sender
{
  NSInteger   tag       = [(NSMenuItem *)sender tag] - 1;
  
  NSImage    *iconimage =
    [[NSWorkspace sharedWorkspace]
      iconForFileType:NSFileTypeForHFSTypeCode([[icons objectAtIndex:tag] integerValue])];
  [iconimage setSize:NSMakeSize(kIconSize, kIconSize)];

  [imagePopUpButton setIconImage:iconimage];
}
@end
