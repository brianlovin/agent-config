---
name: skill-creator
description: Guide for creating effective skills—covering writing YAML frontmatter, defining description fields, structuring skill content sections, and organizing bundled resources (scripts, references, assets). Use when users want to create a new skill, update an existing skill, write a SKILL.md file, build a skill template, work with a skill file, or extend Claude's capabilities with specialized knowledge, workflows, or tool integrations.
license: Complete terms in LICENSE.txt
---

# Skill Creator

This skill provides guidance for creating effective skills.

## Skill Structure

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter metadata (required)
│   │   ├── name: (required)
│   │   └── description: (required)
│   └── Markdown instructions (required)
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Python/Bash/etc.)
    ├── references/       - Documentation loaded into context as needed
    └── assets/           - Files used in output (templates, icons, fonts, etc.)
```

## Core Principles

- **Concise is key**: Only add context Claude doesn't already have. Prefer concise examples over verbose explanations.
- **Progressive disclosure**: Metadata always in context (~100 words); SKILL.md body loads when triggered (<5k words, under 500 lines); bundled resources load as needed.
- **Set appropriate degrees of freedom**: Use text instructions for flexible tasks, pseudocode for tasks with a preferred pattern, and specific scripts for fragile or deterministic operations.

Keep only the core workflow and selection guidance in SKILL.md. Move variant-specific details into separate reference files.

## Anatomy of a Skill

### SKILL.md (required)

- **Frontmatter** (YAML): Contains `name` and `description`. These are the only fields Claude reads to determine when the skill triggers—be clear and comprehensive.
- **Body** (Markdown): Instructions loaded only after the skill triggers.

### Bundled Resources (optional)

#### Scripts (`scripts/`)

Executable code for tasks requiring deterministic reliability or repeated rewriting.

- **When to include**: When the same code is rewritten repeatedly or deterministic reliability is needed
- **Example**: `scripts/rotate_pdf.py` for PDF rotation tasks
- **Benefits**: Token efficient, deterministic, may be executed without loading into context

#### References (`references/`)

Documentation loaded as needed into context to inform Claude's process.

- **When to include**: For documentation Claude should reference while working
- **Examples**: `references/schema.md` for database schemas, `references/api_docs.md` for API specs, `references/policies.md` for company policies
- **Best practice**: If files are large (>10k words), include grep search patterns in SKILL.md
- **Avoid duplication**: Information should live in either SKILL.md or references files, not both. Move detailed reference material, schemas, and examples to references files to keep SKILL.md lean.

#### Assets (`assets/`)

Files used in Claude's output, not loaded into context.

- **When to include**: When the skill needs files used in the final output
- **Examples**: `assets/logo.png`, `assets/slides.pptx`, `assets/frontend-template/`

#### What to Not Include

Do NOT create extraneous documentation or auxiliary files:

- README.md, INSTALLATION_GUIDE.md, QUICK_REFERENCE.md, CHANGELOG.md, etc.

The skill should only contain information needed for an AI agent to do the job. No auxiliary context about skill creation process, setup procedures, or user-facing documentation.

## Progressive Disclosure Patterns

Keep references one level deep from SKILL.md. For files longer than 100 lines, include a table of contents at the top. See [references/output-patterns.md](references/output-patterns.md) for detailed examples of the following patterns:

- **Pattern 1: High-level guide with references** — SKILL.md contains a quick start; Claude loads detailed reference files (e.g., FORMS.md, REFERENCE.md) only when needed.
- **Pattern 2: Domain-specific organization** — SKILL.md provides overview and navigation; domain files (e.g., `reference/finance.md`, `reference/sales.md`) are loaded per-query.
- **Pattern 3: Conditional details** — SKILL.md covers the common path; edge-case details live in dedicated files (e.g., REDLINING.md for tracked changes).

## Skill Creation Process

1. Understand the skill with concrete examples
2. Plan reusable skill contents (scripts, references, assets)
3. Initialize the skill (run init_skill.py)
4. Edit the skill (implement resources and write SKILL.md)
5. Package the skill (run package_skill.py)
6. Iterate based on real usage

Follow these steps in order, skipping only if there is a clear reason why they are not applicable.

### Step 1: Understanding the Skill with Concrete Examples

Skip this step only when the skill's usage patterns are already clearly understood. It remains valuable even when working with an existing skill.

Clearly understand concrete examples of how the skill will be used. For example, when building an image-editor skill, relevant questions include:

- "What functionality should the image-editor skill support? Editing, rotating, anything else?"
- "Can you give some examples of how this skill would be used?"
- "What would a user say that should trigger this skill?"

Avoid asking too many questions in a single message. Start with the most important and follow up as needed.

Conclude this step when there is a clear sense of the functionality the skill should support.

### Step 2: Planning the Reusable Skill Contents

Analyze each concrete example by:

1. Considering how to execute on the example from scratch
2. Identifying what scripts, references, and assets would help when executing these workflows repeatedly

Example: When building a `pdf-editor` skill for "Help me rotate this PDF":
1. Rotating a PDF requires re-writing the same code each time
2. A `scripts/rotate_pdf.py` script would be helpful

Example: When building a `frontend-webapp-builder` skill for "Build me a todo app":
1. Writing a frontend webapp requires the same boilerplate HTML/React each time
2. An `assets/hello-world/` template would be helpful

Example: When building a `big-query` skill for "How many users logged in today?":
1. Querying BigQuery requires re-discovering table schemas each time
2. A `references/schema.md` file documenting schemas would be helpful

### Step 3: Initializing the Skill

Skip this step only if the skill already exists and iteration or packaging is needed.

When creating a new skill from scratch, always run the `init_skill.py` script:

```bash
scripts/init_skill.py <skill-name> --path <output-directory>
```

The script:

- Creates the skill directory at the specified path
- Generates a SKILL.md template with proper frontmatter and TODO placeholders
- Creates example resource directories: `scripts/`, `references/`, and `assets/`
- Adds example files in each directory that can be customized or deleted

### Step 4: Edit the Skill

The skill is being created for another instance of Claude to use. Include information that would be beneficial and non-obvious to Claude.

#### Learn Proven Design Patterns

- **Multi-step processes**: See references/workflows.md for sequential workflows and conditional logic
- **Specific output formats or quality standards**: See references/output-patterns.md for template and example patterns

#### Start with Reusable Skill Contents

Implement the reusable resources identified above: `scripts/`, `references/`, and `assets/` files. Note that this step may require user input (e.g., brand assets or documentation to include).

Added scripts must be tested by actually running them to ensure there are no bugs and that output matches expectations. If there are many similar scripts, only a representative sample needs to be tested.

Delete any example files and directories not needed for the skill.

#### Update SKILL.md

**Writing Guidelines:** Always use imperative/infinitive form.

##### Frontmatter

Write the YAML frontmatter with `name` and `description`:

- `name`: The skill name
- `description`: The primary triggering mechanism for the skill.
  - Include both what the skill does and specific triggers/contexts for when to use it.
  - Include all "when to use" information here—not in the body. The body is only loaded after triggering, so "When to Use This Skill" sections in the body are not helpful to Claude.
  - Example for a `docx` skill: "Comprehensive document creation, editing, and analysis with support for tracked changes, comments, formatting preservation, and text extraction. Use when Claude needs to work with professional documents (.docx files) for: (1) Creating new documents, (2) Modifying or editing content, (3) Working with tracked changes, (4) Adding comments, or any other document tasks"

Do not include any other fields in YAML frontmatter.

##### Body

Write instructions for using the skill and its bundled resources.

### Step 5: Packaging a Skill

Once development is complete, package the skill into a distributable .skill file:

```bash
scripts/package_skill.py <path/to/skill-folder>
```

Optional output directory specification:

```bash
scripts/package_skill.py <path/to/skill-folder> ./dist
```

The packaging script will:

1. **Validate** the skill automatically, checking:
   - YAML frontmatter format and required fields
   - Skill naming conventions and directory structure
   - Description completeness and quality
   - File organization and resource references

2. **Package** the skill if validation passes, creating a .skill file (e.g., `my-skill.skill`) that includes all files and maintains proper directory structure. The .skill file is a zip file with a .skill extension.

If validation fails, the script reports errors and exits without creating a package. Fix any validation errors and run the packaging command again.

### Step 6: Iterate

After testing the skill, users may request improvements.

**Iteration workflow:**

1. Use the skill on real tasks
2. Notice struggles or inefficiencies
3. Identify how SKILL.md or bundled resources should be updated
4. Implement changes and test again
