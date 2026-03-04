# AI Elements Documentation Index

This index provides a searchable reference for all AI Elements components, examples, and documentation. Use this to quickly locate the right documentation file based on keywords, categories, or related components.

---

## Examples

### Chatbot
**File:** `docs/examples/chatbot.md`
**Description:** Complete tutorial for building a chatbot with reasoning, sources, model picker, and file attachments
**Keywords:** chat, conversation, message, response, reasoning, sources, prompt-input, chatbot, tutorial, complete-example
**Category:** Tutorial
**Installation:** Multiple components
**Related:** message, conversation, response, reasoning, sources, prompt-input, loader, suggestion
**Common Use:** Building complete AI chat interfaces with advanced features

### v0 Clone
**File:** `docs/examples/v0.md`
**Description:** Create a v0 clone using v0 Platform API with WebPreview component
**Keywords:** v0, web-preview, artifact, code-generation, clone, tutorial
**Category:** Tutorial
**Installation:** Multiple components
**Related:** web-preview, artifact, code-block, prompt-input, conversation
**Common Use:** Building code generation and preview interfaces

### Workflow Visualization
**File:** `docs/examples/workflow.md`
**Description:** Build workflow visualizations with React Flow, custom nodes, and animated edges
**Keywords:** workflow, react-flow, canvas, node, edge, visualization, tutorial
**Category:** Tutorial
**Installation:** Multiple components (requires React Flow)
**Related:** canvas, node, edge, connection, toolbar, panel, controls
**Common Use:** Creating AI agent workflow visualizations and node-based interfaces

---

## Components - Chat & Messaging

### Message
**File:** `docs/components/message.md`
**Description:** Core message component with role-based styling for chat interfaces
**Keywords:** message, chat, role, user, assistant, system, avatar, conversation-display
**Category:** Chat & Messaging
**Installation:** `npx ai-elements add message`
**Related:** conversation, response, actions, loader
**Common Use:** Displaying individual chat messages in conversation interfaces

### Conversation
**File:** `docs/components/conversation.md`
**Description:** Chat conversation container with auto-scroll functionality
**Keywords:** conversation, chat, container, auto-scroll, messages, chat-container
**Category:** Chat & Messaging
**Installation:** `npx ai-elements add conversation`
**Related:** message, response, loader, prompt-input
**Common Use:** Building scrollable chat interfaces with auto-scroll to bottom

### Response
**File:** `docs/components/response.md`
**Description:** Markdown response renderer using Streamdown for AI-generated content
**Keywords:** response, markdown, streamdown, ai-content, render, formatting
**Category:** Chat & Messaging
**Installation:** `npx ai-elements add response`
**Related:** message, conversation, code-block
**Common Use:** Rendering AI-generated markdown responses with proper formatting

### Loader
**File:** `docs/components/loader.md`
**Description:** Loading indicators for AI responses with various animation styles
**Keywords:** loader, loading, spinner, animation, pending, waiting
**Category:** Chat & Messaging
**Installation:** `npx ai-elements add loader`
**Related:** conversation, message, prompt-input
**Common Use:** Showing loading state while AI generates responses

### Prompt Input
**File:** `docs/components/prompt-input.md`
**Description:** Rich input component with file attachments, model picker, and action buttons
**Keywords:** prompt, input, textarea, file-attachment, model-picker, submit, chat-input
**Category:** Chat & Messaging
**Installation:** `npx ai-elements add prompt-input`
**Related:** conversation, message, suggestion
**Common Use:** Building rich chat input interfaces with file uploads and model selection

### Suggestion
**File:** `docs/components/suggestion.md`
**Description:** Horizontal row of clickable suggestion chips for quick interactions
**Keywords:** suggestion, chips, quick-reply, buttons, prompts, suggestions
**Category:** Chat & Messaging
**Installation:** `npx ai-elements add suggestion`
**Related:** prompt-input, message, conversation
**Common Use:** Providing quick action suggestions and starter prompts

