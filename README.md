dotfiles-universal
==================

universal Linux/Unix dotfiles for the HOME directory of any user

##quick install
1. login to any unix or linux account
2. execute this command

```
$ curl  https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/universal-install.sh | bash
```

#Motivation

I've been doing consulting for quite a while with both big and small companies.  I've worked thousands of unix and linux systems of all kinds.  Sometimes I'm working as a developer, sometimes I'm working as an Administrator that needs root access for a good part of the day.  

The problem you run into when working on diverse systems is that each system is managed differently.  You might be given a new user account on a Linux, Solaris or AIX box.  Often the default shell environment for this new account will be bare bones.   Sometimes they are customized to meet local conventions.  Often times, this just gets in the way of "getting things done".  Specifically you will see issues such as:

>- The PATH probably won't include admin tool locations
>- Command history might not be turned on
>- Command completion might not work
>- Incremental history search might not be turned on
>- Some servers only have ksh and not the more modern bash
>- Some servers may not be able to use "less" as a PAGER
>- Some users are setup with vi editing mode, some emacs
>- When logged in as root, many systems show a simplistic "# " prompt.  Things can get confusing when you have many windows open.  This is not what you want when you are root.
>- Terminal windows might get confused when they are resized
>- The default prompt may not show the current directory
>- *man* pages may not display correctly

All of these things can be manually fixed by editing individual .bashrc or .profile files.  This gets cumbersome when dealing with many systems.  

This set of dotfiles is meant to fix all these problems in a consistent way.  
##Compatibility
These files are known to work on a variety of unix or linux systems.  It has been tested on the HOME directory for users on:

* CentOS
* RedHat
* Ubuntu
* LinuxMint
* Solaris x86
* Solaris sparc
* Open Solaris
* IBM AIX
* Cygwin
* BusyBox
* VMware ESXi
* Synology Diskstation

####Shells:
* bash 2.x
* bash 3.x
* bash 4.x
* ash
* sh
* ksh
* dash
* any other shell that understands .profile or .bashrc

####Terminals
* gnome-terminal
* rxvt
* mintty
* putty
* sun-cmd
* sun CDE terminal

In addition to these, it will probably work just fine with any terminal emulation program.  The various color combinations of the prompt seem to work best when the window background is either white or black.

##PS1 Prompt

It creates a PS1 prompt to answer the question, where am I?

- what directory am I in?
- what directories are in my stack? (pushd/popd)
- what host am I on?
- what type of host is this?  ubuntu? centos? cygwin? etc.
- am I root or not?
- what time is it?
- am I in a git branch? If so, where?
- do I have an X11 DISPLAY set?
- am I logged on with ssh-agent keys?



It installs a reasonable PATH, based on the OS type

If these files are used on a Windows system running cygwin, it will attempt to start up ssh-agent to allow single sign-on to other systems

##Installing and quick-start tutorial

The simplest way to install this:

```shell
$ curl  https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/universal-install.sh | bash
```

This install method is just a convienent way to install these files into a home directory of an internet connected system.  Usually, this command can be copied and pasted, as necessary.  If your system does not have curl installed, you can just manually copy files in this repository to your HOME directory.

Once these dotfiles are successfully installed, you should install them into your shell:

```
gclaybur@localhost ~ $ . .bashrc
```

Your prompt should change to look something like the screenshots below

#Screenshots

Basic prompt for user "gclaybur" on host "cinnamon":

![plain terminal](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-plain.png)

Error code shows up in the prompt:
![last command with error code](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-errorcode.png)

The current directory is a git master branch:

![git branch](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-gitbranch.png)

If you use pushd/popd commands, the directory stack is shown:

![pushd directory](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-pushd.png)

This box is running Linux mint

![mint host](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-mint-host.png)

This box is running Solaris 5.9 on sparc:

![solaris-sparc](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-solaris.png)

Ubuntu:

![ubuntu](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-ubuntu.png)

CentOS:

![ubuntu](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-centos.png)

In general, Linux hosts use red for the hostname.  The background color of the hostname represents the linux distribution.

When this prompt is used as the root user, much of the prompt is shown in red instead of green.  This is just another visual reminder that you are root here.  Be careful.

![root](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-root.png)



##Workflow and Security

My normal workflow for working with a new user account on a system is like this:

1. Log onto a system that already has these dotfiles installed in the HOME directory.  Normally this is my windows Cygwin [mintty](https://code.google.com/p/mintty/) terminal that is running a bash login shell.  It could also easily be any linux desktop system.
 
> Note: The .bashrc file has a special section when being used on Cygwin.  It will start up ssh-agent the first time a terminal window is opened after logging on to windows.  This will allow the user to authenticate and load the ssh private keys into the agent so that we can use ssh single sign-on to other known hosts.  This ssh-agent setup is not done by these dotfiles under any other system.  It is not necessary since it is normally part of the linux desktop login process.  Cygwin is just, well, weird.

2. Use *installid* function to enable single sign-on and *pushdotfiles* to copy these dotfiles:
![installid thenewguy@bagley  ; pushdotfiles thenewguy@bagley](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-thenewguy.png)

3. Now we can securely log into the server with a consistent environment without needing a password:
![ssh thenewguy@bagley](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-login-thenewguy.png)

When I say securely log in, what I mean is that we are using ssh-agent to protect our private ssh keys.  We only need to generate the public/private keypair one time.  Normally, this is only done on the workstation that we are physically sitting at.  For me, this is my laptop.  No other user accounts or servers need a private key.  What we are doing here is just copying our one public key to all our user accounts that we need to use.  By doing this, we are telling sshd on the other end to trust anyone that can authenticate with the one matching private key.  This private key only resides on the laptop.


###SSH agent forwarding
One thing to be aware of is this alias in .bashrc:

```
alias ssh='ssh -A'
```
This enables forwarding of the ssh-agent connection.  I use it because it makes it easy to hop from box to box without a password.  However, it does have security implications if you don't completely trust the server you are logging into.  See "man ssh" for details.

One other thing to point out is that if you are logged onto a server using ssh keys and ssh agent forwarding as above, you will see the list of available keys in the prompt like this:

![ssh thenewguy@bagley](https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/images/screenshot-nopassword.png)



#Customizing
This set of dotfiles are meant to be interoperable with any platform.  If you need specific customizations for a particular host, they should be put in a *.bashrc.localhost file*.  This file is sourced last during the login process so you can override any settings you need to.  This will allow you to upgrade to new dotfiles as necessary without needing to re-customize local settings.
