function cd()
{
	builtin cd "$*" && ll
}
function cdc()
{
	builtin cd "$*" && clear && ll
}
