pipeline {
    agent any

    environment {
        toolbelt = tool 'sfdx'
        HUB_ORG = credentials('HUB_ORG')
        SFDC_HOST = credentials('SFDC_HOST')
        CONNECTED_APP_CONSUMER_KEY = credentials('CONNECTED_APP_CONSUMER_KEY')
        jwt_key_file = credentials('SERVER_KEY')
        DEV_HUB_ALIAS = "DEV_HUB"
        SCRATCH_ORG_ALIAS = 'Scratch-$BUILD_NUMBER'

        SANDBOX_CONNECTED_APP_CONSUMER_KEY = "3MVG9SOw8KERNN09M7AOhaoDIcn0y_XCchfUzTCsnEb2Q7I.m.A7uWS44uZGStTb6DZFgNnL6jENMlt2IjqQO"
        SANDBOX_ORG = "michaelsav4enko@resourceful-wolf-e390ul.com"
        SANDBOX_ALIAS = "SandBoxOrg"

        SFDX_USE_GENERIC_UNIX_KEYCHAIN=true

        rc = "none"
    }

    options {
        timeout(time:30, unit: "MINUTES")
    }

    stages {


        stage('Login') {

            steps {
                sh '$toolbelt/sfdx force:auth:jwt:grant --clientid $CONNECTED_APP_CONSUMER_KEY --username $HUB_ORG --jwtkeyfile $jwt_key_file -d --instanceurl $SFDC_HOST -a $DEV_HUB_ALIAS --setdefaultdevhubusername'
                rc = sh(script: "$toolbelt/sfdx force:org:list", returnStdout: true)
                println rc
            }
        }

        stage('Print') {
            steps {
                println rc
            }
        }
    }

      /*   stage('Create Scratch Org') {
            steps {
                sh 'SFDX_USE_GENERIC_UNIX_KEYCHAIN=true $toolbelt/sfdx force:org:create --setdefaultusername -f config/project-scratch-def.json -a $SCRATCH_ORG_ALIAS  --targetdevhubusername $DEV_HUB_ALIAS'
                sh 'SFDX_USE_GENERIC_UNIX_KEYCHAIN=true $toolbelt/sfdx force:source:push -u $SCRATCH_ORG_ALIAS'
            }
        }

        stage('Run tests on Scratch Org') {
            steps {
                sh 'SFDX_USE_GENERIC_UNIX_KEYCHAIN=true $toolbelt/sfdx force:apex:test:run -u $SCRATCH_ORG_ALIAS --classnames AccountSearchControllerTest --wait 10 --resultformat tap --codecoverage'
            }
        }

        stage('Deploy to SandBox') {
            when {
                branch 'master'
            }
            steps {
                sh 'SFDX_USE_GENERIC_UNIX_KEYCHAIN=true $toolbelt/sfdx force:auth:jwt:grant --clientid $SANDBOX_CONNECTED_APP_CONSUMER_KEY --username $SANDBOX_ORG --jwtkeyfile $jwt_key_file -d --instanceurl $SFDC_HOST -a $SANDBOX_ALIAS'
                sh 'SFDX_USE_GENERIC_UNIX_KEYCHAIN=true $toolbelt/sfdx force:source:deploy -p force-app -u $SANDBOX_ALIAS'}
        } */
    //}

    /* post {
        always {
            sh 'SFDX_USE_GENERIC_UNIX_KEYCHAIN=true $toolbelt/sfdx force:org:delete -u $SCRATCH_ORG_ALIAS --noprompt'
        }
    } */
}

