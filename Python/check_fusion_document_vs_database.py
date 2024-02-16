#!/usr/bin/env python3
from distutils.log import error
import pymssql
import traceback
import requests
from requests.auth import HTTPBasicAuth
import os, sys
from optparse import OptionParser, OptionGroup

# Connection info for mssql
_fusionurl = "https://searchserver.domain.com:6764/api/solrAdmin/default/{collection}/select?fl=id&fq=Tombstone_s%3A0&fq=_lw_data_source_s%3A{datasource}&q=*%3A*&fq=isSubmitted_s%3A1&rows=1"
_fusionurl_no_issubmitted = "https://searchserver.domain.com:6764/api/solrAdmin/default/{collection}/select?fl=id&fq=Tombstone_s%3A0&fq=_lw_data_source_s%3A{datasource}&q=*%3A*&rows=1"
auth = HTTPBasicAuth('fusion-service-user', 'supersecurepassword')

def parse_args():
    usage = "usage: --server SERVER --database DATABASE --collection COLLECTION --username USERNAME --password PASSWORD --datasource DATASOURCE"
    parser = OptionParser(usage=usage)

    required = OptionGroup(parser, "Required Options")
    required.add_option('-s', '--server', help='SQL Server Name', default=None)
    required.add_option('-u', '--username', help='SQL UserName', default=None)
    required.add_option('-p', '--password', help='SQL Password', default=None)
    required.add_option('-c', '--collection', help='client collection', default=None)
    required.add_option('-d', '--database', help='SQL Database name', default=None)
    required.add_option('-e', '--datasource', help='SOLR Datasource', default=None)
    required.add_option('-b', '--issub', help='Enable or disable isSubmitted', default=None)

    optional = OptionGroup(parser, "Optional Options")

    parser.add_option_group(optional)

    options, _ = parser.parse_args()

    if not options.server:
        parser.error('server is a required option.')

    if not options.database:
        parser.error('database is a required option.')

    if not options.username:
        parser.error('username is a required option.')

    if not options.password:
        parser.error('password is a required option.')

    if not options.collection:
        parser.error('collection is a required option.')

    return options

def return_nagios(options, status):
    if (status == 0):
        prefix = 'OK: '
        stdout = "Documents are concurrent for %s" % (options.collection)
        code = 0
        strresult = '1'
    else:
        prefix = 'CRITICAL: '
        stdout = "Mismatched amount found for %s" % (options.collection)
        code = 2
        strresult = '0'
    stdout = '%s%s|%s' % (prefix, stdout, strresult)
    raise NagiosReturn(stdout, code)



# Sending request to solr

def execute_cmd(options):
    server = options.server
    user= options.username
    password= options.password
    database= options.database
    if options.issub == '1':
        collectionurl= _fusionurl.format(collection=options.collection, datasource=options.datasource)
        query= 'select count(*) as formcount from table as fbu inner join table_versions as fbvu on fbvu.id = fbu.UserVersionId where fbu.Tombstone = 0 and fbu.UserVersionId is not null and fbvu.IsSubmitted =1'
    else:
        collectionurl= _fusionurl_no_issubmitted.format(collection=options.collection, datasource=options.datasource)
        query= 'select count(*) as formcount from table as fbu inner join table_versions as fbvu on fbvu.id = fbu.UserVersionId where fbu.Tombstone = 0 and fbu.UserVersionId is not null'
    try:
        r = requests.get(collectionurl, auth=auth)
        jsonr = r.json()
        solrcount = jsonr["response"]["numFound"]
        if solrcount == 0:
            raise NagiosReturn("Unable to access collection or zero was actually found",3)
    except:
        raise NagiosReturn("Unable to access collection",3)
    # print(solrcount)
    # Building connection to mssql
    try:
        conn = pymssql.connect(server, user, password, database)
        cursor = conn.cursor(as_dict=True)
        cursor.execute(query)
        for row in cursor:
            sqlcount = (row['formcount'])
        conn.close()
    except:
        raise NagiosReturn("unable to access database",3)
    # print(sqlcount)
    # Checking if good
    if sqlcount <= solrcount:
        return_nagios(options, 0)
    else:
        return_nagios(options, 3)

class NagiosReturn(Exception):

    def __init__(self, message, code):
        self.message = message
        self.code = code

def main():
    options = parse_args()
    execute_cmd(options)

if __name__ == '__main__':
    try:
        main()
    except NagiosReturn as e:
        print(e)
        sys.exit(e.code)
    except Exception as e:
        print(e)
        print(traceback.format_exc())
        sys.exit(3)