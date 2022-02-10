# Create Release Buildkite Plugin

This is a Buildkite plugin to create a release in [Octopus Deploy](https://octopus.com/). 

**This plugin requires [Octopus CLI](https://octopus.com/downloads/octopuscli) to be installed on the Buildkite agent.**

## Releases in Octopus Deploy

A release is a snapshot of the deployment process and the associated assets (packages, scripts, variables) as they existed when the release was created. The release is given a version number, and you can deploy that release as many times as you need to, even if parts of the deployment process have changed since the release was created (those changes will be included in future releases but not in this version).

When you deploy the release, you are executing the deployment process with all the associated details, as they existed when the release was created.

More information about releases in Octopus Deploy:

- [Releases](https://octopus.com/docs/releases)
- [Create release](https://octopus.com/docs/octopus-rest-api/octopus-cli/create-release)

## Examples

Incorporate the following step in your `pipeline.yml` to create a release in Octopus Deploy:

**NOTE: These examples configure the Octopus server and API Key environment variables in the `pipeline.yml` file, this is NOT recommended and these should be configured as environment variables on the Buildkite agent.**

### Basic examples

**Using version template configured on the project**

```yml
steps:
  - label: Create a release in Octopus Deploy 🐙
  - plugins: 
    - OctopusDeploy/create-release#v0.0.1
      api_key: "${MY_OCTOPUS_API_KEY}"
      project: 'HelloWorld'
      server: "${MY_OCTOPUS_SERVER}"
```

**Specifying the release version to use**

```yml
steps:
  - label: Create a release in Octopus Deploy 🐙
  - plugins: 
    - OctopusDeploy/create-release#v0.0.1
      api_key: "${MY_OCTOPUS_API_KEY}"
      project: 'HelloWorld'
      release_number: '1.0.3'
      server: "${MY_OCTOPUS_SERVER}"
```

### Version controlled projects

```yml
steps:
  - label: Create a release in Octopus Deploy 🐙
  - plugins: 
    - OctopusDeploy/create-release#v0.0.1
      api_key: "${MY_OCTOPUS_API_KEY}"
      git_ref: 'main'
      project: 'HelloWorld'
      release_number: '1.0.3'
      server: "${MY_OCTOPUS_SERVER}"
```

### Specifying Package Version

**Package version to use for all packages**

```yml
steps:
  - label: Create a release in Octopus Deploy 🐙
  - plugins: 
    - OctopusDeploy/create-release#v0.0.1
      api_key: "${MY_OCTOPUS_API_KEY}"
      default_package_version: '1.0.1'
      project: 'HelloWorld'
      release_number: '1.0.3'
      server: "${MY_OCTOPUS_SERVER}"
```

**Multiple steps with a single package**

```yml
steps:
  - label: Create a release in Octopus Deploy 🐙
  - plugins: 
    - OctopusDeploy/create-release#v0.0.1
      api_key: "${MY_OCTOPUS_API_KEY}"
      packages:
        - 'StepA:1.0.1'
        - 'StepB:1.0.2'
      project: 'HelloWorld'
      release_number: '1.0.3'
      server: "${MY_OCTOPUS_SERVER}"
```

**Step with multiple packages**

```yml
steps:
  - label: Create a release in Octopus Deploy 🐙
  - plugins: 
    - OctopusDeploy/create-release#v0.0.1
      api_key: "${MY_OCTOPUS_API_KEY}"
      packages:
        - 'StepA:Acme.Web:1.0.0'
        - 'StepA:Acme.Data:2.0.0'
      project: 'HelloWorld'
      release_number: '1.0.3'
      server: "${MY_OCTOPUS_SERVER}"
```

**Source package version from a folder containing the packages used in a project**

```yml
steps:
  - label: Create a release in Octopus Deploy 🐙
  - plugins: 
    - OctopusDeploy/create-release#v0.0.1
      api_key: "${MY_OCTOPUS_API_KEY}"
      packages_folder: 'packages'
      project: 'HelloWorld'
      release_number: '1.0.3'
      server: "${MY_OCTOPUS_SERVER}"
```

## 📥 Inputs

**The following inputs are required:**

| Name                           | Description                                                                                                                                                                                                                                                                       |
| :----------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `project`                      | The name or ID of the project associated with this release.                                                                                                                                                                                                                       |

**The following inputs are optional:**

| Name                           | Description                                                                                                                                                                                                                                                          |  Default   |
| :----------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------: |
| `api_key`                      | The API key used to access Octopus Deploy. You must provide an API key or set the `OCTOPUS_CLI_API_KEY` environment variable. If the guest account is enabled, a key of `API-GUEST` may be used. It is strongly recommended that this value retrieved from an environment variable.
| `channel`                      | The name or ID of the channel to use for the new release. If omitted, the best channel will be selected.                                                                                                                                                             |            |
| `config_file`                  | The path to a configuration file of default values with one `key=value` per line.                                                                                                                                                                                    |            |
| `debug`                        | Enable debug logging.                                                                                                                                                                                                                                                |  `false`   |
| `default_package_version`      | Use the default version number of all packages for this release.                                                                                                                                                                                                     |  `false`   |
| `git_commit`                   | Git commit to use when creating the release. Use in conjunction with the `gitRef` parameter to select any previous commit.                                                                                                                                           |            |
| `git_ref`                      | Git reference to use when creating the release.                                                                                                                                                                                                                      |            |
| `ignore_channel_rules`         | Create the release ignoring any version rules specified by the channel.                                                                                                                                                                                              |  `false`   |
| `ignore_existing`              | Ignore existing releases if present in Octopus Deploy with the matching version number.                                                                                                                                                                              |  `false`   |
| `ignore_ssl_errors`            | Ignore certificate errors when communicating with Octopus Deploy. Warning: enabling this option creates a security vulnerability.                                                                                                                                    |  `false`   |
| `log_level`                    | The log level; valid options are `verbose`, `debug`, `information`, `warning`, `error`, and `fatal`.                                                                                                                                                                 |  `debug`   |
| `packages`                     | A single version number or multi-line list of version numbers to use for a package in the release (format: `StepName:Version`, `PackageID:Version`, or `StepName:PackageName:Version`).                                                                                                         |            |
| `package_prerelease`           | Pre-release for latest version of all packages to use for this release.                                                                                                                                                                                              |            |
| `package_version`              | The version number of all packages to use for this release.                                                                                                                                                                                                          |            |
| `packages_folder`              | The folder designated for containing packages.                                                                                                                                                                                                                       |            |
| `proxy`                        | The URL of a proxy to use (i.e. `https://proxy.example.com`).                                                                                                                                                                                                        |            |
| `proxy_password`               | The password used to connect to a proxy. It is strongly recommended following the guidelines in the Buildkite [Managing Pipeline Secrets docs](https://buildkite.com/docs/pipelines/secrets). If `proxy_username` and `proxy_password` are omitted and `proxy` is specified, the default credentials are used.                                    |            |
| `proxy_username`               | The username used to connect to a proxy. It is strongly recommended following the guidelines in the Buildkite [Managing Pipeline Secrets docs](https://buildkite.com/docs/pipelines/secrets).                                                                                                                                                     |            |
| `release_notes`                | The release notes associated with the new release (Markdown is supported).                                                                                                                                                                                           |            |
| `release_notes_file`           | Path to a file that contains release notes for the new release. Supports Markdown files.                                                                                                                                                                             |            |
| `release_number`               | The number for the new release.                                                                                                                                                                                                                                      |            |
| `server`                       | The base URL hosting Octopus Deploy (i.e. "https://octopus.example.com/"). It is recommended to retrieve this value from the `OCTOPUS_CLI_SERVER` environment variable.                                                                                                                                                    |            |
| `space`                        | The name or ID of a space within which this command will be executed. If omitted, the default space will be used.                                                                                                                                                    |            |
| `timeout`                      | A timeout value for network operations (in seconds).                                                                                                                                                                                                                 |   `600`    |
| `what_if`                      | Perform a dry run; do not create or deploy a release.                                                                                                                                                                                                                |  `false`   |

## Developing

To run the tests:

```shell
docker-compose run --rm tests
```

To lint the plugin:

```shell
docker-compose run --rm lint
```
