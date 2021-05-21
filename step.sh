#!/bin/bash

if [ -n "${color_build_failure_custom}" ] ; then
    color_build_failure=${color_build_failure_custom}
fi

if [ -n "${color_build_success_custom}" ] ; then
    color_build_success=${color_build_success_custom}
fi

# check which color to use
if [[ "${BITRISE_BUILD_STATUS}" == "0" ]] ; then
    color=${color_build_success}
else
    color=${color_build_failure}
fi

if [[ "${selector_type}" != "all" ]]; then
    selector="${selector_type}:${bulb_label}"
else
    selector="all"
fi

body="{\"color\":\"${color}\",\"power\":\"on\"}"

# check whether to employ an effect instead of just turning it a solid color
if [[ "${effect}" != "none" ]]; then
    endpoint="lights/${selector}/effects/${effect}"
    body="{\"color\":\"${color}\",\"cycles\":\"${cycles}\",\"power_on\":\"true\"}"
    method="POST"
else
    endpoint="lights/${selector}/state"
    method="PUT"
fi

# change bulb color via API
curl -s -X $method \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${auth_token}" \
    -d ${body} "https://api.lifx.com/v1/$endpoint" #> /dev/null
return_code=$?
exit ${return_code}
