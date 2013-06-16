#!/bin/bash
# Install script for dotfile customizations
# Modified from https://github.com/alexdavid/dotfiles

# Exit on error
set -e
cd

# Backup existing files
backup_dir="dotfiles_backup"
if [ -e $backup_dir ]
then
	rm -rf $backup_dir
fi
mkdir $backup_dir

dotfile_dir="dotfiles"
if [  -e $dotfile_dir ]
then
	rm -rf $dotfile_dir
fi
mkdir $dotfile_dir

echo -e "Looking for files that would be overwritten."
for i in \
	".bash"\
	".bashrc"\
	".git"\
	".gitconfig"\
	".vimrc"\
	".vim"\
	".tmux.conf"\
	".vim_settings"
do
	if [ -e "$i" ]
	then
		echo -e "Moving $i to $backup_dir/$i"
		mv $i "$backup_dir/$i"
	fi
done

# Move into the dotfiles directory to keep it compartmentalized
cd $dotfile_dir

# Pull down repo
if [[ $(git config --get remote.origin.url) != "git://github.com/GLips/dotfiles.git" ]]
then
	git init
	git remote add origin git@github.com:GLips/dotfiles.git
	git fetch
	git branch master origin/master
	git checkout master
else
	git fetch
fi
touch .gitignore
echo "README.md" >> .gitignore
echo "init.sh" >> .gitignore

cd ..

for f in $dotfile_dir/.*
do
	b=$(basename $f)
	if [ $b != ".git" ] && [ $b != ".gitignore" ] && [ $b != ".." ] && [ $b != "." ]
	then
		ln -fs $f $b
	fi
done

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +BundleInstall +qall

source ~/.bashrc
