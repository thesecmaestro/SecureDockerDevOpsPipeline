node('docker') {
 

    stage 'Checkout'
        checkout scm
    stage 'Build & UnitTest'
    sh "docker build -t accountownerapp:B${BUILD_NUMBER} -f Dockerfile ."
    sh "docker build -t localhost:50000/accountownerapp:B${BUILD_NUMBER} -f Dockerfile ."
    sh "docker build -t accountownerapp:test-B${BUILD_NUMBER} -f Dockerfile.Integration ."
    
    stage 'Pusblish UT Reports'
        
        containerID = sh (
            script: "docker run -d accountownerapp:B${BUILD_NUMBER}", 
        returnStdout: true
        ).trim()
        echo "Container ID is ==> ${containerID}"
        //sh "docker cp ${containerID}:/TestResults/test_results.xml test_results.xml"
        sh "docker stop ${containerID}"
        sh "docker rm ${containerID}"
        step([$class: 'MSTestPublisher', failOnError: false, testResultsFile: 'test_results.xml'])    
      
    stage 'Integration Test'
        sh 'docker-compose -f docker-compose.integration.yml up'
        //sh "docker-compose -f docker-compose.integration.yml up --force-recreate --abort-on-container-exit"
        sh "docker-compose -f docker-compose.integration.yml down -v"

    stage 'Push Image'
	sh "docker push localhost:50000/accountownerapp:B${BUILD_NUMBER}"

    //docker.image('localhost:50000/accountownerapp:B${BUILD_NUMBER}').inside('-v /var/run/docker.sock:/var/run/docker.sock') {
    } // docker build

    //docker.image('nordri/clair-scanner').inside('--net ci') {
    // 	stage 'Security Scanner' {
    //	  sh '''
    //         IP=$(ip r | tail -n1 | awk '{ print $9 }')
    //         /clair-scanner --ip ${IP} --clair=http://clair:6060 --threshold="Critical" DOCKER_IMAGE
    //       '''
    //	} // security scanning
    //  } docker image with security scannner

	

    
    stage 'Deploy to K8S'
	 sh "sed -i 's/BUILD_NUMBER/B${BUILD_NUMBER}/g' mydeploy.yaml"
	// 	sh "kubectl apply -f mydeploy.yaml"
        // 	sh "kubectl apply -f myservice.yaml"

}


