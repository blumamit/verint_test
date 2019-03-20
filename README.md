# verint_test

How I solved this:

1. I started off reading about parsing text with Python. 
I read and learnt quite a bit particularly from these links:
https://www.vipinajayakumar.com/parsing-text-with-python/
https://pythonspot.com/json-encoding-and-decoding-with-python/

While it didn't seem too complex - the massive slew of various objects and tools available, and my lack of knowledge of the differences between them pushed me to default back to bash which I feel much more comfortable with. This is a classic case of "there is more than one way to do it", and I felt that forcing myself to use python will take me too long to produce results.

Once i had my json parser up and running and the md5sum file uploaded to the repo, I started working on the jenkins file, which was a bit more challenging for me.

2. Installing jenkins:
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install openjdk-8-jdk jenkins
#opened browser to "ipaddress:8080", enter initial admin password, install recommended plugins (including pipelines)
#Created a new pipline project. Opted for a scripted pipline (rather than a declarative one).

3. Stage "Checkout":
I used the syntax that was directly given from https:JENKINS_IP:8080/job/test/pipeline-syntax/ when picking the "Checkout: Check out from version control" Sample steps.
I chose the step, selected "Git" scm, and entered my repo URL - and voila I had my checkout syntax ready to be copy-pasted.

4. Stage "Verify checksum":
I looked around a bit and other than built in fingerprinting features in Jenkins I couldn't find any helpful libraries for this. So I opted to compare via bash cli, and fail on wrong md5

5. Stage "Execute the script":
very straight forward. nothing to explain here.

6. Stage "Validate the json file":
This is where things got a little tricky. I played around with jsonSlurper library which is nice - but validation is lacking in many cases. I eventually stumbled upon a post in stackoverflow which compared a few json parsers in groovy:
https://stackoverflow.com/questions/48469200/groovy-validate-json-string

and the winner was ObjectMapper - which is what I chose to validate with. If parsing fails (because of invalid json) the build fails - just as required.
