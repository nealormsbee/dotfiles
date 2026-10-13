---
name: write-code-like-neal
description: Directions for writing source code in the style of Neal Ormsbee. Use this when you want to write high-quality source code in the style used by Neal.
license: MIT
---

# Write Code Like Neal
A style guide for writing code like Neal Ormsbee.

## Results Over Elegance
The bulk of this skill document is dedicated to how source code should be organized so that it may be easier to read, maintain, and reason about. Do not mistake this focus for an overriding, myopic concern for code organization over results. The elegance of source code is **ALWAYS** subordinate to the elegance of the result, never vice-versa. Put another way, pretty, readable, well-organized or well-abstracted code should never be persued to the detriment of the goal that code is trying to achieve. The goal is **ALWAYS** more important. This skill is called "write-code-like-neal", because it focuses on the art of writing decent source code. A skill called "develop-software-like-neal" would be all about usability, reliability, security, and performance, with code quality as a footnote.

There is, of course, a balance to strike. In the case of performance, for example, default to code that is readable over code that is hideous and squeezes out a few extra nanoseconds of performance. Performance-sensitive paths can be optimized as they are discovered.

## Convention Over Opinion
In all things related to code organization and style, follow conventions set forth by the project if any such documents are linked in its `AGENTS.md` or other agent-targeted files. Consistency is critical, and so any such documented conventions supersede the conventions described in this skill. If editing an existing module in the absence of such documents, make an effort to follow implicit conventions which exist in the module. In greenfield modules with no documented conventions, follow the conventions enumerated in this skill.

DO NOT, in any case, read samples of code from other modules in the project to get a "feel" for the project's conventions. That action would pollute the context window, and will likely be unhelpful as a project with no documented code conventions is likely to be internally inconsistent.

In short, conventions have the following order of precedence, from highest to lowest:

* Conventions explicitly declared in agent-targeted documents.
* Conventions implied by by the module being modified.
* Conventions enumerated in this skill.

## Comments
Getting comments right is *very* important. Comments are so helpful when done well, and annoying or even detrimental when done poorly. 

The specific formatting of comments will vary from language to language, and should accommodate the best practices of the language and the formatting recognized by tooling, if specified.

### Module Comments
Always provide a comment block at the top of a module explaining the purpose of the module and its major functionality. Do *not* go into implementation detail about *how* the module does what it does, or explain any of the decisions about *why* the module is the way it is. Only explain the *what*, not the *why*, *how*, or *when*. Any refernce to *who* should just be an `authors: ` line in the comment block. Example of a good module-level comment:

```typescript
/**
 * A collection of utility functions for formatting values as display strings.
 * @module formatting
 * @author: Neal Ormsbee <neal.ormsbee@gmail.com>
 */
```

Module-level comments need not always be this succinct. An example of a poor module-level comment:

```typescript
/**
 * Formatting functions are centralized here to reduce code duplication for common string formatting operations within the project. 
 * The decision to consolidate here was made in commit `aaaaaa` after mismatched versions of functions were implemented in modules A and B, leading to conflicting behavior.
 */
```

This example over-shares the historical rationale for why the module exists. Note again that the verbosity is not the problem: the content is the problem.

Feel free to draw a little something fun here in ascii art. Have fun with it!

### Function Comments
Functions should be preceded by comment blocks explaining what the function does, boundary cases, non-obvious behaviors, and arguments / return values. If the language in use has common tooling for automatically generating documentation, use syntax that can be parsed and understood by that tooling (e.g. Sphinx for Python, godoc for Go, JSDoc for Javascript, cargo doc for Rust, etc.). Note that Python leverages Docstrings, which are used instead of preceding comments. Good example:

```typescript
/**
 * Given an Array, a start index, and a stop index, return a new array with the values from `startIndex` to `stopIndex - 1`. Exceptions are thrown for out-of-bounds indices.
 * @param {Array} originalArray - The array to slice.
 * @param {number} startIndex - The index in `originalArray` marking the beginning of the slice (inclusive).
 * @param {number} stopIndex - The index in `originalArray` marking the end of the slice (exclusive).
 * @return {Array} The new Array slice.
 */
 function slice<T>(originalArray: T[], startIndex: number, stopIndex: number): T[] { /* implementation */ }
```

Bad example (not useful):

