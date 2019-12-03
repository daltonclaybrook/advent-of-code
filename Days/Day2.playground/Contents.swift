import Foundation

let inputString = "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,19,10,23,1,23,6,27,1,6,27,31,1,13,31,35,1,13,35,39,1,39,13,43,2,43,9,47,2,6,47,51,1,51,9,55,1,55,9,59,1,59,6,63,1,9,63,67,2,67,10,71,2,71,13,75,1,10,75,79,2,10,79,83,1,83,6,87,2,87,10,91,1,91,6,95,1,95,13,99,1,99,13,103,2,103,9,107,2,107,10,111,1,5,111,115,2,115,9,119,1,5,119,123,1,123,9,127,1,127,2,131,1,5,131,0,99,2,0,14,0"

typealias Intcode = Int
typealias Output = Int
typealias Instruction = (Int, Int) -> Int

extension Array where Element == Int {
	subscript(pointer pointer: Int) -> Int {
		get { self[self[pointer]] }
		set {self[self[pointer]] = newValue }
	}
}

let startingIntcodes: [Intcode] = inputString
	.split(separator: ",")
	.compactMap { Int($0) }
let operations: [Int: Instruction] = [1: (+), 2: (*)]

func evaluate(program: inout [Intcode]) -> Output {
	var ip = 0 // instruction pointer
	while true {
		let opcode = program[ip]
		if let operation = operations[opcode] {
			program[pointer: ip+3] = operation(program[pointer: ip+1], program[pointer: ip+2])
			ip += 4
		} else if opcode == 99 {
			break
		} else {
			fatalError()
		}
	}
	return program[0]
}

func findNounAndVerbFor(desiredOutput: Int) -> (noun: Int, verb: Int)? {
	for noun in (0...99) {
		for verb in (0...99) {
			var program = startingIntcodes
			program[1] = noun
			program[2] = verb
			let output = evaluate(program: &program)
			if output == desiredOutput {
				return (noun, verb)
			}
		}
	}
	return nil
}

if let words = findNounAndVerbFor(desiredOutput: 19690720) {
	print("Part 2 result: \(words.noun * 100 + words.verb)")
} else {
	print("failure")
}