### Actions
**File:** `docs/components/actions.md`
**Description:** Action buttons for message interactions (copy, retry, regenerate, etc.)
**Keywords:** actions, buttons, copy, retry, regenerate, message-actions, toolbar
**Category:** Chat & Messaging
**Installation:** `npx ai-elements add actions`
**Related:** message, conversation, response
**Common Use:** Adding copy, retry, and regenerate functionality to messages

---

## Components - AI-Specific Features

### Tool
**File:** `docs/components/tool.md`
**Description:** Display AI tool invocations with input/output visualization
**Keywords:** tool, function-call, invocation, input, output, ai-tools, tool-use
**Category:** AI-Specific Features
**Installation:** `npx ai-elements add tool`
**Related:** message, response, artifact
**Common Use:** Showing AI tool/function calls and their results

### Reasoning
**File:** `docs/components/reasoning.md`
**Description:** Collapsible component for displaying AI reasoning and chain-of-thought
**Keywords:** reasoning, chain-of-thought, thinking, collapsible, ai-reasoning, deepseek
**Category:** AI-Specific Features
**Installation:** `npx ai-elements add reasoning`
**Related:** chain-of-thought, plan, task, message
**Common Use:** Displaying AI reasoning process in collapsible format

### Chain of Thought
**File:** `docs/components/chain-of-thought.md`
**Description:** Display AI reasoning process step-by-step
**Keywords:** chain-of-thought, reasoning, steps, thinking, process, ai-reasoning
**Category:** AI-Specific Features
**Installation:** `npx ai-elements add chain-of-thought`
**Related:** reasoning, plan, task
**Common Use:** Showing step-by-step AI reasoning and thought process

### Plan
**File:** `docs/components/plan.md`
**Description:** Multi-step plan display with progress tracking and status indicators
**Keywords:** plan, steps, progress, status, multi-step, planning, task-list
**Category:** AI-Specific Features
**Installation:** `npx ai-elements add plan`
**Related:** task, queue, chain-of-thought, reasoning
**Common Use:** Displaying AI-generated plans with progress tracking

### Task
**File:** `docs/components/task.md`
**Description:** Collapsible task lists with file references and progress tracking
**Keywords:** task, checklist, progress, files, collapsible, todo, task-tracking
**Category:** AI-Specific Features
**Installation:** `npx ai-elements add task`
**Related:** plan, queue, chain-of-thought
**Common Use:** Showing AI task execution with file references

### Queue
**File:** `docs/components/queue.md`
**Description:** Task queue visualization for managing AI workflows
**Keywords:** queue, tasks, workflow, sequence, pending, processing
**Category:** AI-Specific Features
**Installation:** `npx ai-elements add queue`
**Related:** task, plan, workflow
**Common Use:** Visualizing queued AI tasks and workflow sequences

### Artifact
**File:** `docs/components/artifact.md`
**Description:** Container for displaying generated artifacts like code, documents, or previews
**Keywords:** artifact, container, generated-content, code, document, preview, output
**Category:** AI-Specific Features
**Installation:** `npx ai-elements add artifact`
**Related:** code-block, web-preview, tool
**Common Use:** Displaying AI-generated artifacts and outputs

---

## Components - Workflow & Canvas

### Canvas
**File:** `docs/components/canvas.md`
**Description:** React Flow canvas wrapper for workflow visualizations
**Keywords:** canvas, react-flow, workflow, visualization, nodes, edges, graph
**Category:** Workflow & Canvas
**Installation:** `npx ai-elements add canvas` (requires React Flow)
**Related:** node, edge, connection, toolbar, panel, controls
**Common Use:** Creating node-based workflow visualizations

### Node
**File:** `docs/components/node.md`
**Description:** Custom workflow nodes with headers, content, and footers
**Keywords:** node, workflow, custom-node, react-flow, graph-node
**Category:** Workflow & Canvas
**Installation:** `npx ai-elements add node`
**Related:** canvas, edge, toolbar, connection
**Common Use:** Building custom nodes for workflow visualizations

