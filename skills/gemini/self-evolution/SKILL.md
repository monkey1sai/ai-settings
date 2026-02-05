---
name: self-evolution
description: A meta-skill for crystallizing resolved problems and learned lessons into permanent capabilities. Use when a complex task, bug fix, or technical hurdle has just been successfully resolved and the user wants to ensure this knowledge is retained for the future.
---

# Self-Evolution

This skill defines the protocol for the agent to evolve its own capabilities by crystallizing learned lessons into permanent skills.

## The Evolution Protocol

When a significant problem is resolved, a bug is fixed, or a complex workflow is mastered, follow this 4-step protocol:

### 1. Reflection (Analyze)
*   **Context**: What was the original goal?
*   **Obstacle**: What specifically caused the difficulty or error? (Root Cause Analysis)
*   **Solution**: How was it resolved?
*   **Gap**: What knowledge or tool was missing that made this difficult?

### 2. Abstraction (Generalize)
*   Is this a one-off edge case, or a recurring pattern?
*   Can this solution be generalized into a reusable workflow, script, or checklist?
*   **Criteria for Skill Creation**:
    *   High frequency of potential recurrence.
    *   High cost of error (if it happens again, it's painful).
    *   Determinable solution (there is a clear "right way").

### 3. Crystallization (Define)
*   **Name**: Choose a clear, functional name (e.g., `debug-python-import`, `deploy-k8s-pod`).
*   **Triggers**: Define exactly when this skill should be activated.
*   **Resources**:
    *   *Scripts*: Can we automate the fix?
    *   *References*: Do we need a checklist or cheat sheet?
    *   *Assets*: Do we need a template?

### 4. Execution (Build)
Use the `skill-creator` skill to generate the new skill.

*   **If updating an existing skill**: Read it first, then append/refine.
*   **If creating a new skill**:
    1.  Initialize the skill structure.
    2.  Write the `SKILL.md` capturing the abstract workflow.
    3.  Create necessary scripts/references.

## Workflow Triggers

Activate this skill when:
1.  The user explicitly asks to "save this solution" or "learn from this".
2.  You have just recovered from a critical crash or deep debugging session.
3.  You successfully executed a complex, novel task for the first time.

## Interaction Pattern

When performing self-evolution:

1.  **Propose**: Briefly explain what you learned and propose the skill name/scope to the user.
2.  **Confirm**: Wait for user assent.
3.  **Build**: Create the skill artifacts.
4.  **Verify**: Confirm the file locations.
