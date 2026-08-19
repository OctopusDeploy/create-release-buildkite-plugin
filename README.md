# Create Release Buildkite Plugin

![image](https://user-images.githubusercontent.com/71493/153728059-fd0408fb-35f8-422b-a951-34f9fdef5876.png)

This is a [Buildkite](https://buildkite.com/) plugin to create a release in [Octopus Deploy](https://octopus.com/).

**This plugin requires the [`octopus` CLI](https://octopus.com/docs/octopus-rest-api/cli) to be installed on the Buildkite agent.** Earlier versions used the retired `octo` CLI — see [Migrating from 0.1.x](#migrating-from-01x).

## Releases in Octopus Deploy

A release is a snapshot of the deployment process and the associated assets (packages, scripts, variables) as they existed when the release was created. The release is given a version number, and you can deploy that release as many times as you need to, even if parts of the deployment process have changed since the release was created (those changes will be included in future releases but not in this version).

When you deploy the release, you are executing the deployment process with all the associated details, as they existed when the release was created.

More information about releases in Octopus Deploy:

- [Releases](https://octopus.com/docs/releases)
- [`octopus release create`](https://octopus.com/docs/octopus-rest-api/cli/octopus-release-create)

## Authentication

The recommended way to authenticate is the [octopus-login plugin](https://github.com/OctopusDeploy/octopus-login-buildkite-plugin), which uses OpenID Connect. No API key is stored in your pipeline, and the token it issues lasts one hour:

```yml
steps:
  - label: ":octopus-deploy: Create a release in Octopus Deploy"
    plugins:
      - OctopusDeploy/octopus-login#v1.0.0:
          server: "https://my.octopus.app"
          service_account_id: "d5de4670-4678-4c08-9479-09555cd6ccbb"
      - OctopusDeploy/create-release#v0.1.1:
          project: "HelloWorld"
```

Otherwise set `server` and `api_key` on this plugin, as in the examples below, and store the key using [Buildkite's guidance for pipeline secrets](https://buildkite.com/docs/pipelines/secrets).

Credentials are read from the same environment variables as the `octopus` CLI: `OCTOPUS_URL`, plus either `OCTOPUS_ACCESS_TOKEN` or `OCTOPUS_API_KEY`. `OCTOPUS_SPACE` is also honoured.

## Examples

Incorporate the following step in your `pipeline.yml` to create a release in Octopus Deploy:

### Basic examples

**Using version template configured on the project**

```yml
steps:
  - label: ":octopus-deploy: Create a release in Octopus Deploy"
    plugins:
      - OctopusDeploy/create-release#v0.1.1:
          api_key: "${MY_OCTOPUS_API_KEY}"
          project: "HelloWorld"
          server: "${MY_OCTOPUS_SERVER}"
```

**Specifying the release version to use**

```yml
steps:
  - label: ":octopus-deploy: Create a release in Octopus Deploy"
    plugins:
      - OctopusDeploy/create-release#v0.1.1:
          api_key: "${MY_OCTOPUS_API_KEY}"
          project: "HelloWorld"
          release_number: "1.0.3"
          server: "${MY_OCTOPUS_SERVER}"
```

### Version controlled projects

`git_ref` and `git_commit` are only valid for version controlled (config-as-code) projects. Supplying them for a regular project fails with `the GitCommit and GitRef arguments are not supported for this command`.

```yml
steps:
  - label: ":octopus-deploy: Create a release in Octopus Deploy"
    plugins:
      - OctopusDeploy/create-release#v0.1.1:
          api_key: "${MY_OCTOPUS_API_KEY}"
          git_ref: "main"
          project: "HelloWorld"
          release_number: "1.0.3"
          server: "${MY_OCTOPUS_SERVER}"
```

### Specifying Package Version

**Package version to use for all packages**

```yml
steps:
  - label: ":octopus-deploy: Create a release in Octopus Deploy"
    plugins:
      - OctopusDeploy/create-release#v0.1.1:
          api_key: "${MY_OCTOPUS_API_KEY}"
          default_package_version: "1.0.1"
          project: "HelloWorld"
          release_number: "1.0.3"
          server: "${MY_OCTOPUS_SERVER}"
```

**Multiple steps with a single package**

```yml
steps:
  - label: ":octopus-deploy: Create a release in Octopus Deploy"
    plugins:
      - OctopusDeploy/create-release#v0.1.1:
          api_key: "${MY_OCTOPUS_API_KEY}"
          packages:
            - "StepA:1.0.1"
            - "StepB:1.0.2"
          project: "HelloWorld"
          release_number: "1.0.3"
          server: "${MY_OCTOPUS_SERVER}"
```

**Step with multiple packages**

```yml
steps:
  - label: ":octopus-deploy: Create a release in Octopus Deploy"
    plugins:
      - OctopusDeploy/create-release#v0.1.1:
          api_key: "${MY_OCTOPUS_API_KEY}"
          packages:
            - "StepA:Acme.Web:1.0.0"
            - "StepA:Acme.Data:2.0.0"
          project: "HelloWorld"
          release_number: "1.0.3"
          server: "${MY_OCTOPUS_SERVER}"
```

## 📥 Inputs

**The following inputs are required:**

| Name      | Description                                                 |
| :-------- | :---------------------------------------------------------- |
| `project` | The name or ID of the project associated with this release. |

**The following inputs are optional:**

| Name                      | Description                                                                                                                                                                            | Default |
| :------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-----: |
|  `api_key`                | The Octopus API key itself, not the name of a variable holding it (changed in 0.2.0). Prefer the octopus-login plugin, which stores no secret.                                                                                                                                                                    | |
| `channel`                 | The name or ID of the channel to use for the new release. If omitted, the best channel will be selected.                                                                                                                                                                                                       |         |
| `debug`                   | Enable debug logging.                                                                                                                                                                                                                                                                                          | `false` |
| `default_package_version` | Use the default version number of all packages for this release.                                                                                                                                                                                                                                               | `false` |
|  `git_commit`             | Git commit to use when creating the release. Version controlled projects only.                                                                                                                                                                                                                                 |         |
|  `git_ref`                | Git reference to use when creating the release. Version controlled projects only.                                                                                                                                                                                                                              |         |
| `ignore_channel_rules`    | Create the release ignoring any version rules specified by the channel.                                                                                                                                                                                                                                        | `false` |
| `ignore_existing`         | Ignore existing releases if present in Octopus Deploy with the matching version number.                                                                                                                                                                                                                        | `false` |
|  `output_format`               | The output format of the octopus CLI; one of `basic`, `json`, or `table`.                                                                                                                                                                                                                                      |         |
| `packages`                | A single version number or multi-line list of version numbers to use for a package in the release (format: `StepName:Version`, `PackageID:Version`, or `StepName:PackageName:Version`).                                                                                                                        |         |
| `release_notes`           | The release notes associated with the new release (Markdown is supported).                                                                                                                                                                                                                                     |         |
| `release_notes_file`      | Path to a file that contains release notes for the new release. Supports Markdown files.                                                                                                                                                                                                                       |         |
| `release_number`          | The number for the new release.                                                                                                                                                                                                                                                                                |         |
|  `server`                 | The base URL hosting Octopus Deploy. Not needed when using the octopus-login plugin.                                                                                                                                                                                                                           |         |
| `space`                   | The name or ID of a space within which this command will be executed. If omitted, the default space will be used.                                                                                                                                                                                              |         |

## Migrating from 0.1.x

0.1.x used the retired `octo` CLI. This version uses `octopus`, which changes three things.

**`api_key` now takes the key, not a variable name.** 0.1.x took the *name* of an environment variable and `eval`'d it:

```diff
- api_key: "MY_OCTOPUS_API_KEY"
+ api_key: "${MY_OCTOPUS_API_KEY}"
```

**`OCTOPUS_CLI_SERVER` and `OCTOPUS_CLI_API_KEY` are no longer read.** The `octopus` CLI uses `OCTOPUS_URL` and `OCTOPUS_API_KEY`.

**Some options are gone**, as the `octopus` CLI has no equivalent. `what_if`, `packages_folder` and `package_prerelease` are **rejected with an error**, because silently ignoring them would change what your build does. `config_file`, `log_level`, `timeout`, `proxy`, `proxy_username`, `proxy_password` and `ignore_ssl_errors` are ignored with a warning.

## Developing

To run the tests:

```shell
docker compose run --rm tests
```

To lint the plugin:

```shell
docker compose run --rm lint
```

## 🤝 Contributions

Contributions are welcome! :heart: Please read our [Contributing Guide](CONTRIBUTING.md) for information about how to get involved in this project.
