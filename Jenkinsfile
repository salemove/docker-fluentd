import org.jenkinsci.plugins.pipeline.github.trigger.IssueCommentCause

@Library('pipeline-lib') _
@Library('cve-monitor') __

def MAIN_BRANCH = 'master'
def DOCKER_PROJECT_NAME = 'salemove/docker-fluentd'
def DOCKER_REGISTRY_URL = 'https://registry.hub.docker.com'
def DOCKER_REGISTRY_CREDENTIALS_ID = '6992a9de-fab7-4932-9907-3aba4a70c4c0'

def FLUENTD_VERSION = '1.4.2'

properties([
    pipelineTriggers([issueCommentTrigger('!build')])
])
def isForcePublish = !!currentBuild.rawBuild.getCause(IssueCommentCause)

withResultReporting(slackChannel: '#tm-inf') {
  inDockerAgent(containers: [imageScanner.container()]) {
    checkout(scm)
    def shortCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
    def version = "${FLUENTD_VERSION}-${shortCommit}"
    def image
    stage('Build docker image') {
      ansiColor('xterm') {
        image = docker.build("${DOCKER_PROJECT_NAME}:${version}", "--build-arg FLUENTD_VERSION=${FLUENTD_VERSION} .")
      }
    }
    stage('Scan docker image') {
      imageScanner.scan(image)
    }

    stage('Publish docker image') {
      docker.withRegistry(DOCKER_REGISTRY_URL, DOCKER_REGISTRY_CREDENTIALS_ID) {
        if (BRANCH_NAME == MAIN_BRANCH || isForcePublish) {
          echo("Publishing docker image ${image.imageName()} with tag ${version} and latest")
          image.push("${version}")

          if (isForcePublish) {
            pullRequest.comment("Built and published `${version}`")
          } else {
            image.push("latest")
          }
        } else {
          echo("${BRANCH_NAME} is not the master branch. Not publishing the docker image.")
        }
      }
    }
  }
}
