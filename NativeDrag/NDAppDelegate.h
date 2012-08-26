#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface NDAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>
{
	NSMutableArray *songs;
}
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSTableView *tableView;

@end
