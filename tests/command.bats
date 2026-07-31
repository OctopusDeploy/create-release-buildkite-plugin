#!/usr/bin/env bats

setup() {
    # plugin-tester v4 sets BATS_PLUGIN_PATH; older images set BATS_PATH
    load "${BATS_PLUGIN_PATH:-${BATS_PATH:-}}/load.bash"

    # As the octopus-login plugin would leave them
    export OCTOPUS_URL="https://octopus.example.app"
    export OCTOPUS_ACCESS_TOKEN="octopus.access.token"

    export BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT="Test project"

    # Uncomment to enable stub debug output:
    # export OCTOPUS_STUB_DEBUG=/dev/tty
}

teardown() {
    unset OCTOPUS_URL OCTOPUS_ACCESS_TOKEN OCTOPUS_API_KEY
    for v in $(compgen -e | grep '^BUILDKITE_PLUGIN_CREATE_RELEASE_' || true); do
        unset "$v"
    done
}

@test "Run create release for a project" {
    stub octopus "release create --no-prompt --project 'Test project' : echo octopus command ran"

    run $PWD/hooks/command

    assert_output --partial "octopus command ran"
    assert_success

    unstub octopus
}

@test "release_number is passed as --version" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NUMBER="1.0.0"

    stub octopus "release create --no-prompt --project 'Test project' --version 1.0.0 : echo octopus command ran"

    run $PWD/hooks/command

    assert_output --partial "octopus command ran"
    assert_success

    unstub octopus
}

@test "Run create release for a version controlled project" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_GIT_REF="refs/heads/main"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_GIT_COMMIT="9f31820"

    stub octopus "release create --no-prompt --git-ref refs/heads/main --git-commit 9f31820 --project 'Test project' : echo octopus command ran"

    run $PWD/hooks/command

    assert_output --partial "octopus command ran"
    assert_success

    unstub octopus
}

@test "default_package_version is passed as --package-version" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_DEFAULT_PACKAGE_VERSION="1.0.1"

    stub octopus "release create --no-prompt --package-version 1.0.1 --project 'Test project' : echo octopus command ran"

    run $PWD/hooks/command

    assert_output --partial "octopus command ran"
    assert_success

    unstub octopus
}

@test "Run create release with multiple steps with a single package" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_0="StepA:1.0.1"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_1="StepB:1.0.2"

    stub octopus "release create --no-prompt --package StepA:1.0.1 --package StepB:1.0.2 --project 'Test project' : echo octopus command ran"

    run $PWD/hooks/command

    assert_output --partial "octopus command ran"
    assert_success

    unstub octopus
}

@test "Run create release with a step with multiple packages" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_0="StepA:Acme.Web:1.0.0"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_1="StepA:Acme.Data:2.0.0"

    stub octopus "release create --no-prompt --package StepA:Acme.Web:1.0.0 --package StepA:Acme.Data:2.0.0 --project 'Test project' : echo octopus command ran"

    run $PWD/hooks/command

    assert_output --partial "octopus command ran"
    assert_success

    unstub octopus
}

@test "space is passed as --space" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_SPACE="Outer Space"

    stub octopus "release create --no-prompt --project 'Test project' --space 'Outer Space' : echo octopus command ran"

    run $PWD/hooks/command

    assert_output --partial "octopus command ran"
    assert_success

    unstub octopus
}

@test "Boolean flags are only passed when true" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_IGNORE_EXISTING="true"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_IGNORE_CHANNEL_RULES="false"

    stub octopus "release create --no-prompt --ignore-existing --project 'Test project' : echo octopus command ran"

    run $PWD/hooks/command

    assert_output --partial "octopus command ran"
    assert_success

    unstub octopus
}

@test "Release notes and output format are passed through" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NOTES="Shipped it"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_OUTPUT_FORMAT="json"

    stub octopus "release create --no-prompt --output-format json --project 'Test project' --release-notes 'Shipped it' : echo octopus command ran"

    run $PWD/hooks/command

    assert_output --partial "octopus command ran"
    assert_success

    unstub octopus
}

@test "server and api_key properties are exported for the CLI" {
    unset OCTOPUS_URL OCTOPUS_ACCESS_TOKEN
    export BUILDKITE_PLUGIN_CREATE_RELEASE_SERVER="https://octopus.example"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_API_KEY="API-123"

    stub octopus "release create --no-prompt --project 'Test project' : echo url=\$OCTOPUS_URL key=\$OCTOPUS_API_KEY"

    run $PWD/hooks/command

    assert_output --partial "url=https://octopus.example key=API-123"
    assert_success

    unstub octopus
}

@test "Fails when there is no Octopus URL" {
    unset OCTOPUS_URL

    run $PWD/hooks/command

    assert_output --partial "no Octopus URL"
    assert_failure
}

@test "Fails when there are no credentials" {
    unset OCTOPUS_ACCESS_TOKEN

    run $PWD/hooks/command

    assert_output --partial "no credentials"
    assert_failure
}

@test "what_if is rejected rather than silently ignored" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_WHAT_IF="true"

    run $PWD/hooks/command

    assert_output --partial "'what_if' is not supported"
    assert_failure
}

@test "packages_folder is rejected rather than silently ignored" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_FOLDER="packages"

    run $PWD/hooks/command

    assert_output --partial "'packages_folder' is not supported"
    assert_failure
}

@test "package_prerelease is rejected rather than silently ignored" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGE_PRERELEASE="beta"

    run $PWD/hooks/command

    assert_output --partial "'package_prerelease' is not supported"
    assert_failure
}

@test "Obsolete options warn but do not fail" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_LOG_LEVEL="verbose"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_TIMEOUT="600"

    stub octopus "release create --no-prompt --project 'Test project' : echo octopus command ran"

    run $PWD/hooks/command

    assert_output --partial "'log_level' has no octopus CLI equivalent"
    assert_output --partial "'timeout' has no octopus CLI equivalent"
    assert_success

    unstub octopus
}
