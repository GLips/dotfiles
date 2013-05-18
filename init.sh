#!/bin/bash

# Exit on error
set -e
cd

# Backup existing files
backup_dir="dotfiles_backup"
mkdir $backup_dir

dotfile_dir="dotfiles"
mkdir $dotfile_dir

for i in \
	"bash"\
	"bashrc"\
	"git"\
	"gitconfig"\
	"vimrc"\
	"tmux.conf"
do
	if [ -e ".$i" ]
	then
		echo -e "\e[1;31mMoving .$i to $backup_dir/$i\e[m"
		mv ".$i" "$backup_dir/$i"
	fi
done

# Move into the dotfiles directory to keep it compartmentalized
cd $dotfile_dir

# Pull down repo
git init
git remote add origin git://github.com/GLips/dotfiles.git
git fetch
git branch master origin/master
git checkout master
touch .gitignore
echo "README.md" >> .gitignore
echo "init.sh" >> .gitignore

cd ..

# Move readme & init.sh to the backup folder
mv $dotfile_dir/README.md $backup_dir/
mv $dotfile_dir/init.sh $backup_dir/


for f in $dotfile_dir/.*
do
	b=$(basename $f)
	if [ $b != ".git" ] && [ $b != ".gitignore" ] && [ $b != ".." ] && [ $b != "." ]
	then
		ln -s $f $b
	fi
done

"]]"
