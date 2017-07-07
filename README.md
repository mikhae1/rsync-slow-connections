## Script for safely clonning files on slow connections


#### crontab example setup
*/10  *   *   *   *   /home/user/orchid-rsync/rsync_move.sh >>/home/user/orchid-rsync/logs/send.log 2>&1


#### incron example setup
/home/user/orchid-rsync/send IN_CLOSE_WRITE,IN_NO_LOOP /home/user/orchid-rsync/rsync_move.sh

NB: Use incron only to sync files as fast as they were created
