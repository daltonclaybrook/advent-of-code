import Foundation

let fileURL = Bundle.main.url(forResource: "input-string", withExtension: "txt")!
let inputString = try! String(contentsOf: fileURL)

struct Move {
	enum Direction: String {
		case up = "U"
		case right = "R"
		case down = "D"
		case left = "L"
	}

	let value: Int
	let direction: Direction

	init?<S: StringProtocol>(stringValue: S) {
		guard stringValue.count >= 2 else { return nil }
		let firstIndex = stringValue.index(after: stringValue.startIndex)
		guard let direction = Direction(rawValue: String(stringValue[..<firstIndex])),
			let value = Int(String(stringValue[firstIndex...]))
			else { return nil }

		self.value = value
		self.direction = direction
	}
}

struct Location: Hashable {
	let x: Int
	let y: Int
}

extension Move.Direction {
	var locationMod: Location {
		switch self {
		case .up: return Location(x: 0, y: 1)
		case .right: return Location(x: 1, y: 0)
		case .down: return Location(x: 0, y: -1)
		case .left: return Location(x: -1, y: 0)
		}
	}
}

extension Location {
	static func +(lhs: Location, rhs: Location) -> Location {
		Location(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}

	static func *(lhs: Location, rhs: Int) -> Location {
		Location(x: lhs.x * rhs, y: lhs.y * rhs)
	}
}

func getLocations(for wire: [Move]) -> [Location] {
	var currentLocation = Location(x: 0, y: 0)
	return wire.reduce(into: []) { result, move in
		let mod = move.direction.locationMod
		let nextLocations: [Location] = (1...move.value).map { currentLocation + mod * $0 }
		currentLocation = nextLocations.last ?? currentLocation
		result.append(contentsOf: nextLocations)
	}
}

func getIntersectingLocations(locations1: [Location], locations2: [Location]) -> [Location] {
	Array(Set(locations1).intersection(Set(locations2)))
}

func getShortestDistanceFromZero(locations: [Location]) -> Int {
	locations.reduce(.max) { result, location in
		let distance = abs(location.x) + abs(location.y)
		return min(result, distance)
	}
}

func getShortestCombinedWireLength(locations1: [Location], locations2: [Location], intersections: [Location]) -> Int {
	intersections.reduce(.max) { shortest, intersection in
		let index1 = locations1.firstIndex(of: intersection)! + 1
		let index2 = locations2.firstIndex(of: intersection)! + 1
		return min(index1 + index2, shortest)
	}
}

let moveStrings = inputString.split(separator: "\n")
let wire1 = moveStrings[0].split(separator: ",").compactMap(Move.init)
let wire2 = moveStrings[1].split(separator: ",").compactMap(Move.init)

let locations1 = getLocations(for: wire1)
let locations2 = getLocations(for: wire2)

// part 1
let intersections = getIntersectingLocations(locations1: locations1, locations2: locations2)
let shortestDistance = getShortestDistanceFromZero(locations: intersections)

// part 2
let shortestCombinedLength = getShortestCombinedWireLength(locations1: locations1, locations2: locations2, intersections: intersections)

print("shortest distance: \(shortestDistance)")
print("shortest combined length: \(shortestCombinedLength)")
