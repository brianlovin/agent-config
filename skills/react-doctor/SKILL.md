---
name: react-doctor
description: Diagnoses and fixes React codebase health issues by running automated analysis across security, performance, correctness, and architecture dimensions. Use when reviewing React components, hooks, or .jsx/.tsx files; identifying unnecessary re-renders, memory leaks, or component lifecycle issues; auditing useState/useEffect misuse, missing cleanup, or hardcoded secrets; improving bundle size, accessibility, or Next.js server patterns; or generating a 0-100 health score with prioritized, actionable diagnostics.
version: 1.0.0
---

# React Doctor

Scans your React codebase for security, performance, correctness, and architecture issues. Outputs a 0-100 score with actionable diagnostics.

## Usage

```bash
npx -y react-doctor@latest . --verbose
```

## Workflow

1. Run the command above at the project root
2. Read every diagnostic with file paths and line numbers
3. Fix issues starting with errors (highest severity)
4. Re-run to verify the score improved

## Rules (47+)

- **Security**: hardcoded secrets in client bundle, eval()
- **State & Effects**: derived state in useEffect, missing cleanup, useState from props, cascading setState
- **Architecture**: components inside components, giant components, inline render functions
- **Performance**: layout property animations, transition-all, large blur values
- **Correctness**: array index as key, conditional rendering bugs
- **Next.js**: missing metadata, client-side fetching for server data, async client components
- **Bundle Size**: barrel imports, full lodash, moment.js, missing code splitting
- **Server**: missing auth in server actions, blocking without after()
- **Accessibility**: missing prefers-reduced-motion
- **Dead Code**: unused files, exports, types

## Score

- **75+**: Great
- **50-74**: Needs work
- **0-49**: Critical
