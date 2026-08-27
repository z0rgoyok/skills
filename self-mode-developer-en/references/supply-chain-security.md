# Supply-chain security

Read this before downloading, installing, or first running an external dependency, CLI, remote script, binary artifact, container image, or Git dependency.

## Existing supply path

- Use components already declared by the project and pinned by its lockfile or another reproducible contract.
- Install already-declared dependencies with the project's standard lockfile-based command.

## New external component

1. Stop before downloading, installing, or executing the missing component.
2. Ask the user how it should be introduced and offer project-appropriate options.
3. For each option, state the source, version-pinning method, integrity check, and changes to the project or system.
4. Continue after the user selects or explicitly authorizes the supply path.

Typically consider a dependency declared in the project manifest and lockfile, an approved system package manager, an existing reproducible environment or container, an official version-pinned artifact with a verified checksum, or an image pinned to an immutable digest.

## Controlled fork

- **Recommended path for a Git-sourced component:** use a fork controlled by the user or an approved organization and pin the supply path to a reviewed commit.
- If no trusted fork exists, offer to create one as the first option. Before creating it, obtain explicit authorization and confirm the hosting service, owner or organization, visibility, and repository name.
- After creation, use the fork as the supply source and obtain separate authorization before synchronizing it with upstream.

## Implicit download and execution

- Do not use mechanisms that fetch and execute a missing external component from a package or container registry, Git repository, or URL in one invocation: `npx`, `npm exec`, `pnpm dlx`, `yarn dlx`, `bunx`, `uvx`, `pipx run`, `go run module@version`, `docker run` or `podman run` with a missing image, `curl … | sh`, and equivalents.
- Apply the same rule across ecosystems even when the mechanism calls the operation `run`, `exec`, `dlx`, `x`, bootstrap, or installer.
