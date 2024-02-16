Quick explainers for the desired function of each script:

- new_dfsr_folder.ps1 Creates a new folder for Windows Distributed File System Replication in an existing group
- nagios_sql_avilability_state_nrpe.ps1 Nagios NRPE check that polls the sql server for the SQL always on replication status and throws an error if a healthy isn't returned
- check_user_process_cpu_nrpe.ps1 Nagios NRPE check that uses Windows Perfmon utility to return the current cpu usage of IIS app pools and throws an error if it's outside the configured range
- asset_copy.ps1 Script Copies Assets with a guid file name and moves it to a new location and performs a rename with the title/mimetype pulled from the CMS Database