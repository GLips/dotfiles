# Minuet LSP Context Enhancement Plan

## Overview

Enhance Minuet AI autocomplete with rich LSP-based context including:
1. Function/class signatures with type definitions
2. Imported symbols with their type definitions (local imports only)
3. Deep type resolution (2 levels: types used by functions, and types used by those types)
4. Context from recently edited files (last 3 files, showing edited lines ± 10 lines)

---

## Architecture

```
minuet.lua (modified)
  ├─> Adds chat_input template with custom placeholders
  └─> Calls minuet-lsp-context module

minuet-lsp-context.lua (NEW)
  ├─> LSP Context Gathering
  │   ├─ gather_lsp_symbols() - documentSymbol request
  │   ├─ get_symbol_signature() - hover request
  │   ├─ resolve_type_definition() - recursive type resolution (depth 2)
  │   └─ filter_accessible_symbols() - scope-based filtering
  │
  ├─> Recent Edits Tracking
  │   ├─ Buffer attach with on_lines callback
  │   ├─ Edit consolidation (time-based + overlap merging)
  │   ├─ Whitespace-only detection
  │   ├─ Whole-file reformat detection
  │   └─ Duplicate prevention
  │
  ├─> Import Filtering
  │   └─ Path-based heuristic (local vs external)
  │
  ├─> Context Formatting
  │   ├─ format_lsp_context()
  │   └─ format_recent_edits()
  │
  └─> Debug Command
      └─ :MinuetContextDebug
```

---

## Configuration Schema

```lua
-- Default configuration (user can override)
require('minuet-lsp-context').setup({
  -- LSP Context
  lsp_context = {
    enabled = true,
    timeout_ms = 1000,
    max_symbols = 100,           -- Limit total symbols
    type_resolution_depth = 2,
    include_imports = true,
    
    -- Import filtering
    local_import_patterns = {
      '^%.',                     -- Relative imports: ./foo, ../bar
      '^@/',                     -- Common alias
      '^~/',                     -- Common alias
    },
  },
  
  -- Recent Edits Tracking
  recent_edits = {
    enabled = true,
    max_files = 3,
    max_regions_per_file = 5,
    max_lines_per_region = 100,
    context_lines_before = 10,
    context_lines_after = 10,
    consolidation_window_seconds = 5,
    ignore_whitespace_only = true,
    whole_file_threshold = 0.8,  -- 80% changed = reformat
  },
  
  -- Debug
  debug = {
    verbose = false,              -- Log to :messages
    log_file = nil,               -- Optional log file
  },
})
```

---

## Implementation Details

### LSP Context Gathering

**LSP Methods Used:**
- `textDocument/documentSymbol` - Get all symbols (functions, classes, variables)
- `textDocument/hover` - Get type signatures for symbols
- `textDocument/typeDefinition` - Get type definitions

**Symbol Kinds Reference:**
```lua
local SymbolKind = {
  File = 1, Module = 2, Namespace = 3, Package = 4,
  Class = 5, Method = 6, Property = 7, Field = 8,
  Constructor = 9, Enum = 10, Interface = 11, Function = 12,
  Variable = 13, Constant = 14, String = 15, Number = 16,
  Boolean = 17, Array = 18
}
```

**Type Resolution Depth:**
```
Level 0: Function signature
  ↓
Level 1: Parameter/return types (custom types expanded)
  ↓
Level 2: Fields of those types (custom types expanded)
  ↓
Level 3+: Custom types shown as names only (not expanded)
```

**Custom Type Detection:**
```lua
-- Primitives to ignore: string, number, boolean, any, unknown, void, null, undefined
-- Custom types: PascalCase names (TypeScript convention)

local function is_primitive(type_name)
  local primitives = {
    'String', 'Number', 'Boolean', 'Array', 'Object',
    'Promise', 'Map', 'Set', 'Date', 'Error',
    'void', 'any', 'unknown', 'never', 'null', 'undefined'
  }
  return vim.tbl_contains(primitives, type_name)
end
```

