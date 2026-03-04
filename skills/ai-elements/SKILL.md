---
name: ai-elements
description: Intelligent documentation system for AI Elements component library. Activate automatically when working with AI-native applications or when AI Elements component names are mentioned (Message, Conversation, Reasoning, Canvas, etc.). Provides context-aware documentation retrieval - fetches examples for implementation queries, component references for API lookups, and smart multi-page fetching for complex tasks.
---

# AI Elements Documentation

## Overview

Provide intelligent documentation retrieval for the AI Elements component library when building AI-native applications. AI Elements is a component library built on shadcn/ui that provides pre-built components like conversations, messages, prompts, workflows, and more - all designed to integrate with the AI SDK.

This skill automatically fetches relevant documentation from the bundled markdown files and provides context-aware routing to ensure users get the right information format for their query.

## Activation

### Automatically Activate When:

1. **AI Elements Component Names Mentioned:**
   - Chat & Messaging: Message, Conversation, Response, Loader, Prompt Input, Suggestion, Actions
   - AI-Specific: Tool, Reasoning, Chain of Thought, Plan, Task, Queue, Artifact
   - Workflow: Canvas, Node, Edge, Connection, Toolbar, Panel, Controls
   - UI Enhancements: Code Block, Image, Sources, Inline Citation, Confirmation, etc.

2. **AI Elements Library Terms:**
   - "ai-elements", "AI Elements library"
   - "ai-native app", "AI native application"
   - "shadcn AI components"
   - "@ai-elements/..." (component installation syntax)

3. **File Context Detection:**
   - Imports from `@/components/ai-elements/`
   - Component usage matching AI Elements component names
   - AI Elements commands in package.json

4. **AI-Native Development Queries:**
   - Building chat interfaces with AI responses
   - Creating workflow visualizations for AI agents
   - Displaying AI reasoning or chain-of-thought
   - Implementing AI artifact containers

### Do NOT Activate For:

- Generic chat/messaging apps without AI context
- General React Flow usage without AI workflow context
- Standard UI components unless specifically AI Elements components
- Generic "conversation" mentions without AI/component context

## Core Capabilities

### 1. Context-Aware Documentation Routing

Route queries intelligently based on intent to provide the most useful documentation format:

#### Route 1: Implementation Queries → Examples + Components

**Triggers:**
- "how to build...", "create a...", "implement a..."
- "building a chatbot", "creating a workflow visualization"
- "I want to make...", "I need to develop..."

**Action:**
1. Identify the most relevant example from INDEX.md
2. Read the example file using Read tool: `.claude/skills/ai-elements/docs/examples/[example].md`
3. Identify 2-3 key components mentioned in the example
4. Read those component files: `.claude/skills/ai-elements/docs/components/[component].md`
5. Present with integration pattern explanation

**Example Query:** "How do I build a chatbot with reasoning?"
**Fetch:**
- `docs/examples/chatbot.md`
- `docs/components/reasoning.md`
- `docs/components/conversation.md`

#### Route 2: API Reference Queries → Component Only

**Triggers:**
- "what is...", "what does... do", "what props..."
- "how does X component work"
- "show me the API for..."
- "what properties does... accept"

**Action:**
1. Look up component in INDEX.md
2. Read single component file: `.claude/skills/ai-elements/docs/components/[component].md`
3. Suggest 2-3 category-related components from INDEX.md

**Example Query:** "What props does Message accept?"
**Fetch:**
- `docs/components/message.md`
**Suggest:** Conversation, Response, Actions (same category)

#### Route 3: General Guidance Queries → Overview Docs

**Triggers:**
- "getting started with AI Elements"
- "how to install...", "setup..."
- "troubleshooting...", "common issues..."
- "best practices for..."

**Action:**
1. Read appropriate general documentation:
   - `docs/introduction.md` for getting started
   - `docs/usage.md` for implementation patterns
   - `docs/troubleshooting.md` for issues
   - `docs/README.md` for overview

**Example Query:** "I'm new to AI Elements, how do I get started?"
**Fetch:**
- `docs/introduction.md`
- `docs/usage.md`

#### Route 4: Category/Use Case Queries → README + Components

**Triggers:**
- "components for building chat interfaces"
- "workflow visualization components"
- "what components help with..."
- "show me all... components"

**Action:**
1. Read `docs/README.md` (contains categorized component lists)
2. Optionally read 1-2 key components in that category
3. List all relevant components with brief descriptions from INDEX.md

