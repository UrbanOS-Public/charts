# to be run from the root of this repo.
# sometimes dependent charts don't respond to running
# `helm dependency update` from the `/urban-os` chart.
# This series of commands perform the updates bottom up.

# when a new chart is added to this repo of charts, and 
# that new chart has external dependencies listed in it's
# chart.yaml, it should be added here.

cd charts
helm dep up kafka
helm dep up persistence
helm dep up monitoring
helm dep up urban-os
cd ..
