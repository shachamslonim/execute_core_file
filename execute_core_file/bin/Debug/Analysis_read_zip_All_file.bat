@echo on
setLocal EnableDelayedExpansion
title Core watchdog 
IF not exist %CD%\rpa_list2.txt goto needlist
cls
set I=
::get first errors
For /F "eol=# tokens=1,2,4 delims=; " %%I IN (rpa_list2.txt) DO (

 
 

 IF not exist %%I mkdir %%I
 IF exist %%I\Analysis_old.txt del %%I\Analysis_old.txt


 IF exist %%I\Analysis.txt move %%I\Analysis.txt %%I\Analysis_old.txt

)

::PING 1.1.1.1 -n 5 -w 1000 >NUL
rem sleep 1 secend
ping 1.1.1.1 -n 1 -w 1000 > nul 
echo error11 > error.txt

cls
echo befoe_dddd > error.txt
	For /F "eol=# tokens=1,2,4 delims=; " %%I IN (rpa_list2.txt) DO (
	echo befoe > error.txt
	if %%J == ESX (
echo ####################### > %%I\Analysis.txt
echo Kdriver  LOG EVENT: >>%%I\Analysis.txt
echo ####################### >>%%I\Analysis.txt

echo ==================================================================================== >>%%I\Analysis.txt
echo ESX Spliter LOG EVENT: Core files >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I "find /scratch/log/ -type f -size +8000k -exec ls -lh {} \; | grep core\\. ">> %%I\Analysis.txt

echo ==================================================================================== >>%%I\Analysis.txt
echo ESX Spliter LOG EVENT: error >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt					
	plink.exe -pw %%K -ssh root@%%I grep -E '"error"' /scratch/log/kdriver.log.* >>%%I\Analysis.txt				

echo ====================================================================================
echo ESX Spliter LOG EVENT: HERE  >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt					
	plink.exe -pw %%K -ssh root@%%I grep -E '"HERE"' /scratch/log/kdriver.log.* >>%%I\Analysis.txt				

echo ==================================================================================== >>%%I\Analysis.txt
echo ESX Spliter LOG EVENT:Assertion files >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt					
	plink.exe -pw %%K -ssh root@%%I grep -E '"Assertion"' /scratch/log/kdriver.log.* >>%%I\Analysis.txt				

echo ==================================================================================== >>%%I\Analysis.txt
echo ESX Spliter LOG EVENT: DEVICE_STATE_SUSPECTED files >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt					
	plink.exe -pw %%K -ssh root@%%I grep -E '"DEVICE_STATE_SUSPECTED"' /scratch/log/kdriver.log.* >>%%I\Analysis.txt				

echo ==================================================================================== >>%%I\Analysis.txt
echo ESX Spliter LOG EVENT: fatal files >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt					
	plink.exe -pw %%K -ssh root@%%I grep -E '"fatal"' /scratch/log/kdriver.log.* >>%%I\Analysis.txt				

echo ==================================================================================== >>%%I\Analysis.txt
echo ESX Spliter LOG EVENT: deadlock files >>%%I\Analysis.txt
echo ====================================================================================>>%%I\Analysis.txt 					
	plink.exe -pw %%K -ssh root@%%I grep -E '"deadlock"' /scratch/log/kdriver.log.* >>%%I\Analysis.txt
	)
IF  %%J == RPA (
echo ####################### > %%I\Analysis.txt
echo RPA LOG EVENT: Core files >>%%I\Analysis.txt
echo ####################### >>%%I\Analysis.txt
					 
plink.exe -pw %%K -ssh root@%%I "find /home -type f -size +8000k -exec ls -lh {} \; | grep core\\. " >>%CD%\%%I\Analysis.txt

echo	   ####################### >>%%I\Analysis.txt
echo    REPLICATION PROCESS: >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt
echo >> %%I\Analysis.txt

echo ==================================================================================== >>%%I\Analysis.txt
echo REPLICATION LOG EVENT: Process Restart >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
	
	echo  ********************/home/kos/replication/result.log%%C%%D********************************* >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I grep HERE /home/kos/replication/result.log.00 >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"HERE"' /home/kos/replication/*.gz  >>%%I\Analysis.txt

echo ==================================================================================== >>%%I\Analysis.txt
echo REPLICATION LOG EVENT: Assertions >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I grep Assertion /home/kos/replication/result.log.00 >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"Assertion"' /home/kos/replication/*.gz  >>%%I\Analysis.txt
	
echo ==================================================================================== >>%%I\Analysis.txt
echo REPLICATION LOG EVENT: Assertions DLManager: deadlock suspected >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I grep 'DLManager: deadlock suspected' /home/kos/replication/result.log.00 >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"DLManager: deadlock suspected"' /home/kos/replication/*.gz  >>%%I\Analysis.txt
	
echo	   ####################### >>%%I\Analysis.txt
echo    management : >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt

echo  ==================================================================================== >>%%I\Analysis.txt
echo  MANAGEMENT LOG EVENT: Process Restart >>%%I\Analysis.txt
echo  ==================================================================================== >>%%I\Analysis.txt
plink.exe -pw %%K -ssh root@%%I grep HERE /home/kos/management/result.log.00 >>%%I\Analysis.txt
plink.exe -pw %%K -ssh root@%%I zgrep -E '"HERE"' /home/kos/management/*.gz >>%%I\Analysis.txt	

echo  ==================================================================================== >>%%I\Analysis.txt
echo  MANAGEMENT LOG EVENT: Process Assertion >>%%I\Analysis.txt
echo  ==================================================================================== >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I grep Assertion /home/kos/management/result.log.00 >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"Assertion"' /home/kos/management/*.gz >>%%I\Analysis.txt

echo	   ####################### >>%%I\Analysis.txt
echo    control : >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt

echo ==================================================================================== >>%%I\Analysis.txt
echo control LOG EVENT: Process Restart >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I grep HERE /home/kos/control/result.log.00 >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"HERE"' /home/kos/control/*.gz >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
echo control LOG EVENT: Process Assertion >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt	
	
	plink.exe -pw %%K -ssh root@%%I grep Assertion /home/kos/control/result.log.00 >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"Assertion"' /home/kos/control/*.gz >>%%I\Analysis.txt

echo ==================================================================================== >>%%I\Analysis.txt
echo control LOG EVENT: OCW >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt		
	
	plink.exe -pw %%K -ssh root@%%I grep OCW /home/kos/control/result.log.00 >>%%I\Analysis.txt			
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"OCW"' /home/kos/control/*.gz >>%%I\Analysis.txt

echo	   ####################### >>%%I\Analysis.txt
echo    site_connector : >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt

echo ==================================================================================== >>%%I\Analysis.txt
echo site_connector LOG EVENT: Process Restart >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt

	plink.exe -pw %%K -ssh root@%%I grep HERE /home/kos/site_connector/result.log.00 >>%%I\Analysis.txt	
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"HERE"' /home/kos/site_connector/*.gz >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
echo site_connector LOG EVENT: Process Assertion >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I grep Assertion /home/kos/site_connector/result.log.00 >>%%I\Analysis.txt	
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"Assertion"' /home/kos/site_connector/*.gz >>%%I\Analysis.txt	
	
echo	   ####################### >>%%I\Analysis.txt
echo    storage : >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt

echo ==================================================================================== >>%%I\Analysis.txt
echo storage LOG EVENT: Process Assertion >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt

plink.exe -pw %%K -ssh root@%%I grep Assertion /home/kos/storage/result.log.00 >>%%I\Analysis.txt	
plink.exe -pw %%K -ssh root@%%I zgrep -E '"Assertion"' /home/kos/storage/*.gz >>%%I\Analysis.txt


echo ==================================================================================== >>%%I\Analysis.txt
echo storage LOG EVENT: Process Restart >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt	
plink.exe -pw %%K -ssh root@%%I grep HERE /home/kos/storage/result.log.00 >>%%I\Analysis.txt
plink.exe -pw %%K -ssh root@%%I zgrep -E '"HERE"' /home/kos/storage/*.gz >>%%I\Analysis.txt
echo	   ####################### >>%%I\Analysis.txt
echo    mirror : >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
echo mirror LOG EVENT: Process Assertion >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt

plink.exe -pw %%K -ssh root@%%I grep Assertion /home/kos/mirror/result.log.00 >>%%I\Analysis.txt	
plink.exe -pw %%K -ssh root@%%I zgrep -E '"Assertion"' /home/kos/mirror/*.gz >>%%I\Analysis.txt


echo ==================================================================================== >>%%I\Analysis.txt
echo mirror LOG EVENT: Process Restart >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt	
	plink.exe -pw %%K -ssh root@%%I grep HERE /home/kos/mirror/result.log.00 >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"HERE"' /home/kos/mirror/*.gz >>%%I\Analysis.txt


echo	   ####################### >>%%I\Analysis.txt
echo    hlr : >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
echo hlr LOG EVENT: Process Assertion >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt

plink.exe -pw %%K -ssh root@%%I grep Assertion /home/kos/hlr/result.log.00 >>%%I\Analysis.txt	
plink.exe -pw %%K -ssh root@%%I zgrep -E '"Assertion"' /home/kos/hlr/*.gz >>%%I\Analysis.txt

echo ==================================================================================== >>%%I\Analysis.txt
echo hlr LOG EVENT: Process Restart >>%%I\Analysis.txt 
echo ==================================================================================== >>%%I\Analysis.txt	
	plink.exe -pw %%K -ssh root@%%I grep HERE /home/kos/hlr/result.log.00 >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"HERE"' /home/kos/hlr/*.gz >>%%I\Analysis.txt
	

echo	   ####################### >>%%I\Analysis.txt
echo    client- hlr : >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
echo client- hlr LOG EVENT: Process Assertion >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt

plink.exe -pw %%K -ssh root@%%I grep Assertion /home/kos/hlr/client/result.log.00 >>%%I\Analysis.txt	
plink.exe -pw %%K -ssh root@%%I zgrep -E '"Assertion"' /home/kos/hlr/client/*.gz >>%%I\Analysis.txt


echo ==================================================================================== >>%%I\Analysis.txt
echo hlr LOG EVENT: Process Restart >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt	
	plink.exe -pw %%K -ssh root@%%I grep HERE /home/kos/hlr/client/result.log.00 >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"HERE"' /home/kos/hlr/client/*.gz >>%%I\Analysis.txt	
	
echo	   ####################### >>%%I\Analysis.txt
echo    installationLogs : >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
echo installationLogs EVENT:Process ERROR >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt	
    plink.exe -pw %%K -ssh root@%%I grep ERROR /home/kos/installationLogs/server.log >>%CD%\%%I\Analysis.txt

echo ==================================================================================== >>%%I\Analysis.txt
echo installation_processes_logs EVENT:Process ERROR >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt

     plink.exe -pw %%K -ssh root@%%I grep ERROR /home/kos/installation_processes_logs/results.log* >>%CD%\%%I\Analysis.txt
	
echo	   ####################### >>%%I\Analysis.txt
echo    connectivity_tool : >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt
	 plink.exe -pw %%K -ssh root@%%I zgrep -E '"Assertion"' /home/kos/connectivity_tool/*.gz >>%%I\Analysis.txt
	 plink.exe -pw %%K -ssh root@%%I grep -E '"Assertion"' /home/kos/connectivity_tool/result.log.00 >>%%I\Analysis.txt

echo	   ####################### >>%%I\Analysis.txt
echo    vi_connector : >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I zgrep -E '"Assertion|error"' /home/kos/vi_connector/logs/*.gz >>%%I\Analysis.txt
	plink.exe -pw %%K -ssh root@%%I grep -E '"Assertion|error"' /home/kos/vi_connector/logs/vi_connector_view.log >>%%I\Analysis.txt

echo	   ####################### >>%%I\Analysis.txt
echo    CLI : >>%%I\Analysis.txt
echo    ####################### >>%%I\Analysis.txt
echo ==================================================================================== >>%%I\Analysis.txt
	echo ********************/home/kos/cli/result.log. *zip ****************************** >>Analysis.txt
	plink.exe -pw %%K -ssh root@%%I grep -E '"Assertion|error"' /home/kos/cli/result.log* >>%%I\Analysis.txt
echo after_befor  > error.txt
) 

	rem if you the old we did The diff
	IF exist %%I\Analysis_old.txt diff -bBi --ignore-all-space %%I\Analysis.txt %%I\Analysis_old.txt > %%I\Analysis_diff.txt

	
)






::PING 1.1.1.1 -n 1 -w 1000 >NUL

:: set v!N!=%%I 





::PING 1.1.1.1 -n 30 -w 1000 >NUL

goto END
:needlist
echo Missing file rpa_list2.txt
goto end
:END

echo done



