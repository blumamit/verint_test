# verint_test

# How I solved this:

## 1. Json parser:

I have only limited experience with Python, but I started off reading about parsing text files and jsons with it. While it didn't seem too complex - the massive slew of various objects and tools available, and my lack of knowledge of the differences between them pushed me to default back to bash which I feel much more comfortable performing text processing and manipulation with. I decided this mainly because I was afraid I might not have enough time to do this *properly* with Python. 

With Bash, I began by downloading the webpage using "curl" to send out an HTTP GET request on the page.
Then, with some help of the object inspector (chrome or firefox dev tools) I was able to parse out the required information by using a mixture Bash text processing tools, and in particular by using Regexs with techniques like forward and backward lookup.

Once i had my json parser up and running and the md5sum file uploaded to the repo, I started working on the jenkins file, which was a bit more challenging for me.

## 2. Installing jenkins:

```
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install openjdk-8-jdk jenkins
```

Once I created a new pipline project I built the outline/skeleton of the Jenkinsfile and slowly filled it with content.
I opted for a scripted pipline (rather than a declarative one), because it feels more natural to me.

## 3. Stage "Checkout":

I used the syntax that was directly given from https:JENKINS_IP:8080/job/test/pipeline-syntax/ when picking the "Checkout: Check out from version control" Sample steps.

I chose the step, selected "Git" scm, and entered my repo URL - and voila I had my checkout syntax ready to be copy-pasted.

## 4 Stage "Verify checksum":

I looked around a bit and other than some built-in fingerprinting features in Jenkins (that I did not know how to use in this context) I couldn't find any helpful groovy libraries for this. So I opted to compare via bash cli, and fail on wrong md5

## 5. Stage "Execute the script":
Very straight forward. Give the file permissions and execute the script. Nothing to explain here.

## 6. Stage "Validate the json file":

This is where things got a little tricky. I played around with jsonSlurper library quite a bi - but ended up wasting my time in finding out that validation is lacking in this json parsing library in many cases. I eventually stumbled upon this golden post in stackoverflow which compared a few json parsers in groovy:
https://stackoverflow.com/questions/48469200/groovy-validate-json-string

The winner was ObjectMapper - which is what I chose to use. If parsing fails (because of invalid json) the build fails - as required.
