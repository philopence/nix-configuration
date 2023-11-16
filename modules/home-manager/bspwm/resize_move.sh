CURRENT=$(bspc query -T -n)
PARENT=$(bspc query -T -n @parent)
CURRENT_STATE=$(echo $CURRENT | jq -r .client.state)

if [ $CURRENT_STATE == "floating" ] || [ $CURRENT_STATE == "pseudo_tiled" ]; then
  SIZE=10
  case "$1" in
    "-l")
      bspc node focused --resize left $SIZE 0
      bspc node focused --resize right -$SIZE 0
      ;;
    "-d")
      bspc node focused --resize top 0 $SIZE
      bspc node focused --resize bottom 0 -$SIZE
      ;;
    "-u")
      bspc node focused --resize top 0 -$SIZE
      bspc node focused --resize bottom 0 $SIZE
      ;;
    "-r")
      bspc node focused --resize left -$SIZE 0
      bspc node focused --resize right $SIZE 0
      ;;
    "-c")
      MONITOR=$(bspc query -T -m)
      WIDTH=$(echo $MONITOR | jq -r .rectangle.width)
      HEIGHT=$(echo $MONITOR | jq -r .rectangle.height)
      CURRENT_X=$(echo $CURRENT | jq -r .client.floatingRectangle.x)
      CURRENT_Y=$(echo $CURRENT | jq -r .client.floatingRectangle.y)
      CURRENT_WIDTH=$(echo $CURRENT | jq -r .client.floatingRectangle.width)
      CURRENT_HEIGHT=$(echo $CURRENT | jq -r .client.floatingRectangle.height)
      DX=$((WIDTH / 2 - CURRENT_X - CURRENT_WIDTH / 2))
      DY=$((HEIGHT / 2 - CURRENT_Y - CURRENT_HEIGHT / 2))
      bspc node focused --move $DX $DY
      ;;
  esac
  exit 0
fi

[ -z "$PARENT" ] && exit 0

FIRSTCHILD=$(echo $PARENT | jq -r ".firstChild.id")
SECONDCHILD=$(echo $PARENT | jq -r ".secondChild.id")
SIZE=20

case "$(echo $CURRENT | jq -r .id)" in
  "$FIRSTCHILD")
    case "$1" in
      "-l")
        bspc node focused --resize right -$SIZE 0
        ;;
      "-d")
        bspc node focused --resize bottom 0 $SIZE
        ;;
      "-u")
        bspc node focused --resize bottom 0 -$SIZE
        ;;
      "-r")
        bspc node focused --resize right $SIZE 0
        ;;
    esac
    ;;
  "$SECONDCHILD")
    case "$1" in
      "-l")
        bspc node focused --resize left -$SIZE 0
        ;;
      "-d")
        bspc node focused --resize top 0 $SIZE
        ;;
      "-u")
        bspc node focused --resize top 0 -$SIZE
        ;;
      "-r")
        bspc node focused --resize left $SIZE 0
        ;;
    esac
    ;;
esac
