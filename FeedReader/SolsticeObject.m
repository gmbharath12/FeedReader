//
//  SolsticeObject.m
//  FeedReader
//
//  Created by Bharath G M on 3/15/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import "SolsticeObject.h"

@implementation SolsticeObject

@synthesize m_cContent,m_cPublishedDate,m_cTitle,m_cAuthorName,m_cEmail,m_cImageSource;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.m_cTitle = nil;
        self.m_cPublishedDate = nil;
        self.m_cContent = nil;
        self.m_cAuthorName = nil;
        self.m_cEmail = nil;
        self.m_cImageSource = nil;
    }
    return self;
}
@end