/*
#!groovy
import groovy.json.JsonSlurperClassic
node {
    //changes in dev

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def HUB_ORG ="michaelsav4enko@playful-goat-wb8z0r.com"
    def SFDC_HOST = "https://login.salesforce.com"
    def CONNECTED_APP_CONSUMER_KEY = "3MVG91BJr_0ZDQ4swvCaW48wcrDDYHizUkJMbuJGzQXeYnSXGD3oVZwWI8130BOJ3sxKYXfdU5z_wme.yqs6t"

    def SANBOX_CONNECTED_APP_CONSUMER_KEY = "3MVG9SOw8KERNN09M7AOhaoDIcn0y_XCchfUzTCsnEb2Q7I.m.A7uWS44uZGStTb6DZFgNnL6jENMlt2IjqQO"
    def SANBOX_ORG = "michaelsav4enko@resourceful-wolf-e390ul.com"

    println 'KEY IS' 
    println HUB_ORG
    println SFDC_HOST
    println CONNECTED_APP_CONSUMER_KEY
    def toolbelt = tool 'sfdx'

    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }

    withCredentials([file(credentialsId: 'SERVER_KEY', variable: 'jwt_key_file')]) {
        stage('Auth') {
            if (isUnix()) {
                rc = sh returnStatus: true, script: "SFDX_USE_GENERIC_UNIX_KEYCHAIN=true ${toolbelt}/sfdx force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} -d --instanceurl ${SFDC_HOST} --setalias HubOrg --setdefaultdevhubusername"
                println rc
                rc = sh returnStatus: true, script: "SFDX_USE_GENERIC_UNIX_KEYCHAIN=true ${toolbelt}/sfdx force:auth:jwt:grant --clientid ${SANBOX_CONNECTED_APP_CONSUMER_KEY} --username ${SANBOX_ORG} --jwtkeyfile ${jwt_key_file} -d --instanceurl ${SFDC_HOST} -a SandBoxOrg"
                println rc
                rc = sh returnStatus: true, script: "SFDX_USE_GENERIC_UNIX_KEYCHAIN=true ${toolbelt}/sfdx force:source:deploy -p force-app -u SandBoxOrg"
                println rc
                rc = sh returnStatus: true, script: "SFDX_USE_GENERIC_UNIX_KEYCHAIN=true ${toolbelt}/sfdx force:org:list"
                println rc
            }else{
                 rc = bat returnStatus: true, script: "\"${toolbelt}\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            }
            if (rc != 0) { error 'hub org authorization failed' }

			println rc
        }

        stage('Create Test Scratch Org') {
                if (BRANCH_NAME == 'master') {
                    rc = sh returnStatus: true, script: "SFDX_USE_GENERIC_UNIX_KEYCHAIN=true ${toolbelt}/sfdx force:org:create --setdefaultusername -f config/project-scratch-def.json -a ${BUILD_NUMBER}  --targetdevhubusername HubOrg"
                    if (rc != 0) {
                        println rc
                        error 'Salesforce test scratch org creation failed.'
                    }
                }

        }

        stage('Push To Test Scratch Org') {
               
                rc = sh returnStatus: true, script: "SFDX_USE_GENERIC_UNIX_KEYCHAIN=true ${toolbelt}/sfdx force:source:push --targetusername ciorg"
                if (rc != 0) {
                     println rc
                     error 'Salesforce push to test scratch org failed.'
                     rc = sh returnStatus: true, script: "SFDX_USE_GENERIC_UNIX_KEYCHAIN=true ${toolbelt}/sfdx force:org:delete -u ciorg --noprompt"
                     println rc
                }
        }

        stage('Run Tests In Test Scratch Org') {
               

                rc = rc = sh returnStatus: true, script: "SFDX_USE_GENERIC_UNIX_KEYCHAIN=true ${toolbelt}/sfdx force:apex:test:run --targetusername ciorg --wait 10 --resultformat tap --codecoverage"
                if (rc != 0) {
                     println rc
                    error 'Salesforce unit test run in test scratch org failed.'
                    rc = sh returnStatus: true, script: "SFDX_USE_GENERIC_UNIX_KEYCHAIN=true ${toolbelt}/sfdx force:org:delete -u ciorg --noprompt"
                     println rc
                }
        }
        
        stage('Delete Package Install Scratch Org') {

               
                rc= sh returnStatus: true, script: "SFDX_USE_GENERIC_UNIX_KEYCHAIN=true ${toolbelt}/sfdx force:org:delete -u ciorg --noprompt"
                if (rc != 0) {
                     println rc
                    error 'Salesforce package install scratch org deletion failed.'
                }
        }
    }
}
 */
