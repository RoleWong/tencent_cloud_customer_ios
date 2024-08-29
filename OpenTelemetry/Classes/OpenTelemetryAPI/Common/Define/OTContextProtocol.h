//
//  OTContextProtocol.h
//  Pods
//
//  Created by ravendeng on 2021/10/22.
//  Copyright (c) 2020 ravendeng. All rights reserved.
//

#ifndef OTContextProtocol_h
#define OTContextProtocol_h

@protocol OTContextProtocol <NSObject, NSSecureCoding, NSCoding>

/// decide wether the span will be sampled and report
@property (nonatomic, assign, readonly) BOOL isSampled;
@property (nonatomic, copy, readonly) NSString *traceIdString;
@property (nonatomic, copy, readonly) NSString *spanIdString;
@property (nonatomic, copy, readonly) NSString *traceParentString;
@property (nonatomic, copy, readonly) NSString *traceStateString;
@property (nonatomic, copy, readonly) NSData *traceIdByte;
@property (nonatomic, copy, readonly) NSData *spanIdByte;

@end

#endif /* OTContextProtocol_h */
