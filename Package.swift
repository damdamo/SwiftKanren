// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "SwiftKanren",
  products: [
    .library(name: "LogicKit", type: .static, targets: ["SwiftKanren"]),
  ],
  targets: [
    .target(name: "SwiftKanren"),
    .testTarget(name: "SwiftKanrenTests", dependencies: ["SwiftKanren"]),
  ]
)
