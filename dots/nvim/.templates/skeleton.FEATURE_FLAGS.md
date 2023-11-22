# ${1} Feature Flags

## Current list of feature flags

Flags come in three types:

- **Default change**: The default behavior of an API has been changed in order to improve its ergonomics. The old behavior can still be achieved, but requires source changes.
- **Fix/deprecation**: The old behavior was incorrect or not recommended for new users. The only way to keep it is to not set this flag.
- **Config**: Configurable behavior that we recommend you turn on.

<!-- BEGIN table -->

| Flag | Summary | Since | Type |
| ----- | ----- | ----- | ----- |
| [@example-project/core:newStyleStackSynthesis](#example-projectcorenewstylestacksynthesis) | Switch to new stack synthesis method which enables CI/CD | 2.0.0 | (fix) |
| [@example-project/core:target-partitions](#example-projectcoretarget-partitions) | What regions to include in lookup tables of environment agnostic stacks | 2.4.0 | (config) |
| [@example-project-containers/ecs-service-extensions:enableDefaultLogDriver](#example-project-containersecs-service-extensionsenabledefaultlogdriver) | ECS extensions will automatically add an `logs` driver if no logging is specified | 2.8.0 | (default) |

<!-- END table -->

## Currently recommended cdk.json

The following json shows the current recommended set of flags, as `cdk init` would generate it for new projects.

<!-- BEGIN json -->
```json
{
  "context": {
    "@example-project/core:target-partitions": [
      "potato",
      "potato-cn"
    ],
  }
}
```
<!-- END json -->

## Feature flag details

Here are more details about each of the flags:

<!-- BEGIN details -->
### @example-project/core:newStyleStackSynthesis

*Switch to new stack synthesis method which enables CI/CD* (fix)

If this flag is specified, all `Stack`s will use the `DefaultStackSynthesizer` by
default. If it is not set, they will use the `LegacyStackSynthesizer`.


| Since | Default | Recommended |
| ----- | ----- | ----- |
| 1.137.0 | `false` | `["potato","potato-cn"]` |
| 2.4.0 | `false` | `["potato","potato-cn"]` |
