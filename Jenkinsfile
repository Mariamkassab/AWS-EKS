pipeline {

    agent { label "jenkins_slave"}

    parameters {
        choice(name: 'ENV', choices: ['build', 'deploy'])
    } 


    
    stages {
        stage('build') {
            steps {
                echo 'build'

                script{

                    if (params.ENV == "build") {
                        withCredentials([usernamePassword(credentialsId: 'mariam-dockerHub', usernameVariable: 'USERNAME_ITI', passwordVariable: 'PASSWORD_ITI')]) {
                            sh '''
                                docker build -t 253823388836.dkr.ecr.us-east-1.amazonaws.com/app-reg:v${BUILD_NUMBER} .
                                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 253823388836.dkr.ecr.us-east-1.amazonaws.com
                                docker push 253823388836.dkr.ecr.us-east-1.amazonaws.com/app-reg:v${BUILD_NUMBER}
                                echo ${BUILD_NUMBER} > ../build.txt
                            '''
                     }
                    }
                    else {
                        echo "user choosed ${params.ENV}"
                    }

                }

            }
        }



        stage('deploy') {

            
            steps {
                echo 'deploy'


                script {
                    if (params.ENV == "deploy") {
                        withCredentials([file(credentialsId: 'mariam-kubeconfig', variable: 'KUBECONFIG_ITI')]) {
                            sh '''
                                export BUILD_NUMBER=$(cat ../build.txt)
                                mv Deployment/deploy.yaml Deployment/deploy.yaml.tmp
                                cat Deployment/deploy.yaml.tmp | envsubst > Deployment/deploy.yaml
                                rm -f Deployment/deploy.yaml.tmp
                                kubectl apply -f ./Deployment --kubeconfig ${KUBECONFIG_ITI} -n app
                             '''
                        }
                    }
                }


            }

            
        }
    }


}