**Example Query:** "What components help with workflow visualization?"
**Fetch:**
- `docs/README.md`
- Optionally: `docs/components/canvas.md`

### 2. Smart Multi-Page Fetching

**Fetch Multiple Pages (2-4 total) When:**
- Implementation queries ("how to build...")
- Query mentions multiple components ("chat with reasoning")
- Component docs reference other required components
- Related component sets (Canvas + Node + Edge, Message + Conversation + Response)

**Fetch Single Page When:**
- Simple reference queries ("what props...")
- Troubleshooting lookups
- General overview requests

**Stop Fetching When:**
- Already fetched 3-4 pages
- Query is answered sufficiently
- Additional pages would be tangential

### 3. Category-Aware Suggestions

After fetching documentation, always suggest 2-3 related components using these category groupings:

**Chat & Messaging:**
- Message, Conversation, Response, Loader, Prompt Input, Suggestion, Actions

**AI-Specific Features:**
- Tool, Reasoning, Chain of Thought, Plan, Task, Queue, Artifact

**Workflow & Canvas:**
- Canvas, Node, Edge, Connection, Toolbar, Panel, Controls

**UI Enhancements:**
- Code Block, Image, Sources, Inline Citation, Web Preview, Shimmer, Open in Chat, Confirmation, Context, Branch

**Common Pairings:**
- Message → Conversation, Response, Actions
- Reasoning → Chain of Thought, Plan, Task
- Canvas → Node, Edge, Toolbar, Panel
- Prompt Input → Suggestion, Confirmation
- Tool → Artifact, Code Block
- Sources → Inline Citation

Suggest components from:
1. Same category (highest priority)
2. Commonly used together
3. Next implementation step

### 4. Installation Command Generation

Always include installation commands in responses:

**Single component:**
```
**Installation:**
`npx ai-elements add [component-name]`
```

**Multiple components:**
```
**Installation:**
`npx ai-elements add message conversation response`
```

**All components:**
```
**Installation (all components):**
`npx ai-elements add @ai-elements/all`
```

**For workflow components (Canvas, Node, Edge, etc.):**
```
**Installation:**
`npx ai-elements add canvas` (requires React Flow)
```

## Response Formats

### Single-Page Response Format

```markdown
I've fetched the [Component Name] documentation from AI Elements.

**Installation:**
`npx ai-elements add [component-name]`

[Full component documentation content from file]

---

**Related Components:**
- **[Component 1]** - [Brief description of relationship]
- **[Component 2]** - [Brief description of relationship]
- **[Component 3]** - [Brief description of relationship]
```

### Multi-Page Response Format

```markdown
This requires understanding multiple components. I've fetched:

---

## [Example/Component 1 Name]

**Installation:**
`npx ai-elements add [component-name]`

[Full content from file]

---

## [Component 2 Name]

**Installation:**
`npx ai-elements add [component-name]`

[Full content from file]

---

## [Component 3 Name] (if needed)

**Installation:**
`npx ai-elements add [component-name]`

[Full content from file]

---

**Integration Pattern:**
[2-3 sentences explaining how these components work together, referencing examples from the documentation]

**Related Resources:**
- **[Additional Component]** - [Description]
- **[Tutorial/Example]** - [Description]
```

## Implementation Guidance Scope

### ✅ DO Provide:

1. **Pattern Explanations from Examples**
   - "The chatbot example shows using Conversation with auto-scroll"
   - "The workflow example demonstrates connecting Canvas + Node + Edge"

2. **Component Integration Patterns**
   - "Typically used together: Message inside Conversation with Response for AI output"
   - "Canvas requires Node and Edge components for complete workflows"

3. **Best Practices from Docs**
   - "The docs recommend using Loader during AI response generation"
   - "Prompt Input includes built-in file attachment handling"

4. **Common Pitfall Warnings**
   - "Note: Canvas requires React Flow to be installed separately"
   - "Response component uses Streamdown for markdown rendering"

5. **Installation Guidance**
   - "Install all chat components: `npx ai-elements add message conversation response`"
   - "Prerequisites: Next.js with AI SDK and shadcn/ui"

### ❌ DON'T Provide:

1. **Complete Custom Implementations** - Reference examples instead of generating new code
2. **Customization Beyond Docs** - Only suggest what's documented
3. **Debugging User Code** - Can reference troubleshooting docs only
4. **Undocumented Features** - Only describe documented capabilities
5. **Framework Integration** (unless documented) - Stick to documented Next.js + AI SDK patterns

