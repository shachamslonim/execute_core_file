plink.exe -pw q -ssh root@10.108.112.10 gdb /home/kos/kashya/archive/bin/release/replication --core /home/kos/replication/rp_core.6834 --batch --quiet  -ex 'set logging on'  -ex 'info thread' -ex 'where' -ex 'thread apply all bt full' -ex 'quit'  > 10.108.112.10\1.8G_Mar_15_02_32__replication_rp_core.6834.txt_FULL
plink.exe -pw q -ssh root@10.108.112.10 gdb /home/kos/kashya/archive/bin/release/replication --core /home/kos/replication/rp_core.6834 --batch --quiet -ex 'info thread' -ex 'where' -ex 'thread apply all bt' -ex 'quit'  > 10.108.112.10\1.8G_Mar_15_02_32__replication_rp_core.6834.txt
plink.exe -pw q -ssh root@10.108.112.10 /usr/bin/strings /home/kos/replication/rp_core.6834  >> 10.108.112.10\1.8G_Mar_15_02_32__replication_rp_core.6834.txt_strings
ication/rp_core.10492  >> 10.108.112.12\976K_Mar__6_14_43__replication_rp_core.10492.gz.txt_strings
