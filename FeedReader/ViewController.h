//
//  ViewController.h
//  FeedReader
//
//  Created by Bharath G M on 3/14/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolsticeObject.h"

@interface ViewController : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSXMLParser *m_cParser;
    NSMutableData *m_cXmlData;
    NSURLConnection *m_cURLConnection;
    SolsticeObject *m_cFeed;
    NSArray *m_cElementsToParse;
    BOOL ifElementFound;
    NSMutableString *m_cReadableDataString;
    NSMutableArray *m_cArrayOfFeeds;
    UITableView *m_cTableView;
}

@property (nonatomic,strong)  NSMutableData *m_cXmlData;
@property (nonatomic,strong)  NSURLConnection *m_cURLConnection;
@property (nonatomic,strong) SolsticeObject *m_cFeed;
@property (nonatomic,strong) NSMutableArray *m_cArrayOfFeeds;

@end