## Documentation Access

### File Structure

All documentation is bundled in the skill at:
```
.claude/skills/ai-elements/
├── SKILL.md (this file)
├── INDEX.md (searchable component reference)
└── docs/
    ├── README.md (overview and categories)
    ├── introduction.md (getting started)
    ├── usage.md (implementation patterns)
    ├── troubleshooting.md (common issues)
    ├── components/ (31 component files)
    │   ├── message.md
    │   ├── conversation.md
    │   ├── reasoning.md
    │   └── ...
    └── examples/ (3 tutorial files)
        ├── chatbot.md
        ├── v0.md
        └── workflow.md
```

### How to Access Documentation

1. **Search INDEX.md** for component names, keywords, or categories
2. **Read files** using the Read tool with absolute paths:
   - Components: `.claude/skills/ai-elements/docs/components/[name].md`
   - Examples: `.claude/skills/ai-elements/docs/examples/[name].md`
   - General: `.claude/skills/ai-elements/docs/[name].md`
3. **Extract metadata** from INDEX.md entries (keywords, related components, categories)
4. **Generate suggestions** using category groupings and common pairings

## Query Interpretation Examples

### Example 1: Building a Feature

**Query:** "How do I build a chat interface with AI responses?"

**Routing:** Implementation query → Examples + Components

**Process:**
1. Search INDEX.md for "chat", "conversation", "chatbot"
2. Identify relevant example: chatbot.md
3. Read `.claude/skills/ai-elements/docs/examples/chatbot.md`
4. Extract key components mentioned: Conversation, Message, Response
5. Read those component files
6. Format multi-page response with integration pattern

**Response includes:**
- Installation commands for all components
- Full chatbot example
- Component API references
- Integration pattern explanation

### Example 2: API Lookup

**Query:** "What props does the Reasoning component accept?"

**Routing:** API reference query → Component only

**Process:**
1. Look up "reasoning" in INDEX.md
2. Read `.claude/skills/ai-elements/docs/components/reasoning.md`
3. Extract category from INDEX.md: "AI-Specific Features"
4. Find related components: Chain of Thought, Plan, Task

**Response includes:**
- Installation: `npx ai-elements add reasoning`
- Full Reasoning component documentation
- Props table and usage examples
- Suggestions: Chain of Thought, Plan, Task

### Example 3: Category Exploration

**Query:** "What components help with workflow visualization?"

**Routing:** Category query → README + key component

**Process:**
1. Search INDEX.md for "workflow" category
2. Read `.claude/skills/ai-elements/docs/README.md`
3. Extract Workflow & Canvas category section
4. Optionally read Canvas component as primary example

**Response includes:**
- List of all workflow components
- Brief descriptions from README
- Installation command for workflow set
- Suggestion to check workflow example

### Example 4: Getting Started

**Query:** "I'm new to AI Elements, how do I get started?"

**Routing:** General guidance → Overview docs

**Process:**
1. Read `.claude/skills/ai-elements/docs/introduction.md`
2. Read `.claude/skills/ai-elements/docs/usage.md`

**Response includes:**
- Installation instructions
- Prerequisites checklist
- Basic usage patterns
- Suggestions to explore chatbot/v0/workflow examples

## Important Notes

### Prerequisites

Always mention when relevant:
- Node.js 18 or later
- Next.js project
- AI SDK installed
- shadcn/ui installed
- React Flow (for workflow components only)

### Component Customization

Components are installed as source files into the user's codebase (typically `@/components/ai-elements/`), making them fully customizable. Reference `usage.md` for customization guidance.

### AI SDK Integration

All components are designed for use with the AI SDK. Reference integration patterns with `useChat`, `useCompletion`, and other AI SDK hooks when showing examples.

### React Flow Dependency

Canvas, Node, Edge, Connection, Toolbar, Panel, and Controls components require React Flow to be installed separately. Always note this dependency when fetching workflow component documentation.

## Workflow Summary

**For every query:**

1. **Identify intent** → Implementation, API reference, category, or general guidance
2. **Route appropriately** → Determine which files to fetch
3. **Search INDEX.md** → Find relevant components, keywords, categories
4. **Read files** → Use Read tool to access documentation
5. **Format response** → Include installation, content, integration pattern, suggestions
6. **Suggest related** → Use category groupings and common pairings

**Keep responses:**
- Focused on documented information
- Formatted with clear installation commands
- Enriched with relevant component suggestions
- Practical with integration patterns from examples
