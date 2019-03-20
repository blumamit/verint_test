#!/usr/bin/env groovy
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature

node{
    stage('checkout'){
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/blumamit/verint_test/']]])
        sh "ls ${WORKSPACE}"
    }
    stage('verify checksum'){
        FILE_CALCULATED_MD5 = sh('md5sum forcast_json_parser.sh | cut -d" " -f1')
        FILE_EXPECTED_MD5 = sh('cat forcast_json_parser.sh_md5sum.txt')
        if ( FILE_CALCULATED_MD5 != FILE_EXPECTED_MD5 ){
            echo "MD5 is not as expected. Stopping build."
            currentBuild.result = 'FAILURE'
        }
    }
    stage('Execute the script'){
        echo "Execute the script:"
        sh 'chmod 755 forcast_json_parser.sh'
        sh './forcast_json_parser.sh'
    }
    stage('Validate the json file'){
//      to check if json validation (next stage) works uncomment next line
//        sh 'echo , >> ${WORKSPACE}/forcast_data.json'
        def jsonString = new File("${WORKSPACE}/forcast_data.json").getText('UTF-8')
        ObjectMapper mapper = new ObjectMapper()
        mapper.configure(DeserializationFeature.FAIL_ON_TRAILING_TOKENS, true)
        mapper.readValue(jsonString, Map)
    }
}
