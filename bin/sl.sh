#!/usr/bin/env bash
#
# for funsies
# see https://gist.github.com/ieure/6876784
#
IFS="
"
echo
for FRAME in \
    "B            :^)" \
    " B           :^)" \
    "  B          :^)" \
    "   B         :^)" \
    "    B        :^)" \
    "     B       :^)" \
    "      B      :^)" \
    "       B     :^)" \
    "        B    :^)" \
    "         B   :^)" \
    "          B  :^)" \
    "           B :^)" \
    "            B:^)" \
    "Deal with it B^)"; do
    echo -en "$FRAME\r"
    sleep .1
done
sleep 2
echo