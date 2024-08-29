//
//  OTLoggingSink.m
//  OpenTelemetry
//
//  Created by jonassun on 2021/10/4.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "OTLoggingSink.h"
#import "OTLoggingProcessor.h"

@interface OTLoggingSink ()
@end

@implementation OTLoggingSink

- (void)offer:(OTLoggingRecord *)record {
    if ([self.delegate respondsToSelector:@selector(offerRecord:instrumentationLibraryInfo:)]) {
        [self.delegate offerRecord:record instrumentationLibraryInfo:self.instrumentationLibraryInfo];
    }
}

@end
