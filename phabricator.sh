#!/bin/sh
# `/sbin/setuser <<USER>>>` runs the given command as the user `<<USER>>`.
# If you omit that part, the command will be run as root.
exec /opt/phabricators/cripts/daemon/phd-daemon PhabricatorGarbageCollectorDaemon >>/var/log/phabricator.garbage.log 2>&1
