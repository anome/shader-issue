#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end




@implementation AppDelegate
{
    NSTimer *timer;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self.openGLView setNeedsDisplay:YES];
    }];
}

@end
