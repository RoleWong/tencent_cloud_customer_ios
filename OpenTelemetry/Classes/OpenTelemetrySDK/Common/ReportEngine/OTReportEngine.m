//
//  OTReportEngine.m
//  opentelemetry-oc
//
//  Created by ravendeng on 2020/7/28.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "OTReportEngine.h"
#import "OTCallbackHelper.h"
#import "OTCarrier.h"
#import "NSObject+OTPerformAdditions.h"

@interface OTReportEngine () <NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSession *session;

@end

static NSString *const kRequiredHeaderFieldContentType = @"Content-Type";
static NSString *const kOptionalHeaderValueContentTypeProto = @"application/x-protobuf";
static NSString *const kRequiredHeaderValueContentType = @"application/json";
static NSInteger const kDefaultRetryCount = 3;
static NSInteger const kDefaultMaximumConnection = 8;
static NSInteger const kDefaultRequestTimeoutInterval = 30;

@implementation OTReportEngine
- (instancetype)init {
    if (self = [super init]) {
        _retryCount = kDefaultRetryCount;
        _requestTimeoutInterval = kDefaultRequestTimeoutInterval;
        _maximumConnection = kDefaultMaximumConnection;
    }
    return self;
}

#pragma mark - Getter & Setter

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.HTTPMaximumConnectionsPerHost = self.maximumConnection;
        _session = [NSURLSession sessionWithConfiguration:sessionConfig];
    }
    return _session;
}

- (void)setMaximumConnection:(NSUInteger)maximumConnection {
    _maximumConnection = maximumConnection;
    self.session.configuration.HTTPMaximumConnectionsPerHost = maximumConnection;
}

- (void)setUsePipelining:(BOOL)usePipelining {
    _usePipelining = usePipelining;
    self.session.configuration.HTTPShouldUsePipelining = usePipelining;
}

#pragma mark - Private

- (NSMutableURLRequest *)reportRequestForReportURL:(NSURL *)reportURL forExtParam:(NSDictionary<NSString *, NSString *> *)extParam {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:reportURL];
    [extParam enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = self.requestTimeoutInterval;
    return request;
}

- (void)reportDataWithApi:(NSString *)api
                  carrier:(OTCarrier *)carrier
                 extParam:(NSDictionary *)extParam
               retryCount:(NSUInteger)retryCount
               completion:(void (^)(BOOL success, NSInteger statusCode, NSError *error, NSData *requestData))completion {
    NSString *urlDomainName = self.reportDestinationDomainName;
    NSURL *urlDomain = [NSURL URLWithString:urlDomainName];
    NSURL *reportUrl = [urlDomain URLByAppendingPathComponent:api];
    NSMutableURLRequest *request = [self reportRequestForReportURL:reportUrl forExtParam:extParam];
    // config contentType
    NSString *contentType = carrier.isProto ? kOptionalHeaderValueContentTypeProto : kRequiredHeaderValueContentType;
    [request setValue:contentType forHTTPHeaderField:kRequiredHeaderFieldContentType];
    request.HTTPBody = carrier.data;
    // ready to report data
    NSURLSessionDataTask *task =
        [self.session dataTaskWithRequest:request
                        completionHandler:^(NSData *_Nullable responseData, NSURLResponse *_Nullable response, NSError *_Nullable error) {
                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                            if (error && retryCount > 0) {
                                [self reportDataWithApi:api carrier:carrier extParam:extParam retryCount:(retryCount - 1) completion:completion];
                                return;
                            }
                            NSInteger statusCode = httpResponse.statusCode;
                            BOOL success = error == nil;
                            if (completion) {
                                completion(success, httpResponse.statusCode, error, carrier.data);
                            }
                            [self postReportResultFromApi:api reqString:carrier.dataDescription success:success statusCode:statusCode error:error];
                        }];
    [task resume];
}

- (void)postReportResultFromApi:(NSString *)api
                      reqString:(NSString *)reqString
                        success:(BOOL)success
                     statusCode:(NSInteger)statusCode
                          error:(NSError *)error {
    NSMutableDictionary *responseDict = [[NSMutableDictionary alloc] init];
    [responseDict setValue:reqString forKey:gOTReportResponseInfoKeyJsonString];
    [responseDict setValue:@(statusCode) forKey:gOTReportResponseInfoKeyStatusCode];
    [responseDict setValue:@(success) forKey:gOTReportResponseInfoKeyResult];
    [responseDict setValue:error forKey:gOTReportResponseInfoKeyError];
    [responseDict setValue:api forKey:gOTReportResponseInfoKeyApi];
    [[NSNotificationCenter defaultCenter] postNotificationName:gOTDataReportDidResponseNotification object:nil userInfo:responseDict];
}

#pragma mark - OTExporterDelegate

- (void)reportTracingData:(OTCarrier *)tracingCarrier extParam:(NSDictionary *)extParam completion:(OTExporterCallback)completion {
    SEL realTracingReportSelector = @selector(realReportTracingData:extParam:completion:);
    [self reportCommonDataWithRealSelector:realTracingReportSelector
                                reportData:tracingCarrier
                                  extParam:extParam
                                completion:completion
                                 exportAPI:gOTExportTracingApi];
}

