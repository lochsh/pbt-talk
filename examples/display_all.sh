pkill -f grip

ports=( 6001 6002 6003 )
host=localhost

grip --title "Example based test" ./example_based.md ${ports[0]} &
grip --title "Manual property based test" ./manual_pbt.md ${ports[1]} &
grip --title "Property based testing with hypothesis" ./pbt.md ${ports[2]} &


ff="firefox -new-tab"
for p in "${ports[@]}"
do
    ff+=" -url $host:$p"
done

$ff &
