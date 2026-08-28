# Changelog

## [0.2.0](https://github.com/OctopusDeploy/create-release-buildkite-plugin/compare/v0.1.1...v0.2.0) (2026-08-28)


### ⚠ BREAKING CHANGES

* `api_key` now takes the API key itself rather than the name of an environment variable to eval. `what_if`, `packages_folder` and `package_prerelease` are rejected, because the octopus CLI has no equivalent and silently ignoring them would change what a build does. config_file, log_level, timeout, proxy, proxy_username, proxy_password and ignore_ssl_errors warn and are ignored. OCTOPUS_CLI_SERVER and OCTOPUS_CLI_API_KEY are no longer read.

### Features

* migrate from the retired octo CLI to the octopus CLI ([a6688fe](https://github.com/OctopusDeploy/create-release-buildkite-plugin/commit/a6688fe657c5fbb0c33e2f65618a364572fb5fee))


### Bug Fixes

* correct version references in migration notes ([1dc2191](https://github.com/OctopusDeploy/create-release-buildkite-plugin/commit/1dc2191c46b0063b56c1cdbf898ac4adf44f20f6))

### [0.1.1](https://github.com/OctopusDeploy/create-release-buildkite-plugin/compare/v0.1.0...v0.1.1) (2022-02-21)


### Bug Fixes

* allow users to specify custom environment variable to override default API Key environment variable ([#5](https://github.com/OctopusDeploy/create-release-buildkite-plugin/issues/5)) ([a37a305](https://github.com/OctopusDeploy/create-release-buildkite-plugin/commit/a37a305f7d241ef6ebca4e289b4634694150cffe))
