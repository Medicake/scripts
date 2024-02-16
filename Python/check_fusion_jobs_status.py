#!/usr/bin/env python
import json
import requests
import traceback
import sys
import os
from datetime import datetime, timedelta
from optparse import OptionParser, OptionGroup
from requests.auth import HTTPBasicAuth

_FUSION_URL_PROD = "https://%s:6764/api/jobs/datasource:%s/history?limit=1"

def parse_args():
    usage = "usage: %prog --job JOB --maxAge HOURS"
    parser = OptionParser(usage=usage)

    required = OptionGroup(parser, "Required Options")
    required.add_option('-s', '--server', help='Server Name', default=None)
    required.add_option('-j', '--job', help='Job', default=None)
    required.add_option('-m', '--maxAge', type="int", help='Max Age in Hours', default=27)
    required.add_option('-w', '--warn', type="int", help='Warn % of failed documents', default=5)
    required.add_option('-c', '--critical', type="int", help='Critical % of failed documents', default=10)
    parser.add_option_group(required)

    optional = OptionGroup(parser, "Optional Options")

    parser.add_option_group(optional)

    options, _ = parser.parse_args()

    if not options.server:
        parser.error('server is a required option.')

    if not options.job:
        parser.error('job is a required option.')

    return options

def return_nagios(options, status, failedDoc):
    if (status == 0):
        prefix = 'OK: '
        stdout = "Job %s: has ran in the last %s hours " % (options.job, options.maxAge)
        code = 0
        strresult = '1'
    elif (status == 2):
        prefix = 'Warning: '
        stdout = "Job %s: has ran in the last %s hours but has %s failed documents " % (options.job, options.maxAge, failedDoc)
        code = 1
        strresult = '0'
    elif (status == 3):
        prefix = 'CRITICAL: '
        stdout = "Job %s: has ran in the last %s hours but has %s failed documents " % (options.job, options.maxAge, failedDoc)
        code = 2
        strresult = '0'
    else:
        prefix = 'CRITICAL: '
        stdout = "Job %s: has not finished running in the last %s hours " % (options.job, options.maxAge)
        code = 2
        strresult = '0'
    stdout = '%s%s|%s=%s' % (prefix, stdout, options.job, strresult)
    raise NagiosReturn(stdout, code)

class NagiosReturn(Exception):

    def __init__(self, message, code):
        self.message = message
        self.code = code

def execute_cmd(options):
    URL = _FUSION_URL_PROD % (options.server, options.job)
    #payload = {'realmName':'HTTP'}
    #headers = {'remote_user': 'nagios'}
    #r = requests.get(URL, headers=headers, data=payload)
    r = requests.get(URL, auth=HTTPBasicAuth('fusion-service-user', 'null'))
    missing = None
    currentTime = datetime.utcnow() - timedelta(hours=options.maxAge)

    requestJson = r.json()

    if (requestJson[0]['status'] == "success"):
      try:
        endTime = datetime.strptime(requestJson[0]['endTime'], "%Y-%m-%dT%H:%M:%S.%fZ")
      except:
        raise NagiosReturn("Unknown: %s" % r.text,3)
      if (endTime < currentTime):
        return_nagios(options, 1, 0)

    if (requestJson[0]['status'] == "running"):
      try:
       startTime = datetime.strptime(requestJson[0]['startTime'], "%Y-%m-%dT%H:%M:%S.%fZ")
      except:
        raise NagiosReturn("SSSUnknown: %s" % r.text,3)
      if (startTime < currentTime):
        return_nagios(options, 4, 0)

    if (requestJson[0]['status'] == "failed"):
      return_nagios(options, 4, 0)

    try:
      inDocs = int(requestJson[0]['extra']['counter.input'])
    except:
      inDocs = 0

    try:
      failDocs = int(requestJson[0]['extra']['counter.failed'])
    except:
      failDocs = 0

    if (inDocs > 0):
      perFailed = (failDocs/inDocs)*100
    else:
      perFailed = 0
    if (perFailed >= options.critical):
       return_nagios(options, 3, failDocs)
    elif (perFailed >= options.warn):
       return_nagios(options, 2, failDocs)
    else:
      startTime = requestJson[0]['startTime']
      start_time = datetime.strptime(startTime, "%Y-%m-%dT%H:%M:%S.%fZ")
      current_time = datetime.utcnow()
      time_difference = current_time - start_time
      if time_difference.total_seconds() <= 10:
        if 'extra' in requestJson[0] and 'counters' in requestJson[0]['extra'] and 'fetch.plugin-response' in requestJson[0]['extra']['counters']:
            return_nagios(options, 0, 0)
        else:
            return_nagios(options, 2, 0)
      else:
          return_nagios(options, 0, 0)



def main():
    options = parse_args()
    execute_cmd(options)

if __name__ == '__main__':
    try:
        main()
    except NagiosReturn, e:
        print e.message
        sys.exit(e.code)
    except Exception, e:
        print type(e)
        print e.message
        print(traceback.format_exc())
        sys.exit(3)