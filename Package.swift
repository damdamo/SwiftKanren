// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "LogicKit",
  products: [
    .library(name: "LogicKit", type: .static, targets: ["LogicKit"]),
  ],
  targets: [
    .target(name: "LogicKit"),
    .testTarget(name: "LogicKitTests", dependencies: ["LogicKit"]),
  ]
)
