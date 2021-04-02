pipeline {
    agent any

    environment {
        toolbelt = tool 'sfdx'

        //use this setup on Linux machines
        SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
    }

    stages {
        stage('Show sfdx-cli version') {
            steps {
                    sh '$toolbelt/sfdx --version'
            }
        }
    }
}