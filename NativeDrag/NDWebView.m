#import "NDWebView.h"

static NSString *const kSongObjectType = @"net.zonble.songobejct";

@implementation NDWebView

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
	
    if ([[pboard types] containsObject:kSongObjectType] ) {
		[super performDragOperation:sender];
		return YES;
	}
    return [super performDragOperation:sender];
}

@end
