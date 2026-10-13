# Typescript Code Style Guidance

## Explicit Type Annotations

Functions should always declare explicit return types. Examples:

```typescript

// BAD
// Returns `string | undefined` and you might not realize until much later. Linter flags **callers** as incorrect when the implementation is flawed.
// Intention is unclear - are we meant to return `string | undefined`, or was a case missed? Explicit annotation signals author intent.
function doSomething(x: number) {
    if (x % 2) {
        return 'odd';
    }
}

// GOOD - missing the `else` case causes the function to be flagged.
function doSomething(x: number): string {
    if (x % 2) {
        return 'odd';
    }
    return 'even'; // if this were missing, linter would flag the function and the problem would be clear.
}
```
