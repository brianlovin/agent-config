---
name: sentry
description: Configures and applies Sentry SDK patterns for error monitoring, performance tracing, and structured logging in Next.js applications. Use when working with Sentry setup, error tracking, crash reporting, exception handling, APM, or observability in Next.js — including tasks like "track errors in production", "debug production issues", "monitor app performance", "set up crash reporting", "add performance spans", or "configure the Sentry SDK". Covers SDK initialization across client/server/edge runtimes, captureException usage, custom span creation for UI actions and API calls, consoleLoggingIntegration, and structured logger output.
---

# Sentry Integration

Guidelines for using Sentry for error monitoring and performance tracing.

## Setup Workflow

Follow this sequence when initializing Sentry in a Next.js project:

1. **Create config files** — `sentry.client.config.ts`, `sentry.server.config.ts`, `sentry.edge.config.ts`
2. **Add DSN** — set `NEXT_PUBLIC_SENTRY_DSN` in environment variables and call `Sentry.init()`
3. **Verify** — send a test event with `Sentry.captureMessage("Test")` and confirm it appears in the Sentry dashboard

## Exception Catching

Use `Sentry.captureException(error)` in try/catch blocks:

```javascript
try {
  await riskyOperation();
} catch (error) {
  Sentry.captureException(error);
  throw error;
}
```

## Performance Tracing

Create spans for meaningful actions like button clicks, API calls, and function calls.

### UI Actions

```javascript
function handleClick() {
  Sentry.startSpan(
    { op: "ui.click", name: "Submit Form" },
    (span) => {
      span.setAttribute("formId", formId);
      submitForm();
    }
  );
}
```

### API Calls

```javascript
async function fetchData(id) {
  return Sentry.startSpan(
    { op: "http.client", name: `GET /api/items/${id}` },
    async () => {
      const response = await fetch(`/api/items/${id}`);
      return response.json();
    }
  );
}
```

## Configuration (Next.js)

Sentry initialization files:
- `sentry.client.config.ts` - Client-side
- `sentry.server.config.ts` - Server-side
- `sentry.edge.config.ts` - Edge runtime

Import with `import * as Sentry from "@sentry/nextjs"` - no need to initialize in other files.

### Basic Setup

```javascript
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  enableLogs: true,
});
```

### With Console Logging

```javascript
Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  integrations: [
    Sentry.consoleLoggingIntegration({ levels: ["log", "warn", "error"] }),
  ],
});
```

### Verification

After initialization, confirm Sentry is capturing events correctly:

```javascript
// Send a test event and check the Sentry dashboard
Sentry.captureMessage("Test: Sentry initialized successfully");
```

## Structured Logging

Use `logger.fmt` for template literals with variables:

```javascript
const { logger } = Sentry;

logger.trace("Starting connection", { database: "users" });
logger.debug(logger.fmt`Cache miss for: ${userId}`);
logger.info("Updated profile", { profileId: 345 });
logger.warn("Rate limit reached", { endpoint: "/api/data" });
logger.error("Payment failed", { orderId: "order_123" });
logger.fatal("Connection pool exhausted", { activeConnections: 100 });
```
