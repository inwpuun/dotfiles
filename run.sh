ln -sf ~/.dotfiles/.gitconfig ~/
ln -sf ~/.dotfiles/.gitignore_global ~/
ln -sf ~/.dotfiles/.tmux.conf ~/
ln -sf ~/.dotfiles/.vimrc ~/
ln -sf ~/.dotfiles/.zshrc ~/
ln -sf ~/.dotfiles/.config ~/

mkdir -p ~/.oh-my-zsh
ln -sf ~/.dotfiles/.oh-my-zsh/custom ~/.oh-my-zsh/

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# install brew package
brew bundle --file ~/.dotfiles/Brewfile

# add colemak-dh layout
cp -r ~/.dotfiles/Colemak\ DH.bundle ~/Library/Keyboard\ Layouts/

echo "Done! Please restart the machine."

