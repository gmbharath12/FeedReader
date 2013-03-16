//
//  ViewController.m
//  FeedReader
//
//  Created by Bharath G M on 3/14/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

#define kFeederURL @"http://blog.solstice-mobile.com/feeds/posts/default"
#define TITLE_NAVIGATIONBAR @"Solstice Mobile Blog";

static NSString *kPublishedDate = @"published";
static NSString *kTitle = @"title";
static NSString *kContent = @"content";
static NSString *kAuthorName = @"name";
static NSString *kEmail = @"email";
static NSString *kImageSource = @"gd:image";

@interface ViewController ()

@end

@implementation ViewController

@synthesize m_cXmlData;
@synthesize m_cURLConnection;
@synthesize m_cFeed;
@synthesize m_cArrayOfFeeds;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initialize];
    [self fetchData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  /*  
   //Fetching date --- Asynchronus Way
   dispatch_async(dispatch_get_global_queue(0, 0),
                   ^{
                       NSError *error;
                       self.m_cXmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kFeederURL] options:NSDataReadingUncached error:&error];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          if (error)
                                          {
                                              NSString *errorMessage = [error localizedDescription];
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot fetch the data" message:errorMessage delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
                                              [alertView show];
                                          }
                                          [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                          NSLog(@"Data = %@",m_cXmlData);

                                       }
                                      );
                    }
                   );*/
}


-(void)initialize
{
    self.title = TITLE_NAVIGATIONBAR
    m_cElementsToParse = [[NSArray alloc] initWithObjects:kPublishedDate,kTitle,kContent,kAuthorName,kEmail,kImageSource, nil];
    m_cReadableDataString = [NSMutableString string];
    m_cArrayOfFeeds = [NSMutableArray array];
    m_cTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 415) style:UITableViewStylePlain];
    m_cTableView.delegate = self;
    m_cTableView.dataSource = self;
    m_cTableView.hidden = YES;
    [self.view addSubview:m_cTableView];
}

-(void)fetchData
{
//    to handle the error gracefully. So NURLConnection.
    NSURLRequest *lrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kFeederURL]];
    m_cURLConnection = [NSURLConnection connectionWithRequest:lrequest delegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}



#pragma mark -
#pragma mark NSURLConnection delegate methods

//	response received 
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.m_cXmlData = [NSMutableData data];    // start fetching data
}

//	data received

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [m_cXmlData appendData:data];  // append incoming data
}

//	connection failed ?

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot fetch the data"
														message:errorMessage
													   delegate:nil
											           cancelButtonTitle:@"OK"
											           otherButtonTitles:nil];
    [alertView show];
    self.m_cURLConnection = nil;
    
}

// data recieved completely

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    NSLog(@"XML data = %@",m_cXmlData);

//    Using SAX NSXMLParser. After parsing I realized DOM would have made my job easier.
    
    m_cParser = [[NSXMLParser alloc] initWithData:m_cXmlData]; //could have used 'initWithURL' r8 here.realized it later
    [m_cParser setDelegate:self];
    [m_cParser parse];
}



#pragma mark -
#pragma mark Feeds processing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                     namespaceURI:(NSString *)namespaceURI
                                     qualifiedName:(NSString *)qName
                                     attributes:(NSDictionary *)attributeDict
{
//    entry: { id,published,updated,category,title (type-text),content (type-html),  author {name,email,gd:image}}

    if ([elementName isEqualToString:@"entry"])
    {
       self.m_cFeed = [[SolsticeObject alloc] init];
    }
    
    ifElementFound = [m_cElementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
                                     namespaceURI:(NSString *)namespaceURI
                                     qualifiedName:(NSString *)qName
{

    if (ifElementFound)
    {
        NSString *trimmedString = [m_cReadableDataString stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [m_cReadableDataString setString:@""];  // clearing the string for next time

        if ([elementName isEqualToString:kPublishedDate])
        {
            self.m_cFeed.m_cPublishedDate = trimmedString;
        }
        
        else if ([elementName isEqualToString:kTitle])
        {
            self.m_cFeed.m_cTitle = trimmedString;

        }
        else if ([elementName isEqualToString:kContent])
        {
            
           self.m_cFeed.m_cContent =  [self extractNSStringFromHtml:trimmedString];
//            instead of extracting NSString from Html I could have used UIWebView in a next view controller.
//            'extractNSString...' function doesnt scan for &nbsp etc.
        }
        
    else if ([elementName isEqualToString:kAuthorName])
    {
        if (m_cFeed) //checking this condition bcoz 'm_cFeed" is null.This is one of the challenges I faced.
            
        {
            self.m_cFeed.m_cAuthorName = trimmedString;
        }
    }

    else if ([elementName isEqualToString:kEmail])
    {
        if (m_cFeed) 
            
        {
            self.m_cFeed.m_cEmail = trimmedString;
        }
        
    }

    else if ([elementName isEqualToString:kImageSource])
    {
        if (m_cFeed) 
        {
            self.m_cFeed.m_cImageSource = trimmedString;
            [m_cArrayOfFeeds addObject:self.m_cFeed];
        }
        
        [m_cTableView setHidden:NO];
        [m_cTableView reloadData];
    }

 }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (ifElementFound)
    {
         [m_cReadableDataString appendString:string];
    }

}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{

    NSLog(@"Error = %@",[parseError description]);
    
}


-(NSString*)extractNSStringFromHtml:(NSString*)htmlString
{
//    scanner scans the entire string. by default it scans from left to r8.
//    direction of scanning can be changed
//    here I'm trying to look for '<' '>' characters and storing the scanned string in 'extractedString' var
    NSScanner *scanner = [NSScanner scannerWithString:htmlString];
    NSString *extractedString = [NSString string];
    while ([scanner isAtEnd] == NO)
    {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&extractedString];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",extractedString] withString:@""];
    }
    return htmlString;
}


#pragma mark --
#pragma mark Table View Data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_cArrayOfFeeds count];//no of feeds
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    SolsticeObject *feeds = [m_cArrayOfFeeds objectAtIndex:indexPath.row];
    cell.textLabel.text = feeds.m_cTitle;
    cell.textLabel.adjustsFontSizeToFitWidth = NO;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    return cell;
}

#pragma --
#pragma mark Table View Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *lDetailController = [[DetailViewController alloc] init];
    lDetailController.m_cDetailViewObject = [m_cArrayOfFeeds objectAtIndex:indexPath.row];
    lDetailController.navigationItem.title = @"Feeds";
    [self.navigationController pushViewController:lDetailController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
