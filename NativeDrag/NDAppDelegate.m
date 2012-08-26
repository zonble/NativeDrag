#import "NDAppDelegate.h"

static NSString *const kSongObjectType = @"net.zonble.songobejct";
static NSString *const kSongNameType = @"song_name";
static NSString *const kArtistNameType = @"artist_name";
static NSString *const kAlbumNameType = @"album_name";

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

#pragma mark WebView UI Delegate

- (NSUInteger)webView:(WebView *)sender dragDestinationActionMaskForDraggingInfo:(id <NSDraggingInfo>)draggingInfo
{
    return WebDragDestinationActionAny;
}

- (void)webView:(WebView *)webView willPerformDragDestinationAction:(WebDragDestinationAction)action forDraggingInfo:(id <NSDraggingInfo>)draggingInfo
{
}

#pragma mark TableView Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [songs count];
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	if ([cell respondsToSelector:@selector(setFont:)]) {
		[cell setFont:[NSFont systemFontOfSize:18.0]];
	}
}
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	return 25.0;
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
	[pboard declareTypes:@[kSongObjectType, NSStringPboardType] owner:self];
	NSData *data = [NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:nil];
	NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[pboard setString:JSONString forType:kSongObjectType];
	[pboard setString:[NSString stringWithFormat:@"\nSong: %@\nArtist: %@\nAlbum: %@", d[kSongNameType], d[kArtistNameType], d[kAlbumNameType]] forType:NSStringPboardType];
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
		return NSDragOperationCopy;
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
		NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		if (!d) {
			return NO;
		}
		if (row < [songs count]) {
			[songs insertObject:d atIndex:row];
		}
		else {
			[songs addObject:d];
		}
		[tableView reloadData];
		return YES;
	}
	return NO;
}


@end

