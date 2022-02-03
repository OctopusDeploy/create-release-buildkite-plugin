#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

# Uncomment to enable stub debug output:
# export DOCKER_STUB_DEBUG=/dev/tty

@test "Running create release command using latest octo docker image" {
    export OCTOPUS_CLI_SERVER="https://octopus.example"
    export OCTOPUS_CLI_API_KEY="API-xxxxxx"
    export BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT="Test project"

    stub docker "--env OCTOPUS_CLI_SERVER --env OCTOPUS_CLI_API_KEY run OctopusDeploy/octo:latest sh -e -c create-release --project \'Test project\' : echo ran command in docker"

    run $PWD/hooks/command

    assert_output --partial "ran command in docker"
    assert_success

    unstub docker
    unset BUILDKITE_PLUGIN_CREATE_RELEASE_PROJECT
}