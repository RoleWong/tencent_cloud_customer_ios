//
//  OTCallbackDefine.h
//  Pods
//
//  Created by ravendeng on 2021/10/20.
//  Copyright (c) 2020 ravendeng. All rights reserved.
//

#ifndef OTCallbackDefine_h
#define OTCallbackDefine_h

@class OTResource;

typedef void (^OTExporterCallback)(NSInteger statusCode, NSString *_Nullable dataString, NSError *_Nullable error);

FOUNDATION_EXPORT NSErrorDomain const _Nonnull gOTExporterErrorDomain;
FOUNDATION_EXPORT NSInteger const gOTExporterNotImplemented;
FOUNDATION_EXPORT NSInteger const gOTExporterShuttedDown;
FOUNDATION_EXPORT NSInteger const gOTExporterNotReportEngine;
FOUNDATION_EXPORT NSInteger const gOTExporterJsonFormatError;

#endif /* OTCallbackDefine_h */
