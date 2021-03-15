#!groovy
import groovy.json.JsonSlurperClassic
node {

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def HUB_ORG ="michaelsav4enko@playful-goat-wb8z0r.com"
    def SFDC_HOST = "https://login.salesforce.com"
    def CONNECTED_APP_CONSUMER_KEY = "3MVG91BJr_0ZDQ4swvCaW48wcrDDYHizUkJMbuJGzQXeYnSXGD3oVZwWI8130BOJ3sxKYXfdU5z_wme.yqs6t"

    println 'KEY IS' 
    println HUB_ORG
    println SFDC_HOST
    println CONNECTED_APP_CONSUMER_KEY
    def toolbelt = tool 'sfdx'

    stage('checkout source') {
        //test
        // when running in multi-branch job, one must issue this command
        checkout scm
    }
}
