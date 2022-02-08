#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

# Uncomment to enable stub debug output:
export OCTO_STUB_DEBUG=/dev/tty

@test "Run create release for a project" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT="Test project"

    stub octo 'create-release --project \"Test project\" : echo octo command ran'

    run $PWD/hooks/command

    assert_output --partial "octo command ran"
    assert_success

    unstub octo
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT
}

@test "Run create release specifying release version" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT="Test project"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NUMBER="1.0.0"

    stub octo 'create-release --project \"Test project\" --releaseNumber \"1.0.0\" : echo octo command ran'

    run $PWD/hooks/command

    assert_output --partial "octo command ran"
    assert_success

    unstub octo
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NUMBER
}

@test "Run create release for a version controlled project" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT="Test project"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NUMBER="1.0.0"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_GIT_REF="main"

    stub octo 'create-release --gitRef \"main\" --project \"Test project\" --releaseNumber \"1.0.0\" : echo octo command ran'

    run $PWD/hooks/command

    assert_output --partial "octo command ran"
    assert_success

    unstub octo
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NUMBER
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_GIT_REF
}

@test "Run create release specifying package version to use for all packages" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT="Test project"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NUMBER="1.0.3"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_DEFAULT_PACKAGE_VERSION="1.0.1"

    stub octo 'create-release --defaultPackageVersion \"1.0.1\" --project \"Test project\" --releaseNumber \"1.0.3\" : echo octo command ran'

    run $PWD/hooks/command

    assert_output --partial "octo command ran"
    assert_success

    unstub octo
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NUMBER
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_DEFAULT_PACKAGE_VERSION
}

@test "Run create release with multiple steps with a single package" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT="Test project"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NUMBER="1.0.3"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_0="StepA:1.0.1"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_1="StepB:1.0.2"

    stub octo 'create-release --package \"StepA:1.0.1\" --package \"StepB:1.0.2\" --project \"Test project\" --releaseNumber \"1.0.3\" : echo octo command ran'

    run $PWD/hooks/command

    assert_output --partial "octo command ran"
    assert_success

    unstub octo
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NUMBER
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_0
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_1
}

@test "Run create release with a step with multiple packages" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT="Test project"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NUMBER="1.0.3"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_0="StepA:Acme.Web:1.0.0"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_1="StepA:Acme.Data:2.0.0"

    stub octo 'create-release --package \"StepA:Acme.Web:1.0.0\" --package \"StepA:Acme.Data:2.0.0\" --project \"Test project\" --releaseNumber \"1.0.3\" : echo octo command ran'

    run $PWD/hooks/command

    assert_output --partial "octo command ran"
    assert_success

    unstub octo
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT
}

@test "Run create release retrieving package versions from a folder" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT="Test project"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_RELEASE_NUMBER="1.0.3"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PACKAGES_FOLDER="packages"

    stub octo 'create-release --packagesFolder \"packages\" --project \"Test project\" --releaseNumber \"1.0.3\" : echo octo command ran'

    run $PWD/hooks/command

    assert_output --partial "octo command ran"
    assert_success

    unstub octo
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT
}