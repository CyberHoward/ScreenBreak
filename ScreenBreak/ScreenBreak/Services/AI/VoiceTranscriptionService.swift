//
//  VoiceTranscriptionService.swift
//  ScreenBreak
//
//  Service for recording audio and transcribing via OpenAI Whisper API
//

import Foundation
import AVFoundation
import OpenAI

final class VoiceTranscriptionService: NSObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioSession: AVAudioSession?
    private var recordingURL: URL?
    private let client: OpenAI
    private let hasValidKey: Bool
    
    override init() {
        // Try to get API key from multiple sources
        let key: String
        if let envKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], !envKey.isEmpty {
            key = envKey
        } else if let plistKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String, !plistKey.isEmpty {
            key = plistKey
        } else {
            key = ""
        }
        
        self.hasValidKey = !key.isEmpty
        self.client = OpenAI(apiToken: key)
        super.init()
    }
    
    // MARK: - Recording
    
    func startRecording() async throws {
        // Request microphone permission
        let permission = await requestMicrophonePermission()
        guard permission else {
            throw TranscriptionError.microphonePermissionDenied
        }
        
        // Configure audio session
        audioSession = AVAudioSession.sharedInstance()
        try audioSession?.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        try audioSession?.setActive(true)
        
        // Create recording URL
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        recordingURL = documentsPath.appendingPathComponent("voice_recording.m4a")
        
        guard let url = recordingURL else {
            throw TranscriptionError.recordingFailed
        }
        
        // Delete existing file if present
        try? FileManager.default.removeItem(at: url)
        
        // Configure recorder settings
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.record()
    }
    
    func stopRecordingAndTranscribe() async throws -> String {
        guard let recorder = audioRecorder, recorder.isRecording else {
            throw TranscriptionError.noActiveRecording
        }
        
        recorder.stop()
        
        // Deactivate audio session
        try? audioSession?.setActive(false)
        
        guard let url = recordingURL else {
            throw TranscriptionError.recordingFailed
        }
        
        // Transcribe the audio
        return try await transcribe(audioURL: url)
    }
    
    func cancelRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        try? audioSession?.setActive(false)
        
        // Clean up file
        if let url = recordingURL {
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    // MARK: - Transcription
    
    private func transcribe(audioURL: URL) async throws -> String {
        guard hasValidKey else {
            throw TranscriptionError.missingAPIKey
        }
        
        let audioData = try Data(contentsOf: audioURL)
        
        let query = AudioTranscriptionQuery(
            file: audioData,
            fileType: .m4a,
            model: .whisper_1,
            language: "en"
        )
        
        let result = try await client.audioTranscriptions(query: query)
        
        // Clean up the recording file
        try? FileManager.default.removeItem(at: audioURL)
        
        return result.text
    }
    
    // MARK: - Permissions
    
    private func requestMicrophonePermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    // MARK: - Errors
    
    enum TranscriptionError: LocalizedError {
        case microphonePermissionDenied
        case recordingFailed
        case noActiveRecording
        case transcriptionFailed(String)
        case missingAPIKey
        
        var errorDescription: String? {
            switch self {
            case .microphonePermissionDenied:
                return "Microphone access was denied. Please enable it in Settings."
            case .recordingFailed:
                return "Failed to start recording."
            case .noActiveRecording:
                return "No active recording found."
            case .transcriptionFailed(let message):
                return "Transcription failed: \(message)"
            case .missingAPIKey:
                return "OpenAI API key not configured."
            }
        }
    }
}

// MARK: - AVAudioRecorderDelegate

extension VoiceTranscriptionService: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Recording finished unsuccessfully")
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Recording encode error: \(error.localizedDescription)")
        }
    }
}

