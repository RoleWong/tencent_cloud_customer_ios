//
//  OTDependencyDefine.h
//  Pods
//
//  Created by ravendeng on 2021/5/14.
//  Copyright (c) 2020 ravendeng. All rights reserved.
//

#ifndef OTDependencyDefine_h
#define OTDependencyDefine_h

#pragma mark - Monitor
#if __has_include(<OpenTelemetry/OTReportMonitor.h>)
/// reportMonitor
#define OT_MONITOR_SDK_REPORT_MONITOR
#endif

#pragma mark - Clock
#if __has_include(<OpenTelemetry/OTNTPClock.h>)
/// clock
#define OT_NTPCLOCK_SDK_CLOCK
#endif

#pragma mark - ProtoConverter

#if __has_include(<OpenTelemetry/OTProtoConverter+OTTrace.h>)
#define OT_PROTO_CONVERTER_TRACE
#endif

#if __has_include(<OpenTelemetry/OTProtoConverter+OTMetric.h>)
#define OT_PROTO_CONVERTER_METRIC
#endif

#if __has_include(<OpenTelemetry/OTProtoConverter+OTLogging.h>)
#define OT_PROTO_CONVERTER_LOG
#endif

#pragma mark - Tracing

#if __has_include(<OpenTelemetry/OTReadableSpan.h>)
/// ReadableSpan
#define OT_TRACING_SDK_SPAN
#endif

#if __has_include(<OpenTelemetry/OTSpanProcessorImp.h>)
/// ProcessorImp
#define OT_TRACING_SDK_PROCESSOR
#endif

#if __has_include(<OpenTelemetry/OTSpanExporterImp.h>)
/// Exporter
#define OT_TRACING_SDK_EXPORTER
#endif

#pragma mark - Metric

#if __has_include(<OpenTelemetry/OTInstrumentBuilder.h>)
/// ReadableInstrument
#define OT_METRIC_SDK_INSTRUMENT
#endif

#if __has_include(<OpenTelemetry/OTMetricReaderImp.h>)
/// MetricDataReader
#define OT_METRIC_SDK_READER
#endif

#if __has_include(<OpenTelemetry/OTMetricExporterImp.h>)
/// MetricExporter
#define OT_METRIC_SDK_EXPORTER
#endif

#if __has_include(<OpenTelemetry/OTExemplarFilter.h>)
// ExemplarFilter
#define OT_METRIC_SDK_EXEMPLAR_FILTER
#endif

#if __has_include(<OpenTelemetry/OTExemplarReservoir.h>)
// ExemplarReservoir
#define OT_METRIC_SDK_EXEMPLAR_RESERVOIR
#endif

#pragma mark - Logging

#if __has_include(<OpenTelemetry/OTLoggingProcessorImp.h>)
/// ProcessorImp
#define OT_LOGGING_SDK_PROCESSOR
#endif

#if __has_include(<OpenTelemetry/OTLoggingExporterImp.h>)
/// Exporter
#define OT_LOGGING_SDK_EXPORTER
#endif

#endif /* OTDependencyDefine_h */
