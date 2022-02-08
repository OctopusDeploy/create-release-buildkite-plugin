#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

# Uncomment to enable stub debug output:
export OCTO_STUB_DEBUG=/dev/tty

@test "Running create release command" {
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT="Test project"

    stub octo "create-release --project \'Test project\' : echo octo command ran"

    run $PWD/hooks/command

    assert_output --partial "octo command ran"
    assert_success

    unstub octo
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT
}