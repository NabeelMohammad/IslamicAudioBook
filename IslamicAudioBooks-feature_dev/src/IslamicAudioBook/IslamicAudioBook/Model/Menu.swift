//
//  Menu.swift
//  IslamicAudioBook
//
//  Created by Ameer Shaikh on 14/09/2020.
//  Copyright © 2020 Ameer. All rights reserved.
//

import Foundation
// MARK: - FAQElement
struct FAQElement: Codable {
    let id, question, ans, status: String
}

typealias FAQ = [FAQElement]

// MARK: - TestimonialElement
struct TestimonialElement: Codable {
    let id, name, message, status: String
    let platform : String?
}

typealias Testimonial = [TestimonialElement]

// MARK: - Feedback
struct Feedback: Codable {
    let message: String
}
