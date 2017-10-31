# cp-from-npm

> Copy source code from npm registry to a local directory.
>
> Using [msu][msu], you can move around with them from machine to machine.


## usage:

```bash
# Objective: Copy source code in npm package 'express' to a directory named 'express-src'.

# Create the destination directory (destdir)
$ mkdir ./express-src/

# Run the tool.
#             <package> <destdir>
$ cp-from-npm  express  ./express-src/
```


## installation:

Ensure you have [msu][msu] installed:

```bash
$ msu install gh:GochoMugo/cp-from-npm
```

You need to restart your terminal for `cp-from-npm` to be available,
or use msu's alias `msu.reload`.


## license:

**The MIT License (MIT)**

Copyright &copy; 2017 GochoMugo <mugo@forfuture.co.ke>


[msu]:https://github.com/GochoMugo/msu