### Edge
**File:** `docs/components/edge.md`
**Description:** Animated and temporary edge types for workflow connections
**Keywords:** edge, connection, animated, temporary, react-flow, workflow-edge
**Category:** Workflow & Canvas
**Installation:** `npx ai-elements add edge`
**Related:** canvas, node, connection
**Common Use:** Creating animated connections between workflow nodes

### Connection
**File:** `docs/components/connection.md`
**Description:** Custom connection lines for React Flow graphs
**Keywords:** connection, line, react-flow, connecting, workflow
**Category:** Workflow & Canvas
**Installation:** `npx ai-elements add connection`
**Related:** canvas, node, edge
**Common Use:** Customizing connection appearance in workflows

### Toolbar
**File:** `docs/components/toolbar.md`
**Description:** Node toolbar for React Flow with action buttons
**Keywords:** toolbar, actions, node-toolbar, react-flow, buttons
**Category:** Workflow & Canvas
**Installation:** `npx ai-elements add toolbar`
**Related:** canvas, node, panel
**Common Use:** Adding action toolbars to workflow nodes

### Panel
**File:** `docs/components/panel.md`
**Description:** Positioned panels for canvas overlays and controls
**Keywords:** panel, overlay, positioned, react-flow, controls
**Category:** Workflow & Canvas
**Installation:** `npx ai-elements add panel`
**Related:** canvas, controls, toolbar
**Common Use:** Creating overlay panels on workflow canvases

### Controls
**File:** `docs/components/controls.md`
**Description:** Canvas control buttons for zoom, fit view, and navigation
**Keywords:** controls, zoom, fit-view, navigation, react-flow, canvas-controls
**Category:** Workflow & Canvas
**Installation:** `npx ai-elements add controls`
**Related:** canvas, panel
**Common Use:** Adding zoom and navigation controls to canvas

---

## Components - UI Enhancements

### Code Block
**File:** `docs/components/code-block.md`
**Description:** Syntax-highlighted code blocks with copy functionality
**Keywords:** code-block, syntax-highlighting, copy, code, programming, snippet
**Category:** UI Enhancements
**Installation:** `npx ai-elements add code-block`
**Related:** response, artifact, tool
**Common Use:** Displaying formatted code with syntax highlighting

### Image
**File:** `docs/components/image.md`
**Description:** Image display component with error handling
**Keywords:** image, picture, display, error-handling, media
**Category:** UI Enhancements
**Installation:** `npx ai-elements add image`
**Related:** message, response, artifact
**Common Use:** Displaying images with graceful error handling

### Sources
**File:** `docs/components/sources.md`
**Description:** Collapsible source and citation list for AI responses
**Keywords:** sources, citations, references, collapsible, rag, retrieval
**Category:** UI Enhancements
**Installation:** `npx ai-elements add sources`
**Related:** inline-citation, message, response
**Common Use:** Showing sources and citations for AI-generated content

### Inline Citation
**File:** `docs/components/inline-citation.md`
**Description:** Inline source citations with hover previews
**Keywords:** citation, inline, hover, preview, reference, sources
**Category:** UI Enhancements
**Installation:** `npx ai-elements add inline-citation`
**Related:** sources, response, message
**Common Use:** Adding inline citations with hover previews to text

### Web Preview
**File:** `docs/components/web-preview.md`
**Description:** Iframe component for displaying web previews
**Keywords:** web-preview, iframe, preview, web, html, render
**Category:** UI Enhancements
**Installation:** `npx ai-elements add web-preview`
**Related:** artifact, code-block
**Common Use:** Previewing generated HTML and web content

### Shimmer
**File:** `docs/components/shimmer.md`
**Description:** Animated shimmer effect for loading states
**Keywords:** shimmer, loading, skeleton, animation, placeholder
**Category:** UI Enhancements
**Installation:** `npx ai-elements add shimmer`
**Related:** loader, message
**Common Use:** Creating skeleton loading states with shimmer effect

