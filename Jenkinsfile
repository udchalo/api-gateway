pipeline {
  options {
      buildDiscarder(logRotator(numToKeepStr: '3'))
  }
  agent any
  environment {
    NODE_ENV = 'dev'
	DOMAIN_URL="https://$NODE_ENV-server.udchalo.com"
	USER_URL="https://users-$NODE_ENV-api.udchalo.com"
  }
  stages {
    stage('Build preparations') {
      steps {
        script {
          // calculate GIT lastest commit short-hash
          gitCommitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
          shortCommitHash = gitCommitHash.take(7)
          if(env.GIT_BRANCH == "master"){
            NODE_ENV = 'prod'
          } else 
          if(env.GIT_BRANCH == "stage"){
            NODE_ENV = 'stage'
          } else
          if(env.GIT_BRANCH == "uat"){
            NODE_ENV = 'uat'
          } else {
            NODE_ENV = 'dev'
          }
          // calculate a sample version tag
          VERSION = "$NODE_ENV-$shortCommitHash"
          // set the build display name
          currentBuild.displayName = "#${BUILD_ID}-${VERSION}"
		  echo 'git_branch:' + env.GIT_BRANCH
        }
      }
    }
    stage('Preparing for build and deploy') {
      steps {
        script {
          sh "chmod +x -R ${env.WORKSPACE}/build.sh"
		  sh "./build.sh"
		  }
        }
      }
    }
	stage('Building and deploying API Gateway'){
	  steps{
	    script{
		    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_OPSUSER_GLOBAL', variable: 'AWS_ACCESS_KEY_ID']]){
				sam package --template-file template.yaml --s3-bucket $BUCKET --output-template-file package.yaml
				sam deploy --template-file package.yaml --stack-name $STACK --capabilities CAPABILITY_IAM
			
			}
		}
	  }
	}
  }
}
