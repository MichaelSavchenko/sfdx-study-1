pipeline {
    agent any

    environment {
        toolbelt = tool 'sfdx'
        HUB_ORG = credentials('HUB_ORG')
        SFDC_HOST = credentials('SFDC_HOST')
        CONNECTED_APP_CONSUMER_KEY = credentials('CONNECTED_APP_CONSUMER_KEY')
        jwt_key_file = credentials('SERVER_KEY')
        DEV_HUB_ALIAS = "DEV_HUB"


        SANDBOX_CONNECTED_APP_CONSUMER_KEY = "3MVG9SOw8KERNN09M7AOhaoDIcn0y_XCchfUzTCsnEb2Q7I.m.A7uWS44uZGStTb6DZFgNnL6jENMlt2IjqQO"
        SANDBOX_ORG = "michaelsav4enko@resourceful-wolf-e390ul.com"
        SANDBOX_ALIAS = "SandBoxOrg"

        SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
    }

    options {
        timeout(time:30, unit: "MINUTES")
    }

    stages {

        stage('Login') {

            steps {
                script {
                    def SCRATCH_ORG_ALIAS = 'Scratch-${BUILD_NUMBER}'
                    sh '$toolbelt/sfdx force:auth:jwt:grant --clientid $CONNECTED_APP_CONSUMER_KEY --username $HUB_ORG --jwtkeyfile $jwt_key_file -d --instanceurl $SFDC_HOST -a $DEV_HUB_ALIAS --setdefaultdevhubusername'
                    env.rc = sh(script: "$toolbelt/sfdx force:org:list", returnStdout: true)
                }
            }
        }

        stage('Create Scratch Org') {
            when {
                not { branch 'master' }
            }

            steps {
                sh '$toolbelt/sfdx force:org:create --setdefaultusername -f config/project-scratch-def.json -a $SCRATCH_ORG_ALIAS  --targetdevhubusername $DEV_HUB_ALIAS'
                sh '$toolbelt/sfdx force:source:push -u $SCRATCH_ORG_ALIAS'

                script {
                    env.scratchCreated = true
                }
            }
        }


        stage('Run tests on Scratch Org') {
            when {
                 not { branch 'master' }
            }

            steps {
                sh '$toolbelt/sfdx force:apex:test:run -u $SCRATCH_ORG_ALIAS --classnames AccountSearchControllerTest --wait 10 --resultformat tap --codecoverage'
            }
        }

        stage('Deploy to SandBox') {
            when {
                branch 'master'
            }
            steps {
                sh '$toolbelt/sfdx force:auth:jwt:grant --clientid $SANDBOX_CONNECTED_APP_CONSUMER_KEY --username $SANDBOX_ORG --jwtkeyfile $jwt_key_file -d --instanceurl $SFDC_HOST -a $SANDBOX_ALIAS'
                sh '$toolbelt/sfdx force:source:deploy -p force-app -u $SANDBOX_ALIAS'}
        }
    }

    post {
        always {
            emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
                        recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
                        subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}"

            script {
                if (env.scratchCreated && env.scratchCreated.toBoolean()) {
                    sh '$toolbelt/sfdx force:org:delete -u $SCRATCH_ORG_ALIAS --noprompt'
                    sh '$toolbelt/sfdx force:org:list --clean --noprompt'
                }
            }
        }
    }
}