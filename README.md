# dotconfs

## Installation

```bash
ln -sf ~/repos/dotconfs/nvim ~/.config/nvim

ln -sf ~/repos/dotconfs/tmux/.tmux.conf ~/.tmux.conf

ln -sf ~/repos/dotconfs/bin/workspaces ~/.local/bin/workspace

ln -sf ~/repos/dotconfs/bin/regen-mcp ~/.local/bin/regen-mcp 

mkdir ~/.oh-my-zsh/completion

ln -sf ~/repos/dotconfs/zsh/completions/_workspaces ~/.oh-my-zsh/completions/_workspace

mkdir ~/.oh-my-zsh/custom/function

ln -sf ~/repos/dotconfs/bin/workspace ~/.oh-my-zsh/custom/functions/workspac

ln -sf ~/repos/dotconfs/zsh/completions/_workspace ~/.oh-my-zsh/completions/_workspac

echo "autoload -Uz workspace" >> ~/.zshrc
```
