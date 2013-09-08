# Dotfiles (jrsdead)

bash dotfiles and various useful scripts. Also installs some software on OS X (Dropbox, TotalTerminal, PHP).


## How to install

The installation step requires the [XCode Command Line
Tools](https://developer.apple.com/downloads) and may overwrite existing
dotfiles in your HOME directory.

```bash
$ bash -c "$(curl -fsSL raw.github.com/jrsdead/dotfiles/master/setup.sh)"
```

N.B. If you wish to fork this project and maintain your own dotfiles, you must
substitute my username for your own in the above command and the 2 variables
found at the top of the `bin/dotfiles` script.