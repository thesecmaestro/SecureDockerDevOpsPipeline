def CONTAINER_NAME="docker-jenkinspipeline"
def CONTAINER_TAG="${env.BUILD_NUMBER}"
def DOCKER_HUB_USER="akrao"
def HTTP_PORT="8091"


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
    //  sh 'docker-compose -f docker-compose.integration.yml up'
        //sh "docker-compose -f docker-compose.integration.yml up --force-recreate --abort-on-container-exit"
    //    sh "docker-compose -f docker-compose.integration.yml down -v"

    stage 'Push to Docker Registry' {
		withCredentials([usernamePassword(credentialsId: 'dockerHubAccount', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            	pushToImage(CONTAINER_NAME, CONTAINER_TAG, USERNAME, PASSWORD)
		//sh "docker push localhost:50000/accountownerapp:B${BUILD_NUMBER}"
	}	
    }

    //docker.image('localhost:50000/accountownerapp:B${BUILD_NUMBER}').inside('-v /var/run/docker.sock:/var/run/docker.sock') {
    //} //docker build

    //docker.image('nordri/clair-scanner').inside('--net ci') {
    // 	stage 'Security Scanner' {
    //	  sh '''
    //         IP=$(ip r | tail -n1 | awk '{ print $9 }')
    //         /clair-scanner --ip ${IP} --clair=http://clair:6060 --threshold="Critical" DOCKER_IMAGE
    //       '''
    //	} // security scanning
    //  } docker image with security scannner

    //stage('Run App'){
    //    runApp(CONTAINER_NAME, CONTAINER_TAG, DOCKER_HUB_USER, HTTP_PORT)
    //}
    
    stage 'Deploy to K8S'
	 sh "sed -i 's/BUILD_NUMBER/B${BUILD_NUMBER}/g' mydeploy.yaml"
	// 	sh "kubectl apply -f mydeploy.yaml"
        // 	sh "kubectl apply -f myservice.yaml"


}





def imagePrune(containerName){
    try {
        sh "docker image prune -f"
        sh "docker stop $containerName"
    } catch(error){}
}

def imageBuild(containerName, tag){
    try {
        sh "docker image prune -f"
        sh "docker stop $containerName"
    } catch(error){}
    
    sh "docker build -t $containerName:$tag  -t $containerName --pull --no-cache ."
    echo "Image build complete"
}

def pushToImage(containerName, tag, dockerUser, dockerPassword){
    sh "docker login -u $dockerUser -p $dockerPassword"
    sh "docker tag $containerName:$tag $dockerUser/$containerName:$tag"
    sh "docker push $dockerUser/$containerName:$tag"
    echo "Image push complete"
}

def runApp(containerName, tag, dockerHubUser, httpPort){
    sh "docker pull $dockerHubUser/$containerName:$tag"
    sh "docker run -d --rm -p $httpPort:$httpPort --name $containerName $dockerHubUser/$containerName:$tag"
    echo "Application started on port: ${httpPort} (http)"
}





