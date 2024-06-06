//
//  String+Extensions.swift
//  WhatsappDummy
//
//  Created by abhay mundhara on 05/06/2024.
//

import Foundation

extension String {
    var isEmptyorWhiteSpace: Bool { return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty}
}
