#!/usr/bin/env bash

set -euo pipefail

#######################################
# Global variables
#######################################

UPN=""
DISPLAY_NAME=""
JOB_TITLE=""
DEPARTMENT=""
USAGE_LOCATION=""

#######################################
# Functions
#######################################

usage() {
cat <<EOF
Usage:
 
$(basename "$0") \
--upn <upn> \
--department <department> \
--usage-location <country-code> \
[--display-name <display-name>] \
[--job-title <job-title>]
 
Required:
--upn
--department
--usage-location
 
Optional:
--display-name
--job-title
 
Example:
 
$(basename "$0") \
--upn john.doe@contoso.com \
--department IT \
--usage-location US \
--display-name "John Doe" \
--job-title "Azure Administrator"
 
EOF
}

validate_parameters() {

    if [[ -z "$UPN" ]]; then
        echo "ERROR: --upn is required!" >&2
        usage
        exit 1
    fi

    if [[ -z "$DEPARTMENT" ]]; then
        echo "ERROR: --dept is required!" >&2
        usage
        exit 1
    fi

    if [[ -z "$USAGE_LOCATION" ]]; then
        echo "ERROR: --usage-location is required!" >&2
        usage
        exit 1
    fi

    # Deault display name to UPN
    if [[ -z "$DISPLAY_NAME" ]]; then
        DISPLAY_NAME="$UPN"
    fi
}

validate_upn() {

    local upn_regex='^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'

    if ! [[ "$UPN" =~ $upn_regex ]]; then
        echo "ERROR: Invalid User Principal Name format." >&2
        echo "Example: john.doe@contoso.com" >&2
        exit 1
    fi
}

validate_authentication() {

    echo "Checking Azure authentication..."

    if ! az account show >/dev/null 2>&1; then
        echo "ERROR: Azure authentication not found." >&2
        echo "Run 'az login' and try again." >&2
        exit 1
    fi
}

check_existing_user() {

    echo "Checking if user already exists..."
    if az ad user show \
        --id "$UPN" \
        >/dev/null 2>&1
    then
        echo "ERROR: User '$UPN' already exists." >&2
        exit 1
    fi

    echo "User doesn't already exist. Creating Entra ID user..."
}

create_user() {
    
    local temp_password
    local body

    temp_password=$(openssl rand -base64 16)
    if ! az ad user create \
        --user-principal-name "$UPN" \
        --display-name "$DISPLAY_NAME" \
        --password "$temp_password" \
        --force-change-password-next-sign-in true \
        --output none
    then
        echo "ERROR: User creation failed." >&2
        exit 1
    fi

    echo
    echo "User created successfully!"
    echo

    echo "Updating user's info..."
    body=$(jq -n \
        --arg department "$DEPARTMENT" \
        --arg usageLocation "$USAGE_LOCATION" \
        '{
            department: $department,
            usageLocation: $usageLocation
        }')

    if [[ -n "$JOB_TITLE" ]]; then
        body=$(echo "$body" | jq \
            --arg jobTitle "$JOB_TITLE" \
            '. + {jobTitle: $jobTitle}')
    fi

    if ! az rest \
        --method PATCH \
        --url "https://graph.microsoft.com/v1.0/users/$UPN" \
        --headers "Content-Type=application/json" \
        --body "$body"
    then
        echo "ERROR: User update failed." >&2
        exit 1
    fi

    echo
    echo "User updated successfully!"
    echo

    az rest \
        --method GET \
        --url "https://graph.microsoft.com/v1.0/users/$UPN?\$select=displayName,userPrincipalName,department,jobTitle,usageLocation" \
        --output table

    echo
    echo "Temporary password:"
    echo "$temp_password"
    echo
    echo "The user must change the password during the first sign-in."

}

#######################################
# Parameter processing
#######################################

while [[ $# -gt 0 ]]
do
    case "$1" in

        --upn)
            UPN="$2"
            shift 2
            ;;

        --department)
            DEPARTMENT="$2"
            shift 2
            ;;

        --usage-location)
            USAGE_LOCATION="$2"
            shift 2
            ;;
        
        --display-name)
            DISPLAY_NAME="$2"
            shift 2
            ;;

        --job-title)
            JOB_TITLE="$2"
            shift 2
            ;;

        -h|--help)
            usage
            exit 0
            ;;

        *)
            echo "ERROR: Unknown parameter '$1'" >&2
            usage
            exit 1
            ;;
    esac
done

#######################################
# Main
#######################################

main() {

    validate_parameters
    validate_upn

    validate_authentication
    check_existing_user

    create_user
}

main "$@"