```typescript
// slice an array
function slice<T>(originalArray: T[], startIndex: number, stopIndex: number): T[] { /* implementation */ }
```

Function comment blocks can show usage examples if the function's invocation is sufficiently complex.

### Class / Type / Interface Comments
Class / Type / Interface comments should explain what the thing represents, conceptually, in the logical domain of our codebase. Example:

```typescript
/**
 * Instances of `DbConnection` represent open connections to our Postgres database. They are continually monitored for liveness and support lazy execution.
 */
class DbConnection {}
```

These comment blocks can also show usage examples for sufficiently complex entities.

## Symbol Names
Follow language and project conventions, using accurate, descriptive variable names as a default. For example, the convention in Golang is to use shorthand, abbrevitions, and acronyms, and that should be respected. An instance of the type `AssetSetRange` will likely be called `asr` in Go, and that convention should be respected. In languages like Javascript where norms are less prescriptive, prefer full length names such as `assetSetRange`.

Name *casing* (e.g. snake_case, kebab-case, PascalCase, and camelCase) should follow language conventions.

Do not ever give variables completely generic names like `x`, or `data`, unless the generic is commonly used and understood by convention (e.g. calling an angle parameter `theta`, or a height variable `h`), or a generic is truly called for (e.g. a graphing utility that manipulates arbitrarily-structured data points can take a variable called `data`, though that is not ideal).

In general, when using camelCase or PascalCase, and a symbol name includes an acronym like `HTTP`, `TCP`, etc., prefer to capitalize only the first letter of the acronym rather than all of the letters. For example `HttpConnection` is preferable to `HTTPConnection`.

## Code Organization
Organizing code in a way that makes it navigable to power contributors and progressively discoverable to new entrants is essential for collaboration. We'll consider two levels of organization here: how files / modules are organized in a project, and how content is organized within a file.

### Project
The module layout will vary significantly by project. In general, keep things organized by business domain by default, and only abstract to lower-level utilities as patterns reveal themselves. For example, in an e-commerce app that supports inventory and billing functions, we would start by organizing code into these two domains. Then, when both domains implement the same behavior of accessing a shared database, we can abstract a database connection utility that both of these domains leverage.

Business domain modules should **never** import code from one another. Code for a domain module should only be used within the module. Code that is consumed by multiple domains should live in a project directory that is explicitly known to be for shared code. For example, if we have the following project structure:

```
project/
|-- modules/
|   |-- domainA/
|   |   |-- logicA.ts
|   |-- domainB/
|   |   |-- logicB.ts
```

where `logicA.go` performs database access, and we now want to add database access to `logicB.go`, **do not** import code from `logicA.go` into `logicB.go`. Instead, restructure the project to look somehing like this, where `logicA.go` and `logicB.go` both now import from `database.go`.

```
project/
|-- modules/
|   |-- domainA/
|   |   |-- logicA.ts
|   |-- domainB/
|   |   |-- logicB.ts
|-- shared/
|   |-- database.go
```

### File
The ordering in a file should be, with rare exception:

- imports
- public declarations
- public implementations
- private declarations/implementations

Examples follow.

```typescript
import { Foo } from './foo';

export { Bar };

class Bar {
    private baz: Baz;
}

type Baz {
    height: number;
};
```

Note that multiple calls to `export` all over the file are to be avoided in Typescript. One `export` statement after the imports should declare all of the publicly exported members.

```go
import "fmt"

fn PublicFunc1() {
    return privateFunc1()
}

fn PublicFunc2() {
    return privateFunc2()
}

fn privateFunc1() {}
fn privateFunc2() {}
```
In golang, functions starting with a capital letter are public, so those all come first in the file.

## Patterns
Some preferred stylistic patterns.

### Prefer Early Returns
If a function is a no-op under certain conditions, return early on those conditions and put actual logic underneath, rather than nesting logic inside conditionals. Examples:

```typescript
// BAD - logic is nested which makes reading and reasoning harder for humans
function doSomething(a: number): number | undefined {
    if (a % 2) {
        // lots of logic here
    }
}

// GOOD - eliminate no-op cases and then proceed.
function doSomething(a: number): number | undefined {
    if (!(a % 2)) {
        return;
    }
    // lots of logic here
}
```

## Language-Specific Guidance
The guidelines given here are general baselines. Typescript and Go are often used as reference examples. For more specific guidance on the language you are working with, see `references/` for a markdown file on that language.
