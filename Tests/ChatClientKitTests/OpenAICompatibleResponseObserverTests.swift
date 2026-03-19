@testable import ChatClientKit
import Foundation
import ServerEvent
import Testing

struct OpenAICompatibleResponseObserverTests {
    @Test("OpenAI compatible stream processor reports HTTP response headers on open")
    func streamProcessorReportsHTTPResponseHeaders() async throws {
        let response = HTTPURLResponse(
            url: try #require(URL(string: "https://example.com/v1/chat/completions")),
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["X-App-Conversation-Id": "server-conv-1"]
        )
        let task = StubEventStreamTask(
            response: try #require(response),
            events: [
                .open,
                .event(StubServerEvent(data: #"{"choices":[{"index":0,"delta":{"content":"你好"}}]}"#)),
                .closed,
            ]
        )
        let processor = OpenAICompatibleStreamProcessor(
            eventSourceFactory: StubEventSourceFactory(task: task)
        )

        let request = try URLRequest(url: #require(URL(string: "https://example.com/v1/chat/completions")))
        var observedConversationID: String?
        var chunks: [ChatResponseChunk] = []

        let stream = processor.stream(
            request: request,
            collectError: { _ in },
            didReceiveHTTPResponse: { httpResponse in
                observedConversationID = httpResponse.value(forHTTPHeaderField: "X-App-Conversation-Id")
            }
        )

        for try await chunk in stream {
            chunks.append(chunk)
        }

        #expect(observedConversationID == "server-conv-1")
        #expect(chunks == [.text("你好")])
    }
}

private struct StubEventSourceFactory: EventSourceProducing {
    let task: StubEventStreamTask

    func makeDataTask(for _: URLRequest) -> EventStreamTask {
        task
    }
}

private final class StubEventStreamTask: HTTPResponseProvidingEventStreamTask, @unchecked Sendable {
    let response: HTTPURLResponse?
    private let eventValues: [EventSource.EventType]

    init(response: HTTPURLResponse?, events: [EventSource.EventType]) {
        self.response = response
        eventValues = events
    }

    func events() -> AsyncStream<EventSource.EventType> {
        AsyncStream { continuation in
            for event in eventValues {
                continuation.yield(event)
            }
            continuation.finish()
        }
    }
}

private struct StubServerEvent: EVEvent {
    var id: String? = nil
    var event: String? = nil
    var data: String?
    var other: [String: String]? = nil
    var time: String? = nil

    init(data: String) {
        self.data = data
    }
}
