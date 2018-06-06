#!/usr/bin/env groovy
podTemplate(
    label: 'build',
    containers: [
      containerTemplate(name: 'jnlp', image: 'jenkins/jnlp-slave:alpine', args: '${computer.jnlpmac} ${computer.name}'),
      containerTemplate(name: 'debian', image: 'debian:stretch-slim', ttyEnabled: true, command: '/bin/sh', workingDir: '/home/jenkins', alwaysPullImage: true)
    ],
    volumes: [
      hostPathVolume(mountPath: '/etc/localtime', hostPath: '/etc/localtime'),
      hostPathVolume(mountPath: '/etc/timezone', hostPath: '/etc/timezone'),
      hostPathVolume(mountPath: '/usr/bin/docker', hostPath: '/usr/bin/docker'),
      hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
    ],
)
{ try {} catch(err) {} finally { node('build') {
try {
  date = new Date().format('yyyy-MM-dd')
  imageName = 'faas_base'
  dockerFile = 'Dockerfile'
  stage ('checkout') { container('debian') {
    dir('faas_base') {
      git branch: "master", credentialsId: 'playgali-github-ssh', url: 'git@gitlab.com:playgali/faas_base.git'
    }
  }}
  stage ('building image (x64)') { container('debian') {
    dir('faas_base') {
      withCredentials([[$class: 'UsernamePasswordMultiBinding',
        credentialsId: 'dockerhub',
        usernameVariable: 'DOCKER_HUB_USER',
        passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
          sh """
            docker build --no-cache -t ${env.DOCKER_HUB_USER}/${imageName}:latest -f ${dockerFile} .
            docker tag ${env.DOCKER_HUB_USER}/${imageName}:latest ${env.DOCKER_HUB_USER}/${imageName}:${date}
            docker tag ${env.DOCKER_HUB_USER}/${imageName}:latest registry.gitlab.com/${env.DOCKER_HUB_USER}/${imageName}:latest
            docker tag ${env.DOCKER_HUB_USER}/${imageName}:latest registry.gitlab.com/${env.DOCKER_HUB_USER}/${imageName}:${date}
          """
      }
    }
  }}
  stage ('publishing image (x64)') { container('debian') {
    dir('galik8s') {
      withCredentials([[$class: 'UsernamePasswordMultiBinding',
        credentialsId: 'dockerhub',
        usernameVariable: 'DOCKER_HUB_USER',
        passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
          sh """
            docker login -u ${env.DOCKER_HUB_USER} -p ${env.DOCKER_HUB_PASSWORD}
            docker push ${env.DOCKER_HUB_USER}/${imageName}:latest
            docker push ${env.DOCKER_HUB_USER}/${imageName}:${date}
            docker login registry.gitlab.com -u ${env.DOCKER_HUB_USER} -p ${env.DOCKER_HUB_PASSWORD}
            docker push registry.gitlab.com/${env.DOCKER_HUB_USER}/${imageName}:latest
            docker push registry.gitlab.com/${env.DOCKER_HUB_USER}/${imageName}:${date}
          """
      }
    }
  }}
  stage ('building image (armhf)') { container('debian') {
    dir('faas_base') {
      withCredentials([[$class: 'UsernamePasswordMultiBinding',
        credentialsId: 'dockerhub',
        usernameVariable: 'DOCKER_HUB_USER',
        passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
          sh """
            docker build --no-cache -t ${env.DOCKER_HUB_USER}/${imageName}:latest-armhf -f ${dockerFile}.armhf .
            docker tag ${env.DOCKER_HUB_USER}/${imageName}:latest-armhf ${env.DOCKER_HUB_USER}/${imageName}:${date}-armhf
            docker tag ${env.DOCKER_HUB_USER}/${imageName}:latest-armhf registry.gitlab.com/${env.DOCKER_HUB_USER}/${imageName}:latest-armhf
            docker tag ${env.DOCKER_HUB_USER}/${imageName}:latest-armhf registry.gitlab.com/${env.DOCKER_HUB_USER}/${imageName}:${date}-armhf
          """
      }
    }
  }}
  stage ('publishing image (armhf)') { container('debian') {
    dir('galik8s') {
      withCredentials([[$class: 'UsernamePasswordMultiBinding',
        credentialsId: 'dockerhub',
        usernameVariable: 'DOCKER_HUB_USER',
        passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
          sh """
            docker login -u ${env.DOCKER_HUB_USER} -p ${env.DOCKER_HUB_PASSWORD}
            docker push ${env.DOCKER_HUB_USER}/${imageName}:latest-armhf
            docker push ${env.DOCKER_HUB_USER}/${imageName}:${date}-armhf
            docker login registry.gitlab.com -u ${env.DOCKER_HUB_USER} -p ${env.DOCKER_HUB_PASSWORD}
            docker push registry.gitlab.com/${env.DOCKER_HUB_USER}/${imageName}:latest-armhf
            docker push registry.gitlab.com/${env.DOCKER_HUB_USER}/${imageName}:${date}-armhf
          """
      }
    }
  }}
  currentBuild.result =  'SUCCESS'
}
catch (any) {
  currentBuild.result = 'FAILURE'
  throw any //rethrow exception to prevent the build from proceeding
}}}}
