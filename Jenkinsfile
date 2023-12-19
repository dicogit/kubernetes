pipeline {
	agent any 
	environment {
		IMAGE_PHP="devopsdr/pub:php$BUILD_NUMBER"
		IMAGE_DB="devopsdr/pub:DB$BUILD_NUMBER"
		BUILD_IP='ec2-user@65.2.81.2'
	}
	stages {
		stage ('BUILD THE PHPDB IMAGE') {
			steps {
				sshagent(['ssh-agent']) {
					script {
						withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dpwd', usernameVariable: 'docr')]) {
							echo "BUILD THE PHPDB IMAGE"
							sh "scp -o StrictHostKeyChecking=no -r php_files db_files ${BUILD_IP}:/home/ec2-user/"
							sh "ssh -o StrictHostKeyChecking=no ${BUILD_IP} 'bash ~/php_files/php_script.sh'"
							sh "ssh -o StrictHostKeyChecking=no ${BUILD_IP} 'sudo docker build -t ${IMAGE_PHP} /home/ec2-user/php_files/'"
							sh "ssh -o StrictHostKeyChecking=no ${BUILD_IP} 'sudo docker build -t ${IMAGE_DB} /home/ec2-user/db_files/'"
							sh "ssh -o StrictHostKeyChecking=no ${BUILD_IP} 'sudo docker login -u ${docr} -p ${dpwd}'"
							sh "ssh -o StrictHostKeyChecking=no ${BUILD_IP} 'sudo docker push ${IMAGE_PHP}'"
							sh "ssh -o StrictHostKeyChecking=no ${BUILD_IP} 'sudo docker push ${IMAGE_DB}'"
						}
					}
				}
			}
		}
		stage ('DEPLOY ON KUBERNETES EKSCTL') {
			steps {
				script {
					withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dpwd', usernameVariable: 'docr')]) {
						echo "DEPLOY PHP-DB APPLICATION BY EKSCTL"
						sh "ssh -o StrictHostKeyChecking=no envsubst < eks_phpdb_app.yml | kubectl apply -f -"
						
					}
				}
			}
		}
	}
}  
	