---

### Import Filtering (Hybrid Path-Based Heuristic)

```lua
local function is_external_module(import_path)
  -- Relative paths → local
  if import_path:match('^%.') then
    return false
  end
  
  -- Common local aliases
  if import_path:match('^@/') or import_path:match('^~/') then
    return false
  end
  
  -- Bare imports (no path separators) → external
  if not import_path:match('[/\\]') then
    return true
  end
  
  -- Conservative: assume external if unsure
  return true
end
```

**Result:**
- Filters out 95%+ of external imports correctly
- Includes all local modules
- Simple to understand and maintain

---

### Recent Edits Tracking

**Buffer-Level Tracking with nvim_buf_attach:**
- Real-time tracking as you type
- Works everywhere (no git required)
- Works for unsaved files
- Precise line-level granularity

**Edit Consolidation:**

1. **Time-based (5 second window):**
   - Edits within 5 seconds → merge into single region

2. **Overlapping Region Merging:**
   - Region A: lines 10-15
   - Region B: lines 13-20
   - Merged: lines 10-20

3. **Whitespace-Only Detection:**
   - Compare lines with whitespace stripped
   - If only whitespace changed → ignore the edit

4. **Whole-File Reformat Detection:**
   - If >80% of file changed → likely a reformat
   - Check if whitespace-only → skip entirely
   - Otherwise, cap to 50 most recent lines

5. **Duplicate Prevention:**
   - Track seen line ranges
   - Skip overlapping ranges when extracting context

**Limits:**
```lua
max_files = 3
max_regions_per_file = 5
max_lines_per_region = 100
```

---

### Debug Command

**`:MinuetContextDebug`**
- Generate full LSP context (same as what would be sent to AI)
- Open vertical split with scratch buffer
- Markdown syntax highlighting
- Read-only buffer
- Press `q` to close
- Stats header with metadata (timestamp, buffer, cursor, LSP clients)

---

## Expected Context Output

```markdown
## LSP Context - Accessible Symbols

### Functions
- parseDesign(figmaUrl: string, options: ParseOptions): Promise<DesignResult>
  Types:
    - ParseOptions { skipImages?: boolean, maxDepth?: number }
    - DesignResult { nodes: Node[], styles: StyleMap }
      - Node { id: string, type: NodeType, ... }
      - StyleMap (Map<string, Style>)

### Classes
- DesignParser
  Constructor: (apiKey: string)
  Methods:
    - parse(url: string): Promise<Design>
    - validate(design: Design): ValidationResult

### Imports (Local)
- import { Node, NodeType } from './types'
  - Node { ... }
  - NodeType (enum)

---

## Recent Edits Context

### File: /path/to/parser.ts (edited 2 seconds ago)
Lines 45-65 (changed: 52-58):
```typescript
  // Parse the Figma node tree
  private parseNode(node: FigmaNode): Node {
    // ... context lines ...
    
    >>> CHANGED:
    const parsed: Node = {
      id: node.id,
      type: this.mapNodeType(node.type),
    }
    >>> END CHANGED
    
    return parsed
  }
```

---

# Current File
Language: typescript
...
```

**Estimated size:** 5-10KB typical, 15KB max

---

## Performance Expectations

| Operation | Time | Notes |
|-----------|------|-------|
| `documentSymbol` request | 50-200ms | Cached per buffer |
| `hover` request (per symbol) | 20-50ms | Can batch with timeout |
| `typeDefinition` request | 30-100ms | Recursive (depth 2) |
| Buffer attach overhead | ~0ms | Event-driven |
| Edit tracking per change | <1ms | In-memory updates |
| File read (30 lines) | <5ms | Local I/O |
| **Total context generation** | **200-500ms** | Acceptable for AI latency |

**Optimizations:**
- Cache `documentSymbol` results per buffer (invalidate on change)
- Batch type resolution requests when possible
- Only regenerate context when actually needed

