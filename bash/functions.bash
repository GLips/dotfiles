if [ -f ~/.lastdir ]; then
			cd "`cat ~/.lastdir`"
fi

export LASTDIR="/"

function prompt_command {
	pwd > ~/.lastdir

	# Record new directory on change.
	newdir=`pwd`

	export LASTDIR=$newdir

}
export PROMPT_COMMAND=prompt_command

function cd()
{
	builtin cd "$*" && ll -t
}
function cl()
{
	builtin cd "$*" && clear && ll -t
}
function cdto()
{
	echo + Switching to $*
	echo + Press CTRL-D to return to `pwd`
	 
	echo $* > ~/.lastdir
	bash --login
}
function freq() {
	sort $* | uniq -c | sort -rn;
}
function gp() {
	grep -R $1 $2
}
