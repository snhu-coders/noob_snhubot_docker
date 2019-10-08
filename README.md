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
**NEVER** publish your tokens to GitHub.  Slack will deactivate them within seconds and the 
app will need to be recreated in Slack to get new ones.

### Building

Onto building the image.  Assuming you have Docker installed on your system, the image
can be built with the following command:

```
docker build -t snhubot_image .
```

Once the image is built, we need to run the container. This is done with the following command:

```
docker run --privileged -d -p 27017:27017 -v /path/to/repo:/home/ubuntu/noob_snhubot --name noob_snhubot snhubot_image
```

The `/path/to/repo` portion of that command is something you will need to change.  It should be the path 
to a forked repository you have on your own machine. In other words, your local copy of the Noob_SNHUbot repository
will get mounted as a volume in the container.  This is done so you can still edit the code on your own machine
and run it through the Docker container.  Otherwise, you would be stuck editing the code with one of the editors
included in the image.

### Running

If you are running the image for the first time, execute the following command to populate the `catalog` db in Mongo.

```
docker exec noob_snhubot mongorestore -d catalog -c subjects /subjects.bson
```

Subsequent runs can be executed as follows.  This will log you into the home directory in the image, where you will find the Noob_SNHUbot repo!

```
docker exec --user ubuntu -it noob_snhubot /bin/bash
```

### Known Issues / Potential Improvements

1. Due to the current configuration, tokens and other config options must be given through config files.  Environment variables can be set, but
there is currently no need for that.
2. The list of required Python packages is obtained from the `master` branch of the snhu-coders/noob_snhubot repository.  Because of this,
the package list may be out of date relative to newer branches.
