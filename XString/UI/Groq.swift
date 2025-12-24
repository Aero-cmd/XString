//
//  Grok.swift
//  XString
//
//  Created by AeroStar on 22/12/2025.
//

import Foundation
import SwiftUI
internal import Combine

// MARK: - Message Models

struct GroqMessage: Codable, Identifiable {
    var id = UUID()
    let role: String
    let content: String
}

// MARK: - Chat Request / Response

struct GroqRequest: Codable {
    let model: String
    let messages: [GroqAPImessage]
    let temperature: Double
}

struct GroqAPImessage: Codable {
    let role: String
    let content: String
}


struct GroqResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

// MARK: - Groq Client

final class GroqClient {
    private let apiKey = "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"
    private let endpoint = URL(string: "https://api.groq.com/openai/v1/chat/completions")!

    func chat(messages: [GroqMessage]) async throws -> String {
        let apiMessages = messages.map {
            GroqAPImessage(role: $0.role, content: $0.content)
        }

        let body = GroqRequest(
            model: "llama-3.3-70b-versatile", // ✅ FIXED
            messages: apiMessages,
            temperature: 0.4
        )

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept") // ✅ FIXED
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            print("Groq HTTP:", http.statusCode)
            print(String(data: data, encoding: .utf8) ?? "No body")
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(GroqResponse.self, from: data)
        return decoded.choices.first?.message.content ?? ""
    }
}

// MARK: - Similarity Helper (unused in V1, safe to keep)

func cosineSimilarity(_ a: [Double], _ b: [Double]) -> Double {
    let dot = zip(a, b).map(*).reduce(0, +)
    let magA = sqrt(a.map { $0 * $0 }.reduce(0, +))
    let magB = sqrt(b.map { $0 * $0 }.reduce(0, +))
    return dot / (magA * magB + 1e-8)
}

// MARK: - Assistant ViewModel

@MainActor
final class AssistantViewModel: ObservableObject {
    @Published var messages: [GroqMessage] = []
    @Published var input: String = ""
    @Published var isLoading = false

    private let groq = GroqClient()

    func start(for tab: BrowserTab) {
        messages = [
            GroqMessage(
                role: "system",
                content: """
You are a lightweight browser assistant.
Help the user complete tasks step-by-step.
Ask before taking action.
Be concise.
Do not give direct urls. Unless requested
You may automatically open tabs on your side to help the user.
The task may vary, if it includes or relates to:
- Cooking
- Shopping
- Travel planning (hotels, nice areas, flights, booking tickets for something like a football match does not count)
- be very strict on relevancy
Do not ask alot of questions unless necessary
"""
            ),
            GroqMessage(
                role: "system",
                content: """
Current page:
Title: \(tab.title)
URL: \(tab.searchText)
"""
            )
        ]
    }

    func send() async {
        guard !input.isEmpty else { return }
        isLoading = true

        messages.append(.init(role: "user", content: input))
        input = ""

        do {
            let reply = try await groq.chat(messages: messages)
            messages.append(.init(role: "assistant", content: reply))
        } catch {
            messages.append(
                .init(
                    role: "assistant",
                    content: "Groq error: \(error.localizedDescription)"
                )
            )
        }

        isLoading = false
    }
    func sendTaskSystemMessage(_ text: String) async {
        messages.insert(
            GroqMessage(role: "system", content: text),
            at: 0
        )

        do {
            let reply = try await groq.chat(messages: messages)
            messages.append(
                GroqMessage(role: "assistant", content: reply)
            )
            print(reply)
        } catch {
            messages.append(
                GroqMessage(role: "assistant", content: "Something went wrong.")
            )
        }
    }
}
