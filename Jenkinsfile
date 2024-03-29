pipeline {
    agent any
    options {
      skipDefaultCheckout true
    }
    stages {
        stage('CleanWSStart') {
            steps {
                deleteDir()
            }
        }
        stage('Setup') {
            steps {
                sh 'git clone -j 10 --recursive -b $BRANCH_NAME http://${GLUSER}:${GLPASS}@10.0.0.101:180/growsense/index.git .'
                shHide('git remote rm origin')
                shHide('git remote add origin https://${GHTOKEN}@github.com/GrowSense/Index.git')
                shHide('#git remote set-url --add --push origin https://${GHTOKEN}@github.com/GrowSense/Index.git')
                shHide( 'sh set-wifi-credentials.sh ${WIFI_NAME} ${WIFI_PASSWORD}' )
                sh 'sh init-mock-systemctl.sh'
                sh 'sh init-mock-docker.sh'
                sh 'sh init-mock-setup.sh'
                sh 'sh init-mock-submodule-builds.sh'
                sh 'git config --global user.email "compulsivecoder@gmail.com"'
                sh 'git config --global user.name "CompulsiveCoderCI"'
            }
        }
        stage('Prepare') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'echo "Disabled prepare script to speed up CI" #sh prepare.sh'
            }
        }
        stage('Init') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'sh init-all.sh'
            }
        }
        stage('Configure WiFi and MQTT') {
            when { expression { !shouldSkipBuild() } }
            steps {
                shHide( 'sh set-wifi-credentials.sh ${WIFI_NAME} ${WIFI_PASSWORD}' )
                shHide( 'sh set-mqtt-credentials.sh ${MQTT_HOST} ${MQTT_USERNAME} ${MQTT_PASSWORD}' )
            }
        }
        stage('Build') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'sh build-cli.sh'
                sh 'sh build-tests.sh'
            }
        }
        stage('Test') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'sh test-software.sh'
            }
        }
        stage('Increment Version') {
            when { expression { !shouldSkipBuild() } }
            steps {
              sh 'sh increment-version.sh'
            }
        }
        stage('Push Version') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'sh push-version.sh'
            }
        }
        stage('Create Release Zip') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'bash create-release-zip.sh'
            }
        }
        stage('Publish GitHub Release') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'bash publish-github-release.sh'
            }
        }
        stage('Deploy Update') {
            when { expression { !shouldSkipBuild() } }
            steps {
               sh '#sh deploy-dev-update.sh'
               sh '#sh deploy-master-update.sh'
               sh '#sh deploy-rc-update.sh'
            }
        }
        stage('Deploy') {
            when { expression { !shouldSkipBuild() } }
            steps {
               sh 'sh deploy-dev.sh'
               sh 'sh deploy-master.sh'
               sh 'sh deploy-rc.sh'
               sh 'sh deploy-lts.sh'
            }
        }
        stage('Clean') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'sh clean.sh'
            }
        }
        stage('Graduate') {
            when { expression { !shouldSkipBuild() } }
            steps {
                sh 'sh graduate.sh'
            }
        }
    }
    post {
        always{
          sh 'sh increment-cycle.sh'
          sh 'sh push-cycle.sh'
        }
        success() {
          emailext (
              subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
              body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                <p>Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>""",
              recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
        failure() {
          sh '#sh rollback.sh'
          emailext (
              subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
              body: """<p>FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
                <p>Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>""",
              recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
    }
}
Boolean shouldSkipBuild() {
    return sh( script: 'sh check-ci-skip.sh', returnStatus: true )
}
def shHide(cmd) {
    sh('#!/bin/sh -e\n' + cmd)
}






























 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
