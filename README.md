# Neal's Dotfiles

My configs at any given time live here, to make migrating to a new machine easier. They're public so you can take advantage if you like.

I don't include scripts to automatically set configs on a new machine, because I find walking through them, re-evaluating the value of each tool, and getting the latest versions to be a useful exercise.


## Tools
This repo contains configurations for:

* [Neovim](https://neovim.io/)
* [Oh My ZSH](https://github.com/ohmyzsh/ohmyzsh)
* [Vim](https://www.vim.org/) (historical - I haven't used this in some time and will likely remove from the repo soon.)
* [Zsh](https://www.zsh.org/)

The configurations tend to be pretty minimal. Mostly colors, aliases, and creature comforts. I'm not a big plugin-maxxer.


## Layout

### Dotfiles (nvim, zsh, etc.)
There is a directory corresponding to each tool, with configurations set up.

### Scripts
There is also a `scripts/` directory containing some convenient scripts to keep packages updated and cleaned. I run them ~daily, and they are appropriately called `osx-daily` and `fedora-daily`. These are the only OS-dependent things in the repo, and only then because I want the Fedora script to manage `dnf` packages. Everything else here *should* be sufficienctly abstracted to be OS-independent.

### Env
The file `oh-my-zsh/custom/env.zsh` is `.gitignore`'d, so that machine-specific preferences have a place to live. Things like machine secrets, or invocations of scripts living at different paths, can reside here.


## Setup
While I'd encourage looking at the setup for each tool and adopting the pieces you want...fully adopting all of the configs is easy, as this is how I keep everything git-tracked. You can make sure all of the tools are installed, and then run something like the following from the root of this repo:

```bash
# Each step preserves a backup of your original config, and links this repo's content to the location

mv ~/.config/nvim ~/.config/nvim.bak
ln -s $(pwd)/nvim $HOME/.config/nvim

mv ~/.oh-my-zsh/custom ~/.oh-my-zsh/custom.bak
ln -s $(pwd)/oh-my-zsh/custom $HOME/.oh-my-zsh/custom

mkdir ~/.zsh_backups
mv ~/.zshrc ~/.zlogin ~/.zprofile ~/.zshenv ~/.zsh_backups
ln -s $(pwd)/zsh/.zshrc $HOME/.zshrc
ln -s $(pwd)/zsh/.zprofile $HOME/.zprofile
ln -s $(pwd)/zsh/.zlogin $HOME/.zlogin
ln -s $(pwd)/zsh/.zshenv $HOME/.zshenv

# This will put the `daily` script in an executable path - fedora is used as an example but it's the same premise for other OSes.
chmod +x ./scripts/fedora-daily
ln -s $(pwd)/scripts/fedora-daily /usr/local/bin/daily
```

## Notes

* The order of ZSH file loading is `.zshenv` -> `.zprofile` (login shells) -> `.zshrc` (interactive shells) -> `.zlogin` (login shells)
* The Nvim package manager I use is the builtin VimPack. I tried Lazy.nvim, and I imagine the async triggers etc. are worth it if you are very plugin-heavy. I have found VimPack to be very clean and simple.
* I might see about eliminating oh-my-zsh soon. I love `zinit` (used in the `.zshrc`) and I think it can do everything oh-my-zsh can do.
* In the meantime, `~/.oh-my-zsh` is a git repo of the OMZ framework, and `custom/` is the gitignored path where all user-defined content goes.
