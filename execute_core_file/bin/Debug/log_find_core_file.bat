@echo on
setLocal EnableDelayedExpansion
title Core watchdog 
IF not exist rpa_list2.txt goto needlist
cls
set I=
::get first errors
For /F "eol=# tokens=1,2,4 delims=; " %%I IN (rpa_list2.txt) DO (
IF not exist %%I mkdir %%I 
IF exist %%I\core.txt del %%I\core.txt
)

::PING 1.1.1.1 -n 5 -w 1000 >NUL
rem sleep 1 secend
ping 1.1.1.1 -n 1 -w 1000 > nul 
echo error11 > error.txt

cls
echo befoe_dddd > error.txt
	For /F "eol=# tokens=1,2,4 delims=; " %%I IN (rpa_list2.txt) DO (
	echo befoe > error.txt
IF %%J == ESX (
echo befoe_dddd1111 > error.txt
)
IF  %%J == RPA (	 
plink.exe -pw %%K -ssh root@%%I "find / -type f -size +8000k -exec ls -lh {} \; | grep core\\. " > %%I\core.txt

) 

	
)



goto END
:needlist
echo Missing file C:\temp\log\rpa_list2.txt
goto end
:END

echo done



