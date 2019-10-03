# Noob SNHUbot Docker Image
## (Beta)

This image will allow you to spin up a Docker container running
the Noob_SNHUbot Slack bot!  There are a number of things you'll
need to know before getting started.

### Config files

There are two configuration files included in this image, `cfg/slack.yml` and `cfg/mongo.yml`.
The Mongo file is good to go, but edits need to be made to `slack.yml`.  There are two keys,
`token` and `oauth`, each need to be populated with your personal app keys from Slack.  You 
can also set up environment variables for these, but that will not be discussed here.  See
the README for Noob_SNHUbot for more information.  Whichever way you decide to go, be aware,
*NEVER* publish your tokens to GitHub.  Slack will deactivate them within seconds and the 
app will need to be recreated in Slack to get new ones.

Onto building the image.  Assuming you have Docker installed on your system, the image
can be built with the following command:

```
sudo docker build --build-arg GIT_FORK=https://your.fork.url.git -t snhubot_image .
```

Please be sure to populate the `GIT_FORK` argument with *your own fork's clone URL*. 
This argument is used to clone the repository into the image.  As such, do not clone 
the primary repository from the SNHU Coders group.  You will not be allowed to publish
changes directly to that repository.

The building process will take quite a while because there is a lot going on.  When
that is finished, the container can be built with the following command:

```
sudo docker run --privileged -d -p 27017:27017 --name noob_snhubot snhubot_image
```



sudo docker exec noob_snhubot mongorestore -d catalog -c subjects /subjects.bson

sudo docker exec --user ubuntu -it noob_snhubot /bin/bash