#!/bin/sh
# `/sbin/setuser <<USER>>>` runs the given command as the user `<<USER>>`.
# If you omit that part, the command will be run as root.
exec /opt/phabricator/scripts/daemon/phd-daemon PhabricatorRepositoryPullLocalDaemon >>/var/log/phabricator.repo.log 2>&1
