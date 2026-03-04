# AI Elements Documentation

This folder contains comprehensive documentation for AI Elements, a component library built on top of shadcn/ui for building AI-native applications.

## Introduction

[AI Elements](https://www.npmjs.com/package/ai-elements) is a component library and custom registry that helps you build AI-native applications faster. It provides pre-built components like conversations, messages, prompts, workflows, and more, all designed to integrate seamlessly with the [AI SDK](https://ai-sdk.dev/).

For more information, see [Introduction](introduction.md).

## Getting Started

### Installation

**Using AI Elements CLI:**

```bash
npx ai-elements@latest
```

**Using shadcn CLI:**

```bash
npx shadcn@latest add @ai-elements/all
```

### Prerequisites

-   Node.js version 18 or later
-   A Next.js project with the AI SDK installed
-   shadcn/ui installed in your project

For detailed installation instructions, see [Introduction](introduction.md).

## Components

### Chat & Messaging

-   [**Message**](elements/components/message.md) - Core message component with role-based styling for chat interfaces
-   [**Conversation**](elements/components/conversation.md) - Chat conversation container with auto-scroll functionality
-   [**Response**](elements/components/response.md) - Markdown response renderer using Streamdown for AI-generated content
-   [**Loader**](elements/components/loader.md) - Loading indicators for AI responses with various animation styles

### Input & Prompts

-   [**Prompt Input**](elements/components/prompt-input.md) - Rich input component with file attachments, model picker, and action buttons
-   [**Suggestion**](elements/components/suggestion.md) - Horizontal row of clickable suggestion chips for quick interactions

### AI-Specific Features

-   [**Tool**](elements/components/tool.md) - Display AI tool invocations with input/output visualization
-   [**Reasoning**](elements/components/reasoning.md) - Collapsible component for displaying AI reasoning and chain-of-thought
-   [**Chain of Thought**](elements/components/chain-of-thought.md) - Display AI reasoning process step-by-step
-   [**Plan**](elements/components/plan.md) - Multi-step plan display with progress tracking and status indicators
-   [**Task**](elements/components/task.md) - Collapsible task lists with file references and progress tracking
-   [**Queue**](elements/components/queue.md) - Task queue visualization for managing AI workflows
-   [**Artifact**](elements/components/artifact.md) - Container for displaying generated artifacts like code, documents, or previews

### Workflow & Canvas

-   [**Canvas**](elements/components/canvas.md) - React Flow canvas wrapper for workflow visualizations
-   [**Node**](elements/components/node.md) - Custom workflow nodes with headers, content, and footers
-   [**Edge**](elements/components/edge.md) - Animated and temporary edge types for workflow connections
-   [**Connection**](elements/components/connection.md) - Custom connection lines for React Flow graphs
-   [**Toolbar**](elements/components/toolbar.md) - Node toolbar for React Flow with action buttons
-   [**Panel**](elements/components/panel.md) - Positioned panels for canvas overlays and controls
-   [**Controls**](elements/components/controls.md) - Canvas control buttons for zoom, fit view, and navigation

### UI Enhancements

-   [**Actions**](elements/components/actions.md) - Action buttons for message interactions (copy, retry, regenerate, etc.)
-   [**Confirmation**](elements/components/confirmation.md) - User approval flow for sensitive AI operations
-   [**Sources**](elements/components/sources.md) - Collapsible source and citation list for AI responses
-   [**Inline Citation**](elements/components/inline-citation.md) - Inline source citations with hover previews
-   [**Code Block**](elements/components/code-block.md) - Syntax-highlighted code blocks with copy functionality
-   [**Image**](elements/components/image.md) - Image display component with error handling
-   [**Shimmer**](elements/components/shimmer.md) - Animated shimmer effect for loading states
-   [**Web Preview**](elements/components/web-preview.md) - Iframe component for displaying web previews
-   [**Open in Chat**](elements/components/open-in-chat.md) - Button to open content in chat interface
-   [**Context**](elements/components/context.md) - Context menu system for conversations
-   [**Branch**](elements/components/branch.md) - Multi-version message branches with navigation

## Examples

Complete tutorials demonstrating how to build AI applications with AI Elements:

-   [**Chatbot**](elements/examples/chatbot.md) - Build a complete chatbot with reasoning, sources, model picker, and file attachments
-   [**v0 Clone**](elements/examples/v0.md) - Create a v0 clone using the v0 Platform API with WebPreview component
-   [**Workflow Visualization**](elements/examples/workflow.md) - Build workflow visualizations with React Flow, custom nodes, and animated edges

## Documentation

-   [**Usage**](usage.md) - Learn how to use AI Elements components in your application
-   [**Troubleshooting**](troubleshooting.md) - Common issues and solutions for AI Elements

## Component Categories

### By Use Case

**Building Chat Interfaces:**

-   Message, Conversation, Response, Loader, Prompt Input, Suggestion, Actions

**Displaying AI Reasoning:**

-   Reasoning, Chain of Thought, Plan, Task, Tool

**Creating Workflows:**

-   Canvas, Node, Edge, Connection, Toolbar, Panel, Controls

**Enhancing Content:**

-   Code Block, Image, Sources, Inline Citation, Web Preview, Artifact

**User Interactions:**

-   Confirmation, Actions, Suggestion, Open in Chat, Context, Branch

## Installation Methods

You can install individual components or all components at once:

**Install a single component:**

```bash
npx ai-elements@latest add message
```

**Install all components:**

```bash
npx ai-elements@latest add @ai-elements/all
```

**Using shadcn CLI:**

```bash
npx shadcn@latest add @ai-elements/[component-name]
```

## Customization

All AI Elements components are installed directly into your codebase (typically in `@/components/ai-elements/`), making them fully customizable. You can modify styles, add features, or adapt components to your specific needs.

For customization examples, see [Usage](usage.md).

## Support

If you encounter any issues, check the [Troubleshooting](troubleshooting.md) guide or open an issue on the [GitHub repository](https://github.com/vercel/ai-elements/issues).
