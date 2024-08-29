//
//  TencentCloudCustomerLogger.swift
//  TencentCloudCustomer
//
//  Created by Role Wong on 8/20/24.
//

import Foundation
//import OpenTelemetryApi
//import OpenTelemetrySdk


enum ExportResult {
    case success
    case failure
}

struct LogRecord {
    let timestamp: Date
    let severityText: String
    let body: String
    let traceId: String
    let spanId: String

    init(severity: String, message: String, traceId: String, spanId: String) {
        self.timestamp = Date()
        self.severityText = severity
        self.body = message
        self.traceId = traceId
        self.spanId = spanId
    }
}

class OtlpCustomLogExporter {
    private let endpoint: URL

    init(endpoint: URL) {
        self.endpoint = endpoint
    }

    func export(logs: [LogRecord]) -> ExportResult {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare log data
        let logData = logs.map { logRecord in
            return [
                "timestamp": logRecord.timestamp.description,
                "severity": logRecord.severityText,
                "message": logRecord.body,
                "traceId": logRecord.traceId,
                "spanId": logRecord.spanId
            ]
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: logData, options: [])
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Failed to send logs: \(error)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    
                    // 打印 response code
                    print("Response code: \(statusCode)")
                    
                    if (200...299).contains(statusCode) {
                        print("Logs successfully sent to server.")
                    } else {
                        print("Server error: \(statusCode)")
                    }
                } else {
                    print("Failed to get valid HTTP response.")
                }
            }
            task.resume()

            return .success
        } catch {
            print("Failed to encode logs: \(error)")
            return .failure
        }
    }
}

//@objc public class TencentCloudCustomerLogger : NSObject {
//    @objc public static let shared = TencentCloudCustomerLogger()
//    
//    private var exporter: OtlpCustomLogExporter!
//    
//    private override init () {
//        super.init()
//        let url = URL(string: "https://otlp.tccc.qcloud.com/v1/logs")!
//        exporter = OtlpCustomLogExporter(endpoint: url)
//    }
//    
//    @objc public func logTrace (severity: String, message: String) {
//        let tracer = OpenTelemetry.instance.tracerProvider.get(instrumentationName: "Tencent-Cloud-Customer-iOS", instrumentationVersion: "1.0")
//        
//        // Start a new span for the log trace
//        let span = tracer.spanBuilder(spanName: "logTrace").startSpan()
//        
//        // Add a log event in the span
//        span.addEvent(name: message)
//        
//        // Capture traceId and spanId for logging
//        let traceId = span.context.traceId.hexString
//        let spanId = span.context.spanId.hexString
//        
//        // Log record with trace and span IDs
//        let logRecord = LogRecord(severity: severity, message: message, traceId: traceId, spanId: spanId)
//        let exportResult = exporter.export(logs: [logRecord])
//        
//        // End the span
//        span.end()
//
//        if exportResult == .success {
//            print("Log successfully sent to server")
//        } else {
//            print("Failed to send log to server")
//        }
//    }
//}

