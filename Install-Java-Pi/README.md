# Install-Java-Pi
This is a basic script to automate a teadious process of installing java to Raspberry Pis.
A whole lot of time is spent searching how to do it, every time you reset your sdcard .. or at least in my case.

## How
Basically 4 things
* Downloads a specfic copy of java from (this repo)[https://github.com/frekele/oracle-java/] as orcale requires you to make an account
	to download java versions now.
* Makes a DIR in /usr/java
* Extracts the tar.gz file into /usr/java
* Sets java PATH

## What else?
That is about it, you can do the following:
* Change the settings in the script to keep the downloaded file after the script is done.
* Change the download dir.
* Eat Pizza

## Disclaimer
This script does not automatically assume you have java installed or not,
This responsibility is in your hands. You must accept the download.

If you choose yes and it deletes pizza because you already have java installed, you must pay for your actons.

## Is that it?
Yup.
