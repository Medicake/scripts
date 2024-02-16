Quick explainers for the desired function of each script:

- replicate_solr_signals.py Copies search signals (user search queries) from our old search instance into our new one
- check_fusion_job_status.py is Nagios check that monitors search crawl jobs to ensure they've run within the configured interval and will also throw an error if the job log lists any failed documents
- check_fusion_document_vs_database.py is a Nagios check that pulls the document count from both the search server and the database the search server crawls and throws an error for a count mismatch is found