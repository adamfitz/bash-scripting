cd frr
echo ">> adding upstream"
git remote add upstream https://github.com/FRRouting/frr
echo ""
echo ">> fetching frr upstream"
git fetch upstream
echo ""
echo ">> pulling frr upstream"
git pull upstream master
echo""
echo ">> updating remote fork (pushing updates from frr to github)"
git push
echo ""
echo ">> sync of frr fork complete"