### Open in Chat
**File:** `docs/components/open-in-chat.md`
**Description:** Button to open content in chat interface
**Keywords:** open-in-chat, button, navigation, chat, action
**Category:** UI Enhancements
**Installation:** `npx ai-elements add open-in-chat`
**Related:** conversation, message, prompt-input
**Common Use:** Adding buttons to open content in chat interface

### Context
**File:** `docs/components/context.md`
**Description:** Context menu system for conversations
**Keywords:** context-menu, menu, right-click, actions, conversation
**Category:** UI Enhancements
**Installation:** `npx ai-elements add context`
**Related:** message, conversation, actions
**Common Use:** Adding context menus to conversation elements

### Confirmation
**File:** `docs/components/confirmation.md`
**Description:** User approval flow for sensitive AI operations
**Keywords:** confirmation, approval, dialog, user-confirmation, sensitive, permission
**Category:** UI Enhancements
**Installation:** `npx ai-elements add confirmation`
**Related:** message, tool, actions
**Common Use:** Requesting user approval for sensitive AI actions

### Branch
**File:** `docs/components/branch.md`
**Description:** Multi-version message branches with navigation
**Keywords:** branch, versions, multi-version, navigation, conversation-branch, alternatives
**Category:** UI Enhancements
**Installation:** `npx ai-elements add branch`
**Related:** message, conversation, actions
**Common Use:** Managing multiple conversation branches and alternatives

---

## General Documentation

### README
**File:** `docs/README.md`
**Description:** Overview of AI Elements library with component categories and installation methods
**Keywords:** overview, introduction, component-list, categories, getting-started
**Related:** introduction, usage

### Introduction
**File:** `docs/introduction.md`
**Description:** Getting started guide with installation, prerequisites, and library overview
**Keywords:** introduction, installation, setup, prerequisites, getting-started, quickstart
**Related:** README, usage, troubleshooting

### Usage
**File:** `docs/usage.md`
**Description:** Implementation patterns and customization examples for AI Elements
**Keywords:** usage, patterns, customization, implementation, examples, how-to
**Related:** introduction, troubleshooting

### Troubleshooting
**File:** `docs/troubleshooting.md`
**Description:** Common issues and solutions for AI Elements
**Keywords:** troubleshooting, issues, problems, solutions, errors, debugging, help
**Related:** introduction, usage

---

## Component Categories Summary

### By Use Case

**Building Chat Interfaces:**
- Message, Conversation, Response, Loader, Prompt Input, Suggestion, Actions

**Displaying AI Reasoning:**
- Reasoning, Chain of Thought, Plan, Task, Tool, Queue

**Creating Workflows:**
- Canvas, Node, Edge, Connection, Toolbar, Panel, Controls

**Enhancing Content:**
- Code Block, Image, Sources, Inline Citation, Web Preview, Artifact, Shimmer

**User Interactions:**
- Confirmation, Actions, Suggestion, Open in Chat, Context, Branch

---

## Common Component Pairings

These components are frequently used together:

- **Chat Interface:** Message + Conversation + Response + Prompt Input + Loader
- **AI Reasoning Display:** Reasoning + Chain of Thought + Plan + Task
- **Workflow Visualization:** Canvas + Node + Edge + Toolbar + Controls
- **Code Generation:** Artifact + Code Block + Web Preview + Response
- **Citations & Sources:** Sources + Inline Citation + Response
- **Rich Messages:** Message + Response + Code Block + Tool + Reasoning
- **Complete Chatbot:** See chatbot example for full integration

---

## Prerequisites

All AI Elements components require:
- Node.js 18 or later
- Next.js project
- AI SDK installed
- shadcn/ui installed

**Additional for Workflow Components:**
- React Flow library (for Canvas, Node, Edge, Connection, Toolbar, Panel, Controls)

---

## Installation Quick Reference

**Single component:**
```bash
npx ai-elements add [component-name]
```

**Multiple components:**
```bash
npx ai-elements add message conversation response
```

**All components:**
```bash
npx ai-elements add @ai-elements/all
```

**Using shadcn CLI:**
```bash
npx shadcn@latest add @ai-elements/[component-name]
```