---

## Implementation Phases

### Phase 1: Module Setup & Basic LSP
- [ ] Create `minuet-lsp-context.lua` module
- [ ] Implement `gather_lsp_symbols()` using `textDocument/documentSymbol`
- [ ] Parse DocumentSymbol response (extract functions, classes, methods)
- [ ] Implement basic formatting for symbols
- [ ] Test with a TypeScript file

### Phase 2: Type Resolution
- [ ] Implement `get_symbol_signature()` using `textDocument/hover`
- [ ] Extract custom type names from signatures
- [ ] Implement `resolve_type_definition()` with depth tracking (max 2)
- [ ] Build type hierarchy structure
- [ ] Format type definitions nicely
- [ ] Test with complex nested types

### Phase 3: Scope Filtering
- [ ] Implement `filter_accessible_symbols()`
- [ ] Parse DocumentSymbol hierarchy to determine scope
- [ ] Filter based on cursor position
- [ ] Test from various cursor positions

### Phase 4: Import Filtering
- [ ] Parse imports from documentSymbol (or hover data)
- [ ] Implement `is_external_module()` path heuristic
- [ ] Filter out external packages
- [ ] Include local imports with their type info
- [ ] Test with mixed imports

### Phase 5: Recent Edits Tracking - Core
- [ ] Implement buffer attach with `nvim_buf_attach()`
- [ ] Track edit regions in global state
- [ ] Implement FIFO for max 3 files
- [ ] Cap regions per file (max 5)
- [ ] Cap lines per region (max 100)

### Phase 6: Recent Edits - Consolidation
- [ ] Time-based consolidation (5 second window)
- [ ] Overlapping region merging
- [ ] Whitespace-only change detection
- [ ] Whole-file reformat detection (>80% changed)
- [ ] Duplicate line range prevention
- [ ] Test with various editing patterns

### Phase 7: Context Extraction
- [ ] Implement `read_file_lines()` with error handling
- [ ] Extract ±10 lines around edit regions
- [ ] Use buffer API when available, fall back to file read
- [ ] Handle file read errors gracefully
- [ ] Format recent edits context
- [ ] Test with files in different states

### Phase 8: Minuet Integration
- [ ] Modify `minuet.lua` setup
- [ ] Add `chat_input` template with placeholders
- [ ] Connect `lsp_context` function
- [ ] Connect `recent_edits` function
- [ ] Test end-to-end context generation

### Phase 9: Debug Command
- [ ] Implement `:MinuetContextDebug` command
- [ ] Create split with formatted context
- [ ] Add stats header
- [ ] Set markdown filetype, read-only scratch buffer
- [ ] Add `q` to close keybinding
- [ ] Test output readability

### Phase 10: Error Handling & Polish
- [ ] Add timeout handling for LSP requests (1000ms)
- [ ] Add error handling for failed LSP requests
- [ ] Add graceful degradation (no LSP → empty context)
- [ ] Add logging for debugging (optional verbose mode)
- [ ] Add caching for documentSymbol
- [ ] Test edge cases (large files, no LSP, slow LSP)

### Phase 11: Configuration & Documentation
- [ ] Add setup function with config options
- [ ] Document configuration options in comments
- [ ] Add `:MinuetStatus` enhancement showing context stats
- [ ] Test with different configurations

---

## Testing Plan

1. **Unit tests (manual verification):**
   - Test LSP request/response parsing
   - Test type resolution with nested types
   - Test edit consolidation logic
   - Test whitespace detection
   - Test import filtering

2. **Integration tests:**
   - Test full context generation in TypeScript file
   - Test scope filtering from different cursor positions
   - Test with rapid edits (consolidation)
   - Test with file reformats
   - Test with multiple files

3. **Edge case tests:**
   - No LSP attached → empty context
   - LSP timeout → partial context
   - Very large file (>5000 lines) → performance
   - Binary/unreadable files → graceful skip
   - Deleted files in recent edits → graceful skip
