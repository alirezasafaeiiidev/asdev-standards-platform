# Platform Adoption Dashboard

- Generated at: 2026-02-10T13:48:58Z
## Level 0 Adoption (from divergence report)

| Repository | Aligned | Diverged | Missing | Opted-out |
|---|---:|---:|---:|---:|

## Level 0 Trend (Current vs Previous Snapshot)

| Status | Previous | Current | Delta |
|---|---:|---:|---:|
| aligned | 1 | 0 | -1 |
| diverged | 0 | 0 | 0 |
| missing | 0 | 0 | 0 |
| opted_out | 0 | 0 | 0 |

## Combined Report Trend (Current vs Previous Snapshot)

| Status | Previous | Current | Delta |
|---|---:|---:|---:|
| aligned | 23 | 0 | -23 |
| diverged | 0 | 0 | 0 |
| missing | 2 | 0 | -2 |
| opted_out | 1 | 0 | -1 |
| clone_failed | 2 | 0 | -2 |
| unknown_template | 0 | 0 | 0 |
| unknown | 0 | 0 | 0 |

## Combined Reliability (clone_failed)

| Metric | Previous | Current | Delta |
|---|---:|---:|---:|
| clone_failed rows | 2 | 0 | -2 |

### clone_failed Trend by Run

| Run | clone_failed rows |
|---|---:|
| 20260209T100000Z | 2 |
| 20260210T134011Z | 2 |
| current | 0 |
| previous | 2 |

### unknown_template Trend by Run

| Run | unknown_template rows |
|---|---:|
| 20260209T100000Z | 1 |
| 20260210T134011Z | 0 |
| current | 0 |
| previous | 0 |

### clone_failed by Repository

| Repository | Previous | Current | Delta |
|---|---:|---:|---:|
| alirezasafaeiiidev/go-level1-pilot | 1 | 0 | -1 |
| alirezasafaeiiidev/python-level1-pilot | 1 | 0 | -1 |

## Transient Error Fingerprints (Combined)

| Fingerprint | Previous | Current | Delta |
|---|---:|---:|---:|
| auth_or_access | 2 | 0 | -2 |

## Top Fingerprint Deltas (Current Run)

### Top Positive Deltas

| Fingerprint | Delta |
|---|---:|
| none | 0 |

### Top Negative Deltas

| Fingerprint | Delta |
|---|---:|
| auth_or_access | -2 |

## Fingerprint Delta History (Recent Runs)

| Run | Fingerprint | Delta |
|---|---|---:|
| 20260209T100000Z | auth_or_access | 3 |
| 20260209T100000Z | timeout | 5 |
| 20260209T100000Z | tls_error | 2 |
| 20260210T134011Z | auth_or_access | 3 |
| 20260210T134011Z | timeout | -1 |
| 20260210T134011Z | tls_error | 2 |
| current | auth_or_access | -2 |
| previous | auth_or_access | 3 |
| previous | timeout | -1 |
| previous | tls_error | 2 |

## auth_or_access Trend by Run

| Run | auth_or_access count |
|---|---:|
| 20260209T100000Z | 3 |
| 20260210T134011Z | 4 |
| current | 0 |
| previous | 4 |

## timeout Trend by Run

| Run | timeout count |
|---|---:|
| 20260209T100000Z | 5 |
| 20260210T134011Z | 1 |
| current | 0 |
| previous | 1 |

## Combined Report Delta by Repo

| Repository | Previous Non-aligned | Current Non-aligned | Delta |
|---|---:|---:|---:|
| alirezasafaeiiidev/go-level1-pilot | 1 | 0 | -1 |
| alirezasafaeiiidev/my_portfolio | 1 | 0 | -1 |
| alirezasafaeiiidev/patreon_iran | 1 | 0 | -1 |
| alirezasafaeiiidev/persian_tools | 1 | 0 | -1 |
| alirezasafaeiiidev/python-level1-pilot | 1 | 0 | -1 |

## Level 1 Rollout Targets

| Repository | Level 1 Templates | Target File |
|---|---|---|
| alirezasafaeiiidev/go-level1-pilot | go-level1-ci | sync/targets.level1.go.yaml |
| alirezasafaeiiidev/patreon_iran | js-ts-level1-ci | sync/targets.level1.patreon.yaml |
| alirezasafaeiiidev/python-level1-pilot | python-level1-ci | sync/targets.level1.python.yaml |
| alirezasafaeiiidev/my_portfolio | js-ts-level1-ci | sync/targets.level1.yaml |
| alirezasafaeiiidev/persian_tools | js-ts-level1-ci | sync/targets.level1.yaml |
| alirezasafaeiiidev/patreon_iran | js-ts-level1-ci | sync/targets.level1.yaml |

## Notes

- Level 0 metrics are derived from `sync/divergence-report.csv`.
- Level 1 section reflects configured rollout intent from `sync/targets.level1*.yaml`.