- (void)reportMetircData:(OTCarrier *)metricCarrier
                extParam:(NSDictionary<NSString *, NSString *> *)extParam
              completion:(OTExporterCallback)completion {
    SEL realMetircReportSelector = @selector(realReportMetircData:extParam:completion:);
    [self reportCommonDataWithRealSelector:realMetircReportSelector
                                reportData:metricCarrier
                                  extParam:extParam
                                completion:completion
                                 exportAPI:gOTExportMetricApi];
}

- (void)reportLogData:(OTCarrier *)logCarrier extParam:(NSDictionary *)extParam completion:(OTExporterCallback)completion {
    SEL realLogReportSelector = @selector(realReportLogData:extParam:completion:);
    [self reportCommonDataWithRealSelector:realLogReportSelector
                                reportData:logCarrier
                                  extParam:extParam
                                completion:completion
                                 exportAPI:gOTExportLoggingApi];
}

- (void)reportCommonDataWithRealSelector:(SEL)realReportSelector
                              reportData:(OTCarrier *)carrier
                                extParam:(NSDictionary *)extParam
                              completion:(OTExporterCallback)completion
                               exportAPI:(NSString *)exportAPI {
    BOOL enableDelayExport = [[OTAbnormalNetworkDBManager shareInstance] enableDelayExport];
    if (!enableDelayExport) {
        [self ot_utPerformSelector:realReportSelector withObject:carrier withObject:extParam withObject:completion];
        return;
    }
    BOOL isNetworkAvailable = [[OTAbnormalNetworkDBManager shareInstance] isNetworkAvailable];
    if (isNetworkAvailable) {
        [self ot_utPerformSelector:realReportSelector withObject:carrier withObject:extParam withObject:completion];
    } else {
        [self delayReportData:carrier extParam:extParam exportAPI:exportAPI];
    }
}

- (void)reportDataWith:(OTAbnormalNetworkDataItem *)dataItem
            completion:(void (^)(BOOL success, NSInteger statusCode, NSError *error, NSData *requestData))completion {
    OTCarrier *itemCarrier = [[OTCarrier alloc] initWithData:dataItem.dataInfo description:dataItem.dataDescription isProto:dataItem.protoState];
    [self reportDataWithApi:dataItem.exportAPI carrier:itemCarrier extParam:dataItem.extraParam retryCount:self.retryCount completion:completion];
}

#pragma mark - Private

- (void)realReportTracingData:(OTCarrier *)tracingCarrier extParam:(NSDictionary *)extParam completion:(OTExporterCallback)completion {
    [self reportDataWithApi:gOTExportTracingApi
                    carrier:tracingCarrier
                   extParam:extParam
                 retryCount:self.retryCount
                 completion:^(BOOL success, NSInteger statusCode, NSError *error, NSData *requestData) {
                     if (!success) {
                         [self requestFailureDataWithData:tracingCarrier extParam:extParam exportAPI:gOTExportTracingApi];
                     }
                     if (completion) {
                         completion(statusCode, tracingCarrier.dataDescription, error);
                     }
                 }];
}

- (void)realReportMetircData:(OTCarrier *)metricCarrier
                    extParam:(NSDictionary<NSString *, NSString *> *)extParam
                  completion:(OTExporterCallback)completion {
    [self reportDataWithApi:gOTExportMetricApi
                    carrier:metricCarrier
                   extParam:extParam
                 retryCount:self.retryCount
                 completion:^(BOOL success, NSInteger statusCode, NSError *error, NSData *requestData) {
                     if (!success) {
                         [self requestFailureDataWithData:metricCarrier extParam:extParam exportAPI:gOTExportMetricApi];
                     }
                     if (completion) {
                         completion(statusCode, metricCarrier.dataDescription, error);
                     }
                 }];
}

- (void)realReportLogData:(OTCarrier *)logCarrier extParam:(NSDictionary *)extParam completion:(OTExporterCallback)completion {
    [self reportDataWithApi:gOTExportLoggingApi
                    carrier:logCarrier
                   extParam:extParam
                 retryCount:self.retryCount
                 completion:^(BOOL success, NSInteger statusCode, NSError *error, NSData *requestData) {
                     if (!success) {
                         [self requestFailureDataWithData:logCarrier extParam:extParam exportAPI:gOTExportLoggingApi];
                     }
                     if (completion) {
                         completion(statusCode, logCarrier.dataDescription, error);
                     }
                 }];
}

- (void)requestFailureDataWithData:(OTCarrier *)carrier extParam:(NSDictionary *)extParam exportAPI:(NSString *)exportAPI {
    BOOL enableDelayExport = [[OTAbnormalNetworkDBManager shareInstance] enableDelayExport];
    if (!enableDelayExport) {
        return;
    }
    [self delayReportData:carrier extParam:extParam exportAPI:exportAPI];
}

- (void)delayReportData:(OTCarrier *)logCarrier extParam:(NSDictionary *)extParam exportAPI:(NSString *)exportAPI {
    OTAbnormalNetworkDataItem *item = [[OTAbnormalNetworkDataItem alloc] init];
    item.exportAPI = exportAPI;
    // 精确到纳秒与json中时间戳单位对齐
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970] * 1000000000)];
    item.itemID = [NSString stringWithFormat:@"%@-%@", exportAPI, timeString];
    NSDictionary *itemExtParam = extParam;
    if (!itemExtParam) {
        itemExtParam = [NSDictionary dictionary];
    }
    item.extraParam = itemExtParam;
    item.protoState = logCarrier.proto;
    item.dataInfo = logCarrier.data;
    [[OTAbnormalNetworkDBManager shareInstance] insertItemInfo:item];
}

@end
