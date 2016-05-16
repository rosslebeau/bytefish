import PackageDescription

let package = Package(
    name: "bytefish",
    dependencies: [
        .Package(url: "https://github.com/qutheory/vapor.git", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/PlanTeam/MongoKitten.git", majorVersion: 0, minor: 9),
        .Package(url: "https://github.com/zewo/Mustache.git", majorVersion: 0, minor: 6),
    ],
    exclude: [
        "Deploy",
        "Public",
        "Resources",
		"Tests",
		"Database"
    ]
)
