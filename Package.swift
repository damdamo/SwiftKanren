// swift-tools-version:4.2

import PackageDescription

let package = Package(
  name: "SwiftKanren",
  products: [
    .library(name: "SwiftKanren", type: .static, targets: ["SwiftKanren"]),
  ],
  targets: [
    .target(name: "SwiftKanren"),
    .testTarget(name: "SwiftKanrenTests", dependencies: ["SwiftKanren"]),
  ]
)
