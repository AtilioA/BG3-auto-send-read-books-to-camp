Run from the repository root with Lua:

```sh
lua tests/book_processing.lua
```

These offline tests exercise the inventory processor used on camp arrival and
the book-close handler. They cover both wares settings, unique and duplicate
books, and disabled instant processing. Dependency fixtures and the mod's
engine-facing wrappers isolate the routing decision; engine APIs are not replaced.
The tests do not verify read tracking, camp-arrival event timing, or engine transfers.

The original regression compared the boolean returned by
`VCHelpers.Inventory:IsItemInCampChest` with `nil`. Because `false ~= nil` is true,
unique books were marked as wares. Instant processing also ignored the main
wares setting when duplicate-only processing remained enabled. Both paths now
use the same routing decision.
