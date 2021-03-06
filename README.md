# SwiftKanren

SwiftKanren is a Swift implementation of [miniKanren](http://minikanren.org), allowing one to write logic programs in Swift.

## Getting started

Like all kanren implementations, SwiftKanren allows one to define a logic program in terms of relations, and search for values which satisfy such relations.
For instance, the following program searches a value for `x` and `y` such that `x = y ∧ (y = 0 ∨ y = 1)` holds:

```swift
import SwiftKanren

let x = Variable(named: "x")
let y = Variable(named: "y")

let system = (x ≡ y) && (y ≡ Value(0) || y ≡ Value(1))

let solutions = solve(system)
for solution in solutions {
    print("x = \(solution[x]), y = \(solution[y])")
}

// Prints "x = 0, y = 0"
// Prints "x = 1, y = 1"
```

### Values, lists and maps

Out of the box, SwiftKanren offers a `Value<T>` type, which can be used to associate logic variables to values.
Any type can be used, as long as `T` is `Equatable`.
Like in most kanren implementations, lists are also supported, and proposed in the form of linked list.

```swift
import SwiftKanren

// The following represents the list [0, 1]
let l = List.cons(Value(0), List.cons(Value(1), List.empty))
```

Unlike Swift arrays, SwiftKanren lists can contain mixed elements, as long as they all conform to `Term`.
This means it's of course possible to mix logic variables with values, and ask SwiftKanren to search for values inside a list.
For instance, the following program searches a value for `x` and `y` such that `[1, x] = [y, 2]` holds:

```swift
import SwiftKanren

let x = Variable(named: "x")
let y = Variable(named: "y")

let lhs = List.cons(Value(1), List.cons(x, List.empty))
let rhs = List.cons(y, List.cons(Value(2), List.empty))

for solution in solve(lhs ≡ rhs) {
    print("x = \(solution[x]), y = \(solution[y])")
}

// Prints "x = 2, y = 1"
```

A `Map` type is also supported, which mimics Swift's dictionaries:

```swift
import SwiftKanren

let x = Variable(named: "x")

let m: Map = ["message": x]
let n: Map = ["message": Value("Hello!")]
let o: Map = ["message": Value("Goodbye!")]

let system = (m ≡ n) || (m ≡ o)
for solution in solve(system) {
    print(solution[x])
}

// Prints "Hello!"
// Prints "Goodbye!"
```

Any type that conforms to `Term` can be used as a value.
The only requirement of the protocol is to implement a function `equals(_:) -> Bool` that SwiftKanren will use to match values.
However, it is currently not supported to define custom types for terms with subterms.
Such structures should be mapped to lists or maps for the time being.

### Goals

At its core, SwiftKanren uses [unification](https://en.wikipedia.org/wiki/Unification_(computer_science)), a kind of pattern matching, to solve programs.
This process is used to build a substitution map that associates the logic variables of the program with their possible values.
On the top of that, a handful of operators allows to define *goals*, a fancy name to designate functions that map a program to a stream of substitutions for which its relations hold.

The following is a list of the basic goal constructors:

* `u ≡ v` returns a substitution in which the two terms `u` and `v` can be unified, or nothing if they can't.
* `g || h` returns the disjunction `g ∨ h`.
* `g ^ h` returns the conjunction `g ∨ h`.
* `fresh{ x in g }` returns the goal `g` after feeding it with  a fresh variable `x`.

Those goals constructors can be combined directly, or embedded in other constructors to build more complex systems.
For instance, the following functions respectively construct goals that insert an element at the top of a list and search for the first value of a list:

```swift
func prepending(_ head: Term, to tail: Term, gives result: Term) -> Goal {
    return List.cons(head, tail) ≡ result
}

func head(of result: Term, is head: Term) -> Goal {
    return fresh{ tail in prepending(head, to: tail, gives: result) }
}
```

## Examples

Some examples of usage are presented inside `Examples/`.
To run those examples, navigate to their directory (where `main.swift` lies) and execute the following:

```bash
swift build
.build/debug/<name of the example>
```

## References

* William Byrd's [PhD thesis](http://gradworks.umi.com/3380156.pdf).
* [miniKaren](http://minikanren.org) and its original [implementation](https://github.com/webyrd/miniKanren) in Scheme.
* [microLogic](http://mullr.github.io/micrologic/literate.html#sec-2-5), a very well documented implementation of microKanren in Clojure.
