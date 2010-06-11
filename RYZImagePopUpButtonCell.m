#import "RYZImagePopUpButtonCell.h"


@implementation RYZImagePopUpButtonCell

// -----------------------------------------
//	Initialization and termination
// -----------------------------------------

- (id) init
{
  if (self = [super init])
  {
    _buttonCell = [[NSButtonCell alloc] initTextCell: @""];
    [_buttonCell setBordered: NO];
    [_buttonCell setHighlightsBy: NSContentsCellMask];
    [_buttonCell setImagePosition: NSImageLeft];

    _iconSize                 = NSMakeSize(32, 32);
    _showsMenuWhenIconClicked = NO;

    [self setIconImage: [NSImage imageNamed: @"NSApplicationIcon"]];
    [self setArrowImage: [NSImage imageNamed: @"ArrowPointingDown"]];
  }

  return self;
}

- (void) dealloc
{
  [_buttonCell release];
  [_iconImage release];
  [_arrowImage release];
  [super dealloc];
}


// --------------------------------------------
//	Getting and setting the icon size
// --------------------------------------------

- (NSSize) iconSize
{
  return _iconSize;
}


- (void) setIconSize:(NSSize)iconSize
{
  _iconSize = iconSize;
}


// ---------------------------------------------------------------------------------
//	Getting and setting whether the menu is shown when the icon is clicked
// ---------------------------------------------------------------------------------

- (BOOL) showsMenuWhenIconClicked
{
  return _showsMenuWhenIconClicked;
}


- (void) setShowsMenuWhenIconClicked:(BOOL)showsMenuWhenIconClicked
{
  _showsMenuWhenIconClicked = showsMenuWhenIconClicked;
}


// ---------------------------------------------
//      Getting and setting the icon image
// ---------------------------------------------

- (NSImage *) iconImage
{
  return _iconImage;
}


- (void) setIconImage:(NSImage *)iconImage
{
  [iconImage retain];
  [_iconImage release];
  _iconImage = iconImage;
}


// ----------------------------------------------
//      Getting and setting the arrow image
// ----------------------------------------------

- (NSImage *) arrowImage
{
  return _arrowImage;
}


- (void) setArrowImage:(NSImage *)arrowImage
{
  [arrowImage retain];
  [_arrowImage release];
  _arrowImage = arrowImage;
}


// -----------------------------------------
//	Handling mouse/keyboard events
// -----------------------------------------

- (BOOL) trackMouse:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)
untilMouseUp
{
  
  BOOL trackingResult = YES;

  if ([event type] == NSKeyDown)
  {
    return trackingResult;
  }
  
  NSPoint mouseLocation = [controlView convertPoint: [event locationInWindow]  fromView: nil];
  NSSize  iconSize      = [self iconSize];
  NSSize  arrowSize     = [[self arrowImage] size];
  NSRect  arrowRect     = NSMakeRect(cellFrame.origin.x + iconSize.width + 1,
                                     cellFrame.origin.y,
                                     arrowSize.width,
                                     arrowSize.height);

  if ([controlView isFlipped])
  {
    arrowRect.origin.y += iconSize.height;
    arrowRect.origin.y -= arrowSize.height;
  }

  NSView *superv = [[controlView superview] superview];

  DLog(@"%@->%@->%@",[controlView class],[superv class],[[superv superview] class]);

  if ([event type] == NSLeftMouseDown &&
      ([self showsMenuWhenIconClicked] == YES || [controlView mouse: mouseLocation inRect: arrowRect]))
  {
    NSEvent *newEvent = [NSEvent mouseEventWithType: [event type]
                         location: NSMakePoint([superv frame].origin.x,
                                               [superv frame].origin.y - 2)
                         modifierFlags: [event modifierFlags]
                         timestamp: [event timestamp]
                         windowNumber:[event windowNumber]
                         context: [event context]
                         eventNumber: [event eventNumber]
                         clickCount: [event clickCount]
                         pressure: [event pressure]];

    [NSMenu popUpContextMenu: [self menu]  withEvent: newEvent forView: controlView];
  }
  else
  {
    trackingResult = [_buttonCell trackMouse: event
                      inRect: cellFrame
                      ofView: controlView
                      untilMouseUp: [[_buttonCell class] prefersTrackingUntilMouseUp]];                    // NO for NSButton

    if (trackingResult == YES)
    {
      NSMenuItem *selectedItem = [self selectedItem];
      [[NSApplication sharedApplication] sendAction: [selectedItem action]  to: [selectedItem target]  from:
       selectedItem];
    }
  }
  
  DLog(@"trackingResult: %d", trackingResult);
  return trackingResult;
}


- (void) performClick:(id)sender
{
  NSLog(@"performClick:");

  [_buttonCell performClick: sender];
  [super performClick: sender];
}


// -----------------------------------
//	Drawing and highlighting
// -----------------------------------

- (void) drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  NSImage *iconImage;

  if ([self usesItemFromMenu] == NO)
  {
    iconImage = [self iconImage];
  }
  else
  {
    iconImage = [[[[self selectedItem] image] copy] autorelease];
  }

  [iconImage setSize: [self iconSize]];
  NSImage *arrowImage = [self arrowImage];
  NSSize   iconSize   = [iconImage size];
  NSSize   arrowSize  = [arrowImage size];
  NSImage *popUpImage =
    [[NSImage alloc] initWithSize: NSMakeSize(iconSize.width + arrowSize.width, iconSize.height)];

  NSRect iconRect      = NSMakeRect(0, 0, iconSize.width, iconSize.height);
  NSRect arrowRect     = NSMakeRect(0, 0, arrowSize.width, arrowSize.height);
  NSRect iconDrawRect  = NSMakeRect(0, 0, iconSize.width, iconSize.height);
  NSRect arrowDrawRect = NSMakeRect(iconSize.width, 1, arrowSize.width, arrowSize.height);

  [popUpImage lockFocus];
  [iconImage drawInRect: iconDrawRect fromRect: iconRect operation: NSCompositeSourceOver fraction: 1.0];
  [arrowImage drawInRect: arrowDrawRect fromRect: arrowRect operation: NSCompositeSourceOver fraction: 1.0];
  [popUpImage unlockFocus];

  [_buttonCell setImage: popUpImage];
  [popUpImage release];

  if ([[controlView window] firstResponder] == controlView &&
      [controlView respondsToSelector: @selector(selectedCell)] &&
      [controlView performSelector: @selector(selectedCell)] == self)
  {
    [_buttonCell setShowsFirstResponder: YES];
  }
  else
  {
    [_buttonCell setShowsFirstResponder: NO];
  }

  DLog(@"cellFrame: %@  selectedItem: %@", NSStringFromRect(cellFrame), [[self selectedItem] title]);

  [_buttonCell drawWithFrame: cellFrame inView: controlView];
}


- (void) highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  DLog(@"highlight: %d", flag);

  [_buttonCell highlight: flag withFrame: cellFrame inView: controlView];
  [super highlight: flag withFrame: cellFrame inView: controlView];
}

@end