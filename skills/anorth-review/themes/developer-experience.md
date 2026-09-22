# CI Reproducibility Locally

Scope: load when a diff touches CI workflow configuration, build pipelines, or verification/lint/codegen steps.

- Don't let build, generation, or verification logic live only inside CI configuration. Put the actual commands in a developer-invocable script or build target (e.g. a `Makefile` target or checked-in script) and have CI call that target.
- The test: a contributor should be able to run the same check locally with one command and get the same result CI does. Flag steps that can only be exercised by pushing a commit.
