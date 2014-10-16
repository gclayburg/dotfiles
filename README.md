dotfiles-universal
==================

universal Linux/Unix dotfiles for the HOME directory of any user


These set of home directory dot files are known to work on a variety of unix or linux systems.  It has been tested on the HOME directory for users on:

* CentOS
* RedHat
* Ubuntu
* LinuxMint
* Solaris x86
* Open Solaris
* IBM AIX
* Cygwin
* busybox
* VMware esxi 4.1
* Synology diskstation


And these shells

* bash 2.x
* bash 3.x
* bash 4.x
* ash
* sh
* ksh
* dash


Basically, these files are intended to be a replacement for the home directory dotfiles of any known unix or linux distribution.

What do these dotfiles do?

It creates a PS1 prompt to answer the question, where am I?

- what directory am I in?
- what directories are in my stack? (pushd/popd)
- what host am I on?
- what type of host is this?  ubuntu? centos? cygwin? etc.
- am I root or not?
- what time is it?
- am I in a git branch?
- do I have an X11 DISPLAY set?
- am I logged on with ssh-agent keys?



It installs a reasonable PATH, based on the OS type

If these files are used on a Windows system running cygwin, it will attempt to start up ssh-agent to allow single sign-on to other systems

##Installing and quick-start tutorial

The simplest way to install this:

```
gclaybur@localhost ~ $ curl  https://raw.githubusercontent.com/gclayburg/dotfiles-universal/master/universal-install.sh | bash
```

This install method is just a convienent way to install these files into a home directory of an internet connected system.  Usually, this command can be copied and pasted, as necessary.  If your system does not have curl installed, you can just manually copy files in this repository to your HOME directory.

Once these dotfiles are successfully installed, you should install them into your shell:

```
gclaybur@localhost ~ $ . .bashrc
```

Your prompt should change to look something like this:

```shell
1834 0 [10-15 16:29:07] :0.0 gclaybur@bagley ~/dev/tmpjunk 
$ 
```

this is the end



