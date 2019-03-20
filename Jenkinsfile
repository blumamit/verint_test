#!/usr/bin/env groovy

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature

node{

    stage('Checkout'){
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/blumamit/verint_test/']]])
        sh "ls ."
    }

    stage('Verify checksum'){
        fileCalculatedMD5 = sh(script: 'md5sum forcast_json_parser.sh | cut -d" " -f1', returnStdout: true).trim()
        fileExpectedMD5 = sh(script: 'cat forcast_json_parser.sh_md5sum.txt', returnStdout: true).trim()
//      To fail the checksum verification pollute one of the md5sum variables by uncommenting the next line:
//        fileExpectedMD5 = "not the real checksum"
        assert fileCalculatedMD5.equals(fileExpectedMD5)
    }

    stage('Execute the script'){
        echo "Execute the script:"
        sh 'chmod 755 forcast_json_parser.sh'
        sh './forcast_json_parser.sh'
        cat './forcast_data.json'
    }

    stage('Validate the json file'){
//      To fail the json validation pollute the json file by uncommenting the next line
//        sh 'echo , >> ./forcast_data.json'
        def jsonString = new File("${WORKSPACE}/forcast_data.json").getText('UTF-8')
        ObjectMapper mapper = new ObjectMapper()
        mapper.configure(DeserializationFeature.FAIL_ON_TRAILING_TOKENS, true)
        mapper.readValue(jsonString, Map)
    }

}
