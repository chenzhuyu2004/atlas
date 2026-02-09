# Projects

This directory is for your development projects.
This code does NOT participate in Docker image builds.
It is included in CI linting to keep code quality consistent.

Recommended structure:
- One project per subdirectory
- Add a project-level README and its own .gitignore if needed

Example:
```
projects/my-app/
  README.md
  .gitignore
  src/
```

Related docs:
- [../docs/README.md](../docs/README.md) (repository documentation index)
- [../docs/WORKSPACE.md](../docs/WORKSPACE.md) (workspace usage guide)
- [../docker/atlas/docs/RUN.md](../docker/atlas/docs/RUN.md) (runtime guide for mounted workspaces)
