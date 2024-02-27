# script to create prs with jira infromation based on the branch name

[[ -z "$1" ]] && { echo "a pr description is expected as an only argument" ; exit 1; }
DRAFT=$2

# TODO change me
JIRA_URL="jira.com"

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
[[ -z "$BRANCH_NAME" ]] && { echo "no git repo nor branch name found" ; exit 1; }


PREFIX_PATTERN='[A-Z]{2,5}-[0-9]{1,6}'
[[ $BRANCH_NAME =~ $PREFIX_PATTERN ]]
JIRA=${BASH_REMATCH[0]}

[[ -z "$JIRA" ]] && { echo "no jira ID found in branch name $BRANCH_NAME with pattern $PREFIX_PATTERN" ; exit 1; }

TITLE_NAME=$(echo $BRANCH_NAME | sed -e "s/$JIRA-//g")
TITLE_NAME=$(echo "$TITLE_NAME" | tr '-' ' ')
TITLE_NAME=$(echo "$TITLE_NAME" | tr '_' ' ')
echo $TITLE_NAME
DESCRIPTION=$1
TITLE="[$JIRA]-$TITLE_NAME"


echo -e "[$JIRA]https://$JIRA_URL/browse/$JIRA\n$DESCRIPTION" > msg_file
export BODY=$(cat msg_file)

echo "creating pr for issue $1 with title $TITLE and body:"
echo "$BODY"

gh pr create $DRAFT --title "$TITLE" --body "$BODY" || echo "error creating pull request, maybe there are no changes or gh cli not installed"
