#Jenkins job runtime improvement with aws codebuild projects

##Preconditions:
* Jenkins is setup in aws and we did not manage to use slaves. 
* Since the platform is big and some artifacts (Java) 
contain many others, jenkins comes to his limits when multiple developers commit to different repositories and it is forced to run multiple jobs at the same time. 
* The job that verifies the maven multiproject runs around 35 min.

##Goal:
* Stay with jenkins
* Run jobs in codebuild and get feedback in jenkins to improve the performance

##Solutions:
Jenkinsfiles and buildspecs are in this ordner

###Following steps were done to build big artifacts (maven multiproject) outside of jenkins
* Install jenkins codebuild plugin
* Create jenkins pipeline
* Store settings.xml for maven build in s3
* Store access in system manager parameters to use in codebuild and maven

* Create codebuild project with the necessary permissions and following functionality:
    * Get settings.xml from s3 
    * run maven with the necessary access data
    * store tests results in s3

* Create jenkinsfile whith following functionality:
    * get commitID and run codebuild with it
    * get generated files of test results from s3 and pass it to jenkins
    * delete generated files from s3
    * pass files to jenkins to show test results

With this approach we managed to reduce the runtime to 5 mins.


###Build and push docker image from angular app and java ms to different aws accounts
We next challenge we had was to build and angular application on top of a java microservice, create a docker image and push it to different environments. This jobs was running around 25 mins in jenkins.

We did the following steps to build the docker images outside of jenkins:
* Install jenkins codebuild plugin
* Create jenkins pipeline
* Store settings.xml for maven build in s3
* Store access in system manager parameters to use in codebuild and maven

* Create codebuild project with the necessary permissions and following functionality:
    * Get settings.xml from s3
    * login into ecr in all environments
    * build the angular app
    * build the java app
    * copy necessary files for docker build
    * build docker image
    * push to all envoronments

* Create jenkinsfile whith following functionality:
    * get branch names of both repositories to build the docker image from
    * get branch latest commitID
    * call the codebuild projects with both commitIDs (notice that the main repository will need the buildspec)

With this approach we managed to reduce the runtime to 5 mins.