#!/bin/bash

case "$1" in
OK)

        ;;
WARNING)

        ;;
UNKNOWN)

        ;;
CRITICAL)

        case "$2" in

        SOFT)
            case "$3" in
            3)
            # Call the script to reboot the lightsail instance

            instanceId=`/usr/local/aws-cli/v2/current/bin/aws lightsail get-instances --query "instances[?publicIpAddress=='$5'].name" --output text`
            instanceState=`/usr/local/aws-cli/v2/current/bin/aws lightsail get-instance-state --instance-name $instanceId --query "state.name" --output text`
            if [[ $instanceState == "running" ]]; then
                echo "Rebooting $instanceId"
                /usr/local/aws-cli/v2/current/bin/aws lightsail reboot-instance --instance-name $instanceId --no-cli-pager
                exit 0
            else
                echo "Instance is still rebooting"
                exit 0
            fi
                        ;;
                        esac
                ;;

        # Welp, the script didn't work :( gotta wake up
        HARD)
         exit 0
                ;;
        esac
        ;;
esac
exit 0