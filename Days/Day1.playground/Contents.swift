import Foundation

let fileURL = Bundle.main.url(forResource: "input-string", withExtension: "txt")!
let inputString = try! String(contentsOf: fileURL)
let moduleMasses = inputString.split(separator: "\n").compactMap { Int($0) }

// MARK: - Part 1

let part1Sum = moduleMasses.reduce(into: 0) { result, mass in
	result += Int(Double(mass) / 3.0) - 2
}

// MARK: - Part 2

func fuelForMass(_ mass: Int) -> Int {
	let fuel = Int(Double(mass) / 3.0) - 2
	guard fuel > 0 else { return 0 }
	return fuel + fuelForMass(fuel)
}

let part2Sum = moduleMasses.reduce(into: 0) { result, mass in
	result += fuelForMass(mass)
}

print("part 1 sum: \(part1Sum); part 2 sum: \(part2Sum)")
