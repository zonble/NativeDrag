#import "NDAppDelegate.h"

static NSString *const kSongObjectType = @"net.zonble.songobejct";
static NSString *const kSongNameType = @"net.zonble.songname";
static NSString *const kArtistNameType = @"net.zonble.artistname";
static NSString *const kAlbumNameType = @"net.zonble.albumname";

@implementation NDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	songs = [[NSMutableArray alloc] init];
	[songs addObject:@{kSongNameType:@"Apple Flow", kArtistNameType:@"Apple Artist", kAlbumNameType:@"Apple Album"}];
	[songs addObject:@{kSongNameType:@"Orange Flow", kArtistNameType:@"Orange Artist", kAlbumNameType:@"Orange Album"}];
	[songs addObject:@{kSongNameType:@"Banana Flow", kArtistNameType:@"Banana Artist", kAlbumNameType:@"Banana Album"}];
	
	[self.webView setUIDelegate:self];
	
	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];
	[self.tableView registerForDraggedTypes:@[kSongObjectType]];
	[self.tableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];

	NSURLRequest *request = [NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"]];
	[[self.webView mainFrame] loadRequest:request];
}

- (NSUInteger)webView:(WebView *)sender dragDestinationActionMaskForDraggingInfo:(id <NSDraggingInfo>)draggingInfo
{
    return WebDragDestinationActionAny;
}

- (void)webView:(WebView *)webView willPerformDragDestinationAction:(WebDragDestinationAction)action forDraggingInfo:(id <NSDraggingInfo>)draggingInfo
{
//	NSLog(@"%s", __PRETTY_FUNCTION__);
//	NSLog(@"WebDragDestinationAction:%d", action);
//	NSLog(@"draggingInfo:%@", draggingInfo);
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [songs count];
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSDictionary *d = songs[row];
	if ([[tableColumn identifier] isEqualToString:@"song_name"]) {
		return d[kSongNameType];
	}
	else if ([[tableColumn identifier] isEqualToString:@"artist_name"]) {
		return d[kArtistNameType];
	}
	else if ([[tableColumn identifier] isEqualToString:@"album_name"]) {
		return d[kAlbumNameType];
	}
	
	return nil;
}
- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
	NSInteger row = [rowIndexes lastIndex];	
	NSDictionary *d = songs[row];
	[pboard setString:@"song" forType:kSongObjectType];
	[pboard setString:d[kSongNameType] forType:kSongNameType];
	[pboard setString:d[kArtistNameType] forType:kArtistNameType];
	[pboard setString:d[kAlbumNameType] forType:kAlbumNameType];
	return YES;
}
- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
	if (dropOperation != NSTableViewDropAbove) {
		return NSDragOperationNone;
	}
	NSPasteboard *pasteBoard = [info draggingPasteboard];
	NSData *data = [pasteBoard dataForType:kSongObjectType];
	if (data) {
		NSString *songName = [pasteBoard stringForType:kSongNameType];
		NSString *artistName = [pasteBoard stringForType:kArtistNameType];
		NSString *albumName = [pasteBoard stringForType:kAlbumNameType];
		if ([songName length] && [artistName length] && [albumName length]) {
			return NSDragOperationCopy;
		}
	}
	return NSDragOperationNone;
}
- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation
{
	if (dropOperation != NSTableViewDropAbove) {
		return NO;
	}
	
	NSPasteboard *pasteBoard = [info draggingPasteboard];
	NSData *data = [pasteBoard dataForType:kSongObjectType];
	if (data) {
		NSString *songName = [pasteBoard stringForType:kSongNameType];
		NSString *artistName = [pasteBoard stringForType:kArtistNameType];
		NSString *albumName = [pasteBoard stringForType:kAlbumNameType];
		if ([songName length] && [artistName length] && [albumName length]) {
			NSDictionary *d = @{
				kSongNameType:songName,
				kArtistNameType:artistName,
				kAlbumNameType:albumName
			};
			if (row < [songs count]) {
				[songs insertObject:d atIndex:row];
			}
			else {
				[songs addObject:d];
			}
			[tableView reloadData];
			return YES;
		}
	}
	return NO;
}


@end

