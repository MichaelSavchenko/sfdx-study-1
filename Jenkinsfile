#!groovy
import groovy.json.JsonSlurperClassic
node {


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

        /*stage('Push To Test Scratch Org') {
               
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
        }*/
    }
}
