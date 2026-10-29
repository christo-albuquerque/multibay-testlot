# multibay-testlot

A tiny, real JavaScript library ("Grain Kit") whose GitHub Actions runs feed the
[DirectedByMultiBay](https://github.com/christo-albuquerque/directed-by-multibay) factory on Kepler-22b.
Open the factory at https://christo-albuquerque.github.io/directed-by-multibay/ and every run here shows up as a
product on the conveyor belt.

## What's in it

| Path | What it does |
| --- | --- |
| `src/index.js` | `mixGrains`, `packBoxes`, `slug`: small pure functions |
| `test/` | Real tests (`node --test`, no test framework needed) |
| `scripts/build.mjs` | A real build: copies `src/` to `dist/` and writes a manifest |
| `eslint.config.js` | A real lint step |

```bash
npm ci
npm run lint && npm run build && npm test
```

## Workflows

| Workflow | Triggers | Factory stages it exercises |
| --- | --- | --- |
| **CI** (`ci.yml`) | every push and pull request | install (cached) → lint → build → test on Node 20 and 22 |
| **Controllable pipeline** (`controllable.yml`) | manual only | all stages, on demand, with any failure you ask for |
| **Release** (`release.yml`) | manual, or pushing a `v*` tag | install → build → test → publish a real GitHub Release (rocket launch) |

The factory maps job and step names to stages, so these workflows use the names it looks for
(`Install dependencies`, `Lint`, `Build`, `Test`, `Release`/`Publish`).

### Controllable pipeline inputs

| Input | Values | Effect |
| --- | --- | --- |
| `fail_at` | `none`, `lint`, `build`, `test` | Fails at that stage on purpose: Chaos Incident at the matching machine |
| `delay_seconds` | `1`–`60` | How long each stage takes, so you can watch the product travel |
| `matrix` | `true`/`false` | Runs the test stage as two parallel lanes |
| `cancel_me` | `true`/`false` | Cancels itself mid-test: the CANCELLED stamp and trapdoor |
| `release` | `true`/`false` | Includes the (simulated) release stage; success launches the rocket |

## Demo script

You need the [GitHub CLI](https://cli.github.com/) signed in (`gh auth login`).

```powershell
./scripts/demo.ps1 success       # idle -> alarm -> belt -> rocket
./scripts/demo.ps1 fail-build    # smoke, rescue crew, credits on the TVs
./scripts/demo.ps1 fail-test
./scripts/demo.ps1 fail-lint
./scripts/demo.ps1 matrix
./scripts/demo.ps1 cancel
./scripts/demo.ps1 release       # a real tag + GitHub Release
./scripts/demo.ps1 tour          # the whole story, about five minutes
```

Bash/macOS/Linux: `scripts/demo.sh <scenario> [delay-seconds]`.
Or use the same inputs from the **Actions** tab → *Controllable pipeline* → *Run workflow*.

### A failure from a real commit

```bash
git switch -c demo/break-it
# make a test fail, e.g. change an expected value in test/index.test.js
git commit -am "Break a test on purpose" && git push -u origin demo/break-it
```

CI runs on the push, the Test job fails, and the factory shows the incident at the testing grounds.

## Notes

- Everything here is public, so GitHub Actions minutes are free.
- The factory polls the public GitHub API without a token (60 requests/hour); add a read-only token in the
  factory's **Token** button for faster updates.

MIT licensed.
