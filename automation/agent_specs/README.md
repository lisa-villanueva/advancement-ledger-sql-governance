Overview
This directory serves as the Control Plane for all AI-augmented workflows within this project. As a Governed AI Strategist, I utilize these assets to bridge the gap between raw data diagnostics and autonomous operational support, ensuring that all AI insertions are auditable, reversible, and anchored in business ROI.

Directory Structure
agent_specs/: Contains formal architectural specifications for AI Agents. Each spec defines the agent's persona, "Anti-AI Hype" guardrails, and mandatory Human-in-the-loop (HITL) triggers.

prompt_library/: (Coming Soon) Version-controlled system prompts designed to execute specific workflow tasks, such as ticket triage or executive summarization.

workflow_blueprints/: (Coming Soon) Logic maps for integrating SQL-backed diagnostics with automation platforms like Power Automate or custom Gems.

Governed AI Principles
Every asset in this folder adheres to the following Disciplined AI Execution standards:

Baseline Requirement: No automation is deployed without a 30-day performance baseline established in the sql/03_metrics/ layer.

Grain Discipline: Agents are strictly prohibited from deriving logic from raw event logs; all analysis must utilize the case-level v_incidents_latest view.

Socratic Scaffolding: Educational agents (Tutors) are designed to provide conceptual scaffolding rather than direct answers to build institutional knowledge.

Integrity Checks: Automated outputs must include self-reconciliation unit tests to identify and flag hallucinated or statistically insignificant data.