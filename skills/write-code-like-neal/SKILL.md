---
name: write-code-like-neal
description: Directions for writing source code in the style of Neal Ormsbee. Use this when you want to write high-quality source code in the style used by Neal.
license: MIT
---

# Write Code Like Neal
A style guide for writing code like Neal Ormsbee.

## Comments
Getting comments right is *very* important. Comments are so helpful when done well, and annoying or even detrimental when done poorly. 

### Module Comments
Always provide a comment block at the top of a module explaining the purpose of the module and its major functionality. Do *not* go into implementation detail about *how* the module does what it does, or explain any of the decisions about *why* the module is the way it is. Only explain the *what*, not the *why*, *how*, or *when*. Any refernce to *who* should just be an `authors: ` line in the comment block. Example of a good module-level comment:

```typescript
/**
 * A collection of utility functions for formatting values as display strings.
 * @module formatting
 * @author: Neal Ormsbee <neal.ormsbee@gmail.com>
 */
```

Module-level comments need not always be this succinct. And an example of a poor module-level comment:

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

## Favorite Patterns - WIP
In gang of 4 terms, I love me some Observer pattern. It's so easy to implement and the decoupling allowed by event-driven systems using this makes so much sense to me.
The Strategy pattern is also terrific. Will fill out this section after some sleep.
Also a big fan of functional patterns like immutability. Mutation can and should be used in situations where it makes sense, like memory-constrained operations. Prefer immutable by default as it prevents so many classes of bugs, especially when multithreading. Also need to add a section on clarity of intent in code by using named things. A great example being that Javascript's Arrays have `.map()`, `.filter()`, `.reduce()`, and `.forEach()`. the behaviors of each of these can be matched using `for () {}` loops, but the name of the function *tells the reader* something about your intention, which is valuable. Maybe also a section on who the reader is and what they need to know, which gives context to why we don't want to litigate project history in comments but maybe do want to provide some depth on why things behave the way the do.

## Visual Design & Styling - WIP
CSS is not a strength, so don't improvise a design from scratch each time — apply the concrete defaults below. Treat this section as carrying the same weight as Comments, Naming, and Organization above: a page's visual polish should never be the thing that gets shortchanged because effort went into code structure instead. Structure and style are not in tension; both get done properly.

### Color
- Define all colors as CSS custom properties on `:root` (e.g. `--fg`, `--bg`, `--muted`, `--line`, `--accent`). Never hardcode color values inline or scattered across selectors.
- Support dark mode via `@media (prefers-color-scheme: dark)` redefining the same custom properties. Don't build a separate stylesheet or a JS-driven toggle unless asked.
- Prefer soft, warm color schemes over stark, high-contrast ones:
  - Avoid pure `#fff` backgrounds and pure `#000` text. Use warm off-whites/creams for light backgrounds and softened, warm darks (not cold blue-blacks) for dark mode.
  - Avoid saturated, high-chroma accent colors; prefer muted, desaturated tones.
  - Aim for comfortable reading contrast, not maximal contrast.

Baseline palette to start from and adjust per project:

```css
:root {
  color-scheme: light dark;
  --fg: #3a352f;
  --muted: #8a8177;
  --bg: #fbf9f6;
  --line: #e8e2d9;
  --accent: #b5794a;
}
@media (prefers-color-scheme: dark) {
  :root {
    --fg: #e8e2d9;
    --muted: #a39a8d;
    --bg: #211e1a;
    --line: #3a352f;
    --accent: #d69b6b;
  }
}
```

### Typography
- Establish a real type scale: headings, body text, and secondary/muted text should be visibly distinct sizes, not all the same.
- Use a comfortable line-height for body text (1.4-1.6).
- Label-style text (table headers, section labels, eyebrows) reads best small, uppercase, letter-spaced, and in the muted color, rather than matching body weight/size.

### Spacing
- Pick a spacing scale (e.g. multiples of 4px or 8px) and use only those values, rather than one-off pixel/rem numbers chosen per element.

### Data & Tables
- Numeric columns should use `font-variant-numeric: tabular-nums` so values align vertically.
- Right-align numeric columns; left-align labels.

### Precedence
These are defaults for when no stronger design direction is given. Always defer to explicit user instructions or an existing design system in the project over these defaults.
