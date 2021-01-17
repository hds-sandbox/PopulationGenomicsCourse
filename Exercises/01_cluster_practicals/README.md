# Data analysis project on GenomeDK

The exercises in this course will be done using our cluster computer. It is called GenomeDK and you can [read about it here](https://genome.au.dk/). We have already made a username for you on the cluster. More about that later. 

> **NB:** Your account on the cluster is **temporary**. It will be deleted once the course is finished, along with any files you have on the cluster. So make sure to download any files you want to keep before the course is over.

The cluster is a very large collection of computers with a shared file system. Using a terminal, you can connect to the cluster from your own computer to run run programs. Using the terminal you can also create and edit files the same way you can on your own machine. The goal of this exercise is to make you familiar with the cluster and to get you set up to do the remaining exercises in this course. We will assume some familiarity with using a terminal (you may know the terminal programs such as Terminal on OSX, PowerShell on Windows). If not, you should run through [this primer](https://lifehacker.com/5633909/who-needs-a-mouse-learn-to-use-the-command-line-for-almost-anything) before you begin.

# On your own machine
## Install Python on your own machine

If you have not done so already, you shuold a distribution of Python called *Anaconda*. Anaconda is simply an easy way of installing Python on Windows, macOS (Mac), and Linux, but it comes with the conda package management system (see below). To install Anaconda, head to [this](https://www.anaconda.com/download). When the download has completed, you should follow the platform specific instructions:

* **For Windows:** Double-click the `.exe` file you just downloaded and follow the instructions on the screen. When prompted, tick the box to add Anaconda python to your PATH. The installer will also ask you if you want to download and install a program called Visual Studio Code. Do that too.
* **For OSX:** Double-click the `.pkg` file you just downloaded and follow the instructions on the screen. Make a default installation. The installer will also ask you if you want to download and install a program called Visual Studio Code. Do that too.
## The Terminal

If you are on a Mac or Limux machine, you can use to default Terminal application. If you are on a Windwos macinne, you need to download and install the newest version of Powershell. You can [download it here](https://github.com/PowerShell/PowerShell/releases/download/v7.0.0/PowerShell-7.0.0-win-x64.msi). Double click the installer and. Now open the newly installed Powershell and run: `conda init powershell`. The adantage of PowerShell it that it works the same way as a Linux or OXS terminal. There are some exelent quick tutorials online that introduces the most basic commands in a Linux terminal. 

> **NB:** When ever we refer to "the terminal" below, it means PoweShell if you are on windows, and the Terminal app if you are on Mac.
## Conda environments

You need to install packages and programs for use in your analyses and pipelines. Sometimes, however, the versions of packages you need for one project conflicts with the versions you need for other projects that you work on in parallel. Such conflicts seem like an unsolvable problem. Would it not be fantastic if you could create a small world, insulated from the rest of your Anaconda installation. Then that small world could only contain the packages you needed for a single project. If each project had its own isolated world, then there would be no such conflicts. Fortunately, there is a tool that lets you do just that, and its name is Conda. The small worlds that Conda creates are called "environments," and you can create as many as you like, and then switch between them as you switch between your bioinformatics projects. Conda also downloads and installs the packages for you and makes sure that the packages you install in each environment are compatible.  It even makes sure that packages needed by packages  (dependencies) are installed. Conda lets you install mutually compatible versions of software and libraries in an enviromment for your project. By creating an enviromnet for each project, the libraries installed for each project do not interfere. 
## Create a conda environment on your own machine

When you install Anaconda or Miniconda, Conda makes a single base environment for you. It is called "base" and this is why it says "(base)" at your terminal prompt. You need a conda enviromnet for you project on both your local machine and on the cluster. Lets call both of them 'bircproject' (you can call it anything you like).

The environmnet on your local machine does not need a lot of packages since it mainly serve to let you connect to the cluster. This creates the enviromnet and installs `slurm-jupyter` from my conda chanel:

    conda create --name popgen -c kaspermunch slurm-jupyter jupyter jupyterlab pandas numpy matplotlib ipympl nodejs seaborn

Say yes (press Enter) when asked to install packages.

**Important:** Whenever you use the terminal on your own machine to do exercises, you should activate your `popgen` environment like this:

    conda activate popgen

When you environment is active it says `(popgen)` on the commnad prompt instead of `(base)`.    
## Connecting to the cluster

You connect to the cluster from the terminal by executing this command:

    ssh usernmae@login.genome.au.dk

When you do, you are promted for you password for your cluster username. Enter that and press enter. You are now in your home folder on the cluster. If you run the `hostname` command, you can see that you are on `fe1.genomedk.net`. To log out of the cluster, you can either use the `exit` commannd or press `Ctrl-d`. Now you are back on your own machine. Try `hostname` again and see what your own machine is called. 
## Set up login without password

You will need to log in to the cluster many many times, so you should set up your `ssh` connection to the cluster so you can connect securely without typing the password every time. You do not need to know *how* this works, but if you are interested here is how:

> Firstly, you have to understand what public/private encryption keys are. A private key is a very long, random stream of bits. A private key is kept secret and never leaves your own machine. A public key is another stream of bits, and it is derivative of the private key. That is, you can generate a unique public key from the private key, but cannot get the private key from a public key: This is a one-way process. These pairs have a unique feature. Using the public key, you can encrypt (or sign) any message, and it will only be possible to decrypt it using the private key. In other words, anyone with your public key can send you encrypted messages that only you will be able to read.
So, if the cluster has your public key saved, it can authenticate you like this:
The cluster sends your machine a message encrypted using your public. Your machine then decrypts the message using its private key and sends it back. If the cluster agrees it is decrypted correctly it logs you in.

First see if you have these two authentication files on your local machine (you can do so by running `ls -a ~/.ssh` in the terminal):

    ~/.ssh/id_rsa
    ~/.ssh/id_rsa.pub

if not, you generate a pair of authentication keys like this. Just press Enter when asked "Enter file in which to save the key". Do not enter a passphrase when prompted - just press enter:

    ssh-keygen -t rsa

Now use `ssh` to create a directory `~/.ssh` on the cluster (assuming your username on the cluster is 'username'):

    ssh username@login.genome.au.dk mkdir -p .ssh

Finally append the public ssh key on your local machine to the file `.ssh/authorized_keys` on the cluster and enter the password one last time (replace username with your cluster user name):

    cat ~/.ssh/id_rsa.pub | ssh username@login.genome.au.dk 'cat >> .ssh/authorized_keys'

From now on you can log into the cluster from your local machine without being prompted for a password.
# On the cluster
## Install Python

You need to install miniconda if you do not already have Anaconda Python installed in your cluster home dir. Log in to the cluster and run this command to download a miniconda installer:

    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  
Then this command to download and install miniconda:

    bash Miniconda3-latest-Linux-x86_64.sh

Say yes when it asks if it should run `conda init` for you.
## Creating an environment

You also need a dedicated conda environment on the cluster. We will name this `popgen` too, but in this one we will also install all the scientific software you will use in the exercises. Log in to the cluster and run this command to create the conda envionment:

    conda create -n popgen -c bioconda -c kaspermunch bwa platypus-variant samtools beagle plink admixture jupyter jupyterlab pandas numpy matplotlib ipympl nodejs seaborn

**Important:** Whenever you log into the cluster to work on your project, you should activate your `popgen` environment like this:

    conda activate popgen
    
 When you environment is active it says `(popgen)` on the commnad prompt instead of `(base)`.
## Set up Jupyter

[Jupyter](https://jupyter.org/) is a notebook environment where you can easily combine text, code and plots. Using the [slurm-jupyter](https://slurm-jupyter.readthedocs.io/en/latest) tool, you can run a jupyter notebook on the cluster, but see it in the browser on your own machine. So your analysis runs on the cluster file system where your data is, but the notebook interface is sent to your browser window.  is a package with a script that starts and connects to a jupyter server on compute note and forwards the web display to your local machine. 

Before you can start using `slurm-jupyter` for the first time, you need to run this command on the cluster:

    config-slurm-jupyter.sh

The script will ask about a lot of information. You can just press enter for all of them except when prompted for what password you want to use. Type a password and remember it.
# Working on the the cluster
## Your home on the cluster

When you log into the cluster you are put in your "home folder". All users have a home folder. However, in this course you will not use your home folder. We have made a special folder for you called `populationgenomics/students/username` where you should keep everything related to the course. To get from your home folder to the this folder you just:

    cd populationgenomics/students/username

(replace username with your cluster user name)
## Backup

**Very important:** Your files on the cluster are not backed up! If you absolutely need some files backed up, you can put them in folder called `BACKUP`. However, note that your userfolder, *including backed up files*, are deleted when the course ends.## Start Jupyter from own machine
## Running programs on the cluster

The whole point in getting you set up on the cluster is that you can then run software made for linux machines (most scientific software will only run on Linux and Mac). 


......

## How to run a Jupyter notebook

Now you should be set up. Log out of the cluster so that you are now back on your local machine. Run this command to start `slurm-jupyter`:

    slurm-jupyter -A populationgenomics -e popgen

Watch the terminal to see what is going on. After a while a jupyter notebook should show up in your browser window. You may be prompted for your password on the way. To close the jupyter notebook, press Ctrl-C twice in the terminal (closing the browser window does not close down the jupyter on the cluster).

You can [read this tutorial](https://www.dataquest.io/blog/jupyter-notebook-tutorial/) to learn how to use it.
## How to copy files to and from the cluster:

You may need to transfer files back and forth between your own machine and the cluster. To copy a file called `file` in a directory called `dir` on the cluster to your own machine you can use the `scp` command:

```bash
scp usernmae@login.genome.au.dk:dir/file .
```

To copy a file called `file` on your own machine to a folder called `dir` on the cluster, you do this:

```bash
scp ./file usernmae@login.genome.au.dk:dir/
```

-------------------------------------------------------------------
## OLD VERSION BELOW HERE

-------------------------------------------------------------------

## Linux server for exercises
During the course there will be several exercises that use command line tools that are only available on linux machines. These programs have been installed on a linux server that you can log onto using ssh.

We will refer to [user], which is your user name. We have created an account for each of you with your first name (all lowercase) as user name and your surname (all lowercase) as password (you can use the command passwd to change the password).

## Login from linux or mac
 If you are on a linux or mac computer then ssh is usually installed by default and you can use the following command to log in to the server:

```bash
ssh -p 8922 [user]@185.45.23.197
```
To copy a file called [file] in a directory called [dir] on the server to your local machine you can use the scp command (you can also use sftp if you prefer that):

```bash
scp -P 8922 [user]@185.45.23.197:[dir]/[file] .
```
In order to copy files from your local machine to the cluster, you just need to inverse the order:

```bash
scp -P 8922 ./[file] [user]@185.45.23.197:[dir]/
```

If your file is not in the current directory, you just need to provide the entire path.

## Login from windows

There are two ways to connect from a Windows machine:

### Using Moba Xterm (which has a Graphical User Interface)

It can be downloaded here: https://mobaxterm.mobatek.net/. Click "GET MOBAXTERM NOW" and then click to get the Free version. Then choose "MobaXterm Home Edition v11.1 (Portable edition)". It is important that it is the "portable" version. You can download it to your Desktop. Double-click it to open it.

To connect to the machine, click "Session" in the top left corner. Then click SSH in the top left corner of the window that pops up. Now fill in the address (185.45.23.197), [user] and the port (8922). 

You should now see a command prompt where you can type commands. The left part should show the folder structure of the folders under your user folder. Fom here you can easily download files to your local machine.

### Using PuTTy

It can be downloaded here: https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html. To log in you can write:

```bash
plink -X -P 8922 [user]@185.45.23.197
```

And you can transfer files between the cluster and your local machine by running:

```bash
pscp -P 8922 [user]@185.45.23.197:[dir]/[file] .
```

In order to copy files from your local machine to the cluster, you just need to inverse the order:

```bash
pscp -P 8922 ./[file] [user]@185.45.23.197:[dir]/
```

If your file is not in the current directory, you just need to provide the entire path.

If you have any problems with the upper commands, there is a more interactive way for both accessing the cluster and transferring files in a windows machine.

To transfer files, you can open PuTTy and set the options like this:

![Alt text](https://user-images.githubusercontent.com/38723379/51401061-30b1cf80-1b4a-11e9-8600-c3f11228ff91.png)

To copy files from the cluster to your local machine and vice-versa in an interactive way, you will need to install WinSCP. It can be downloaded here:
https://winscp.net/eng/download.php

Then, in the program set the options like this:

![Alt text](https://user-images.githubusercontent.com/38723379/51401251-94d49380-1b4a-11e9-8f07-7c58bc7238fb.png)


## Using the command line
If you are not used to using a unix command-line interface you might find this introduction useful:
https://lifehacker.com/5633909/who-needs-a-mouse-learn-to-use-the-command-line-for-almost-anything

After going through the introduction (if necessary), try do the following mini exercises:

1) Obtain the path to your home directory.
2) Create a new directory in your home directory named "ClusterPracticals". 
3) Write "This is a test" to a new file named "test_file_1" inside the directory "ClusterPracticals".
4) Change the name of the file from "test_1" to "test_file_2".
5) Make a copy of "test_file_2" named "test_file_3".
6) Delete "test_file_3".
7) Make a new directory named "test_directory_1". Delete "test_directory_1"
8) Transfer "test_file_2" to your local machine.
9) List the contents of "ClusterPracticals".
10) Make a soft link of "test_file_2" inside "ClusterPracticals".
11) See the contents of "test_file_2".
12) Create a new file named "test_file_4". Write whatever you feel like. Concatenated "test_file_2" and "test_file_4" into a new file called "test_file_5".

If you are done and you want a bit of a challange, you can do the following: (for these you could use grep, awk, vi, wc, chmod, alias). 

13) Check if "test_file_1" contains the word "This".
14) Check the number of words in "test_file_1".
15) Change the word "This" by "this".
16) Print the name of all the files inside "ClusterPracticals".
17) Do ls -l inside "ClusterPracticals". Try to understand each column. Now, look at the first one. Try to figure out which are the permissions of "test_file_1" (Hint: -rwxrwxrwx means that this is a regular file, and that the file owner, the group owner and all other users have permissions to read, write and execute the file).
18) Change the file permissions to -rwxrwxrwx.
19) Make a new alias, so that every time you write l, the command line interprets it as ls -l.
20) Fix the alias, so that every time you log in to the session is maintained.

